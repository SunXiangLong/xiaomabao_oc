(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/startup/room.js                                              //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
// Generated by CoffeeScript 1.10.0                                    //
(function () {                                                         // 2
  var msgStream, notifyStream, checkInvalidMessage, autoRunCount;      // 3
                                                                       //
  msgStream = new Meteor.Stream('messages');                           // 5
  this.notifyStream = new Meteor.Stream('notify-room');                // 6
  checkInvalidMessage = false;                                         // 7
  autoRunCount = 0;                                                    // 8
                                                                       //
  Session.set("hasSendMsg", false);                                    // 10
                                                                       //
  Tracker.autorun(function () {                                        // 12
    autoRunCount++;                                                    // 13
    console.log("visitor start up  autoRun:", autoRunCount, visitor.getRoom());
                                                                       //
    if (visitor.getRoom() != null) {                                   // 16
      //定义监听 Message.Stream 当有消息进来时 在本地mini插入消息数据                      //
      //目前，访客端消息在刷新之后会丢失，因此，初始化时把未读消息设置为0                              //
      console.log("regis event");                                      // 19
      localStorage.setItem('unreadMessageNumber', 0);                  // 20
      msgStream.on(visitor.getRoom(), function (msg) {                 // 21
        if (msg.t === 'sys') {                                         // 22
          if (msg.msg = 'AgentOffline') showError('您的坐席下线了!');         // 23
        } else {                                                       //
          hideError();                                                 // 27
          if (msg.userId !== Meteor.userId()) {                        // 28
            if (ChatMessage.find({ _id: msg._id }).count() === 0) {    // 29
              unread = localStorage.getItem('unreadMessageNumber');    // 30
              if (unread !== undefined && unread !== null) localStorage.setItem('unreadMessageNumber', parseInt(unread) + 1);else localStorage.setItem('unreadMessageNumber', 1);
            }                                                          //
            var msgcount = localStorage.getItem('unreadMessageNumber');
                                                                       //
            if (Session.get('livechat-closed') === true) {             // 38
              $(".msgcount span").html(msgcount > 99 ? 99 : msgcount);
              $(".msgcount").show();                                   // 40
            }                                                          //
          }                                                            //
          if (msg.type !== "merchandise") if (ChatMessage.findOne({ _id: msg._id })) {
            var obj = {};                                              // 45
            for (var k in babelHelpers.sanitizeForInObject(msg)) {     // 46
              if (k !== "_id") {                                       // 47
                obj[k] = msg[k];                                       // 48
              }                                                        //
            }                                                          //
            obj.temp = false;                                          // 51
            ChatMessage.update({                                       // 52
              _id: msg._id                                             // 53
            }, { $set: obj });                                         //
          } else {                                                     //
            ChatMessage.insert(msg);                                   // 56
            outerAgent.noticeNewMsg(msg);                              // 57
          }                                                            //
          if (ChatMessage.find({ rid: visitor.getRoom() }).count() === 1) {
            Session.set('startTime', msg.ts);                          // 60
          }                                                            //
          if (checkInvalidMessage === false) {                         // 62
            checkInvalidMessage = true;                                // 63
            ChatMessage.remove({ u: { _id: Meteor.userId(), username: 'visitor' } });
          }                                                            //
        }                                                              //
      });                                                              //
      csvControler.listen(visitor.getRoom());                          // 68
                                                                       //
      //notifyStream.on(visitor.getRoom() + "/hide", function (rid) {  //
      //  console.log("hide your room", rid);                          //
      //  //showError(Session.get("WebChatConfig").closing);           //
      //    Session.set("whoEndMsg", "agent");                         //
      //    Session.set("roomHasHided", true);                         //
      //    $(".xCover").css("display", "block");                      //
      //                                                               //
      //});                                                            //
    } else {                                                           //
        console.log("not regis event");                                // 81
      }                                                                //
  });                                                                  //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);