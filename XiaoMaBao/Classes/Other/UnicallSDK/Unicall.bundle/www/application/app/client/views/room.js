(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/views/room.js                                                //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
// Generated by CoffeeScript 1.10.0                                    //
(function () {                                                         // 2
  var isSatisfactionOnSubmit = false;                                  // 3
  var surveyByAgent = function (survey) {                              // 4
    var count = 1;                                                     // 5
    Tracker.autorun(function (c) {                                     // 6
      if (!Session.get("roomHasHided")) {                              // 7
        console.log("wait for hide room:" + count);                    // 8
        return;                                                        // 9
      }                                                                //
      c.stop();                                                        // 11
      isSatisfactionOnSubmit = true;                                   // 12
      Meteor.call("saveSatisfaction", {                                // 13
        channelId: "webchat",                                          // 14
        tenantId: "",                                                  // 15
        messageId: visitor.getRoom(),                                  // 16
        surveyResult: survey                                           // 17
      }, function (error, result) {                                    //
        console.log("AgentHideRoom:", error, result);                  // 19
        isSatisfactionOnSubmit = false;                                // 20
        $(".xCover").css("display", "none");                           // 21
        $(".survey-submit").removeClass("agent-survey");               // 22
        if (survey !== "-1") {                                         // 23
          document.getElementById("submit-success").style.display = "block";
        }                                                              //
        Session.set("agent-closing", false);                           // 26
        Session.set("whoEndMsg", "");                                  // 27
      });                                                              //
    });                                                                //
  };                                                                   //
  var surveyByVisitor = function (survey) {                            // 31
    Meteor.call("visitorHideRoom", visitor.getRoom(), function (err, data) {
      console.log("visitorHideRoom:", err, data);                      // 33
      if (!err) {                                                      // 34
        Session.set("roomHasHided", true);                             // 35
        surveyByAgent(survey);                                         // 36
      } else {                                                         //
        alert("错误");                                                   // 38
      }                                                                //
    });                                                                //
  };                                                                   //
  var callParentToggleWindo = function () {                            // 42
    Session.set("hasSendMsg", false);                                  // 43
    //Session.set('chat-room-title', Meteor.settings.public.tenant_livechat_settings ? Meteor.settings.public.tenant_livechat_settings['chat-title-text'] : '开始聊天');
    // Session.set('chat-room-title', Meteor.settings.public.tenant_livechat_settings ? Meteor.settings.public.tenant_livechat_settings['mini-title-text'] : "您需要帮助吗?");
    // Session.set('livechat-closed', true);                           //
    outerAgent.toggleWindow();                                         // 47
  };                                                                   //
                                                                       //
  Template.room.helpers({                                              // 51
    getClosingMsg: function () {                                       // 52
                                                                       //
      return Session.get("agent-closing") === true && isSatisfactionOnSubmit === false ? Meteor.settings["public"].tenant_livechat_settings.surveyByAgent : Meteor.settings["public"].tenant_livechat_settings.surveyByVisitor;
    },                                                                 //
    getAbUrl: function (url) {                                         // 59
      return new Tools().getPath() + url;                              // 60
    },                                                                 //
    messages: function () {                                            // 62
      //rid: visitor.getRoom(),                                        //
      return ChatMessage.find({                                        // 64
        t: {                                                           // 65
          '$ne': 't'                                                   // 66
        }                                                              //
      }, {                                                             //
        sort: {                                                        // 69
          ts: 1                                                        // 70
        }                                                              //
      });                                                              //
    },                                                                 //
    isCordova: function () {                                           // 74
      return Meteor.isCordova;                                         // 75
    },                                                                 //
    supportUploadFile: function () {                                   // 77
      return navigator.userAgent.indexOf('MSIE 8.0') < 0 && navigator.userAgent.indexOf('MSIE 9.0') < 0;
    },                                                                 //
    title: function () {                                               // 80
      return Meteor.isCordova ? Meteor.settings["public"].tenant_livechat_settings.chatTitle : Meteor.settings["public"].tenant_livechat_settings['chat-title-text'];
    },                                                                 //
    ifOpened: function () {                                            // 83
      if (Session.get('livechat-closed') === true) {                   // 84
        return false;                                                  // 85
      }                                                                //
      return true;                                                     // 87
    },                                                                 //
    color: function () {                                               // 89
      var ref;                                                         // 90
      //if (!Template.instance().subscriptionsReady()) {               //
      //  return 'transparent';                                        //
      //}                                                              //
      /*return ((ref = Settings.findOne('Livechat_title_color')) != null ? ref.value : void 0) || '#999999';*/
      return Meteor.settings["public"].tenant_livechat_settings ? Meteor.settings["public"].tenant_livechat_settings['title-bg-color'] : '#434a50';
      //return ((ref = Settings.findOne('Livechat_title_color')) != null ? ref.value : void 0) || '#C1272D';
    },                                                                 //
    fontColor: function () {                                           // 98
      return Meteor.settings["public"].tenant_livechat_settings ? Meteor.settings["public"].tenant_livechat_settings['title-font-color'] : "#ffffff";
    },                                                                 //
    time: function () {                                                // 101
      if (Session.get('startTime')) return moment(Session.get('startTime')).format('YYYY.MM.DD  HH : mm : ss');
    },                                                                 //
    refreshNotice: function () {                                       // 105
      return Session.get('refresh-notice') === 'loading';              // 106
    },                                                                 //
    browserSupportNoticer: function () {                               // 108
      return Session.get("browser-support-notice-show") === true;      // 109
    },                                                                 //
    getAudioUrl: function () {                                         // 111
      return Session.get('audioUrl');                                  // 112
    },                                                                 //
    isCordova: function () {                                           // 114
      return Meteor.isCordova;                                         // 115
    }                                                                  //
  });                                                                  //
                                                                       //
  Template.room.events({                                               // 119
    "click #btn_cancel": function () {                                 // 120
      if (Session.get("whoEndMsg") && Session.get("whoEndMsg") == "agent") {
        surveyByAgent("-1");                                           // 122
      } else {                                                         //
        $(".xCover").css("display", "none");                           // 124
      }                                                                //
    },                                                                 //
    "click #btn_submit": function () {                                 // 127
      var sd = Session.get("SatisfactionDegree");                      // 128
      if (Session.get("whoEndMsg") == "visitor") {                     // 129
        surveyByVisitor(sd);                                           // 130
      } else {                                                         //
        surveyByAgent(sd);                                             // 132
      }                                                                //
    },                                                                 //
    "click #btn_okxxx": function () {                                  // 135
      document.getElementById("submit-success").style.display = "none";
      callParentToggleWindo();                                         // 137
    },                                                                 //
    "click input[type='radio']": function (e) {                        // 139
      var sd = "";                                                     // 140
      switch (e.target.value) {                                        // 141
        case "非常满意":                                                   // 142
          sd = 5;                                                      // 143
          break;                                                       // 144
        case "满意":                                                     // 145
          sd = 4;                                                      // 146
          break;                                                       // 147
        case "一般":                                                     // 148
          sd = 3;                                                      // 149
          break;                                                       // 150
        case "不满意":                                                    // 150
          sd = 2;                                                      // 152
          break;                                                       // 153
        case "非常不满意":                                                  // 153
          sd = 1;                                                      // 155
          break;                                                       // 156
      }                                                                // 156
      Session.set("SatisfactionDegree", sd);                           // 158
    },                                                                 //
    "click #btn_over": function (e) {                                  // 160
      e.stopPropagation();                                             // 161
      e.preventDefault();                                              // 162
      if (visitor.getRoom() && Session.get("hasSendMsg")) {            // 163
        Session.set("whoEndMsg", "visitor");                           // 164
        $(".xCover").css("display", "block");                          // 165
      } else {                                                         //
        //Session.set('chat-room-title', Meteor.settings.public.tenant_livechat_settings ? Meteor.settings.public.tenant_livechat_settings['mini-title-text'] : "您需要帮助吗?");
        //Session.set('livechat-closed', true);                        //
        Session.set("hasSendMsg", false);                              // 169
        outerAgent.closeWindow();                                      // 170
        console.log("房间尚未建立！");                                        // 171
      }                                                                //
    },                                                                 //
    "click #btn_close": function (event) {                             // 174
      event.stopPropagation();                                         // 175
      event.preventDefault();                                          // 176
      surveyByVisitor("-1");                                           // 177
      callParentToggleWindo();                                         // 178
      /*Session.set("roomHasHided", true);                             //
       surveyByAgent(null, function () {                               //
       $(".xCover").css("display", "none");                            //
       callParentToggleWindo();                                        //
       });*/                                                           //
    },                                                                 //
    "click #btn_send": function () {                                   // 185
      return Template.instance().chatMessages.clickButton(visitor.getRoom(), Template.instance().find('.input-message'), Template.instance());
    },                                                                 //
    'keyup .input-message': function (event) {                         // 188
      var inputScrollHeight;                                           // 189
      Template.instance().chatMessages.keyup(visitor.getRoom(), event, Template.instance());
      inputScrollHeight = $(event.currentTarget).prop('scrollHeight');
      if (inputScrollHeight > 70) {                                    // 192
        return $(event.currentTarget).height($(event.currentTarget).val() === '' ? '15px' : inputScrollHeight >= 200 ? inputScrollHeight - 50 : inputScrollHeight - 20);
      }                                                                //
    },                                                                 //
    'keydown .input-message': function (event) {                       // 196
      return Template.instance().chatMessages.keydown(visitor.getRoom(), event, Template.instance());
    },                                                                 //
    'click .new-message': function (e) {                               // 199
      Template.instance().atBottom = true;                             // 200
      return Template.instance().find('.input-message').focus();       // 201
    },                                                                 //
    'change #uploadFileInput': function (event) {                      // 203
      var e = event || event.originalEvent;                            // 204
      var files = e.target.files;                                      // 205
      if (files === undefined || files === null || files.length === 0) {
        if (e.dataTransfer) {                                          // 207
          files = e.dataTransfer.files || [];                          // 208
        }                                                              //
      }                                                                //
      if (files && files.length !== 0) {                               // 211
        var filesToUpload = [];                                        // 212
        for (var i = 0; i < files.length; i++) {                       // 213
          var file = files[i];                                         // 214
          filesToUpload.push({                                         // 215
            file: file,                                                // 216
            name: file.name                                            // 217
          });                                                          //
                                                                       //
          console.log('file selected->' + file.name);                  // 220
        }                                                              //
        slingshotFileUpload(filesToUpload);                            // 222
        //to submit                                                    //
      }                                                                //
    },                                                                 //
    'click .title': function () {                                      // 227
      localStorage.setItem('unreadMessageNumber', 0);                  // 228
      $(".msgcount").hide(0);                                          // 229
      //if (Session.get('chat-room-title') === (Meteor.settings.public.tenant_livechat_settings ? Meteor.settings.public.tenant_livechat_settings['chat-title-text'] : '开始聊天')) {
      //  Session.set('chat-room-title', Meteor.settings.public.tenant_livechat_settings ? Meteor.settings.public.tenant_livechat_settings['mini-title-text'] : '您需要帮助吗?');
      //  Session.set('livechat-closed', true);                        //
      //} else {                                                       //
      //  Session.set('chat-room-title', Meteor.settings.public.tenant_livechat_settings ? Meteor.settings.public.tenant_livechat_settings['chat-title-text'] : '开始聊天');
      //  Session.set('livechat-closed', false);                       //
      //}                                                              //
      return outerAgent.toggleWindow();                                // 237
    },                                                                 //
    'click .error': function (e) {                                     // 239
      return $(e.currentTarget).removeClass('show');                   // 240
    },                                                                 //
    'click #showIE8NoticeButton': function () {                        // 242
      if (Session.get("browser-support-notice-show") === true) Session.set("browser-support-notice-show", false);else Session.set("browser-support-notice-show", true);
    },                                                                 //
    'click .system-notice': function () {                              // 248
      Session.set("browser-support-notice-show", false);               // 249
    },                                                                 //
    'click .msgTime': function (e) {                                   // 251
      return $(e.currentTarget).addClass("hideMsgTime");               // 252
    }                                                                  //
  });                                                                  //
                                                                       //
  /**                                                                  //
   *  订阅房间，并创建房间                                                       //
   */                                                                  //
  Template.room.onCreated(function () {                                // 259
    var self;                                                          // 260
    self = this;                                                       // 261
    self.autorun(function () {                                         // 262
      return self.subscribe('livechat:visitorRoom', visitor.getToken(), function () {
        var room;                                                      // 264
        room = ChatRoom.findOne();                                     // 265
        if (room != null && room.open) {                               // 266
          visitor.setRoom(room._id);                                   // 267
          return RoomHistoryManager.getMoreIfIsEmpty(room._id);        // 268
        }                                                              //
      });                                                              //
    });                                                                //
                                                                       //
    self.subscribe('settings', ['Livechat_title', 'Livechat_title_color']);
    return self.atBottom = true;                                       // 275
  });                                                                  //
  Template.room.onRendered(function () {                               // 277
    Session.set("SatisfactionDegree", 5);                              // 278
    /*默认满意度为非常满意*/                                                     //
    this.chatMessages = new ChatMessages();                            // 280
    Session.set('chat-room-title', Meteor.settings["public"].tenant_livechat_settings ? Meteor.settings["public"].tenant_livechat_settings['chat-title-text'] : '开始聊天');
    //parentCall('toggleWindow');                                      //
    this.chatMessages.init(this.firstNode);                            // 283
                                                                       //
    //播放条                                                              //
    var player = $('#voice-player')[0];                                // 286
    player.addEventListener("ended", function () {                     // 287
      //player.currentTime = 0;                                        //
      $('.message .msgBody .playing').removeClass('playing');          // 289
    });                                                                //
  });                                                                  //
  Template.room.onRendered(function () {                               // 292
    var newMessage, onscroll, template, wrapper, loadHistory;          // 293
    wrapper = this.find('.wrapper');                                   // 294
    newMessage = this.find(".new-message");                            // 295
    template = this;                                                   // 296
    onscroll = _.throttle(function () {                                // 297
      return template.atBottom = wrapper.scrollTop >= wrapper.scrollHeight - wrapper.clientHeight;
    }, 200);                                                           //
    loadHistory = _.throttle(function () {                             // 300
      if (wrapper.scrollTop === 0) {                                   // 301
        CharRecords.load(function (hasMore) {                          // 302
          if (hasMore === true) wrapper.scrollTop = 30;                // 303
        });                                                            //
      }                                                                //
    }, 1000);                                                          //
    var tenantId = new Tools().getUrlParameterByName('tenant_id');     // 309
    Meteor.call("getWebChatConfig", tenantId, true, function (err, data) {
      var welcomes = "您好,请问有什么可以帮到您呢？";                                // 311
      var closing = "本次会话已经结束，感谢您使用在线云客服，再见！";                         // 312
      var advertisement = "欢迎使用荣联.云客服！";                               // 313
      if (!err && data.code === 0) {                                   // 314
        welcomes = data.data.welcomes != "" && data.data.welcomes ? data.data.welcomes : welcomes;
        closing = data.data.closing != "" && data.data.closing ? data.data.closing : closing;
        advertisement = data.data.advertisement != "" && data.data.advertisement ? data.data.advertisement : advertisement;
      }                                                                //
      if (Meteor.isCordova) {                                          // 319
        welcomes = Meteor.settings["public"].tenant_livechat_settings.welcomes;
        closing = Meteor.settings["public"].tenant_livechat_settings.surveyByAgent;
        advertisement = Meteor.settings["public"].tenant_livechat_settings.advertisement;
      }                                                                //
      Session.set("WebChatConfig", {                                   // 324
        advertisement: advertisement,                                  // 325
        welcomes: welcomes,                                            // 326
        closing: closing                                               // 327
      });                                                              //
      console.log("WebChatConfig:", Session.get("WebChatConfig"));     // 329
      Meteor.setTimeout(function () {                                  // 330
        var message = {};                                              // 331
        message.rid = visitor.getRoom();                               // 332
        message.msg = Meteor.settings["public"].tenant_livechat_settings.advertisement;
        message.ts = new Date(Date.now() + (TimeSync.isSynced() ? TimeSync.serverOffset() : 0));
        message.u = {                                                  // 335
          _id: "" + new Date().getTime(),                              // 336
          username: 'Agent',                                           // 337
          name: '  '                                                   // 338
        };                                                             //
        message.temp = false;                                          // 340
        ChatMessage.insert(message);                                   // 341
      }, 100);                                                         //
    });                                                                //
                                                                       //
    Meteor.setInterval(function () {                                   // 347
      if (template.atBottom) {                                         // 348
        wrapper.scrollTop = wrapper.scrollHeight - wrapper.clientHeight;
        //return newMessage.className = "new-message not";             //
      }                                                                //
    }, 100);                                                           //
                                                                       //
    wrapper.addEventListener('touchstart', function () {               // 354
      return template.atBottom = false;                                // 355
    });                                                                //
    wrapper.addEventListener('touchend', function () {                 // 357
      return onscroll();                                               // 358
    });                                                                //
    wrapper.addEventListener('scroll', function () {                   // 360
      template.atBottom = false;                                       // 361
      loadHistory();                                                   // 362
      return onscroll();                                               // 363
    });                                                                //
    wrapper.addEventListener('mousewheel', function () {               // 365
      template.atBottom = false;                                       // 366
      return onscroll();                                               // 367
    });                                                                //
    return wrapper.addEventListener('wheel', function () {             // 369
      template.atBottom = false;                                       // 370
      return onscroll();                                               // 371
    });                                                                //
  });                                                                  //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);
