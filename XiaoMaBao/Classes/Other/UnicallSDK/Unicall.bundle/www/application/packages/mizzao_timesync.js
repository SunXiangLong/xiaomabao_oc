//////////////////////////////////////////////////////////////////////////
//                                                                      //
// This is a generated file. You can view the original                  //
// source in your browser if your browser supports source maps.         //
// Source maps are supported by all recent versions of Chrome, Safari,  //
// and Firefox, and by Internet Explorer 11.                            //
//                                                                      //
//////////////////////////////////////////////////////////////////////////


(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var check = Package.check.check;
var Match = Package.check.Match;
var Tracker = Package.tracker.Tracker;
var Deps = Package.tracker.Deps;
var HTTP = Package.http.HTTP;

/* Package-scope variables */
var TimeSync, SyncInternals;

(function(){

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// packages/mizzao_timesync/timesync-client.js                                   //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////
                                                                                 //
//IE8 doesn't have Date.now()                                                    // 1
Date.now = Date.now || function() { return +new Date; };                         // 2
                                                                                 // 3
TimeSync = {                                                                     // 4
  loggingEnabled: true                                                           // 5
};                                                                               // 6
                                                                                 // 7
function log(/* arguments */) {                                                  // 8
  if (TimeSync.loggingEnabled) {                                                 // 9
    Meteor._debug.apply(this, arguments);                                        // 10
  }                                                                              // 11
}                                                                                // 12
                                                                                 // 13
var defaultInterval = 1000;                                                      // 14
                                                                                 // 15
// Internal values, exported for testing                                         // 16
SyncInternals = {                                                                // 17
  offset: undefined,                                                             // 18
  roundTripTime: undefined,                                                      // 19
  offsetDep: new Deps.Dependency(),                                              // 20
  timeTick: {},                                                                  // 21
                                                                                 // 22
  timeCheck: function (lastTime, currentTime, interval, tolerance) {             // 23
    if (Math.abs(currentTime - lastTime - interval) < tolerance) {               // 24
      // Everything is A-OK                                                      // 25
      return true;                                                               // 26
    }                                                                            // 27
    // We're no longer in sync.                                                  // 28
    return false;                                                                // 29
  }                                                                              // 30
};                                                                               // 31
                                                                                 // 32
SyncInternals.timeTick[defaultInterval] = new Deps.Dependency();                 // 33
                                                                                 // 34
var maxAttempts = 5;                                                             // 35
var attempts = 0;                                                                // 36
                                                                                 // 37
/*                                                                               // 38
  This is an approximation of                                                    // 39
  http://en.wikipedia.org/wiki/Network_Time_Protocol                             // 40
                                                                                 // 41
  If this turns out to be more accurate under the connect handlers,              // 42
  we should try taking multiple measurements.                                    // 43
 */                                                                              // 44
                                                                                 // 45
// Only use Meteor.absoluteUrl for Cordova; see                                  // 46
// https://github.com/meteor/meteor/issues/4696                                  // 47
// https://github.com/mizzao/meteor-timesync/issues/30                           // 48
var syncUrl = "/_timesync";                                                      // 49
if (Meteor.isCordova) {                                                          // 50
  syncUrl = Meteor.absoluteUrl("_timesync");                                     // 51
}                                                                                // 52
                                                                                 // 53
var updateOffset = function() {                                                  // 54
  var t0 = Date.now();                                                           // 55
                                                                                 // 56
  HTTP.get(syncUrl, function(err, response) {                                    // 57
    var t3 = Date.now(); // Grab this now                                        // 58
    if (err) {                                                                   // 59
      //  We'll still use our last computed offset if is defined                 // 60
      log("Error syncing to server time: ", err);                                // 61
      if (++attempts <= maxAttempts)                                             // 62
        Meteor.setTimeout(TimeSync.resync, 1000);                                // 63
      else                                                                       // 64
        log("Max number of time sync attempts reached. Giving up.");             // 65
      return;                                                                    // 66
    }                                                                            // 67
                                                                                 // 68
    attempts = 0; // It worked                                                   // 69
                                                                                 // 70
    var ts = parseInt(response.content);                                         // 71
    SyncInternals.offset = Math.round(((ts - t0) + (ts - t3)) / 2);              // 72
    SyncInternals.roundTripTime = t3 - t0; // - (ts - ts) which is 0             // 73
    SyncInternals.offsetDep.changed();                                           // 74
  });                                                                            // 75
};                                                                               // 76
                                                                                 // 77
// Reactive variable for server time that updates every second.                  // 78
TimeSync.serverTime = function(clientTime, interval) {                           // 79
  check(interval, Match.Optional(Match.Integer));                                // 80
  // If we don't know the offset, we can't provide the server time.              // 81
  if ( !TimeSync.isSynced() ) return undefined;                                  // 82
  // If a client time is provided, we don't need to depend on the tick.          // 83
  if ( !clientTime ) getTickDependency(interval || defaultInterval).depend();    // 84
                                                                                 // 85
  // SyncInternals.offsetDep.depend(); implicit as we call isSynced()            // 86
  // Convert Date argument to epoch as necessary                                 // 87
  return (+clientTime || Date.now()) + SyncInternals.offset;                     // 88
};                                                                               // 89
                                                                                 // 90
// Reactive variable for the difference between server and client time.          // 91
TimeSync.serverOffset = function() {                                             // 92
  SyncInternals.offsetDep.depend();                                              // 93
  return SyncInternals.offset;                                                   // 94
};                                                                               // 95
                                                                                 // 96
TimeSync.roundTripTime = function() {                                            // 97
  SyncInternals.offsetDep.depend();                                              // 98
  return SyncInternals.roundTripTime;                                            // 99
};                                                                               // 100
                                                                                 // 101
TimeSync.isSynced = function() {                                                 // 102
  SyncInternals.offsetDep.depend();                                              // 103
  return SyncInternals.offset !== undefined;                                     // 104
};                                                                               // 105
                                                                                 // 106
var resyncIntervalId = null;                                                     // 107
                                                                                 // 108
TimeSync.resync = function() {                                                   // 109
  if (resyncIntervalId !== null) Meteor.clearInterval(resyncIntervalId);         // 110
  updateOffset();                                                                // 111
  resyncIntervalId = Meteor.setInterval(updateOffset, 600000);                   // 112
};                                                                               // 113
                                                                                 // 114
// Run this as soon as we load, even before Meteor.startup()                     // 115
// Run again whenever we reconnect after losing connection                       // 116
var wasConnected = false;                                                        // 117
                                                                                 // 118
Deps.autorun(function() {                                                        // 119
  var connected = Meteor.status().connected;                                     // 120
  if ( connected && !wasConnected ) TimeSync.resync();                           // 121
  wasConnected = connected;                                                      // 122
});                                                                              // 123
                                                                                 // 124
// Resync if unexpected change by more than a few seconds. This needs to be      // 125
// somewhat lenient, or a CPU-intensive operation can trigger a re-sync even     // 126
// when the offset is still accurate. In any case, we're not going to be able to
// catch very small system-initiated NTP adjustments with this, anyway.          // 128
var tickCheckTolerance = 5000;                                                   // 129
                                                                                 // 130
var lastClientTime = Date.now();                                                 // 131
                                                                                 // 132
// Set up a new interval for any amount of reactivity.                           // 133
function getTickDependency(interval) {                                           // 134
                                                                                 // 135
  if ( !SyncInternals.timeTick[interval] ) {                                     // 136
    var dep  = new Deps.Dependency();                                            // 137
                                                                                 // 138
    Meteor.setInterval(function() {                                              // 139
      dep.changed();                                                             // 140
    }, interval);                                                                // 141
                                                                                 // 142
    SyncInternals.timeTick[interval] = dep;                                      // 143
  }                                                                              // 144
                                                                                 // 145
  return SyncInternals.timeTick[interval];                                       // 146
}                                                                                // 147
                                                                                 // 148
// Set up special interval for the default tick, which also watches for re-sync  // 149
Meteor.setInterval(function() {                                                  // 150
  var currentClientTime = Date.now();                                            // 151
                                                                                 // 152
  if ( SyncInternals.timeCheck(                                                  // 153
    lastClientTime, currentClientTime, defaultInterval, tickCheckTolerance) ) {  // 154
    // No problem here, just keep ticking along                                  // 155
    SyncInternals.timeTick[defaultInterval].changed();                           // 156
  }                                                                              // 157
  else {                                                                         // 158
    // resync on major client clock changes                                      // 159
    // based on http://stackoverflow.com/a/3367542/1656818                       // 160
    log("Clock discrepancy detected. Attempting re-sync.");                      // 161
    // Refuse to compute server time.                                            // 162
    SyncInternals.offset = undefined;                                            // 163
    SyncInternals.offsetDep.changed();                                           // 164
    TimeSync.resync();                                                           // 165
  }                                                                              // 166
                                                                                 // 167
  lastClientTime = currentClientTime;                                            // 168
}, defaultInterval);                                                             // 169
                                                                                 // 170
                                                                                 // 171
///////////////////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['mizzao:timesync'] = {
  TimeSync: TimeSync,
  SyncInternals: SyncInternals
};

})();
