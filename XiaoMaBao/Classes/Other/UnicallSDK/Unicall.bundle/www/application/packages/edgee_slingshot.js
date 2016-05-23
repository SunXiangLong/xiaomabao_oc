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
var check = Package.check.check;
var Match = Package.check.Match;
var Tracker = Package.tracker.Tracker;
var Deps = Package.tracker.Deps;
var ReactiveVar = Package['reactive-var'].ReactiveVar;

/* Package-scope variables */
var Slingshot, matchAllowedFileTypes;

(function(){

/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
// packages/edgee_slingshot/packages/edgee_slingshot.js                                //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////
                                                                                       //
(function () {                                                                         // 1
                                                                                       // 2
//////////////////////////////////////////////////////////////////////////////////     // 3
//                                                                              //     // 4
// packages/edgee:slingshot/lib/restrictions.js                                 //     // 5
//                                                                              //     // 6
//////////////////////////////////////////////////////////////////////////////////     // 7
                                                                                //     // 8
/**                                                                             // 1   // 9
 * @module meteor-slingshot                                                     // 2   // 10
 */                                                                             // 3   // 11
                                                                                // 4   // 12
Slingshot = {};                                                                 // 5   // 13
                                                                                // 6   // 14
/* global matchAllowedFileTypes: true */                                        // 7   // 15
matchAllowedFileTypes = Match.OneOf(String, [String], RegExp, null);            // 8   // 16
                                                                                // 9   // 17
/**                                                                             // 10  // 18
 * List of configured restrictions by name.                                     // 11  // 19
 *                                                                              // 12  // 20
 * @type {Object.<String, Function>}                                            // 13  // 21
 * @private                                                                     // 14  // 22
 */                                                                             // 15  // 23
                                                                                // 16  // 24
Slingshot._restrictions = {};                                                   // 17  // 25
                                                                                // 18  // 26
/**                                                                             // 19  // 27
 * Creates file upload restrictions for a specific directive.                   // 20  // 28
 *                                                                              // 21  // 29
 * @param {string} name - A unique identifier of the directive.                 // 22  // 30
 * @param {Object} restrictions - The file upload restrictions.                 // 23  // 31
 * @returns {Object}                                                            // 24  // 32
 */                                                                             // 25  // 33
                                                                                // 26  // 34
Slingshot.fileRestrictions = function (name, restrictions) {                    // 27  // 35
  check(restrictions, {                                                         // 28  // 36
    authorize: Match.Optional(Function),                                        // 29  // 37
    maxSize: Match.Optional(Match.OneOf(Number, null)),                         // 30  // 38
    allowedFileTypes: Match.Optional(matchAllowedFileTypes)                     // 31  // 39
  });                                                                           // 32  // 40
                                                                                // 33  // 41
  if (Meteor.isServer) {                                                        // 34  // 42
    var directive = Slingshot.getDirective(name);                               // 35  // 43
    if (directive) {                                                            // 36  // 44
      _.extend(directive._directive, restrictions);                             // 37  // 45
    }                                                                           // 38  // 46
  }                                                                             // 39  // 47
                                                                                // 40  // 48
  return (Slingshot._restrictions[name] =                                       // 41  // 49
    _.extend(Slingshot._restrictions[name] || {}, restrictions));               // 42  // 50
};                                                                              // 43  // 51
                                                                                // 44  // 52
/**                                                                             // 45  // 53
 * @param {string} name - The unique identifier of the directive to             // 46  // 54
 * retrieve the restrictions for.                                               // 47  // 55
 * @returns {Object}                                                            // 48  // 56
 */                                                                             // 49  // 57
                                                                                // 50  // 58
Slingshot.getRestrictions = function (name) {                                   // 51  // 59
  return this._restrictions[name] || {};                                        // 52  // 60
};                                                                              // 53  // 61
                                                                                // 54  // 62
//////////////////////////////////////////////////////////////////////////////////     // 63
                                                                                       // 64
}).call(this);                                                                         // 65
                                                                                       // 66
                                                                                       // 67
                                                                                       // 68
                                                                                       // 69
                                                                                       // 70
                                                                                       // 71
(function () {                                                                         // 72
                                                                                       // 73
//////////////////////////////////////////////////////////////////////////////////     // 74
//                                                                              //     // 75
// packages/edgee:slingshot/lib/validators.js                                   //     // 76
//                                                                              //     // 77
//////////////////////////////////////////////////////////////////////////////////     // 78
                                                                                //     // 79
Slingshot.Validators = {                                                        // 1   // 80
                                                                                // 2   // 81
 /**                                                                            // 3   // 82
  *                                                                             // 4   // 83
  * @method checkAll                                                            // 5   // 84
  *                                                                             // 6   // 85
  * @throws Meteor.Error                                                        // 7   // 86
  *                                                                             // 8   // 87
  * @param {Object} context                                                     // 9   // 88
  * @param {FileInfo} file                                                      // 10  // 89
  * @param {Object} [meta]                                                      // 11  // 90
  * @param {Object} [restrictions]                                              // 12  // 91
  *                                                                             // 13  // 92
  * @returns {Boolean}                                                          // 14  // 93
  */                                                                            // 15  // 94
                                                                                // 16  // 95
  checkAll: function (context, file, meta, restrictions) {                      // 17  // 96
    return this.checkFileSize(file.size, restrictions.maxSize) &&               // 18  // 97
      this.checkFileType(file.type, restrictions.allowedFileTypes) &&           // 19  // 98
      (typeof restrictions.authorize !== 'function' ||                          // 20  // 99
        restrictions.authorize.call(context, file, meta));                      // 21  // 100
  },                                                                            // 22  // 101
                                                                                // 23  // 102
  /**                                                                           // 24  // 103
   * @throws Meteor.Error                                                       // 25  // 104
   *                                                                            // 26  // 105
   * @param {Number} size - Size of file in bytes.                              // 27  // 106
   * @param {Number} maxSize - Max size of file in bytes.                       // 28  // 107
   * @returns {boolean}                                                         // 29  // 108
   */                                                                           // 30  // 109
                                                                                // 31  // 110
  checkFileSize: function (size, maxSize) {                                     // 32  // 111
    maxSize = Math.min(maxSize, Infinity);                                      // 33  // 112
                                                                                // 34  // 113
    if (maxSize && size > maxSize)                                              // 35  // 114
      throw new Meteor.Error("Upload denied", "File exceeds allowed size of " + // 36  // 115
      formatBytes(maxSize));                                                    // 37  // 116
                                                                                // 38  // 117
    return true;                                                                // 39  // 118
  },                                                                            // 40  // 119
                                                                                // 41  // 120
  /**                                                                           // 42  // 121
   *                                                                            // 43  // 122
   * @throws Meteor.Error                                                       // 44  // 123
   *                                                                            // 45  // 124
   * @param {String} type - Mime type                                           // 46  // 125
   * @param {(RegExp|Array|String)} [allowed] - Allowed file type(s)            // 47  // 126
   * @returns {boolean}                                                         // 48  // 127
   */                                                                           // 49  // 128
                                                                                // 50  // 129
  checkFileType: function (type, allowed) {                                     // 51  // 130
    if (allowed instanceof RegExp) {                                            // 52  // 131
                                                                                // 53  // 132
      if (!allowed.test(type))                                                  // 54  // 133
        throw new Meteor.Error("Upload denied",                                 // 55  // 134
          type + " is not an allowed file type");                               // 56  // 135
                                                                                // 57  // 136
      return true;                                                              // 58  // 137
    }                                                                           // 59  // 138
                                                                                // 60  // 139
    if (_.isArray(allowed)) {                                                   // 61  // 140
      if (allowed.indexOf(type) < 0) {                                          // 62  // 141
        throw new Meteor.Error("Upload denied",                                 // 63  // 142
          type + " is not one of the followed allowed file types: " +           // 64  // 143
          allowed.join(", "));                                                  // 65  // 144
      }                                                                         // 66  // 145
                                                                                // 67  // 146
      return true;                                                              // 68  // 147
    }                                                                           // 69  // 148
                                                                                // 70  // 149
    if (allowed && allowed !== type) {                                          // 71  // 150
      throw new Meteor.Error("Upload denied", "Only files of type " + allowed + // 72  // 151
        " can be uploaded");                                                    // 73  // 152
    }                                                                           // 74  // 153
                                                                                // 75  // 154
    return true;                                                                // 76  // 155
  }                                                                             // 77  // 156
};                                                                              // 78  // 157
                                                                                // 79  // 158
/** Human readable data-size in bytes.                                          // 80  // 159
 *                                                                              // 81  // 160
 * @param size {Number}                                                         // 82  // 161
 * @returns {string}                                                            // 83  // 162
 */                                                                             // 84  // 163
                                                                                // 85  // 164
function formatBytes(size) {                                                    // 86  // 165
  var units = ['Bytes', 'KB', 'MB', 'GB', 'TB'],                                // 87  // 166
      unit = units.shift();                                                     // 88  // 167
                                                                                // 89  // 168
  while (size >= 0x400 && units.length) {                                       // 90  // 169
    size /= 0x400;                                                              // 91  // 170
    unit = units.shift();                                                       // 92  // 171
  }                                                                             // 93  // 172
                                                                                // 94  // 173
  return (Math.round(size * 100) / 100) + " " + unit;                           // 95  // 174
}                                                                               // 96  // 175
                                                                                // 97  // 176
//////////////////////////////////////////////////////////////////////////////////     // 177
                                                                                       // 178
}).call(this);                                                                         // 179
                                                                                       // 180
                                                                                       // 181
                                                                                       // 182
                                                                                       // 183
                                                                                       // 184
                                                                                       // 185
(function () {                                                                         // 186
                                                                                       // 187
//////////////////////////////////////////////////////////////////////////////////     // 188
//                                                                              //     // 189
// packages/edgee:slingshot/lib/upload.js                                       //     // 190
//                                                                              //     // 191
//////////////////////////////////////////////////////////////////////////////////     // 192
                                                                                //     // 193
/**                                                                             // 1   // 194
 * @fileOverview Defines client side API in which files can be uploaded.        // 2   // 195
 */                                                                             // 3   // 196
                                                                                // 4   // 197
/**                                                                             // 5   // 198
 *                                                                              // 6   // 199
 * @param {string} directive - Name of server-directive to use.                 // 7   // 200
 * @param {object} [metaData] - Data to be sent to directive.                   // 8   // 201
 * @constructor                                                                 // 9   // 202
 */                                                                             // 10  // 203
                                                                                // 11  // 204
Slingshot.Upload = function (directive, metaData) {                             // 12  // 205
                                                                                // 13  // 206
  if (!window.File || !window.FormData) {                                       // 14  // 207
    throw new Error("Browser does not support HTML5 uploads");                  // 15  // 208
  }                                                                             // 16  // 209
                                                                                // 17  // 210
  var self = this,                                                              // 18  // 211
      loaded = new ReactiveVar(),                                               // 19  // 212
      total = new ReactiveVar(),                                                // 20  // 213
      status = new ReactiveVar("idle"),                                         // 21  // 214
      dataUri,                                                                  // 22  // 215
      preloaded;                                                                // 23  // 216
                                                                                // 24  // 217
  function buildFormData() {                                                    // 25  // 218
    var formData = new window.FormData();                                       // 26  // 219
                                                                                // 27  // 220
    _.each(self.instructions.postData, function (field) {                       // 28  // 221
      formData.append(field.name, field.value);                                 // 29  // 222
    });                                                                         // 30  // 223
                                                                                // 31  // 224
    formData.append("file", self.file);                                         // 32  // 225
                                                                                // 33  // 226
    return formData;                                                            // 34  // 227
  }                                                                             // 35  // 228
                                                                                // 36  // 229
  _.extend(self, {                                                              // 37  // 230
                                                                                // 38  // 231
    /**                                                                         // 39  // 232
     * @returns {string}                                                        // 40  // 233
     */                                                                         // 41  // 234
                                                                                // 42  // 235
    status: function () {                                                       // 43  // 236
      return status.get();                                                      // 44  // 237
    },                                                                          // 45  // 238
                                                                                // 46  // 239
    /**                                                                         // 47  // 240
     * @returns {number}                                                        // 48  // 241
     */                                                                         // 49  // 242
                                                                                // 50  // 243
    progress: function () {                                                     // 51  // 244
      return self.uploaded() / total.get();                                     // 52  // 245
    },                                                                          // 53  // 246
                                                                                // 54  // 247
    /**                                                                         // 55  // 248
     * @returns {number}                                                        // 56  // 249
     */                                                                         // 57  // 250
                                                                                // 58  // 251
    uploaded: function () {                                                     // 59  // 252
      return loaded.get();                                                      // 60  // 253
    },                                                                          // 61  // 254
                                                                                // 62  // 255
   /**                                                                          // 63  // 256
    * @param {File} file                                                        // 64  // 257
    * @returns {null|Error} Returns null on success, Error on failure.          // 65  // 258
    */                                                                          // 66  // 259
                                                                                // 67  // 260
    validate: function(file) {                                                  // 68  // 261
      var context = {                                                           // 69  // 262
        userId: Meteor.userId && Meteor.userId()                                // 70  // 263
      };                                                                        // 71  // 264
      try {                                                                     // 72  // 265
        var validators = Slingshot.Validators,                                  // 73  // 266
            restrictions = Slingshot.getRestrictions(directive);                // 74  // 267
                                                                                // 75  // 268
        validators.checkAll(context, file, metaData, restrictions) && null;     // 76  // 269
      } catch(error) {                                                          // 77  // 270
        return error;                                                           // 78  // 271
      }                                                                         // 79  // 272
    },                                                                          // 80  // 273
                                                                                // 81  // 274
    /**                                                                         // 82  // 275
     * @param {(File|Blob)} file                                                // 83  // 276
     * @param {Function} [callback]                                             // 84  // 277
     * @returns {Slingshot.Upload}                                              // 85  // 278
     */                                                                         // 86  // 279
                                                                                // 87  // 280
    send: function (file, callback) {                                           // 88  // 281
      if (! (file instanceof window.File) && ! (file instanceof window.Blob))   // 89  // 282
        throw new Error("Not a file");                                          // 90  // 283
                                                                                // 91  // 284
      self.file = file;                                                         // 92  // 285
                                                                                // 93  // 286
      self.request(function (error, instructions) {                             // 94  // 287
        if (error) {                                                            // 95  // 288
          return callback(error);                                               // 96  // 289
        }                                                                       // 97  // 290
                                                                                // 98  // 291
        self.instructions = instructions;                                       // 99  // 292
                                                                                // 100
        self.transfer(callback);                                                // 101
      });                                                                       // 102
                                                                                // 103
      return self;                                                              // 104
    },                                                                          // 105
                                                                                // 106
    /**                                                                         // 107
     * @param {Function} [callback]                                             // 108
     * @returns {Slingshot.Upload}                                              // 109
     */                                                                         // 110
                                                                                // 111
    request: function (callback) {                                              // 112
                                                                                // 113
      if (!self.file) {                                                         // 114
        callback(new Error("No file to request upload for"));                   // 115
      }                                                                         // 116
                                                                                // 117
      var file = _.pick(self.file, "name", "size", "type");                     // 118
                                                                                // 119
      status.set("authorizing");                                                // 120
                                                                                // 121
      var error = this.validate(file);                                          // 122
      if (error) {                                                              // 123
        status.set("failed");                                                   // 124
        callback(error);                                                        // 125
        return self;                                                            // 126
      }                                                                         // 127
                                                                                // 128
      Meteor.call("slingshot/uploadRequest", directive,                         // 129
        file, metaData, function (error, instructions) {                        // 130
          status.set(error ? "failed" : "authorized");                          // 131
          callback(error, instructions);                                        // 132
        });                                                                     // 133
                                                                                // 134
      return self;                                                              // 135
    },                                                                          // 136
                                                                                // 137
    /**                                                                         // 138
     * @param {Function} [callback]                                             // 139
     *                                                                          // 140
     * @returns {Slingshot.Upload}                                              // 141
     */                                                                         // 142
                                                                                // 143
    transfer: function (callback) {                                             // 144
      if (status.curValue !== "authorized") {                                   // 145
        throw new Error("Cannot transfer file at upload status: " +             // 146
          status.curValue);                                                     // 147
      }                                                                         // 148
                                                                                // 149
      status.set("transferring");                                               // 150
      loaded.set(0);                                                            // 151
                                                                                // 152
      var xhr = new XMLHttpRequest();                                           // 153
                                                                                // 154
      xhr.upload.addEventListener("progress", function (event) {                // 155
        if (event.lengthComputable) {                                           // 156
          loaded.set(event.loaded);                                             // 157
          total.set(event.total);                                               // 158
        }                                                                       // 159
      }, false);                                                                // 160
                                                                                // 161
      function getError() {                                                     // 162
        return new Meteor.Error(xhr.statusText + " - " + xhr.status,            // 163
            "Failed to upload file to cloud storage");                          // 164
      }                                                                         // 165
                                                                                // 166
      xhr.addEventListener("load", function () {                                // 167
                                                                                // 168
        if (xhr.status < 400) {                                                 // 169
          status.set("done");                                                   // 170
          loaded.set(total.get());                                              // 171
          callback(null, self.instructions.download);                           // 172
        }                                                                       // 173
        else {                                                                  // 174
          status.set("failed");                                                 // 175
          callback(getError());                                                 // 176
        }                                                                       // 177
      });                                                                       // 178
                                                                                // 179
      xhr.addEventListener("error", function () {                               // 180
        status.set("failed");                                                   // 181
        callback(getError());                                                   // 182
      });                                                                       // 183
                                                                                // 184
      xhr.addEventListener("abort", function () {                               // 185
        status.set("aborted");                                                  // 186
        callback(new Meteor.Error("Aborted",                                    // 187
          "The upload has been aborted by the user"));                          // 188
      });                                                                       // 189
                                                                                // 190
      xhr.open("POST", self.instructions.upload, true);                         // 191
                                                                                // 192
      _.each(self.instructions.headers, function (value, key) {                 // 193
        xhr.setRequestHeader(key, value);                                       // 194
      });                                                                       // 195
                                                                                // 196
      xhr.send(buildFormData());                                                // 197
      self.xhr = xhr;                                                           // 198
                                                                                // 199
      return self;                                                              // 200
    },                                                                          // 201
                                                                                // 202
    /**                                                                         // 203
     * @returns {boolean}                                                       // 204
     */                                                                         // 205
                                                                                // 206
    isImage: function () {                                                      // 207
      self.status(); //React to status change.                                  // 208
      return Boolean(self.file && self.file.type.split("/")[0] === "image");    // 209
    },                                                                          // 210
                                                                                // 211
    /**                                                                         // 212
     * Latency compensated url of the file to be uploaded.                      // 213
     *                                                                          // 214
     * @param {boolean} preload                                                 // 215
     *                                                                          // 216
     * @returns {string}                                                        // 217
     */                                                                         // 218
                                                                                // 219
    url: function (preload) {                                                   // 220
      if (!dataUri) {                                                           // 221
        var localUrl = new ReactiveVar(),                                       // 222
            URL = (window.URL || window.webkitURL);                             // 223
                                                                                // 224
        dataUri = new ReactiveVar();                                            // 225
                                                                                // 226
        Tracker.nonreactive(function () {                                       // 227
                                                                                // 228
          /*                                                                    // 229
           It is important that we generate the local url not more than once    // 230
           throughout the entire lifecycle of `self` to prevent flickering.     // 231
           */                                                                   // 232
                                                                                // 233
          var previewRequirement = new Tracker.Dependency();                    // 234
                                                                                // 235
          Tracker.autorun(function (computation) {                              // 236
            if (self.file) {                                                    // 237
              if (URL) {                                                        // 238
                localUrl.set(URL.createObjectURL(self.file));                   // 239
                computation.stop();                                             // 240
              }                                                                 // 241
              else if (Tracker.active && window.FileReader) {                   // 242
                readDataUrl(self.file, function (result) {                      // 243
                  localUrl.set(result);                                         // 244
                  computation.stop();                                           // 245
                });                                                             // 246
              }                                                                 // 247
            }                                                                   // 248
            else {                                                              // 249
              previewRequirement.depend();                                      // 250
            }                                                                   // 251
          });                                                                   // 252
                                                                                // 253
          Tracker.autorun(function (computation) {                              // 254
            var status = self.status();                                         // 255
                                                                                // 256
            if (self.instructions && status === "done") {                       // 257
              computation.stop();                                               // 258
              dataUri.set(self.instructions.download);                          // 259
            }                                                                   // 260
            else if (status === "failed" || status === "aborted") {             // 261
              computation.stop();                                               // 262
            }                                                                   // 263
            else if (self.file && !dataUri.curValue) {                          // 264
              previewRequirement.changed();                                     // 265
              dataUri.set(localUrl.get());                                      // 266
            }                                                                   // 267
          });                                                                   // 268
        });                                                                     // 269
      }                                                                         // 270
                                                                                // 271
      if (preload) {                                                            // 272
                                                                                // 273
        if (self.file && !self.isImage())                                       // 274
          throw new Error("Cannot pre-load anything other than images");        // 275
                                                                                // 276
        if (!preloaded) {                                                       // 277
          Tracker.nonreactive(function () {                                     // 278
            preloaded = new ReactiveVar();                                      // 279
                                                                                // 280
            Tracker.autorun(function (computation) {                            // 281
              var url = dataUri.get();                                          // 282
                                                                                // 283
              if (self.instructions) {                                          // 284
                preloadImage(url, function () {                                 // 285
                  computation.stop();                                           // 286
                  preloaded.set(url);                                           // 287
                });                                                             // 288
              }                                                                 // 289
              else                                                              // 290
                preloaded.set(url);                                             // 291
            });                                                                 // 292
          });                                                                   // 293
        }                                                                       // 294
                                                                                // 295
        return preloaded.get();                                                 // 296
      }                                                                         // 297
      else                                                                      // 298
        return dataUri.get();                                                   // 299
    },                                                                          // 300
                                                                                // 301
    /** Gets an upload parameter for the directive.                             // 302
     *                                                                          // 303
     * @param {String} name                                                     // 304
     * @returns {String|Number|Undefined}                                       // 305
     */                                                                         // 306
                                                                                // 307
    param: function (name) {                                                    // 308
      self.status(); //React to status changes.                                 // 309
                                                                                // 310
      var data = self.instructions && self.instructions.postData,               // 311
          field = data && _.findWhere(data, {name: name});                      // 312
                                                                                // 313
      return field && field.value;                                              // 314
    }                                                                           // 315
                                                                                // 316
  });                                                                           // 317
};                                                                              // 318
                                                                                // 319
/**                                                                             // 320
 *                                                                              // 321
 * @param {String} image - URL of image to preload.                             // 322
 * @param {Function} callback                                                   // 323
 */                                                                             // 324
                                                                                // 325
function preloadImage(image, callback) {                                        // 326
  var preloader = new window.Image();                                           // 327
                                                                                // 328
  preloader.onload = callback;                                                  // 329
                                                                                // 330
  preloader.src = image;                                                        // 331
}                                                                               // 332
                                                                                // 333
function readDataUrl(file, callback) {                                          // 334
  var reader = new window.FileReader();                                         // 335
                                                                                // 336
  reader.onloadend = function () {                                              // 337
    callback(reader.result);                                                    // 338
  };                                                                            // 339
                                                                                // 340
  reader.readAsDataURL(file);                                                   // 341
}                                                                               // 342
                                                                                // 343
//////////////////////////////////////////////////////////////////////////////////     // 537
                                                                                       // 538
}).call(this);                                                                         // 539
                                                                                       // 540
/////////////////////////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['edgee:slingshot'] = {
  Slingshot: Slingshot
};

})();
