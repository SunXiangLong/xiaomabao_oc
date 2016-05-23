(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/methods/sendMessageExternal.js                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
// Generated by CoffeeScript 1.10.0                                    //
(function () {                                                         // 2
  Meteor.methods({                                                     // 3
    sendMessageLivechat: function (message) {                          // 4
      if (!Session.get("hasSendMsg")) {                                // 5
        Session.set("hasSendMsg", true);                               // 6
      }                                                                //
      message.ts = new Date(Date.now() + (TimeSync.isSynced() ? TimeSync.serverOffset() : 0));
      message.u = {                                                    // 9
        _id: Meteor.userId(),                                          // 10
        username: 'visitor',                                           // 11
        name: 'visitor'                                                // 12
      };                                                               //
      if (message.temp === undefined) message.temp = true;             // 14
      if (ChatMessage.findOne({ _id: message._id })) {                 // 16
        return ChatMessage.update(message);                            // 17
      } else {                                                         //
        return ChatMessage.insert(message);                            // 19
      }                                                                //
    },                                                                 //
    sendMessageToLocalLivechat: function (message) {                   // 22
      message.ts = new Date(Date.now() + TimeSync.serverOffset());     // 23
      message.u = {                                                    // 24
        _id: Meteor.userId(),                                          // 25
        username: 'visitor',                                           // 26
        name: 'visitor'                                                // 27
      };                                                               //
      return ChatMessage.insert(message);                              // 29
    },                                                                 //
    sendMessageLivechatData: function (data, callback) {               // 31
      function dummy() {                                               // 32
        if (!data._id) {                                               // 33
          data._id = Random.id();                                      // 34
        }                                                              //
        // if(!data.rid){                                              //
        data.rid = visitor.getRoom(true);                              // 37
        // }                                                           //
        Meteor.call('sendMessageLivechat', data, function (err, result) {
          if (err) {                                                   // 40
            ChatMessage.update(msgId, {                                // 41
              $set: {                                                  // 42
                error: true                                            // 43
              }                                                        //
            });                                                        //
            return showError('发送消息失败！');                               // 46
          } else {                                                     //
            if (result) {                                              // 48
              if (result.rid && visitor.getRoom() !== result.rid) {    // 49
                csvControler.onRoomChanged(result.rid);                // 50
              }                                                        //
              if (result.type !== "merchandise") if (ChatMessage.findOne({ _id: result._id })) {
                var properties = {};                                   // 54
                for (var i in babelHelpers.sanitizeForInObject(result)) {
                  if (i !== '_id') {                                   // 56
                    properties[i] = result[i];                         // 57
                  }                                                    //
                }                                                      //
                properties.temp = false;                               // 60
                ChatMessage.update({                                   // 61
                  _id: result._id                                      // 62
                }, { $set: properties });                              //
              } else {                                                 //
                ChatMessage.insert(result);                            // 65
              }                                                        //
              if (callback) callback();                                // 67
            }                                                          //
          }                                                            //
        });                                                            //
      }                                                                //
      var sysMsg = outerAgent.recoverUniqueSystemMessage();            // 73
      if (sysMsg) {                                                    // 74
        //sysMsg._id =  Random.id();                                   //
        //sysMsg.rid = data.rid;                                       //
        function innerDummy() {                                        // 77
          sysMsg.temp = false;                                         // 78
          Meteor.call('sendMessageLivechatData', sysMsg, function () {
            setTimeout(dummy, 50);                                     // 80
          }, function () {});                                          //
        }                                                              //
        setTimeout(innerDummy, 50);                                    // 83
      } else {                                                         //
        setTimeout(dummy, 50);                                         // 85
      }                                                                //
    }                                                                  //
  });                                                                  //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);
