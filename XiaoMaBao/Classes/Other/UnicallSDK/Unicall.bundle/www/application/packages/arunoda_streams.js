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
var _ = Package.underscore._;

/* Package-scope variables */
var EV;

(function(){

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
// packages/arunoda_streams/packages/arunoda_streams.js                    //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////
                                                                           //
(function () {                                                             // 1
                                                                           // 2
///////////////////////////////////////////////////////////////////////    // 3
//                                                                   //    // 4
// packages/arunoda:streams/lib/ev.js                                //    // 5
//                                                                   //    // 6
///////////////////////////////////////////////////////////////////////    // 7
                                                                     //    // 8
function _EV() {                                                     // 1  // 9
  var self = this;                                                   // 2  // 10
  var handlers = {};                                                 // 3  // 11
                                                                     // 4  // 12
  self.emit = function emit(event) {                                 // 5  // 13
    var args = Array.prototype.slice.call(arguments, 1);             // 6  // 14
                                                                     // 7  // 15
    if(handlers[event]) {                                            // 8  // 16
      for(var lc=0; lc<handlers[event].length; lc++) {               // 9  // 17
        var handler = handlers[event][lc];                           // 10
        handler.apply(this, args);                                   // 11
      }                                                              // 12
    }                                                                // 13
  };                                                                 // 14
                                                                     // 15
  self.on = function on(event, callback) {                           // 16
    if(!handlers[event]) {                                           // 17
      handlers[event] = [];                                          // 18
    }                                                                // 19
    handlers[event].push(callback);                                  // 20
  };                                                                 // 21
                                                                     // 22
  self.once = function once(event, callback) {                       // 23
    self.on(event, function onetimeCallback() {                      // 24
      callback.apply(this, arguments);                               // 25
      self.removeListener(event, onetimeCallback);                   // 26
    });                                                              // 27
  };                                                                 // 28
                                                                     // 29
  self.removeListener = function removeListener(event, callback) {   // 30
    if(handlers[event]) {                                            // 31
      var index = handlers[event].indexOf(callback);                 // 32
      handlers[event].splice(index, 1);                              // 33
    }                                                                // 34
  };                                                                 // 35
                                                                     // 36
  self.removeAllListeners = function removeAllListeners(event) {     // 37
    handlers[event] = undefined;                                     // 38
  };                                                                 // 39
}                                                                    // 40
                                                                     // 41
EV = _EV;                                                            // 42
///////////////////////////////////////////////////////////////////////    // 51
                                                                           // 52
}).call(this);                                                             // 53
                                                                           // 54
                                                                           // 55
                                                                           // 56
                                                                           // 57
                                                                           // 58
                                                                           // 59
(function () {                                                             // 60
                                                                           // 61
///////////////////////////////////////////////////////////////////////    // 62
//                                                                   //    // 63
// packages/arunoda:streams/lib/client.js                            //    // 64
//                                                                   //    // 65
///////////////////////////////////////////////////////////////////////    // 66
                                                                     //    // 67
Meteor.Stream = function Stream(name, callback) {                    // 1  // 68
  EV.call(this);                                                     // 2  // 69
                                                                     // 3  // 70
  var self = this;                                                   // 4  // 71
  var streamName = 'stream-' + name;                                 // 5  // 72
  var collection = new Meteor.Collection(streamName);                // 6  // 73
  var subscription;                                                  // 7  // 74
  var subscriptionId;                                                // 8  // 75
                                                                     // 9  // 76
  var connected = false;                                             // 10
  var pendingEvents = [];                                            // 11
                                                                     // 12
  self._emit = self.emit;                                            // 13
                                                                     // 14
  collection.find({}).observe({                                      // 15
    "added": function(item) {                                        // 16
      if(item.type == 'subscriptionId') {                            // 17
        subscriptionId = item._id;                                   // 18
        connected = true;                                            // 19
        pendingEvents.forEach(function(args) {                       // 20
          self.emit.apply(self, args);                               // 21
        });                                                          // 22
        pendingEvents = [];                                          // 23
      } else {                                                       // 24
        var context = {};                                            // 25
        context.subscriptionId = item.subscriptionId;                // 26
        context.userId = item.userId;                                // 27
        self._emit.apply(context, item.args);                        // 28
      }                                                              // 29
    }                                                                // 30
  });                                                                // 31
                                                                     // 32
  subscription = Meteor.subscribe(streamName, callback);             // 33
                                                                     // 34
  self.emit = function emit() {                                      // 35
    if(connected) {                                                  // 36
      Meteor.call(streamName, subscriptionId, arguments);            // 37
    } else {                                                         // 38
      pendingEvents.push(arguments);                                 // 39
    }                                                                // 40
  };                                                                 // 41
                                                                     // 42
  self.close = function close() {                                    // 43
    subscription.stop();                                             // 44
  };                                                                 // 45
}                                                                    // 46
                                                                     // 47
_.extend(Meteor.Stream.prototype, EV.prototype);                     // 48
                                                                     // 49
///////////////////////////////////////////////////////////////////////    // 117
                                                                           // 118
}).call(this);                                                             // 119
                                                                           // 120
/////////////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['arunoda:streams'] = {};

})();
