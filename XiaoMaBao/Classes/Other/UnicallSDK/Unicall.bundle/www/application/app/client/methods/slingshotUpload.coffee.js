(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/methods/slingshotUpload.coffee.js                            //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var S3UpdatedCache, readAsArrayBuffer, readAsDataURL, send, types, uploadFileFilter;
                                                                       //
S3UpdatedCache = {};                                                   // 1
                                                                       //
readAsDataURL = function(file, callback) {                             // 1
  var reader;                                                          // 3
  reader = new FileReader();                                           // 3
  reader.onload = function(ev) {                                       // 3
    return callback(ev.target.result, file);                           //
  };                                                                   //
  return reader.readAsDataURL(file);                                   //
};                                                                     // 2
                                                                       //
readAsArrayBuffer = function(file, callback) {                         // 1
  var reader;                                                          // 10
  reader = new FileReader();                                           // 10
  reader.onload = function(ev) {                                       // 10
    return callback(ev.target.result, file);                           //
  };                                                                   //
  return reader.readAsArrayBuffer(file);                               //
};                                                                     // 9
                                                                       //
send = function(uploader, file, callback) {                            // 1
  var dummy;                                                           // 16
  if ((file instanceof window.File) === false && (file instanceof window.Blob) === false) {
    throw new Meteor.Error("Not a file", "Not a file");                // 17
  }                                                                    //
  dummy = function() {                                                 // 16
    uploader.file = file;                                              // 20
    return uploader.request(function(error, instructions) {            //
      if (error) {                                                     // 22
        return callback(error);                                        // 23
      }                                                                //
      if (instructions['postData']) {                                  // 25
        instructions['postData'].forEach(function(item) {              // 26
          if (item['name'] === 'key') {                                // 27
            return instructions.download = item['value'];              //
          }                                                            //
        });                                                            //
      }                                                                //
      uploader.instructions = instructions;                            // 22
      return uploader.transfer(callback);                              //
    });                                                                //
  };                                                                   //
  if (Meteor.userId()) {                                               // 34
    dummy();                                                           // 35
  } else {                                                             //
    Meteor.call('registerGuest', visitor.getToken(), new Tools().getUrlParameterByName('tenant_id'), function(err, r) {
      if (err) {                                                       // 38
        return showError('注册访客失败！');                                   // 39
      }                                                                //
      return Meteor.loginWithPassword({                                //
        id: r.user                                                     // 40
      }, r.pass, function() {                                          //
        if (err) {                                                     // 41
          return showError('访客登录失败！');                                 // 42
        }                                                              //
        return dummy();                                                // 43
      });                                                              //
    });                                                                //
  }                                                                    //
  return uploader;                                                     // 45
};                                                                     // 15
                                                                       //
types = 'image\/*';                                                    // 1
                                                                       //
types += '|' + 'text\/*';                                              // 1
                                                                       //
types += '|' + 'audio\/*';                                             // 1
                                                                       //
types += '|' + 'video\/avi';                                           // 1
                                                                       //
types += '|' + 'video\/x-mpeg';                                        // 1
                                                                       //
types += '|' + 'video\/mpeg4';                                         // 1
                                                                       //
types += '|' + 'video\/mpg';                                           // 1
                                                                       //
types += '|' + 'video\/x-ms-wmv';                                      // 1
                                                                       //
types += '|' + 'application\/msword';                                  // 1
                                                                       //
types += '|' + 'application\/pdf';                                     // 1
                                                                       //
types += '|' + 'application\/ppt';                                     // 1
                                                                       //
types += '|' + 'application\/x-ppt';                                   // 1
                                                                       //
types += '|' + 'application\/x-xls';                                   // 1
                                                                       //
types += '|' + 'application\/zip';                                     // 1
                                                                       //
types += '|' + 'application\/x-zip-compressed';                        // 1
                                                                       //
types += '|' + 'application\/vnd.ms-powerpoint';                       // 1
                                                                       //
types += '|' + 'application\/vnd.rn-realmedia';                        // 1
                                                                       //
types += '|' + 'application\/vnd.rn-realmedia-vbr';                    // 1
                                                                       //
types += '|' + 'application\/vnd.ms-project';                          // 1
                                                                       //
types += '|' + 'application\/vnd.ms-excel';                            // 1
                                                                       //
types += '|' + 'application\/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
                                                                       //
types += '|' + 'application\/vnd.openxmlformats-officedocument.wordprocessingml.document';
                                                                       //
this.SlingshotAllowedFileTypes = new RegExp(types, 'gm');              // 1
                                                                       //
uploadFileFilter = function(file) {                                    // 1
  if (file && file.type && file.type.match(SlingshotAllowedFileTypes) && file.size <= 10 * 1024 * 1024) {
    return true;                                                       // 71
  }                                                                    //
  return false;                                                        // 72
};                                                                     // 69
                                                                       //
this.slingshotFileUpload = function(files) {                           // 1
  var consume, roomId;                                                 // 75
  roomId = visitor.getRoom(true);                                      // 75
  files = [].concat(files);                                            // 75
  consume = function() {                                               // 75
    var file;                                                          // 79
    file = files.pop();                                                // 79
    if (file == null) {                                                // 80
      swal.close();                                                    // 81
      return;                                                          // 82
    }                                                                  //
    return readAsDataURL(file.file, function(fileContent) {            //
      var minType, text;                                               // 85
      if (!uploadFileFilter(file.file)) {                              // 85
        return;                                                        // 85
      }                                                                //
      text = '';                                                       // 85
      minType = file.file.type.split('/')[0];                          // 85
      if (minType === 'audio') {                                       // 89
        text = "<div class='upload-preview'>\n	<audio  style=\"width: 100%;\" controls=\"controls\">\n		<source src=\"" + fileContent + "\" type=\"audio/wav\">\n		Your browser does not support the audio element.\n	</audio>\n</div>\n<div class='upload-preview-title'>" + (Handlebars._escape(file.name)) + "</div>";
      } else {                                                         //
        text = "<div class='upload-preview'>\n	<div class='upload-preview-file' style='height: 200px;background-size: contain;background-repeat: no-repeat;background-position: center;background-image: url(" + fileContent + ")'></div>\n</div>\n<div class='upload-preview-title'>" + (Handlebars._escape(file.name)) + "</div>";
      }                                                                //
      return swal({                                                    //
        title: TAPi18n.__('Upload_file_question'),                     // 110
        text: text,                                                    // 110
        showCancelButton: true,                                        // 110
        closeOnConfirm: false,                                         // 110
        closeOnCancel: false,                                          // 110
        html: true                                                     // 110
      }, function(isConfirm) {                                         //
        var msgId, userFileUploader;                                   // 117
        consume();                                                     // 117
        if (isConfirm !== true) {                                      // 119
          return;                                                      // 120
        }                                                              //
        userFileUploader = new Slingshot.Upload("userFileUpload", {    // 117
          rid: roomId,                                                 // 121
          filename: file.name                                          // 121
        });                                                            //
        msgId = Random.id();                                           // 117
        Meteor.call('sendMessageToLocalLivechat', {                    // 117
          _id: msgId,                                                  // 124
          rid: roomId,                                                 // 124
          msg: "",                                                     // 124
          imageBytes: fileContent                                      // 124
        });                                                            //
        Tracker.autorun(function(c) {                                  // 117
          var progress, rate, target;                                  // 131
          target = document.getElementById('byte-image-' + msgId);     // 131
          progress = document.getElementById('progress-image-' + msgId);
          rate = userFileUploader.progress();                          // 131
          if (target === null) {                                       // 135
            return;                                                    // 136
          }                                                            //
          if (progress === null) {                                     // 137
            return;                                                    // 138
          }                                                            //
          if (isNaN(rate)) {                                           // 139
            return;                                                    // 140
          }                                                            //
          if (rate === 1) {                                            // 141
            c.stop();                                                  // 142
            progress.style.width = "0px";                              // 142
            return;                                                    // 144
          }                                                            //
          return progress.style.width = Math.round(target.offsetWidth * rate) + "px";
        });                                                            //
        return send(userFileUploader, file.file, function(e, s3key) {  //
          var clienttype, ref, ref1, ref2, ref3, s3url, uri;           // 149
          if (e != null) {                                             // 149
            throw new Meteor.Error("Upload File Failed", "Upload File Failed");
          } else {                                                     //
            uri = 's3r/' + s3key;                                      // 153
            if ((typeof Meteor !== "undefined" && Meteor !== null ? (ref = Meteor.connection) != null ? (ref1 = ref._stream) != null ? (ref2 = ref1.rawUrl) != null ? ref2.length : void 0 : void 0 : void 0 : void 0) < 4) {
              uri = window.location.protocol + '//' + window.location.host + new Tools().getPath() + uri;
            } else {                                                   //
              uri = Meteor.connection._stream.rawUrl + '/' + uri;      // 157
            }                                                          //
            s3url = {                                                  // 153
              contentLength: file.file.size,                           // 159
              contentType: file.file.type,                             // 159
              type: minType,                                           // 159
              filename: file.name,                                     // 159
              uri: uri                                                 // 159
            };                                                         //
            if (minType === 'audio') {                                 // 164
              s3url.isRead = false;                                    // 165
              s3url.duration = Math.ceil((ref3 = $('.upload-preview audio')[0]) != null ? ref3.duration : void 0);
            }                                                          //
            clienttype = 'webchat';                                    // 153
            if (Meteor.isCordova === true) {                           // 168
              clienttype = device.platform;                            // 169
            }                                                          //
            Meteor.call('sendMessageLivechatData', {                   // 153
              _id: msgId,                                              // 170
              rid: roomId,                                             // 170
              msg: "File Uploaded: *" + file.name + "*\n" + uri,       // 170
              file: {                                                  // 170
                _id: file._id                                          // 178
              },                                                       //
              clientType: clienttype,                                  // 170
              s3url: s3url,                                            // 170
              token: visitor.getToken(),                               // 170
              fromWebSite: localStorage.getItem('_3partywebsite')      // 170
            }, null, function(err, result) {                           //
              return console.log(err);                                 //
            });                                                        //
            if (S3UpdatedCache[s3key]) {                               // 185
                                                                       // 185
            } else {                                                   //
              S3UpdatedCache[s3key] = true;                            // 188
              return Meteor.call('updateS3Metadata', s3key, s3url, function(e, r) {
                if (e) {                                               // 190
                  return console.log(e);                               //
                } else {                                               //
                  return console.log(r);                               //
                }                                                      //
              });                                                      //
            }                                                          //
          }                                                            //
        });                                                            //
      });                                                              //
    });                                                                //
  };                                                                   //
  return consume();                                                    //
};                                                                     // 74
                                                                       //
/////////////////////////////////////////////////////////////////////////

}).call(this);
