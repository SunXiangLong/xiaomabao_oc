(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/lib/unicallAppInfoAgent.js                                   //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by lil on 16/4/13.                                          //
 */                                                                    //
(function () {                                                         // 4
  if (Meteor.isCordova) {                                              // 5
    var Agent = function () {                                          // 6
      var self = this;                                                 // 7
      //init                                                           //
      navigator.unicallAppInfo.initial();                              // 9
      //**********************************                             //
                                                                       //
      //basic function                                                 //
      this.addEventListener = function (type, callback) {              // 13
        navigator.unicallAppInfo.addEventListener(type, callback);     // 14
      };                                                               //
      this.removeEventListener = function (type, callback) {           // 16
        navigator.unicallAppInfo.removeEventListener(type, callback);  // 17
      };                                                               //
      this.sendMessage = function (type, msg) {                        // 19
        navigator.unicallAppInfo.sendMessage(type, msg);               // 20
      };                                                               //
      //**********************************                             //
                                                                       //
      //extend function                                                //
                                                                       //
      this.livechatLoadReady = function () {                           // 26
        self.sendMessage("livechat-sdk-ready", { time: new Date() });  // 27
      };                                                               //
      this.registerCallbackOnSignReady = function (callback) {         // 29
        self.addEventListener("appInfo", callback);                    // 30
      };                                                               //
                                                                       //
      //**********************************                             //
    };                                                                 //
    var target = null;                                                 // 36
    this.getUnicallAppInfoAgent = function () {                        // 37
      if (target === null) {                                           // 38
        target = new Agent();                                          // 39
      }                                                                //
      return target;                                                   // 41
    };                                                                 //
  }                                                                    //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);
