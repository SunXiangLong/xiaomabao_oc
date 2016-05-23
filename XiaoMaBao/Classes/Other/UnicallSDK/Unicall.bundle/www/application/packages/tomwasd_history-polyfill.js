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

(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/tomwasd_history-polyfill/HTML5-History-API/history.js                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
/*!                                                                                                                   // 1
 * History API JavaScript Library v4.2.2                                                                              // 2
 *                                                                                                                    // 3
 * Support: IE8+, FF3+, Opera 9+, Safari, Chrome and other                                                            // 4
 *                                                                                                                    // 5
 * Copyright 2011-2015, Dmitrii Pakhtinov ( spb.piksel@gmail.com )                                                    // 6
 *                                                                                                                    // 7
 * http://spb-piksel.ru/                                                                                              // 8
 *                                                                                                                    // 9
 * Dual licensed under the MIT and GPL licenses:                                                                      // 10
 *   http://www.opensource.org/licenses/mit-license.php                                                               // 11
 *   http://www.gnu.org/licenses/gpl.html                                                                             // 12
 *                                                                                                                    // 13
 * Update: 2015-06-26 23:22                                                                                           // 14
 */                                                                                                                   // 15
(function(factory) {                                                                                                  // 16
    if (typeof define === 'function' && define['amd']) {                                                              // 17
        // https://github.com/devote/HTML5-History-API/issues/73                                                      // 18
        var rndKey = '[history' + (new Date()).getTime() + ']';                                                       // 19
        var onError = requirejs['onError'];                                                                           // 20
        factory.toString = function() {                                                                               // 21
          return rndKey;                                                                                              // 22
        };                                                                                                            // 23
        requirejs['onError'] = function(err) {                                                                        // 24
          if (err.message.indexOf(rndKey) === -1) {                                                                   // 25
            onError.call(requirejs, err);                                                                             // 26
          }                                                                                                           // 27
        };                                                                                                            // 28
        define([], factory);                                                                                          // 29
    }                                                                                                                 // 30
    // commonJS support                                                                                               // 31
    if (typeof exports === "object" && typeof module !== "undefined") {                                               // 32
      module['exports'] = factory();                                                                                  // 33
    } else {                                                                                                          // 34
      // execute anyway                                                                                               // 35
      return factory();                                                                                               // 36
    }                                                                                                                 // 37
})(function() {                                                                                                       // 38
    // Define global variable                                                                                         // 39
    var global = (typeof window === 'object' ? window : this) || {};                                                  // 40
    // Prevent the code from running if there is no window.history object or library already loaded                   // 41
    if (!global.history || "emulate" in global.history) return global.history;                                        // 42
    // symlink to document                                                                                            // 43
    var document = global.document;                                                                                   // 44
    // HTML element                                                                                                   // 45
    var documentElement = document.documentElement;                                                                   // 46
    // symlink to constructor of Object                                                                               // 47
    var Object = global['Object'];                                                                                    // 48
    // symlink to JSON Object                                                                                         // 49
    var JSON = global['JSON'];                                                                                        // 50
    // symlink to instance object of 'Location'                                                                       // 51
    var windowLocation = global.location;                                                                             // 52
    // symlink to instance object of 'History'                                                                        // 53
    var windowHistory = global.history;                                                                               // 54
    // new instance of 'History'. The default is a reference to the original object instance                          // 55
    var historyObject = windowHistory;                                                                                // 56
    // symlink to method 'history.pushState'                                                                          // 57
    var historyPushState = windowHistory.pushState;                                                                   // 58
    // symlink to method 'history.replaceState'                                                                       // 59
    var historyReplaceState = windowHistory.replaceState;                                                             // 60
    // if the browser supports HTML5-History-API                                                                      // 61
    var isSupportHistoryAPI = !!historyPushState;                                                                     // 62
    // verifies the presence of an object 'state' in interface 'History'                                              // 63
    var isSupportStateObjectInHistory = 'state' in windowHistory;                                                     // 64
    // symlink to method 'Object.defineProperty'                                                                      // 65
    var defineProperty = Object.defineProperty;                                                                       // 66
    // new instance of 'Location', for IE8 will use the element HTMLAnchorElement, instead of pure object             // 67
    var locationObject = redefineProperty({}, 't') ? {} : document.createElement('a');                                // 68
    // prefix for the names of events                                                                                 // 69
    var eventNamePrefix = '';                                                                                         // 70
    // String that will contain the name of the method                                                                // 71
    var addEventListenerName = global.addEventListener ? 'addEventListener' : (eventNamePrefix = 'on') && 'attachEvent';
    // String that will contain the name of the method                                                                // 73
    var removeEventListenerName = global.removeEventListener ? 'removeEventListener' : 'detachEvent';                 // 74
    // String that will contain the name of the method                                                                // 75
    var dispatchEventName = global.dispatchEvent ? 'dispatchEvent' : 'fireEvent';                                     // 76
    // reference native methods for the events                                                                        // 77
    var addEvent = global[addEventListenerName];                                                                      // 78
    var removeEvent = global[removeEventListenerName];                                                                // 79
    var dispatch = global[dispatchEventName];                                                                         // 80
    // default settings                                                                                               // 81
    var currentPath = (window.location.pathname+'/').replace('//','/');                                               // 82
    var settings = {"basepath": currentPath, "redirect": 0, "type": '/', "init": 0};                                  // 83
    // key for the sessionStorage                                                                                     // 84
    var sessionStorageKey = '__historyAPI__';                                                                         // 85
    // Anchor Element for parseURL function                                                                           // 86
    var anchorElement = document.createElement('a');                                                                  // 87
    // last URL before change to new URL                                                                              // 88
    var lastURL = windowLocation.href;                                                                                // 89
    // Control URL, need to fix the bug in Opera                                                                      // 90
    var checkUrlForPopState = '';                                                                                     // 91
    // for fix on Safari 8                                                                                            // 92
    var triggerEventsInWindowAttributes = 1;                                                                          // 93
    // trigger event 'onpopstate' on page load                                                                        // 94
    var isFireInitialState = false;                                                                                   // 95
    // if used history.location of other code                                                                         // 96
    var isUsedHistoryLocationFlag = 0;                                                                                // 97
    // store a list of 'state' objects in the current session                                                         // 98
    var stateStorage = {};                                                                                            // 99
    // in this object will be stored custom handlers                                                                  // 100
    var eventsList = {};                                                                                              // 101
    // stored last title                                                                                              // 102
    var lastTitle = document.title;                                                                                   // 103
                                                                                                                      // 104
    /**                                                                                                               // 105
     * Properties that will be replaced in the global                                                                 // 106
     * object 'window', to prevent conflicts                                                                          // 107
     *                                                                                                                // 108
     * @type {Object}                                                                                                 // 109
     */                                                                                                               // 110
    var eventsDescriptors = {                                                                                         // 111
        "onhashchange": null,                                                                                         // 112
        "onpopstate": null                                                                                            // 113
    };                                                                                                                // 114
                                                                                                                      // 115
    /**                                                                                                               // 116
     * Fix for Chrome in iOS                                                                                          // 117
     * See https://github.com/devote/HTML5-History-API/issues/29                                                      // 118
     */                                                                                                               // 119
    var fastFixChrome = function(method, args) {                                                                      // 120
        var isNeedFix = global.history !== windowHistory;                                                             // 121
        if (isNeedFix) {                                                                                              // 122
            global.history = windowHistory;                                                                           // 123
        }                                                                                                             // 124
        method.apply(windowHistory, args);                                                                            // 125
        if (isNeedFix) {                                                                                              // 126
            global.history = historyObject;                                                                           // 127
        }                                                                                                             // 128
    };                                                                                                                // 129
                                                                                                                      // 130
    /**                                                                                                               // 131
     * Properties that will be replaced/added to object                                                               // 132
     * 'window.history', includes the object 'history.location',                                                      // 133
     * for a complete the work with the URL address                                                                   // 134
     *                                                                                                                // 135
     * @type {Object}                                                                                                 // 136
     */                                                                                                               // 137
    var historyDescriptors = {                                                                                        // 138
        /**                                                                                                           // 139
         * Setting library initialization                                                                             // 140
         *                                                                                                            // 141
         * @param {null|String} [basepath] The base path to the site; defaults to the root "/".                       // 142
         * @param {null|String} [type] Substitute the string after the anchor; by default "/".                        // 143
         * @param {null|Boolean} [redirect] Enable link translation.                                                  // 144
         */                                                                                                           // 145
        "setup": function(basepath, type, redirect) {                                                                 // 146
            settings["basepath"] = ('' + (basepath == null ? settings["basepath"] : basepath))                        // 147
                .replace(/(?:^|\/)[^\/]*$/, '/');                                                                     // 148
            settings["type"] = type == null ? settings["type"] : type;                                                // 149
            settings["redirect"] = redirect == null ? settings["redirect"] : !!redirect;                              // 150
        },                                                                                                            // 151
        /**                                                                                                           // 152
         * @namespace history                                                                                         // 153
         * @param {String} [type]                                                                                     // 154
         * @param {String} [basepath]                                                                                 // 155
         */                                                                                                           // 156
        "redirect": function(type, basepath) {                                                                        // 157
            historyObject['setup'](basepath, type);                                                                   // 158
            basepath = settings["basepath"];                                                                          // 159
            if (global.top == global.self) {                                                                          // 160
                var relative = parseURL(null, false, true)._relative;                                                 // 161
                var path = windowLocation.pathname + windowLocation.search;                                           // 162
                if (isSupportHistoryAPI) {                                                                            // 163
                    path = path.replace(/([^\/])$/, '$1/');                                                           // 164
                    if (relative != basepath && (new RegExp("^" + basepath + "$", "i")).test(path)) {                 // 165
                        windowLocation.replace(relative);                                                             // 166
                    }                                                                                                 // 167
                } else if (path != basepath) {                                                                        // 168
                    path = path.replace(/([^\/])\?/, '$1/?');                                                         // 169
                    if ((new RegExp("^" + basepath, "i")).test(path)) {                                               // 170
                        windowLocation.replace(basepath + '#' + path.                                                 // 171
                            replace(new RegExp("^" + basepath, "i"), settings["type"]) + windowLocation.hash);        // 172
                    }                                                                                                 // 173
                }                                                                                                     // 174
            }                                                                                                         // 175
        },                                                                                                            // 176
        /**                                                                                                           // 177
         * The method adds a state object entry                                                                       // 178
         * to the history.                                                                                            // 179
         *                                                                                                            // 180
         * @namespace history                                                                                         // 181
         * @param {Object} state                                                                                      // 182
         * @param {string} title                                                                                      // 183
         * @param {string} [url]                                                                                      // 184
         */                                                                                                           // 185
        pushState: function(state, title, url) {                                                                      // 186
            var t = document.title;                                                                                   // 187
            if (lastTitle != null) {                                                                                  // 188
                document.title = lastTitle;                                                                           // 189
            }                                                                                                         // 190
            historyPushState && fastFixChrome(historyPushState, arguments);                                           // 191
            changeState(state, url);                                                                                  // 192
            document.title = t;                                                                                       // 193
            lastTitle = title;                                                                                        // 194
        },                                                                                                            // 195
        /**                                                                                                           // 196
         * The method updates the state object,                                                                       // 197
         * title, and optionally the URL of the                                                                       // 198
         * current entry in the history.                                                                              // 199
         *                                                                                                            // 200
         * @namespace history                                                                                         // 201
         * @param {Object} state                                                                                      // 202
         * @param {string} title                                                                                      // 203
         * @param {string} [url]                                                                                      // 204
         */                                                                                                           // 205
        replaceState: function(state, title, url) {                                                                   // 206
            var t = document.title;                                                                                   // 207
            if (lastTitle != null) {                                                                                  // 208
                document.title = lastTitle;                                                                           // 209
            }                                                                                                         // 210
            delete stateStorage[windowLocation.href];                                                                 // 211
            historyReplaceState && fastFixChrome(historyReplaceState, arguments);                                     // 212
            changeState(state, url, true);                                                                            // 213
            document.title = t;                                                                                       // 214
            lastTitle = title;                                                                                        // 215
        },                                                                                                            // 216
        /**                                                                                                           // 217
         * Object 'history.location' is similar to the                                                                // 218
         * object 'window.location', except that in                                                                   // 219
         * HTML4 browsers it will behave a bit differently                                                            // 220
         *                                                                                                            // 221
         * @namespace history                                                                                         // 222
         */                                                                                                           // 223
        "location": {                                                                                                 // 224
            set: function(value) {                                                                                    // 225
                if (isUsedHistoryLocationFlag === 0) isUsedHistoryLocationFlag = 1;                                   // 226
                global.location = value;                                                                              // 227
            },                                                                                                        // 228
            get: function() {                                                                                         // 229
                if (isUsedHistoryLocationFlag === 0) isUsedHistoryLocationFlag = 1;                                   // 230
                return isSupportHistoryAPI ? windowLocation : locationObject;                                         // 231
            }                                                                                                         // 232
        },                                                                                                            // 233
        /**                                                                                                           // 234
         * A state object is an object representing                                                                   // 235
         * a user interface state.                                                                                    // 236
         *                                                                                                            // 237
         * @namespace history                                                                                         // 238
         */                                                                                                           // 239
        "state": {                                                                                                    // 240
            get: function() {                                                                                         // 241
                return stateStorage[windowLocation.href] || null;                                                     // 242
            }                                                                                                         // 243
        }                                                                                                             // 244
    };                                                                                                                // 245
                                                                                                                      // 246
    /**                                                                                                               // 247
     * Properties for object 'history.location'.                                                                      // 248
     * Object 'history.location' is similar to the                                                                    // 249
     * object 'window.location', except that in                                                                       // 250
     * HTML4 browsers it will behave a bit differently                                                                // 251
     *                                                                                                                // 252
     * @type {Object}                                                                                                 // 253
     */                                                                                                               // 254
    var locationDescriptors = {                                                                                       // 255
        /**                                                                                                           // 256
         * Navigates to the given page.                                                                               // 257
         *                                                                                                            // 258
         * @namespace history.location                                                                                // 259
         */                                                                                                           // 260
        assign: function(url) {                                                                                       // 261
            if (('' + url).indexOf('#') === 0) {                                                                      // 262
                changeState(null, url);                                                                               // 263
            } else {                                                                                                  // 264
                windowLocation.assign(url);                                                                           // 265
            }                                                                                                         // 266
        },                                                                                                            // 267
        /**                                                                                                           // 268
         * Reloads the current page.                                                                                  // 269
         *                                                                                                            // 270
         * @namespace history.location                                                                                // 271
         */                                                                                                           // 272
        reload: function() {                                                                                          // 273
            windowLocation.reload();                                                                                  // 274
        },                                                                                                            // 275
        /**                                                                                                           // 276
         * Removes the current page from                                                                              // 277
         * the session history and navigates                                                                          // 278
         * to the given page.                                                                                         // 279
         *                                                                                                            // 280
         * @namespace history.location                                                                                // 281
         */                                                                                                           // 282
        replace: function(url) {                                                                                      // 283
            if (('' + url).indexOf('#') === 0) {                                                                      // 284
                changeState(null, url, true);                                                                         // 285
            } else {                                                                                                  // 286
                windowLocation.replace(url);                                                                          // 287
            }                                                                                                         // 288
        },                                                                                                            // 289
        /**                                                                                                           // 290
         * Returns the current page's location.                                                                       // 291
         *                                                                                                            // 292
         * @namespace history.location                                                                                // 293
         */                                                                                                           // 294
        toString: function() {                                                                                        // 295
            return this.href;                                                                                         // 296
        },                                                                                                            // 297
        /**                                                                                                           // 298
         * Returns the current page's location.                                                                       // 299
         * Can be set, to navigate to another page.                                                                   // 300
         *                                                                                                            // 301
         * @namespace history.location                                                                                // 302
         */                                                                                                           // 303
        "href": {                                                                                                     // 304
            get: function() {                                                                                         // 305
                return parseURL()._href;                                                                              // 306
            }                                                                                                         // 307
        },                                                                                                            // 308
        /**                                                                                                           // 309
         * Returns the current page's protocol.                                                                       // 310
         *                                                                                                            // 311
         * @namespace history.location                                                                                // 312
         */                                                                                                           // 313
        "protocol": null,                                                                                             // 314
        /**                                                                                                           // 315
         * Returns the current page's host and port number.                                                           // 316
         *                                                                                                            // 317
         * @namespace history.location                                                                                // 318
         */                                                                                                           // 319
        "host": null,                                                                                                 // 320
        /**                                                                                                           // 321
         * Returns the current page's host.                                                                           // 322
         *                                                                                                            // 323
         * @namespace history.location                                                                                // 324
         */                                                                                                           // 325
        "hostname": null,                                                                                             // 326
        /**                                                                                                           // 327
         * Returns the current page's port number.                                                                    // 328
         *                                                                                                            // 329
         * @namespace history.location                                                                                // 330
         */                                                                                                           // 331
        "port": null,                                                                                                 // 332
        /**                                                                                                           // 333
         * Returns the current page's path only.                                                                      // 334
         *                                                                                                            // 335
         * @namespace history.location                                                                                // 336
         */                                                                                                           // 337
        "pathname": {                                                                                                 // 338
            get: function() {                                                                                         // 339
                return parseURL()._pathname;                                                                          // 340
            }                                                                                                         // 341
        },                                                                                                            // 342
        /**                                                                                                           // 343
         * Returns the current page's search                                                                          // 344
         * string, beginning with the character                                                                       // 345
         * '?' and to the symbol '#'                                                                                  // 346
         *                                                                                                            // 347
         * @namespace history.location                                                                                // 348
         */                                                                                                           // 349
        "search": {                                                                                                   // 350
            get: function() {                                                                                         // 351
                return parseURL()._search;                                                                            // 352
            }                                                                                                         // 353
        },                                                                                                            // 354
        /**                                                                                                           // 355
         * Returns the current page's hash                                                                            // 356
         * string, beginning with the character                                                                       // 357
         * '#' and to the end line                                                                                    // 358
         *                                                                                                            // 359
         * @namespace history.location                                                                                // 360
         */                                                                                                           // 361
        "hash": {                                                                                                     // 362
            set: function(value) {                                                                                    // 363
                changeState(null, ('' + value).replace(/^(#|)/, '#'), false, lastURL);                                // 364
            },                                                                                                        // 365
            get: function() {                                                                                         // 366
                return parseURL()._hash;                                                                              // 367
            }                                                                                                         // 368
        }                                                                                                             // 369
    };                                                                                                                // 370
                                                                                                                      // 371
    /**                                                                                                               // 372
     * Just empty function                                                                                            // 373
     *                                                                                                                // 374
     * @return void                                                                                                   // 375
     */                                                                                                               // 376
    function emptyFunction() {                                                                                        // 377
        // dummy                                                                                                      // 378
    }                                                                                                                 // 379
                                                                                                                      // 380
    /**                                                                                                               // 381
     * Prepares a parts of the current or specified reference for later use in the library                            // 382
     *                                                                                                                // 383
     * @param {string} [href]                                                                                         // 384
     * @param {boolean} [isWindowLocation]                                                                            // 385
     * @param {boolean} [isNotAPI]                                                                                    // 386
     * @return {Object}                                                                                               // 387
     */                                                                                                               // 388
    function parseURL(href, isWindowLocation, isNotAPI) {                                                             // 389
        var re = /(?:(\w+\:))?(?:\/\/(?:[^@]*@)?([^\/:\?#]+)(?::([0-9]+))?)?([^\?#]*)(?:(\?[^#]+)|\?)?(?:(#.*))?/;    // 390
        if (href != null && href !== '' && !isWindowLocation) {                                                       // 391
            var current = parseURL(),                                                                                 // 392
                base = document.getElementsByTagName('base')[0];                                                      // 393
            if (!isNotAPI && base && base.getAttribute('href')) {                                                     // 394
              // Fix for IE ignoring relative base tags.                                                              // 395
              // See http://stackoverflow.com/questions/3926197/html-base-tag-and-local-folder-path-with-internet-explorer
              base.href = base.href;                                                                                  // 397
              current = parseURL(base.href, null, true);                                                              // 398
            }                                                                                                         // 399
            var _pathname = current._pathname, _protocol = current._protocol;                                         // 400
            // convert to type of string                                                                              // 401
            href = '' + href;                                                                                         // 402
            // convert relative link to the absolute                                                                  // 403
            href = /^(?:\w+\:)?\/\//.test(href) ? href.indexOf("/") === 0                                             // 404
                ? _protocol + href : href : _protocol + "//" + current._host + (                                      // 405
                href.indexOf("/") === 0 ? href : href.indexOf("?") === 0                                              // 406
                    ? _pathname + href : href.indexOf("#") === 0                                                      // 407
                    ? _pathname + current._search + href : _pathname.replace(/[^\/]+$/g, '') + href                   // 408
                );                                                                                                    // 409
        } else {                                                                                                      // 410
            href = isWindowLocation ? href : windowLocation.href;                                                     // 411
            // if current browser not support History-API                                                             // 412
            if (!isSupportHistoryAPI || isNotAPI) {                                                                   // 413
                // get hash fragment                                                                                  // 414
                href = href.replace(/^[^#]*/, '') || "#";                                                             // 415
                // form the absolute link from the hash                                                               // 416
                // https://github.com/devote/HTML5-History-API/issues/50                                              // 417
                href = windowLocation.protocol.replace(/:.*$|$/, ':') + '//' + windowLocation.host + settings['basepath']
                    + href.replace(new RegExp("^#[\/]?(?:" + settings["type"] + ")?"), "");                           // 419
            }                                                                                                         // 420
        }                                                                                                             // 421
        // that would get rid of the links of the form: /../../                                                       // 422
        anchorElement.href = href;                                                                                    // 423
        // decompose the link in parts                                                                                // 424
        var result = re.exec(anchorElement.href);                                                                     // 425
        // host name with the port number                                                                             // 426
        var host = result[2] + (result[3] ? ':' + result[3] : '');                                                    // 427
        // folder                                                                                                     // 428
        var pathname = result[4] || '/';                                                                              // 429
        // the query string                                                                                           // 430
        var search = result[5] || '';                                                                                 // 431
        // hash                                                                                                       // 432
        var hash = result[6] === '#' ? '' : (result[6] || '');                                                        // 433
        // relative link, no protocol, no host                                                                        // 434
        var relative = pathname + search + hash;                                                                      // 435
        // special links for set to hash-link, if browser not support History API                                     // 436
        var nohash = pathname.replace(new RegExp("^" + settings["basepath"], "i"), settings["type"]) + search;        // 437
        // result                                                                                                     // 438
        return {                                                                                                      // 439
            _href: result[1] + '//' + host + relative,                                                                // 440
            _protocol: result[1],                                                                                     // 441
            _host: host,                                                                                              // 442
            _hostname: result[2],                                                                                     // 443
            _port: result[3] || '',                                                                                   // 444
            _pathname: pathname,                                                                                      // 445
            _search: search,                                                                                          // 446
            _hash: hash,                                                                                              // 447
            _relative: relative,                                                                                      // 448
            _nohash: nohash,                                                                                          // 449
            _special: nohash + hash                                                                                   // 450
        }                                                                                                             // 451
    }                                                                                                                 // 452
                                                                                                                      // 453
    /**                                                                                                               // 454
     * Initializing storage for the custom state's object                                                             // 455
     */                                                                                                               // 456
    function storageInitialize() {                                                                                    // 457
        var sessionStorage;                                                                                           // 458
        /**                                                                                                           // 459
         * sessionStorage throws error when cookies are disabled                                                      // 460
         * Chrome content settings when running the site in a Facebook IFrame.                                        // 461
         * see: https://github.com/devote/HTML5-History-API/issues/34                                                 // 462
         * and: http://stackoverflow.com/a/12976988/669360                                                            // 463
         */                                                                                                           // 464
        try {                                                                                                         // 465
            sessionStorage = global['sessionStorage'];                                                                // 466
            sessionStorage.setItem(sessionStorageKey + 't', '1');                                                     // 467
            sessionStorage.removeItem(sessionStorageKey + 't');                                                       // 468
        } catch(_e_) {                                                                                                // 469
            sessionStorage = {                                                                                        // 470
                getItem: function(key) {                                                                              // 471
                    var cookie = document.cookie.split(key + "=");                                                    // 472
                    return cookie.length > 1 && cookie.pop().split(";").shift() || 'null';                            // 473
                },                                                                                                    // 474
                setItem: function(key, value) {                                                                       // 475
                    var state = {};                                                                                   // 476
                    // insert one current element to cookie                                                           // 477
                    if (state[windowLocation.href] = historyObject.state) {                                           // 478
                        document.cookie = key + '=' + JSON.stringify(state);                                          // 479
                    }                                                                                                 // 480
                }                                                                                                     // 481
            }                                                                                                         // 482
        }                                                                                                             // 483
                                                                                                                      // 484
        try {                                                                                                         // 485
            // get cache from the storage in browser                                                                  // 486
            stateStorage = JSON.parse(sessionStorage.getItem(sessionStorageKey)) || {};                               // 487
        } catch(_e_) {                                                                                                // 488
            stateStorage = {};                                                                                        // 489
        }                                                                                                             // 490
                                                                                                                      // 491
        // hang up the event handler to event unload page                                                             // 492
        addEvent(eventNamePrefix + 'unload', function() {                                                             // 493
            // save current state's object                                                                            // 494
            sessionStorage.setItem(sessionStorageKey, JSON.stringify(stateStorage));                                  // 495
        }, false);                                                                                                    // 496
    }                                                                                                                 // 497
                                                                                                                      // 498
    /**                                                                                                               // 499
     * This method is implemented to override the built-in(native)                                                    // 500
     * properties in the browser, unfortunately some browsers are                                                     // 501
     * not allowed to override all the properties and even add.                                                       // 502
     * For this reason, this was written by a method that tries to                                                    // 503
     * do everything necessary to get the desired result.                                                             // 504
     *                                                                                                                // 505
     * @param {Object} object The object in which will be overridden/added property                                   // 506
     * @param {String} prop The property name to be overridden/added                                                  // 507
     * @param {Object} [descriptor] An object containing properties set/get                                           // 508
     * @param {Function} [onWrapped] The function to be called when the wrapper is created                            // 509
     * @return {Object|Boolean} Returns an object on success, otherwise returns false                                 // 510
     */                                                                                                               // 511
    function redefineProperty(object, prop, descriptor, onWrapped) {                                                  // 512
        var testOnly = 0;                                                                                             // 513
        // test only if descriptor is undefined                                                                       // 514
        if (!descriptor) {                                                                                            // 515
            descriptor = {set: emptyFunction};                                                                        // 516
            testOnly = 1;                                                                                             // 517
        }                                                                                                             // 518
        // variable will have a value of true the success of attempts to set descriptors                              // 519
        var isDefinedSetter = !descriptor.set;                                                                        // 520
        var isDefinedGetter = !descriptor.get;                                                                        // 521
        // for tests of attempts to set descriptors                                                                   // 522
        var test = {configurable: true, set: function() {                                                             // 523
            isDefinedSetter = 1;                                                                                      // 524
        }, get: function() {                                                                                          // 525
            isDefinedGetter = 1;                                                                                      // 526
        }};                                                                                                           // 527
                                                                                                                      // 528
        try {                                                                                                         // 529
            // testing for the possibility of overriding/adding properties                                            // 530
            defineProperty(object, prop, test);                                                                       // 531
            // running the test                                                                                       // 532
            object[prop] = object[prop];                                                                              // 533
            // attempt to override property using the standard method                                                 // 534
            defineProperty(object, prop, descriptor);                                                                 // 535
        } catch(_e_) {                                                                                                // 536
        }                                                                                                             // 537
                                                                                                                      // 538
        // If the variable 'isDefined' has a false value, it means that need to try other methods                     // 539
        if (!isDefinedSetter || !isDefinedGetter) {                                                                   // 540
            // try to override/add the property, using deprecated functions                                           // 541
            if (object.__defineGetter__) {                                                                            // 542
                // testing for the possibility of overriding/adding properties                                        // 543
                object.__defineGetter__(prop, test.get);                                                              // 544
                object.__defineSetter__(prop, test.set);                                                              // 545
                // running the test                                                                                   // 546
                object[prop] = object[prop];                                                                          // 547
                // attempt to override property using the deprecated functions                                        // 548
                descriptor.get && object.__defineGetter__(prop, descriptor.get);                                      // 549
                descriptor.set && object.__defineSetter__(prop, descriptor.set);                                      // 550
            }                                                                                                         // 551
                                                                                                                      // 552
            // Browser refused to override the property, using the standard and deprecated methods                    // 553
            if (!isDefinedSetter || !isDefinedGetter) {                                                               // 554
                if (testOnly) {                                                                                       // 555
                    return false;                                                                                     // 556
                } else if (object === global) {                                                                       // 557
                    // try override global properties                                                                 // 558
                    try {                                                                                             // 559
                        // save original value from this property                                                     // 560
                        var originalValue = object[prop];                                                             // 561
                        // set null to built-in(native) property                                                      // 562
                        object[prop] = null;                                                                          // 563
                    } catch(_e_) {                                                                                    // 564
                    }                                                                                                 // 565
                    // This rule for Internet Explorer 8                                                              // 566
                    if ('execScript' in global) {                                                                     // 567
                        /**                                                                                           // 568
                         * to IE8 override the global properties using                                                // 569
                         * VBScript, declaring it in global scope with                                                // 570
                         * the same names.                                                                            // 571
                         */                                                                                           // 572
                        global['execScript']('Public ' + prop, 'VBScript');                                           // 573
                        global['execScript']('var ' + prop + ';', 'JavaScript');                                      // 574
                    } else {                                                                                          // 575
                        try {                                                                                         // 576
                            /**                                                                                       // 577
                             * This hack allows to override a property                                                // 578
                             * with the set 'configurable: false', working                                            // 579
                             * in the hack 'Safari' to 'Mac'                                                          // 580
                             */                                                                                       // 581
                            defineProperty(object, prop, {value: emptyFunction});                                     // 582
                        } catch(_e_) {                                                                                // 583
                            if (prop === 'onpopstate') {                                                              // 584
                                /**                                                                                   // 585
                                 * window.onpopstate fires twice in Safari 8.0.                                       // 586
                                 * Block initial event on window.onpopstate                                           // 587
                                 * See: https://github.com/devote/HTML5-History-API/issues/69                         // 588
                                 */                                                                                   // 589
                                addEvent('popstate', descriptor = function() {                                        // 590
                                    removeEvent('popstate', descriptor, false);                                       // 591
                                    var onpopstate = object.onpopstate;                                               // 592
                                    // cancel initial event on attribute handler                                      // 593
                                    object.onpopstate = null;                                                         // 594
                                    setTimeout(function() {                                                           // 595
                                      // restore attribute value after short time                                     // 596
                                      object.onpopstate = onpopstate;                                                 // 597
                                    }, 1);                                                                            // 598
                                }, false);                                                                            // 599
                                // cancel trigger events on attributes in object the window                           // 600
                                triggerEventsInWindowAttributes = 0;                                                  // 601
                            }                                                                                         // 602
                        }                                                                                             // 603
                    }                                                                                                 // 604
                    // set old value to new variable                                                                  // 605
                    object[prop] = originalValue;                                                                     // 606
                                                                                                                      // 607
                } else {                                                                                              // 608
                    // the last stage of trying to override the property                                              // 609
                    try {                                                                                             // 610
                        try {                                                                                         // 611
                            // wrap the object in a new empty object                                                  // 612
                            var temp = Object.create(object);                                                         // 613
                            defineProperty(Object.getPrototypeOf(temp) === object ? temp : object, prop, descriptor);
                            for(var key in object) {                                                                  // 615
                                // need to bind a function to the original object                                     // 616
                                if (typeof object[key] === 'function') {                                              // 617
                                    temp[key] = object[key].bind(object);                                             // 618
                                }                                                                                     // 619
                            }                                                                                         // 620
                            try {                                                                                     // 621
                                // to run a function that will inform about what the object was to wrapped            // 622
                                onWrapped.call(temp, temp, object);                                                   // 623
                            } catch(_e_) {                                                                            // 624
                            }                                                                                         // 625
                            object = temp;                                                                            // 626
                        } catch(_e_) {                                                                                // 627
                            // sometimes works override simply by assigning the prototype property of the constructor
                            defineProperty(object.constructor.prototype, prop, descriptor);                           // 629
                        }                                                                                             // 630
                    } catch(_e_) {                                                                                    // 631
                        // all methods have failed                                                                    // 632
                        return false;                                                                                 // 633
                    }                                                                                                 // 634
                }                                                                                                     // 635
            }                                                                                                         // 636
        }                                                                                                             // 637
                                                                                                                      // 638
        return object;                                                                                                // 639
    }                                                                                                                 // 640
                                                                                                                      // 641
    /**                                                                                                               // 642
     * Adds the missing property in descriptor                                                                        // 643
     *                                                                                                                // 644
     * @param {Object} object An object that stores values                                                            // 645
     * @param {String} prop Name of the property in the object                                                        // 646
     * @param {Object|null} descriptor Descriptor                                                                     // 647
     * @return {Object} Returns the generated descriptor                                                              // 648
     */                                                                                                               // 649
    function prepareDescriptorsForObject(object, prop, descriptor) {                                                  // 650
        descriptor = descriptor || {};                                                                                // 651
        // the default for the object 'location' is the standard object 'window.location'                             // 652
        object = object === locationDescriptors ? windowLocation : object;                                            // 653
        // setter for object properties                                                                               // 654
        descriptor.set = (descriptor.set || function(value) {                                                         // 655
            object[prop] = value;                                                                                     // 656
        });                                                                                                           // 657
        // getter for object properties                                                                               // 658
        descriptor.get = (descriptor.get || function() {                                                              // 659
            return object[prop];                                                                                      // 660
        });                                                                                                           // 661
        return descriptor;                                                                                            // 662
    }                                                                                                                 // 663
                                                                                                                      // 664
    /**                                                                                                               // 665
     * Wrapper for the methods 'addEventListener/attachEvent' in the context of the 'window'                          // 666
     *                                                                                                                // 667
     * @param {String} event The event type for which the user is registering                                         // 668
     * @param {Function} listener The method to be called when the event occurs.                                      // 669
     * @param {Boolean} capture If true, capture indicates that the user wishes to initiate capture.                  // 670
     * @return void                                                                                                   // 671
     */                                                                                                               // 672
    function addEventListener(event, listener, capture) {                                                             // 673
        if (event in eventsList) {                                                                                    // 674
            // here stored the event listeners 'popstate/hashchange'                                                  // 675
            eventsList[event].push(listener);                                                                         // 676
        } else {                                                                                                      // 677
            // FireFox support non-standart four argument aWantsUntrusted                                             // 678
            // https://github.com/devote/HTML5-History-API/issues/13                                                  // 679
            if (arguments.length > 3) {                                                                               // 680
                addEvent(event, listener, capture, arguments[3]);                                                     // 681
            } else {                                                                                                  // 682
                addEvent(event, listener, capture);                                                                   // 683
            }                                                                                                         // 684
        }                                                                                                             // 685
    }                                                                                                                 // 686
                                                                                                                      // 687
    /**                                                                                                               // 688
     * Wrapper for the methods 'removeEventListener/detachEvent' in the context of the 'window'                       // 689
     *                                                                                                                // 690
     * @param {String} event The event type for which the user is registered                                          // 691
     * @param {Function} listener The parameter indicates the Listener to be removed.                                 // 692
     * @param {Boolean} capture Was registered as a capturing listener or not.                                        // 693
     * @return void                                                                                                   // 694
     */                                                                                                               // 695
    function removeEventListener(event, listener, capture) {                                                          // 696
        var list = eventsList[event];                                                                                 // 697
        if (list) {                                                                                                   // 698
            for(var i = list.length; i--;) {                                                                          // 699
                if (list[i] === listener) {                                                                           // 700
                    list.splice(i, 1);                                                                                // 701
                    break;                                                                                            // 702
                }                                                                                                     // 703
            }                                                                                                         // 704
        } else {                                                                                                      // 705
            removeEvent(event, listener, capture);                                                                    // 706
        }                                                                                                             // 707
    }                                                                                                                 // 708
                                                                                                                      // 709
    /**                                                                                                               // 710
     * Wrapper for the methods 'dispatchEvent/fireEvent' in the context of the 'window'                               // 711
     *                                                                                                                // 712
     * @param {Event|String} event Instance of Event or event type string if 'eventObject' used                       // 713
     * @param {*} [eventObject] For Internet Explorer 8 required event object on this argument                        // 714
     * @return {Boolean} If 'preventDefault' was called the value is false, else the value is true.                   // 715
     */                                                                                                               // 716
    function dispatchEvent(event, eventObject) {                                                                      // 717
        var eventType = ('' + (typeof event === "string" ? event : event.type)).replace(/^on/, '');                   // 718
        var list = eventsList[eventType];                                                                             // 719
        if (list) {                                                                                                   // 720
            // need to understand that there is one object of Event                                                   // 721
            eventObject = typeof event === "string" ? eventObject : event;                                            // 722
            if (eventObject.target == null) {                                                                         // 723
                // need to override some of the properties of the Event object                                        // 724
                for(var props = ['target', 'currentTarget', 'srcElement', 'type']; event = props.pop();) {            // 725
                    // use 'redefineProperty' to override the properties                                              // 726
                    eventObject = redefineProperty(eventObject, event, {                                              // 727
                        get: event === 'type' ? function() {                                                          // 728
                            return eventType;                                                                         // 729
                        } : function() {                                                                              // 730
                            return global;                                                                            // 731
                        }                                                                                             // 732
                    });                                                                                               // 733
                }                                                                                                     // 734
            }                                                                                                         // 735
            if (triggerEventsInWindowAttributes) {                                                                    // 736
              // run function defined in the attributes 'onpopstate/onhashchange' in the 'window' context             // 737
              ((eventType === 'popstate' ? global.onpopstate : global.onhashchange)                                   // 738
                  || emptyFunction).call(global, eventObject);                                                        // 739
            }                                                                                                         // 740
            // run other functions that are in the list of handlers                                                   // 741
            for(var i = 0, len = list.length; i < len; i++) {                                                         // 742
                list[i].call(global, eventObject);                                                                    // 743
            }                                                                                                         // 744
            return true;                                                                                              // 745
        } else {                                                                                                      // 746
            return dispatch(event, eventObject);                                                                      // 747
        }                                                                                                             // 748
    }                                                                                                                 // 749
                                                                                                                      // 750
    /**                                                                                                               // 751
     * dispatch current state event                                                                                   // 752
     */                                                                                                               // 753
    function firePopState() {                                                                                         // 754
        var o = document.createEvent ? document.createEvent('Event') : document.createEventObject();                  // 755
        if (o.initEvent) {                                                                                            // 756
            o.initEvent('popstate', false, false);                                                                    // 757
        } else {                                                                                                      // 758
            o.type = 'popstate';                                                                                      // 759
        }                                                                                                             // 760
        o.state = historyObject.state;                                                                                // 761
        // send a newly created events to be processed                                                                // 762
        dispatchEvent(o);                                                                                             // 763
    }                                                                                                                 // 764
                                                                                                                      // 765
    /**                                                                                                               // 766
     * fire initial state for non-HTML5 browsers                                                                      // 767
     */                                                                                                               // 768
    function fireInitialState() {                                                                                     // 769
        if (isFireInitialState) {                                                                                     // 770
            isFireInitialState = false;                                                                               // 771
            firePopState();                                                                                           // 772
        }                                                                                                             // 773
    }                                                                                                                 // 774
                                                                                                                      // 775
    /**                                                                                                               // 776
     * Change the data of the current history for HTML4 browsers                                                      // 777
     *                                                                                                                // 778
     * @param {Object} state                                                                                          // 779
     * @param {string} [url]                                                                                          // 780
     * @param {Boolean} [replace]                                                                                     // 781
     * @param {string} [lastURLValue]                                                                                 // 782
     * @return void                                                                                                   // 783
     */                                                                                                               // 784
    function changeState(state, url, replace, lastURLValue) {                                                         // 785
        if (!isSupportHistoryAPI) {                                                                                   // 786
            // if not used implementation history.location                                                            // 787
            if (isUsedHistoryLocationFlag === 0) isUsedHistoryLocationFlag = 2;                                       // 788
            // normalization url                                                                                      // 789
            var urlObject = parseURL(url, isUsedHistoryLocationFlag === 2 && ('' + url).indexOf("#") !== -1);         // 790
            // if current url not equal new url                                                                       // 791
            if (urlObject._relative !== parseURL()._relative) {                                                       // 792
                // if empty lastURLValue to skip hash change event                                                    // 793
                lastURL = lastURLValue;                                                                               // 794
                if (replace) {                                                                                        // 795
                    // only replace hash, not store to history                                                        // 796
                    windowLocation.replace("#" + urlObject._special);                                                 // 797
                } else {                                                                                              // 798
                    // change hash and add new record to history                                                      // 799
                    windowLocation.hash = urlObject._special;                                                         // 800
                }                                                                                                     // 801
            }                                                                                                         // 802
        } else {                                                                                                      // 803
            lastURL = windowLocation.href;                                                                            // 804
        }                                                                                                             // 805
        if (!isSupportStateObjectInHistory && state) {                                                                // 806
            stateStorage[windowLocation.href] = state;                                                                // 807
        }                                                                                                             // 808
        isFireInitialState = false;                                                                                   // 809
    }                                                                                                                 // 810
                                                                                                                      // 811
    /**                                                                                                               // 812
     * Event handler function changes the hash in the address bar                                                     // 813
     *                                                                                                                // 814
     * @param {Event} event                                                                                           // 815
     * @return void                                                                                                   // 816
     */                                                                                                               // 817
    function onHashChange(event) {                                                                                    // 818
        // https://github.com/devote/HTML5-History-API/issues/46                                                      // 819
        var fireNow = lastURL;                                                                                        // 820
        // new value to lastURL                                                                                       // 821
        lastURL = windowLocation.href;                                                                                // 822
        // if not empty fireNow, otherwise skipped the current handler event                                          // 823
        if (fireNow) {                                                                                                // 824
            // if checkUrlForPopState equal current url, this means that the event was raised popstate browser        // 825
            if (checkUrlForPopState !== windowLocation.href) {                                                        // 826
                // otherwise,                                                                                         // 827
                // the browser does not support popstate event or just does not run the event by changing the hash.   // 828
                firePopState();                                                                                       // 829
            }                                                                                                         // 830
            // current event object                                                                                   // 831
            event = event || global.event;                                                                            // 832
                                                                                                                      // 833
            var oldURLObject = parseURL(fireNow, true);                                                               // 834
            var newURLObject = parseURL();                                                                            // 835
            // HTML4 browser not support properties oldURL/newURL                                                     // 836
            if (!event.oldURL) {                                                                                      // 837
                event.oldURL = oldURLObject._href;                                                                    // 838
                event.newURL = newURLObject._href;                                                                    // 839
            }                                                                                                         // 840
            if (oldURLObject._hash !== newURLObject._hash) {                                                          // 841
                // if current hash not equal previous hash                                                            // 842
                dispatchEvent(event);                                                                                 // 843
            }                                                                                                         // 844
        }                                                                                                             // 845
    }                                                                                                                 // 846
                                                                                                                      // 847
    /**                                                                                                               // 848
     * The event handler is fully loaded document                                                                     // 849
     *                                                                                                                // 850
     * @param {*} [noScroll]                                                                                          // 851
     * @return void                                                                                                   // 852
     */                                                                                                               // 853
    function onLoad(noScroll) {                                                                                       // 854
        // Get rid of the events popstate when the first loading a document in the webkit browsers                    // 855
        setTimeout(function() {                                                                                       // 856
            // hang up the event handler for the built-in popstate event in the browser                               // 857
            addEvent('popstate', function(e) {                                                                        // 858
                // set the current url, that suppress the creation of the popstate event by changing the hash         // 859
                checkUrlForPopState = windowLocation.href;                                                            // 860
                // for Safari browser in OS Windows not implemented 'state' object in 'History' interface             // 861
                // and not implemented in old HTML4 browsers                                                          // 862
                if (!isSupportStateObjectInHistory) {                                                                 // 863
                    e = redefineProperty(e, 'state', {get: function() {                                               // 864
                        return historyObject.state;                                                                   // 865
                    }});                                                                                              // 866
                }                                                                                                     // 867
                // send events to be processed                                                                        // 868
                dispatchEvent(e);                                                                                     // 869
            }, false);                                                                                                // 870
        }, 0);                                                                                                        // 871
        // for non-HTML5 browsers                                                                                     // 872
        if (!isSupportHistoryAPI && noScroll !== true && "location" in historyObject) {                               // 873
            // scroll window to anchor element                                                                        // 874
            scrollToAnchorId(locationObject.hash);                                                                    // 875
            // fire initial state for non-HTML5 browser after load page                                               // 876
            fireInitialState();                                                                                       // 877
        }                                                                                                             // 878
    }                                                                                                                 // 879
                                                                                                                      // 880
    /**                                                                                                               // 881
     * Finds the closest ancestor anchor element (including the target itself).                                       // 882
     *                                                                                                                // 883
     * @param {HTMLElement} target The element to start scanning from.                                                // 884
     * @return {HTMLElement} An element which is the closest ancestor anchor.                                         // 885
     */                                                                                                               // 886
    function anchorTarget(target) {                                                                                   // 887
        while (target) {                                                                                              // 888
            if (target.nodeName === 'A') return target;                                                               // 889
            target = target.parentNode;                                                                               // 890
        }                                                                                                             // 891
    }                                                                                                                 // 892
                                                                                                                      // 893
    /**                                                                                                               // 894
     * Handles anchor elements with a hash fragment for non-HTML5 browsers                                            // 895
     *                                                                                                                // 896
     * @param {Event} e                                                                                               // 897
     */                                                                                                               // 898
    function onAnchorClick(e) {                                                                                       // 899
        var event = e || global.event;                                                                                // 900
        var target = anchorTarget(event.target || event.srcElement);                                                  // 901
        var defaultPrevented = "defaultPrevented" in event ? event['defaultPrevented'] : event.returnValue === false;
        if (target && target.nodeName === "A" && !defaultPrevented) {                                                 // 903
            var current = parseURL();                                                                                 // 904
            var expect = parseURL(target.getAttribute("href", 2));                                                    // 905
            var isEqualBaseURL = current._href.split('#').shift() === expect._href.split('#').shift();                // 906
            if (isEqualBaseURL && expect._hash) {                                                                     // 907
                if (current._hash !== expect._hash) {                                                                 // 908
                    locationObject.hash = expect._hash;                                                               // 909
                }                                                                                                     // 910
                scrollToAnchorId(expect._hash);                                                                       // 911
                if (event.preventDefault) {                                                                           // 912
                    event.preventDefault();                                                                           // 913
                } else {                                                                                              // 914
                    event.returnValue = false;                                                                        // 915
                }                                                                                                     // 916
            }                                                                                                         // 917
        }                                                                                                             // 918
    }                                                                                                                 // 919
                                                                                                                      // 920
    /**                                                                                                               // 921
     * Scroll page to current anchor in url-hash                                                                      // 922
     *                                                                                                                // 923
     * @param hash                                                                                                    // 924
     */                                                                                                               // 925
    function scrollToAnchorId(hash) {                                                                                 // 926
        var target = document.getElementById(hash = (hash || '').replace(/^#/, ''));                                  // 927
        if (target && target.id === hash && target.nodeName === "A") {                                                // 928
            var rect = target.getBoundingClientRect();                                                                // 929
            global.scrollTo((documentElement.scrollLeft || 0), rect.top + (documentElement.scrollTop || 0)            // 930
                - (documentElement.clientTop || 0));                                                                  // 931
        }                                                                                                             // 932
    }                                                                                                                 // 933
                                                                                                                      // 934
    /**                                                                                                               // 935
     * Library initialization                                                                                         // 936
     *                                                                                                                // 937
     * @return {Boolean} return true if all is well, otherwise return false value                                     // 938
     */                                                                                                               // 939
    function initialize() {                                                                                           // 940
        /**                                                                                                           // 941
         * Get custom settings from the query string                                                                  // 942
         */                                                                                                           // 943
        var scripts = document.getElementsByTagName('script');                                                        // 944
        var src = (scripts[scripts.length - 1] || {}).src || '';                                                      // 945
        var arg = src.indexOf('?') !== -1 ? src.split('?').pop() : '';                                                // 946
        arg.replace(/(\w+)(?:=([^&]*))?/g, function(a, key, value) {                                                  // 947
            settings[key] = (value || '').replace(/^(0|false)$/, '');                                                 // 948
        });                                                                                                           // 949
                                                                                                                      // 950
        /**                                                                                                           // 951
         * hang up the event handler to listen to the events hashchange                                               // 952
         */                                                                                                           // 953
        addEvent(eventNamePrefix + 'hashchange', onHashChange, false);                                                // 954
                                                                                                                      // 955
        // a list of objects with pairs of descriptors/object                                                         // 956
        var data = [locationDescriptors, locationObject, eventsDescriptors, global, historyDescriptors, historyObject];
                                                                                                                      // 958
        // if browser support object 'state' in interface 'History'                                                   // 959
        if (isSupportStateObjectInHistory) {                                                                          // 960
            // remove state property from descriptor                                                                  // 961
            delete historyDescriptors['state'];                                                                       // 962
        }                                                                                                             // 963
                                                                                                                      // 964
        // initializing descriptors                                                                                   // 965
        for(var i = 0; i < data.length; i += 2) {                                                                     // 966
            for(var prop in data[i]) {                                                                                // 967
                if (data[i].hasOwnProperty(prop)) {                                                                   // 968
                    if (typeof data[i][prop] === 'function') {                                                        // 969
                        // If the descriptor is a simple function, simply just assign it an object                    // 970
                        data[i + 1][prop] = data[i][prop];                                                            // 971
                    } else {                                                                                          // 972
                        // prepare the descriptor the required format                                                 // 973
                        var descriptor = prepareDescriptorsForObject(data[i], prop, data[i][prop]);                   // 974
                        // try to set the descriptor object                                                           // 975
                        if (!redefineProperty(data[i + 1], prop, descriptor, function(n, o) {                         // 976
                            // is satisfied if the failed override property                                           // 977
                            if (o === historyObject) {                                                                // 978
                                // the problem occurs in Safari on the Mac                                            // 979
                                global.history = historyObject = data[i + 1] = n;                                     // 980
                            }                                                                                         // 981
                        })) {                                                                                         // 982
                            // if there is no possibility override.                                                   // 983
                            // This browser does not support descriptors, such as IE7                                 // 984
                                                                                                                      // 985
                            // remove previously hung event handlers                                                  // 986
                            removeEvent(eventNamePrefix + 'hashchange', onHashChange, false);                         // 987
                                                                                                                      // 988
                            // fail to initialize :(                                                                  // 989
                            return false;                                                                             // 990
                        }                                                                                             // 991
                                                                                                                      // 992
                        // create a repository for custom handlers onpopstate/onhashchange                            // 993
                        if (data[i + 1] === global) {                                                                 // 994
                            eventsList[prop] = eventsList[prop.substr(2)] = [];                                       // 995
                        }                                                                                             // 996
                    }                                                                                                 // 997
                }                                                                                                     // 998
            }                                                                                                         // 999
        }                                                                                                             // 1000
                                                                                                                      // 1001
        // check settings                                                                                             // 1002
        historyObject['setup']();                                                                                     // 1003
                                                                                                                      // 1004
        // redirect if necessary                                                                                      // 1005
        if (settings['redirect']) {                                                                                   // 1006
            historyObject['redirect']();                                                                              // 1007
        }                                                                                                             // 1008
                                                                                                                      // 1009
        // initialize                                                                                                 // 1010
        if (settings["init"]) {                                                                                       // 1011
            // You agree that you will use window.history.location instead window.location                            // 1012
            isUsedHistoryLocationFlag = 1;                                                                            // 1013
        }                                                                                                             // 1014
                                                                                                                      // 1015
        // If browser does not support object 'state' in interface 'History'                                          // 1016
        if (!isSupportStateObjectInHistory && JSON) {                                                                 // 1017
            storageInitialize();                                                                                      // 1018
        }                                                                                                             // 1019
                                                                                                                      // 1020
        // track clicks on anchors                                                                                    // 1021
        if (!isSupportHistoryAPI) {                                                                                   // 1022
            document[addEventListenerName](eventNamePrefix + "click", onAnchorClick, false);                          // 1023
        }                                                                                                             // 1024
                                                                                                                      // 1025
        if (document.readyState === 'complete') {                                                                     // 1026
            onLoad(true);                                                                                             // 1027
        } else {                                                                                                      // 1028
            if (!isSupportHistoryAPI && parseURL()._relative !== settings["basepath"]) {                              // 1029
                isFireInitialState = true;                                                                            // 1030
            }                                                                                                         // 1031
            /**                                                                                                       // 1032
             * Need to avoid triggering events popstate the initial page load.                                        // 1033
             * Hang handler popstate as will be fully loaded document that                                            // 1034
             * would prevent triggering event onpopstate                                                              // 1035
             */                                                                                                       // 1036
            addEvent(eventNamePrefix + 'load', onLoad, false);                                                        // 1037
        }                                                                                                             // 1038
                                                                                                                      // 1039
        // everything went well                                                                                       // 1040
        return true;                                                                                                  // 1041
    }                                                                                                                 // 1042
                                                                                                                      // 1043
    /**                                                                                                               // 1044
     * Starting the library                                                                                           // 1045
     */                                                                                                               // 1046
    if (!initialize()) {                                                                                              // 1047
        // if unable to initialize descriptors                                                                        // 1048
        // therefore quite old browser and there                                                                      // 1049
        // is no sense to continue to perform                                                                         // 1050
        return;                                                                                                       // 1051
    }                                                                                                                 // 1052
                                                                                                                      // 1053
    /**                                                                                                               // 1054
     * If the property history.emulate will be true,                                                                  // 1055
     * this will be talking about what's going on                                                                     // 1056
     * emulation capabilities HTML5-History-API.                                                                      // 1057
     * Otherwise there is no emulation, ie the                                                                        // 1058
     * built-in browser capabilities.                                                                                 // 1059
     *                                                                                                                // 1060
     * @type {boolean}                                                                                                // 1061
     * @const                                                                                                         // 1062
     */                                                                                                               // 1063
    historyObject['emulate'] = !isSupportHistoryAPI;                                                                  // 1064
                                                                                                                      // 1065
    /**                                                                                                               // 1066
     * Replace the original methods on the wrapper                                                                    // 1067
     */                                                                                                               // 1068
    global[addEventListenerName] = addEventListener;                                                                  // 1069
    global[removeEventListenerName] = removeEventListener;                                                            // 1070
    global[dispatchEventName] = dispatchEvent;                                                                        // 1071
                                                                                                                      // 1072
    return historyObject;                                                                                             // 1073
});                                                                                                                   // 1074
                                                                                                                      // 1075
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/tomwasd_history-polyfill/settings.js                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
// Make sure that polyfilled links are redirected to correct links in                                                 // 1
// supporting browsers. Enables sharing links between IE and non-IE                                                   // 2
// e.g. http://example.com/#/some-path -> http://example.com/some-path                                                // 3
history.redirect();                                                                                                   // 4
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['tomwasd:history-polyfill'] = {};

})();
