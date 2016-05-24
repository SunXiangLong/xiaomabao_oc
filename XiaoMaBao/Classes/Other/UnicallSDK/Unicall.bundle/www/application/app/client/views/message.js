(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/views/message.js                                             //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
// Generated by CoffeeScript 1.10.0                                    //
(function () {                                                         // 2
  Template.message.helpers({                                           // 3
    own: function () {                                                 // 4
      var ref;                                                         // 5
      if (((ref = this.u) != null ? ref._id : void 0) === Meteor.userId()) {
        return 'own';                                                  // 7
      }                                                                //
    },                                                                 //
    time: function () {                                                // 10
      if (this.ts) return moment(this.ts).format('HH:mm');else return moment(new Date()).format('HH:mm');
    },                                                                 //
    currentTime: function () {                                         // 16
      if (this.ts) return this.ts.getTime();else return new Date().getTime();
    },                                                                 //
    date: function () {                                                // 22
      return moment(this.ts).format('LL');                             // 23
    },                                                                 //
    avatarName: function () {},                                        // 25
    isTemp: function () {                                              // 28
      if (this.temp === true) {                                        // 29
        return 'temp';                                                 // 30
      }                                                                //
    },                                                                 //
    messageOwner: function () {                                        // 33
      var shownName = "&nbsp;";                                        // 34
      var messageUserId = this.u._id;                                  // 35
      var meteorUser = Meteor.user();                                  // 36
      if (meteorUser && messageUserId) {                               // 37
        if (messageUserId === meteorUser._id) {                        // 38
          if (Meteor.isCordova) {                                      // 39
            return Meteor.settings['public'].appUsername || shownName;
          } else {                                                     //
            return shownName;                                          // 42
          }                                                            //
        }                                                              //
      }                                                                //
      var realName = this.u.name.trim();                               // 47
      shownName = realName === '' ? shownName : realName.substring(0, 8);
      return shownName;                                                // 49
    },                                                                 //
    error: function () {                                               // 51
      if (this.error) {                                                // 52
        return 'msg-error';                                            // 53
      }                                                                //
    },                                                                 //
    payloadFile: function () {                                         // 56
      return Session.get("redirect:" + this._id);                      // 57
    },                                                                 //
    redirectFile: function () {                                        // 59
      return Session.get("redirectUrl:" + this._id);                   // 60
    },                                                                 //
    imagePayload: function () {                                        // 62
      return Session.get("payloadType:" + this._id) === 'image';       // 63
    },                                                                 //
    audioPayload: function () {                                        // 65
      return Session.get("payloadType:" + this._id) === 'audio';       // 66
    },                                                                 //
    imageLoadingUrl: function () {                                     // 68
      return new Tools().getPath() + 'packages/rocketchat_livechat/public/image_loading.png';
    },                                                                 //
    audioPlayerUrl: function () {                                      // 71
      return new Tools().getPath() + 'audio_player?' + Session.get("redirect:" + this._id);
    },                                                                 //
    audioWidth: function () {                                          // 74
      return 40 + 7 * this.s3url.duration;                             // 75
    },                                                                 //
    isIE: function () {                                                // 77
      var isFirefox = navigator.userAgent.toUpperCase().indexOf("FIREFOX") !== -1;
      var isChrome = navigator.userAgent.toUpperCase().indexOf("CHROME") !== -1;
      return !(isFirefox || isChrome || Meteor.isCordova);             // 80
    },                                                                 //
    isCordova: function () {                                           // 82
      return Meteor.isCordova;                                         // 83
    },                                                                 //
    body: function () {                                                // 85
      var message;                                                     // 86
      switch (this.t) {                                                // 87
        case 'r':                                                      // 88
          return t('Room_name_changed', {                              // 89
            room_name: this.msg,                                       // 90
            user_by: this.u.username                                   // 91
          });                                                          //
        case 'au':                                                     // 92
          return t('User_added_by', {                                  // 94
            user_added: this.msg,                                      // 95
            user_by: this.u.username                                   // 96
          });                                                          //
        case 'ru':                                                     // 97
          return t('User_removed_by', {                                // 99
            user_removed: this.msg,                                    // 100
            user_by: this.u.username                                   // 101
          });                                                          //
        case 'ul':                                                     // 102
          return tr('User_left', {                                     // 104
            context: this.u.gender                                     // 105
          }, {                                                         //
            user_left: this.u.username                                 // 107
          });                                                          //
        case 'uj':                                                     // 109
          return tr('User_joined_channel', {                           // 110
            context: this.u.gender                                     // 111
          }, {                                                         //
            user: this.u.username                                      // 113
          });                                                          //
        case 'wm':                                                     // 114
          return t('Welcome', {                                        // 116
            user: this.u.username                                      // 117
          });                                                          //
        default:                                                       // 119
          this.html = this.msg;                                        // 120
          if (s.trim(this.html) !== '') {                              // 121
            this.html = s.escapeHTML(this.html);                       // 122
          }                                                            //
          message = this;                                              // 124
          MarkDownRender(message);                                     // 125
          message.html = emojione.toImage(message.html);               // 126
          var spliter = message.html.indexOf('\n');                    // 127
          if (spliter >= 0) {                                          // 128
            this.html = message.html.replace(/\n/gm, '<br/>');         // 129
            //if(this.urls){                                           //
            //  for(url in this.urls){                                 //
            //    this.html +="<img width='100%' src ='"+this.urls[url].url+"'></img>";
            //  }                                                      //
            //}                                                        //
          } else {                                                     //
              this.html = message.html;                                // 136
            }                                                          //
          if (message.imageBytes) {                                    // 138
            if (Meteor.isCordova) {                                    // 139
              return '<div><a href=\'' + message.imageBytes + '\' class="swipebox" title="预览" ><img id="byte-image-' + message._id + '" title=\'预览\' class=\'image\' src=\'' + message.imageBytes + '\'/></a><div id="progress-image-' + message._id + '" style="height: 2px;background-color: #00ff00;position: absolute;right: 0;"></div></div>';
            } else {                                                   //
              return '<div><img id="byte-image-' + message._id + '" title=\'预览\' class=\'local-image\' src=\'' + message.imageBytes + '\'/><div id="progress-image-' + message._id + '" style="height: 2px;background-color: #00ff00;position: absolute;right: 0;"></div></div>';
            }                                                          //
          } else if (message.s3url) {                                  //
            var item = message.s3url;                                  // 145
            if (item.contentType && item.contentType.match(/image\/.*/)) {
              Session.set("redirectUrl:" + message._id, item.uri);     // 147
              var imgId = Random.id();                                 // 148
              //there is only one rurl in message                      //
              Session.set("payloadType:" + message._id, 'image');      // 150
              Session.set("redirect:" + message._id, imgId);           // 151
              Meteor.call('awsGetSignedUrl', item.uri, function (error, result) {
                if (result !== null && result !== undefined) {         // 153
                  if (window['image-cache'] === null || window['image-cache'] === undefined) {
                    window['image-cache'] = [];                        // 155
                  }                                                    //
                  //app增加图片放大功能                                        //
                  if (Meteor.isCordova) {                              // 158
                    $('#' + imgId).parent().prop('href', result);      // 159
                  }                                                    //
                  window.document.getElementById(imgId).setAttribute('src', result);
                  window.document.getElementById(imgId).setAttribute('originSrc', item.uri);
                  for (var i = 0; i < window['image-cache'].length; i++) {
                    if (window['image-cache'][i] === item.uri) {       // 164
                      return;                                          // 165
                    }                                                  //
                  }                                                    //
                  window['image-cache'][window['image-cache'].length] = item.uri;
                }                                                      //
              });                                                      //
                                                                       //
              return '';                                               // 172
            } else {                                                   //
              var fileIcon = "packages/rocketchat_livechat/public/unknownFile.png";
              if (item.contentType && item.contentType.match(/audio\/.*/)) {
                var isFirefox = navigator.userAgent.toUpperCase().indexOf("FIREFOX") !== -1;
                var isChrome = navigator.userAgent.toUpperCase().indexOf("CHROME") !== -1;
                if (isChrome || isFirefox) {                           // 178
                  Session.set("payloadType:" + message._id, 'audio');  // 179
                  Session.set("redirect:" + message._id, item.uri);    // 180
                  return '';                                           // 181
                } else {                                               //
                  //create a iframe to play audio                      //
                  Session.set("payloadType:" + message._id, 'audio');  // 184
                  Session.set("redirect:" + message._id, item.uri);    // 185
                  return '';                                           // 186
                }                                                      //
              } else if (item.contentType && item.contentType.match(/video\/.*|application\/vnd.rn-realmedia/)) {
                fileIcon = "packages/rocketchat_livechat/public/videoFile.png";
              } else if (item.contentType && item.contentType.match(/application\/pdf/)) {
                fileIcon = "packages/rocketchat_livechat/public/pdfFile.png";
              } else if (item.contentType && item.contentType.match(/application\/vnd.ms-excel/)) {
                fileIcon = "packages/rocketchat_livechat/public/excelFile.png";
              } else if (item.contentType && item.contentType.match(/application\/zip|application\/x-zip-compressed/)) {
                fileIcon = "packages/rocketchat_livechat/public/zipFile.png";
              } else if (item.contentType && item.contentType.match(/application\/msword|application\/vnd.ms-project|application\/vnd.openxmlformats-officedocument.wordprocessingml.document/)) {
                fileIcon = "packages/rocketchat_livechat/public/wordFile.png";
              }                                                        //
                                                                       //
              var maxLength = 246;                                     // 204
              var shortName = item.filename;                           // 205
              if (shortName.indexOf('.') >= 0) {                       // 206
                var ps = shortName.split('.');                         // 207
                shortName = '';                                        // 208
                for (var i = 0; i < ps.length - 1; i++) {              // 209
                  shortName += ps[i] + '.';                            // 210
                }                                                      //
                shortName = shortName.substring(0, shortName.length - 1);
              }                                                        //
              if (shortName.length <= 10) {                            // 214
                maxLength = (shortName.length + 6) * 12;               // 215
              } else {                                                 //
                shortName = shortName.substring(0, 10) + '...';        // 217
              }                                                        //
              var size = Math.round(item.contentLength / 1024) === 0 ? item.contentLength + "B" : Math.round(item.contentLength / (1024 * 1024)) === 0 ? Math.round(item.contentLength / 1024) + 'k' : Math.round(item.contentLength / (1024 * 1024 * 1024)) === 0 ? Math.round(item.contentLength / (1024 * 1024)) + 'm' : Math.round(item.contentLength / (1024 * 1024 * 1024)) + 'g';
              return '<div class="" title="' + item.filename + '" style="text-align:left;color:#777777;"><img style="margin-bottom:-5px;margin-right:10px;" src="' + new Tools().getPath() + fileIcon + '"/><span onClick="window.open(\'' + item.uri + '\')">' + shortName + '</span><span style="font-size:10px;">(' + size + ')</span></div>';
            }                                                          //
          }                                                            //
          if (message.type === "merchandise") {                        // 226
            var innerHtml = '<div class="arrowBorder"/><div class="arrow"/>';
            if (message.data.url && message.data.url !== '') {         // 228
              innerHtml += '<div class="msgBody" title="' + message.data.url + '" style="width:100%;">';
            } else {                                                   //
              innerHtml += '<div class="msgBody" style="width:100%;">';
            }                                                          //
            if (message.data.title && message.data.title !== '') {     // 233
              innerHtml += '<div style="text-align:center;font-size: large;">' + message.data.title + '</div>';
            }                                                          //
            if (message.data.iconUrl && message.data.iconUrl !== '' && message.data.content && message.data.content !== '') {
              innerHtml += '<div><div style="width:30%;height:50%;display:inline-block;vertical-align: top;"><img style="width:100%;" src="' + message.data.iconUrl + '"/></div><div style="width:65%;height:50%;display:inline-block;text-align:left;">' + message.data.content + '</div></div>';
            } else if (message.data.iconUrl && message.data.iconUrl !== '') {
              innerHtml += '<div><div style="width:100%;height:50%;display:inline-block;vertical-align: top;"><img style="width:100%;" src="' + message.data.iconUrl + '"/></div></div>';
            } else if (message.data.content && message.data.content !== '') {
              innerHtml += '<div><div style="width:100%;height:50%;display:inline-block;text-align:left;">' + message.data.content + '</div></div>';
            }                                                          //
            innerHtml += '</div>';                                     // 243
            return innerHtml;                                          // 244
          }                                                            //
          if (this.msg.length < 16) {                                  // 246
            return '<div class="arrowBorder"/><div class="arrow"/><div class="msgBody" style="width:' + (this.msg.length + 1) * 12 + 'px;">' + this.html + '</div>';
          } else {                                                     //
            return '<div class="arrowBorder"/><div class="arrow"/><div class="msgBody" style="width:' + 246 + 'px;">' + this.html + '</div>';
          }                                                            //
                                                                       //
      }                                                                // 250
    },                                                                 //
    uriFromServer: function () {                                       // 254
      return this.s3url.uri;                                           // 255
    },                                                                 //
                                                                       //
    system: function () {                                              // 258
      var ref;                                                         // 259
      if ((ref = this.t) === 's' || ref === 'p' || ref === 'f' || ref === 'r' || ref === 'au' || ref === 'ru' || ref === 'ul' || ref === 'wm' || ref === 'uj') {
        return 'system';                                               // 261
      }                                                                //
    },                                                                 //
    isUnread: function () {                                            // 264
      if (this.u._id != Meteor.userId() && this.s3url.isRead === false) {
        return 'unRead';                                               // 266
      }                                                                //
    }                                                                  //
  });                                                                  //
                                                                       //
  Template.room.events({                                               // 271
    "click .image": function (e) {                                     // 272
      var currentUri = e.currentTarget.getAttribute('originSrc');      // 273
      var list = [];                                                   // 274
      var cache = window['image-cache'];                               // 275
      if (cache) {                                                     // 276
        for (var i = 0; i < cache.length; i++) {                       // 277
          list[list.length] = cache[i];                                // 278
        }                                                              //
      };                                                               //
      outerAgent.imagePreview({ id: currentUri, list: list });         // 281
    },                                                                 //
    "click .local-image": function (e) {                               // 283
      var src = e.currentTarget.getAttribute('src');                   // 284
      var id = e.currentTarget.getAttribute('id');                     // 285
      window[id] = src;                                                // 286
      var list = [];                                                   // 287
      list[list.length] = id;                                          // 288
      outerAgent.imagePreview({ id: id, list: list });                 // 289
    },                                                                 //
                                                                       //
    "click .s3-swipebox": function (event) {                           // 292
      event.preventDefault();                                          // 293
      $.swipebox([{ href: event.target.getAttribute('data-url') }]);   // 294
    },                                                                 //
    "load .image": function (e) {                                      // 296
      var currentUri = e.currentTarget.getAttribute('src');            // 297
      //图片正在加载时，显示"拼命加载中。。。",此处是加载成功，立即显示图片                            //
    },                                                                 //
    "error .image": function (e) {                                     // 300
      var currentUri = e.currentTarget.getAttribute('src');            // 301
      //图片正在加载时，显示"拼命加载中。。。",此处是加载失败，显示失败图片，并且提供重新加载功能                 //
    },                                                                 //
    "click .audioMsg": function (e) {                                  // 304
      Session.set('audioUrl', e.currentTarget.getAttribute('data-src'));
      var player = $('#voice-player')[0];                              // 306
      var playing = $('.message .msgBody .playing');                   // 307
      Meteor.setTimeout(function () {                                  // 308
        if (!player.paused) {                                          // 309
          //重新加载player,即停止.或者用pause                                    //
          player.load();                                               // 311
          playing.removeClass('playing');                              // 312
        } else {                                                       //
          playing.removeClass('playing');                              // 314
          //播放                                                         //
          player.play();                                               // 316
          $(e.currentTarget).children('.audioIcon').addClass('playing');
          if ($(e.currentTarget).find('.unRead').length > 0) {         // 318
            $(e.currentTarget).find('.unRead').removeClass('unRead');  // 319
            //setTimeout解决更新后立即停止BUG                                   //
            Meteor.setTimeout(function () {                            // 321
              //设为已读                                                   //
              Meteor.call('readVoiceMsg', e.currentTarget.getAttribute('data-msgid'));
            }, e.currentTarget.getAttribute('data-duration') * 1000);  //
          }                                                            //
        }                                                              //
      }, 10); //延时10毫秒                                                 //
    }                                                                  //
  });                                                                  //
  Template.message.onViewRendered = function (context) {               // 330
    var view;                                                          // 331
    view = this;                                                       // 332
    return this._domrange.onAttached(function (domRange) {             // 333
      var fn, i, item, lastNode, len, newMessage, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, ul, wrapper;
      lastNode = domRange.lastNode();                                  // 335
      if (((ref = lastNode.previousElementSibling) != null ? (ref1 = ref.getAttribute('data_date')) != null ? ref1 : void 0 : void 0) !== lastNode.getAttribute('data_date')) {
                                                                       //
        $(lastNode).addClass('new-day');                               // 338
        $(lastNode).removeClass('sequential');                         // 339
      } else if (((ref2 = lastNode.previousElementSibling) != null ? (ref3 = ref2.getAttribute('data_username')) != null ? ref3 : void 0 : void 0) !== lastNode.getAttribute('data_username')) {
        $(lastNode).removeClass('sequential');                         // 341
      }                                                                //
      if (((ref4 = lastNode.nextElementSibling) != null ? (ref5 = ref4.getAttribute('data_date')) != null ? ref5 : void 0 : void 0) === lastNode.getAttribute('data_date')) {
        $(lastNode.nextElementSibling).removeClass('new-day');         // 344
        $(lastNode.nextElementSibling).addClass('sequential');         // 345
      } else {                                                         //
        $(lastNode.nextElementSibling).addClass('new-day');            // 347
        $(lastNode.nextElementSibling).removeClass('sequential');      // 348
      }                                                                //
      if (((ref6 = lastNode.nextElementSibling) != null ? (ref7 = ref6.getAttribute('data_username')) != null ? ref7 : void 0 : void 0) !== lastNode.getAttribute('data_username')) {
        $(lastNode.nextElementSibling).removeClass('sequential');      // 351
      }                                                                //
      ul = lastNode.parentElement;                                     // 353
      wrapper = ul.parentElement;                                      // 354
      if (((ref8 = context.urls) != null ? ref8.length : void 0) > 0 && Template.oembedBaseWidget != null) {
        ref9 = context.urls;                                           // 356
        fn = function (item) {                                         // 357
          var urlNode;                                                 // 358
          urlNode = lastNode.querySelector('.body a[href="' + item.url + '"]');
          if (urlNode != null) {                                       // 360
            return $(urlNode).replaceWith(Blaze.toHTMLWithData(Template.oembedBaseWidget, item));
          }                                                            //
        };                                                             //
        for (i = 0, len = ref9.length; i < len; i++) {                 // 364
          item = ref9[i];                                              // 365
          fn(item);                                                    // 366
        }                                                              //
      }                                                                //
      if (lastNode.nextElementSibling == null) {                       // 369
        var classList = lastNode.getAttribute("class");                // 370
        if (classList && (classList.startsWith('own ') || classList.endsWith(' own') || classList.indexOf(' own ') >= 0)) {
          return view.parentView.parentView.parentView.parentView.parentView.templateInstance().atBottom = true;
        }                                                              //
        if (view.parentView.parentView.parentView.parentView.parentView.templateInstance().atBottom !== true) {
          newMessage = document.querySelector(".new-message");         // 375
          return newMessage.className = "new-message";                 // 376
        }                                                              //
      }                                                                //
    });                                                                //
  };                                                                   //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);