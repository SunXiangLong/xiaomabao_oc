(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/lib/chatMessages.js                                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
(function () {                                                         // 1
	var __indexOf = [].indexOf || function (item) {                       // 2
		for (var i = 0, l = this.length; i < l; i++) {                       // 2
			if (i in this && this[i] === item) return i;                        // 2
		}return -1;                                                          //
	};                                                                    //
                                                                       //
	this.ChatMessages = (function () {                                    // 4
		function ChatMessages() {}                                           // 5
                                                                       //
		ChatMessages.prototype.init = function (node) {                      // 7
			this.editing = {};                                                  // 8
			this.wrapper = $(node).find(".wrapper");                            // 9
			this.input = $(node).find(".input-message").get(0);                 // 10
		};                                                                   //
                                                                       //
		ChatMessages.prototype.resize = function () {                        // 13
			var dif;                                                            // 14
			dif = 60 + $(".messages-container").find("footer").outerHeight();   // 15
			return $(".messages-box").css({                                     // 16
				height: "calc(100% - " + dif + "px)"                               // 17
			});                                                                 //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.toPrevMessage = function () {                 // 21
			var msgs;                                                           // 22
			msgs = this.wrapper.get(0).querySelectorAll(".own:not(.system)");   // 23
			if (msgs.length) {                                                  // 24
				if (this.editing.element) {                                        // 25
					if (msgs[this.editing.index - 1]) {                               // 26
						return this.edit(msgs[this.editing.index - 1], this.editing.index - 1);
					}                                                                 //
				} else {                                                           //
					return this.edit(msgs[msgs.length - 1], msgs.length - 1);         // 30
				}                                                                  //
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.toNextMessage = function () {                 // 35
			var msgs;                                                           // 36
			if (this.editing.element) {                                         // 37
				msgs = this.wrapper.get(0).querySelectorAll(".own:not(.system)");  // 38
				if (msgs[this.editing.index + 1]) {                                // 39
					return this.edit(msgs[this.editing.index + 1], this.editing.index + 1);
				} else {                                                           //
					return this.clearEditing();                                       // 42
				}                                                                  //
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.getEditingIndex = function (element) {        // 47
			var index, msg, msgs, _i, _len;                                     // 48
			msgs = this.wrapper.get(0).querySelectorAll(".own:not(.system)");   // 49
			index = 0;                                                          // 50
			for (_i = 0, _len = msgs.length; _i < _len; _i++) {                 // 51
				msg = msgs[_i];                                                    // 52
				if (msg === element) {                                             // 53
					return index;                                                     // 54
				}                                                                  //
				index++;                                                           // 56
			}                                                                   //
			return -1;                                                          // 58
		};                                                                   //
                                                                       //
		ChatMessages.prototype.edit = function (element, index) {            // 61
			var id, message;                                                    // 62
			var classList = element.getAttribute("class");                      // 63
			if (classList && (classList.startsWith("system ") || classList.endsWith(" system") || classList.indexOf(" system ") >= 0)) {
				return;                                                            // 65
			}                                                                   //
			this.clearEditing();                                                // 67
			id = element.getAttribute("id");                                    // 68
			message = ChatMessage.findOne({                                     // 69
				_id: id,                                                           // 70
				'u._id': Meteor.userId()                                           // 71
			});                                                                 //
			this.input.value = message.msg;                                     // 73
			this.editing.element = element;                                     // 74
			this.editing.index = index || this.getEditingIndex(element);        // 75
			this.editing.id = id;                                               // 76
			element.classList.add("editing");                                   // 77
			this.input.classList.add("editing");                                // 78
			return setTimeout((function (_this) {                               // 79
				return function () {                                               // 80
					return _this.input.focus();                                       // 81
				};                                                                 //
			})(this), 5);                                                       //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.clearEditing = function () {                  // 86
			if (this.editing.element) {                                         // 87
				this.editing.element.classList.remove("editing");                  // 88
				this.input.classList.remove("editing");                            // 89
				this.editing.id = null;                                            // 90
				this.editing.element = null;                                       // 91
				this.editing.index = null;                                         // 92
				return this.input.value = this.editing.saved || "";                // 93
			} else {                                                            //
				return this.editing.saved = this.input.value;                      // 95
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.send = function (rid, input) {                // 99
			var msg, sendMessage;                                               // 100
			if (s.trim(input.value) !== '') {                                   // 101
				if (this.isMessageTooLong(input)) {                                // 102
					return Errors["throw"](t('Error_message_too_long'));              // 103
				}                                                                  //
				msg = input.value;                                                 // 105
				input.value = '';                                                  // 106
				if (!rid) {                                                        // 107
					rid = visitor.getRoom(true);                                      // 108
				}                                                                  //
				sendMessage = function (obj, callback) {                           // 110
					var command, match, msgObject, param;                             // 111
					msgObject = {                                                     // 112
						_id: Random.id(),                                                // 113
						rid: obj.rid,                                                    // 114
						msg: obj.msg,                                                    // 115
						token: visitor.getToken(),                                       // 116
						clientType: Meteor.isCordova ? device.platform : 'webchat',      // 117
						fromWebSite: localStorage.getItem('_3partywebsite')              // 118
					};                                                                //
					MsgTyping.stop(rid);                                              // 120
					if (msg[0] === '/') {                                             // 121
						match = msg.match(/^\/([^\s]+)(?:\s+(.*))?$/m);                  // 122
						if (match != null) {                                             // 123
							command = match[1];                                             // 124
							param = match[2];                                               // 125
							return Meteor.call('slashCommand', {                            // 126
								cmd: command,                                                  // 127
								params: param,                                                 // 128
								msg: msgObject                                                 // 129
							});                                                             //
						}                                                                //
					} else {                                                          //
						if (Meteor.isCordova) {                                          // 133
							msgObject.fromAppKey = Meteor.settings["public"].unicallAppKey;
						}                                                                //
						return Meteor.call('sendMessageLivechatData', msgObject, callback, function (err, result) {
							console.log(err);                                               // 137
						});                                                              //
					}                                                                 //
				};                                                                 //
				if (!Meteor.userId()) {                                            // 141
					return loginer.send({ rid: rid, msg: msg }, sendMessage);         // 142
				} else {                                                           //
					return sendMessage({ rid: rid, msg: msg });                       // 144
				}                                                                  //
			}                                                                   //
		};                                                                   //
                                                                       //
		var loginer = {                                                      // 149
			active: false,                                                      // 150
			msgs: [],                                                           // 151
			send: function (obj, callback) {                                    // 152
				var self = this;                                                   // 153
				if (this.active === false) {                                       // 154
					Meteor.call('registerGuest', visitor.getToken(), new Tools().getUrlParameterByName('tenant_id'), function (error, result) {
						if (error != null) {                                             // 156
							return showError('注册访客失败！');                                    // 157
						}                                                                //
						return Meteor.loginWithPassword({ id: result.user }, result.pass, function (error) {
							if (error) {                                                    // 160
								return showError('访客登录失败！');                                   // 161
							}                                                               //
							var userInfo = outerAgent.recoverUniqueUserInfo();              // 163
							if (userInfo) {                                                 // 164
								Meteor.call('update-visitor-name', userInfo.nickname, function (err, result) {
									console.log(err);                                             // 166
								});                                                            //
							}                                                               //
							self.msgs.forEach(function (o) {                                // 169
								callback(o);                                                   // 170
							});                                                             //
						});                                                              //
					});                                                               //
					this.active = true;                                               // 174
				}                                                                  //
				this.msgs[this.msgs.length] = obj;                                 // 176
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.deleteMsg = function (message) {              // 180
			return Meteor.call('deleteMessage', message, function (error, result) {
				if (error) {                                                       // 182
					return Errors["throw"](error.reason);                             // 183
				}                                                                  //
			});                                                                 //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.update = function (id, rid, input) {          // 188
			var msg;                                                            // 189
			if (s.trim(input.value) !== '') {                                   // 190
				msg = input.value;                                                 // 191
				Meteor.call('updateMessage', {                                     // 192
					id: id,                                                           // 193
					msg: msg                                                          // 194
				});                                                                //
				this.clearEditing();                                               // 196
				return MsgTyping.stop(rid);                                        // 197
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.startTyping = function (rid, input) {         // 201
			if (s.trim(input.value) !== '') {                                   // 202
				return MsgTyping.start(rid);                                       // 203
			} else {                                                            //
				return MsgTyping.stop(rid);                                        // 205
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.bindEvents = function () {                    // 209
			var _ref;                                                           // 210
			if ((_ref = this.wrapper) != null ? _ref.length : void 0) {         // 211
				return $(".input-message").autogrow({                              // 212
					postGrowCallback: (function (_this) {                             // 213
						return function () {                                             // 214
							return _this.resize();                                          // 215
						};                                                               //
					})(this)                                                          //
				});                                                                //
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.tryCompletion = function (input) {            // 222
			var re, user, value;                                                // 223
			value = input.value.match(/[^\s]+$/);                               // 224
			if ((value != null ? value.length : void 0) > 0) {                  // 225
				value = value[0];                                                  // 226
				re = new RegExp(value, 'i');                                       // 227
				user = Meteor.users.findOne({                                      // 228
					username: re                                                      // 229
				});                                                                //
				if (user != null) {                                                // 231
					return input.value = input.value.replace(value, "@" + user.username + " ");
				}                                                                  //
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.keyup = function (rid, event) {               // 237
			var i, input, k, keyCodes, _i, _j;                                  // 238
			input = event.currentTarget;                                        // 239
			k = event.which;                                                    // 240
			keyCodes = [13, 20, 16, 9, 27, 17, 91, 19, 18, 93, 45, 34, 35, 144, 145];
			for (i = _i = 35; _i <= 40; i = ++_i) {                             // 242
				keyCodes.push(i);                                                  // 243
			}                                                                   //
			for (i = _j = 112; _j <= 123; i = ++_j) {                           // 245
				keyCodes.push(i);                                                  // 246
			}                                                                   //
			if (__indexOf.call(keyCodes, k) < 0) {                              // 248
				return this.startTyping(rid, input);                               // 249
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.keydown = function (rid, event) {             // 253
			var input, k, _ref, _ref1;                                          // 254
			input = event.currentTarget;                                        // 255
			k = event.which;                                                    // 256
			this.resize(input);                                                 // 257
			if (k === 13 && !event.shiftKey) {                                  // 258
				event.preventDefault();                                            // 259
				event.stopPropagation();                                           // 260
				if (this.editing.id) {                                             // 261
					this.update(this.editing.id, rid, input);                         // 262
				} else {                                                           //
					this.send(rid, input);                                            // 264
				}                                                                  //
				return;                                                            // 266
			}                                                                   //
			if (k === 9) {                                                      // 268
				event.preventDefault();                                            // 269
				event.stopPropagation();                                           // 270
				this.tryCompletion(input);                                         // 271
			}                                                                   //
			if (k === 27) {                                                     // 273
				if (this.editing.id) {                                             // 274
					event.preventDefault();                                           // 275
					event.stopPropagation();                                          // 276
					this.clearEditing();                                              // 277
				}                                                                  //
			} else if (k === 75 && ((typeof navigator !== "undefined" && navigator !== null ? (_ref = navigator.platform) != null ? _ref.indexOf('Mac') : void 0 : void 0) !== -1 && event.metaKey && event.shiftKey || (typeof navigator !== "undefined" && navigator !== null ? (_ref1 = navigator.platform) != null ? _ref1.indexOf('Mac') : void 0 : void 0) === -1 && event.ctrlKey && event.shiftKey)) {
				return RoomHistoryManager.clear(rid);                              // 280
			}                                                                   //
		};                                                                   //
                                                                       //
		ChatMessages.prototype.isMessageTooLong = function (input) {         // 284
			return (input != null ? input.value.length : void 0) > this.messageMaxSize;
		};                                                                   //
		ChatMessages.prototype.clickButton = function (rid, input) {         // 287
			this.resize(input);                                                 // 288
			if (this.editing.id) {                                              // 289
				this.update(this.editing.id, rid, input);                          // 290
			} else {                                                            //
				this.send(rid, input);                                             // 292
			}                                                                   //
		};                                                                   //
		return ChatMessages;                                                 // 295
	})();                                                                 //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);
