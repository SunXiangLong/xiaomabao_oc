(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/lib/webBrowserAgent.js                                       //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by lil on 16-4-22.                                          //
 */                                                                    //
(function () {                                                         // 4
  if (Meteor.isCordova) {                                              // 5
    console.log("run in app of mobile.");                              // 6
  } else {                                                             //
    console.log("run in web browser.");                                // 8
    var Agent = function () {                                          // 9
      var self = this;                                                 // 10
      var callParent = function (method, args) {                       // 11
        console.log("call parent");                                    // 12
        var data;                                                      // 13
        if (args == null) {                                            // 14
          args = [];                                                   // 15
        }                                                              //
        data = {                                                       // 17
          src: 'rocketchat',                                           // 18
          fn: method,                                                  // 19
          args: args                                                   // 20
        };                                                             //
        return window.parent.postMessage(JSON.stringify(data), '*');   // 22
      };                                                               //
      self.toggleWindow = function () {                                // 24
        //切换窗口                                                         //
        callParent("toggleWindow");                                    // 26
      };                                                               //
      self.noticeNewMsg = function (msg) {                             // 28
        callParent("noticeNewMsg", msg);                               // 29
      };                                                               //
      self.receiveAWSUrl = function (data) {                           // 31
        callParent("receiveAWSUrl", { url: data.url, id: data.id });   // 32
      };                                                               //
      self.imagePreview = function (data) {                            // 34
        callParent("imagePreview", { id: data.id, list: data.list });  // 35
      };                                                               //
      self.closeWindow = function () {                                 // 37
        callParent("closeWindow");                                     // 38
      };                                                               //
      self.signACK = function (msg) {                                  // 40
        //no need to send ack back to outer web browser                //
        console.log(msg);                                              // 42
      };                                                               //
      var message = null;                                              // 44
      self.cacheUniqueSystemMessage = function (msg) {                 // 45
        message = msg;                                                 // 46
      };                                                               //
      self.recoverUniqueSystemMessage = function () {                  // 48
        var result = message;                                          // 49
        message = null;                                                // 50
        return result;                                                 // 51
      };                                                               //
      var userInfo = null;                                             // 53
      self.cacheUniqueUserInfo = function (msg) {                      // 54
        userInfo = msg;                                                // 55
      };                                                               //
      self.recoverUniqueUserInfo = function () {                       // 57
        var result = userInfo;                                         // 58
        userInfo = null;                                               // 59
        return result;                                                 // 60
      };                                                               //
      if (window.addEventListener) {                                   // 62
        window.addEventListener('message', function (msg) {            // 63
          receiveMessage(msg);                                         // 64
        });                                                            //
      } else if (window.attachEvent) {                                 //
        window.attachEvent('onmessage', function (msg) {               // 67
          receiveMessage(msg);                                         // 68
        });                                                            //
      }                                                                //
      var receiveMessage = function (msg) {                            // 71
        if (msg.data) {                                                // 72
          try {                                                        // 73
            var msgData = eval("(" + msg.data + ")");                  // 74
            if (typeof msgData === 'object' && msgData.src !== undefined && msgData.src === 'livechat-parent') {
              console.log('receiveMessage->', msg);                    // 76
              var args = [].concat(msgData.args || []);                // 77
              return api[msgData.fn].apply(null, args);                // 78
            }                                                          //
          } catch (e) {                                                //
            //msg.data is not a json string                            //
          }                                                            //
        }                                                              //
      };                                                               //
      var api = {                                                      // 85
        transferToAWSUrl: function (message) {                         // 86
          if (window[message.url]) {                                   // 87
            callParent('receiveAWSUrl', { url: window[message.url], id: message.id });
          } else {                                                     //
            Meteor.call('awsGetSignedUrl', message.url, function (error, awsUrl) {
              if (awsUrl !== null && awsUrl !== undefined) {           // 91
                callParent('receiveAWSUrl', { url: awsUrl, id: message.id });
              } else {                                                 //
                callParent('receiveAWSUrl', { url: null, id: message.id });
              }                                                        //
            });                                                        //
          }                                                            //
        }                                                              //
      };                                                               //
    };                                                                 //
    this.outerAgent = new Agent();                                     // 101
  }                                                                    //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);
