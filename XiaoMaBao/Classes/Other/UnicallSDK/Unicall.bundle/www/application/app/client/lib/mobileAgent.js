(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/lib/mobileAgent.js                                           //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by lil on 16-4-22.                                          //
 */                                                                    //
(function () {                                                         // 4
  if (Meteor.isCordova) {                                              // 5
    console.log("run in app of mobile.");                              // 6
    var Agent = function () {                                          // 7
      var self = this;                                                 // 8
      var appInfoCallbacks = [];                                       // 9
      var appAccessCallbacks = [];                                     // 10
      var userInfoCallbacks = [];                                      // 11
      var userInterestCallbacks = [];                                  // 12
      var toggleWindowCallbacks = [];                                  // 13
      self.toggleWindow = function () {                                // 14
        //切换窗口                                                         //
        getUnicallAppInfoAgent().sendMessage("toggleWindow");          // 16
      };                                                               //
      self.noticeNewMsg = function (msg) {                             // 18
        getUnicallAppInfoAgent().sendMessage("newMsg", msg);           // 19
      };                                                               //
      self.receiveAWSUrl = function (data) {                           // 21
        //No need to implements on mobile                              //
      };                                                               //
      self.imagePreview = function (data) {                            // 24
        //No need to implements on mobile                              //
      };                                                               //
      self.closeWindow = function () {                                 // 27
        getUnicallAppInfoAgent().sendMessage("closeWindow");           // 28
      };                                                               //
      self.signACK = function (msg) {                                  // 30
        getUnicallAppInfoAgent().sendMessage("signACK", msg);          // 31
      };                                                               //
      self.registerCallbackOnLivechatReady = function (callback) {     // 33
        getUnicallAppInfoAgent().addEventListener("appInfo", callback);
        appInfoCallbacks[appInfoCallbacks.length] = callback;          // 35
      };                                                               //
      self.registerCallbackOnSignReady = function (callback) {         // 37
        getUnicallAppInfoAgent().addEventListener("appAccess", callback);
        appAccessCallbacks[appAccessCallbacks.length] = callback;      // 39
      };                                                               //
      //register on view rendered                                      //
      self.registerCallbackOnUserInfo = function (callback) {          // 42
        getUnicallAppInfoAgent().addEventListener("userInfo", callback);
        userInfoCallbacks[userInfoCallbacks.length] = callback;        // 44
      };                                                               //
      //register on view rendered                                      //
      self.registerCallbackOnUserInterest = function (callback) {      // 47
        getUnicallAppInfoAgent().addEventListener("userInterest", callback);
        userInterestCallbacks[userInterestCallbacks.length] = callback;
      };                                                               //
      self.registerCallbackOnToggleWindow = function (callback) {      // 51
        getUnicallAppInfoAgent().addEventListener("toggleWindow", callback);
        toggleWindowCallbacks[toggleWindowCallbacks.length] = callback;
      };                                                               //
                                                                       //
      self.addEventListener = function (type, callback) {              // 56
        getUnicallAppInfoAgent().addEventListener(type, callback);     // 57
      };                                                               //
      self.ready = function () {                                       // 59
        getUnicallAppInfoAgent().livechatLoadReady();                  // 60
      };                                                               //
      self.sendMessage = function (type, msg) {                        // 62
        getUnicallAppInfoAgent().sendMessage(type, msg);               // 63
      };                                                               //
      var message = null;                                              // 65
      self.cacheUniqueSystemMessage = function (msg) {                 // 66
        message = msg;                                                 // 67
      };                                                               //
      self.recoverUniqueSystemMessage = function () {                  // 69
        var result = message;                                          // 70
        message = null;                                                // 71
        return result;                                                 // 72
      };                                                               //
      var userInfo = null;                                             // 74
      self.cacheUniqueUserInfo = function (msg) {                      // 75
        userInfo = msg;                                                // 76
      };                                                               //
      self.recoverUniqueUserInfo = function () {                       // 78
        var result = userInfo;                                         // 79
        userInfo = null;                                               // 80
        return result;                                                 // 81
      };                                                               //
      self.mock = {                                                    // 83
        sendAppInfo: function (appInfo) {                              // 84
          for (var i = 0; i < appInfoCallbacks.length; i++) {          // 85
            appInfoCallbacks[i](appInfo);                              // 86
          }                                                            //
        },                                                             //
        sendAppAccess: function (appAccess) {                          // 89
          for (var i = 0; i < appAccessCallbacks.length; i++) {        // 90
            appAccessCallbacks[i](appAccess);                          // 91
          }                                                            //
        },                                                             //
        sendUserInfo: function (userInfo) {                            // 94
          for (var i = 0; i < userInfoCallbacks.length; i++) {         // 95
            userInfoCallbacks[i](userInfo);                            // 96
          }                                                            //
        },                                                             //
        sendUserInterest: function (userInterest) {                    // 99
          for (var i = 0; i < userInterestCallbacks.length; i++) {     // 100
            userInterestCallbacks[i](userInterest);                    // 101
          }                                                            //
        },                                                             //
        sendToggleWindow: function () {                                // 104
          for (var i = 0; i < toggleWindowCallbacks.length; i++) {     // 105
            toggleWindowCallbacks[i]();                                // 106
          }                                                            //
        }                                                              //
      };                                                               //
    };                                                                 //
    this.outerAgent = new Agent();                                     // 111
  } else {                                                             //
    console.log("run in web browser.");                                // 113
  }                                                                    //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);
