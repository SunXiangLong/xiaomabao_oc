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
var Tracker = Package.tracker.Tracker;
var Deps = Package.tracker.Deps;
var ReactiveDict = Package['reactive-dict'].ReactiveDict;
var ReactiveVar = Package['reactive-var'].ReactiveVar;
var EJSON = Package.ejson.EJSON;

/* Package-scope variables */
var page, qs, Triggers, Router, Group, Route, FlowRouter;

(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/kadira_flow-router/client.browserify.js                                                                   //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// shim for using process in browser                                                                                  // 2
                                                                                                                      // 3
var process = module.exports = {};                                                                                    // 4
var queue = [];                                                                                                       // 5
var draining = false;                                                                                                 // 6
var currentQueue;                                                                                                     // 7
var queueIndex = -1;                                                                                                  // 8
                                                                                                                      // 9
function cleanUpNextTick() {                                                                                          // 10
    draining = false;                                                                                                 // 11
    if (currentQueue.length) {                                                                                        // 12
        queue = currentQueue.concat(queue);                                                                           // 13
    } else {                                                                                                          // 14
        queueIndex = -1;                                                                                              // 15
    }                                                                                                                 // 16
    if (queue.length) {                                                                                               // 17
        drainQueue();                                                                                                 // 18
    }                                                                                                                 // 19
}                                                                                                                     // 20
                                                                                                                      // 21
function drainQueue() {                                                                                               // 22
    if (draining) {                                                                                                   // 23
        return;                                                                                                       // 24
    }                                                                                                                 // 25
    var timeout = setTimeout(cleanUpNextTick);                                                                        // 26
    draining = true;                                                                                                  // 27
                                                                                                                      // 28
    var len = queue.length;                                                                                           // 29
    while(len) {                                                                                                      // 30
        currentQueue = queue;                                                                                         // 31
        queue = [];                                                                                                   // 32
        while (++queueIndex < len) {                                                                                  // 33
            currentQueue[queueIndex].run();                                                                           // 34
        }                                                                                                             // 35
        queueIndex = -1;                                                                                              // 36
        len = queue.length;                                                                                           // 37
    }                                                                                                                 // 38
    currentQueue = null;                                                                                              // 39
    draining = false;                                                                                                 // 40
    clearTimeout(timeout);                                                                                            // 41
}                                                                                                                     // 42
                                                                                                                      // 43
process.nextTick = function (fun) {                                                                                   // 44
    var args = new Array(arguments.length - 1);                                                                       // 45
    if (arguments.length > 1) {                                                                                       // 46
        for (var i = 1; i < arguments.length; i++) {                                                                  // 47
            args[i - 1] = arguments[i];                                                                               // 48
        }                                                                                                             // 49
    }                                                                                                                 // 50
    queue.push(new Item(fun, args));                                                                                  // 51
    if (queue.length === 1 && !draining) {                                                                            // 52
        setTimeout(drainQueue, 0);                                                                                    // 53
    }                                                                                                                 // 54
};                                                                                                                    // 55
                                                                                                                      // 56
// v8 likes predictible objects                                                                                       // 57
function Item(fun, array) {                                                                                           // 58
    this.fun = fun;                                                                                                   // 59
    this.array = array;                                                                                               // 60
}                                                                                                                     // 61
Item.prototype.run = function () {                                                                                    // 62
    this.fun.apply(null, this.array);                                                                                 // 63
};                                                                                                                    // 64
process.title = 'browser';                                                                                            // 65
process.browser = true;                                                                                               // 66
process.env = {};                                                                                                     // 67
process.argv = [];                                                                                                    // 68
process.version = ''; // empty string to avoid regexp issues                                                          // 69
process.versions = {};                                                                                                // 70
                                                                                                                      // 71
function noop() {}                                                                                                    // 72
                                                                                                                      // 73
process.on = noop;                                                                                                    // 74
process.addListener = noop;                                                                                           // 75
process.once = noop;                                                                                                  // 76
process.off = noop;                                                                                                   // 77
process.removeListener = noop;                                                                                        // 78
process.removeAllListeners = noop;                                                                                    // 79
process.emit = noop;                                                                                                  // 80
                                                                                                                      // 81
process.binding = function (name) {                                                                                   // 82
    throw new Error('process.binding is not supported');                                                              // 83
};                                                                                                                    // 84
                                                                                                                      // 85
// TODO(shtylman)                                                                                                     // 86
process.cwd = function () { return '/' };                                                                             // 87
process.chdir = function (dir) {                                                                                      // 88
    throw new Error('process.chdir is not supported');                                                                // 89
};                                                                                                                    // 90
process.umask = function() { return 0; };                                                                             // 91
                                                                                                                      // 92
},{}],2:[function(require,module,exports){                                                                            // 93
page = require('page');                                                                                               // 94
qs   = require('qs');                                                                                                 // 95
                                                                                                                      // 96
},{"page":3,"qs":6}],3:[function(require,module,exports){                                                             // 97
(function (process){                                                                                                  // 98
  /* globals require, module */                                                                                       // 99
                                                                                                                      // 100
  'use strict';                                                                                                       // 101
                                                                                                                      // 102
  /**                                                                                                                 // 103
   * Module dependencies.                                                                                             // 104
   */                                                                                                                 // 105
                                                                                                                      // 106
  var pathtoRegexp = require('path-to-regexp');                                                                       // 107
                                                                                                                      // 108
  /**                                                                                                                 // 109
   * Module exports.                                                                                                  // 110
   */                                                                                                                 // 111
                                                                                                                      // 112
  module.exports = page;                                                                                              // 113
                                                                                                                      // 114
  /**                                                                                                                 // 115
   * Detect click event                                                                                               // 116
   */                                                                                                                 // 117
  var clickEvent = ('undefined' !== typeof document) && document.ontouchstart ? 'touchstart' : 'click';               // 118
                                                                                                                      // 119
  /**                                                                                                                 // 120
   * To work properly with the URL                                                                                    // 121
   * history.location generated polyfill in https://github.com/devote/HTML5-History-API                               // 122
   */                                                                                                                 // 123
                                                                                                                      // 124
  var location = ('undefined' !== typeof window) && (window.history.location || window.location);                     // 125
                                                                                                                      // 126
  /**                                                                                                                 // 127
   * Perform initial dispatch.                                                                                        // 128
   */                                                                                                                 // 129
                                                                                                                      // 130
  var dispatch = true;                                                                                                // 131
                                                                                                                      // 132
                                                                                                                      // 133
  /**                                                                                                                 // 134
   * Decode URL components (query string, pathname, hash).                                                            // 135
   * Accommodates both regular percent encoding and x-www-form-urlencoded format.                                     // 136
   */                                                                                                                 // 137
  var decodeURLComponents = true;                                                                                     // 138
                                                                                                                      // 139
  /**                                                                                                                 // 140
   * Base path.                                                                                                       // 141
   */                                                                                                                 // 142
                                                                                                                      // 143
  var base = '';                                                                                                      // 144
                                                                                                                      // 145
  /**                                                                                                                 // 146
   * Running flag.                                                                                                    // 147
   */                                                                                                                 // 148
                                                                                                                      // 149
  var running;                                                                                                        // 150
                                                                                                                      // 151
  /**                                                                                                                 // 152
   * HashBang option                                                                                                  // 153
   */                                                                                                                 // 154
                                                                                                                      // 155
  var hashbang = false;                                                                                               // 156
                                                                                                                      // 157
  /**                                                                                                                 // 158
   * Previous context, for capturing                                                                                  // 159
   * page exit events.                                                                                                // 160
   */                                                                                                                 // 161
                                                                                                                      // 162
  var prevContext;                                                                                                    // 163
                                                                                                                      // 164
  /**                                                                                                                 // 165
   * Register `path` with callback `fn()`,                                                                            // 166
   * or route `path`, or redirection,                                                                                 // 167
   * or `page.start()`.                                                                                               // 168
   *                                                                                                                  // 169
   *   page(fn);                                                                                                      // 170
   *   page('*', fn);                                                                                                 // 171
   *   page('/user/:id', load, user);                                                                                 // 172
   *   page('/user/' + user.id, { some: 'thing' });                                                                   // 173
   *   page('/user/' + user.id);                                                                                      // 174
   *   page('/from', '/to')                                                                                           // 175
   *   page();                                                                                                        // 176
   *                                                                                                                  // 177
   * @param {String|Function} path                                                                                    // 178
   * @param {Function} fn...                                                                                          // 179
   * @api public                                                                                                      // 180
   */                                                                                                                 // 181
                                                                                                                      // 182
  function page(path, fn) {                                                                                           // 183
    // <callback>                                                                                                     // 184
    if ('function' === typeof path) {                                                                                 // 185
      return page('*', path);                                                                                         // 186
    }                                                                                                                 // 187
                                                                                                                      // 188
    // route <path> to <callback ...>                                                                                 // 189
    if ('function' === typeof fn) {                                                                                   // 190
      var route = new Route(path);                                                                                    // 191
      for (var i = 1; i < arguments.length; ++i) {                                                                    // 192
        page.callbacks.push(route.middleware(arguments[i]));                                                          // 193
      }                                                                                                               // 194
      // show <path> with [state]                                                                                     // 195
    } else if ('string' === typeof path) {                                                                            // 196
      page['string' === typeof fn ? 'redirect' : 'show'](path, fn);                                                   // 197
      // start [options]                                                                                              // 198
    } else {                                                                                                          // 199
      page.start(path);                                                                                               // 200
    }                                                                                                                 // 201
  }                                                                                                                   // 202
                                                                                                                      // 203
  /**                                                                                                                 // 204
   * Callback functions.                                                                                              // 205
   */                                                                                                                 // 206
                                                                                                                      // 207
  page.callbacks = [];                                                                                                // 208
  page.exits = [];                                                                                                    // 209
                                                                                                                      // 210
  /**                                                                                                                 // 211
   * Current path being processed                                                                                     // 212
   * @type {String}                                                                                                   // 213
   */                                                                                                                 // 214
  page.current = '';                                                                                                  // 215
                                                                                                                      // 216
  /**                                                                                                                 // 217
   * Number of pages navigated to.                                                                                    // 218
   * @type {number}                                                                                                   // 219
   *                                                                                                                  // 220
   *     page.len == 0;                                                                                               // 221
   *     page('/login');                                                                                              // 222
   *     page.len == 1;                                                                                               // 223
   */                                                                                                                 // 224
                                                                                                                      // 225
  page.len = 0;                                                                                                       // 226
                                                                                                                      // 227
  /**                                                                                                                 // 228
   * Get or set basepath to `path`.                                                                                   // 229
   *                                                                                                                  // 230
   * @param {String} path                                                                                             // 231
   * @api public                                                                                                      // 232
   */                                                                                                                 // 233
                                                                                                                      // 234
  page.base = function(path) {                                                                                        // 235
    if (0 === arguments.length) return base;                                                                          // 236
    base = path;                                                                                                      // 237
  };                                                                                                                  // 238
                                                                                                                      // 239
  /**                                                                                                                 // 240
   * Bind with the given `options`.                                                                                   // 241
   *                                                                                                                  // 242
   * Options:                                                                                                         // 243
   *                                                                                                                  // 244
   *    - `click` bind to click events [true]                                                                         // 245
   *    - `popstate` bind to popstate [true]                                                                          // 246
   *    - `dispatch` perform initial dispatch [true]                                                                  // 247
   *                                                                                                                  // 248
   * @param {Object} options                                                                                          // 249
   * @api public                                                                                                      // 250
   */                                                                                                                 // 251
                                                                                                                      // 252
  page.start = function(options) {                                                                                    // 253
    options = options || {};                                                                                          // 254
    if (running) return;                                                                                              // 255
    running = true;                                                                                                   // 256
    if (false === options.dispatch) dispatch = false;                                                                 // 257
    if (false === options.decodeURLComponents) decodeURLComponents = false;                                           // 258
    if (false !== options.popstate) window.addEventListener('popstate', onpopstate, false);                           // 259
    if (false !== options.click) {                                                                                    // 260
      document.addEventListener(clickEvent, onclick, false);                                                          // 261
    }                                                                                                                 // 262
    if (true === options.hashbang) hashbang = true;                                                                   // 263
    if (!dispatch) return;                                                                                            // 264
    var url = (hashbang && ~location.hash.indexOf('#!')) ? location.hash.substr(2) + location.search : location.pathname + location.search + location.hash;
    page.replace(url, null, true, dispatch);                                                                          // 266
  };                                                                                                                  // 267
                                                                                                                      // 268
  /**                                                                                                                 // 269
   * Unbind click and popstate event handlers.                                                                        // 270
   *                                                                                                                  // 271
   * @api public                                                                                                      // 272
   */                                                                                                                 // 273
                                                                                                                      // 274
  page.stop = function() {                                                                                            // 275
    if (!running) return;                                                                                             // 276
    page.current = '';                                                                                                // 277
    page.len = 0;                                                                                                     // 278
    running = false;                                                                                                  // 279
    document.removeEventListener(clickEvent, onclick, false);                                                         // 280
    window.removeEventListener('popstate', onpopstate, false);                                                        // 281
  };                                                                                                                  // 282
                                                                                                                      // 283
  /**                                                                                                                 // 284
   * Show `path` with optional `state` object.                                                                        // 285
   *                                                                                                                  // 286
   * @param {String} path                                                                                             // 287
   * @param {Object} state                                                                                            // 288
   * @param {Boolean} dispatch                                                                                        // 289
   * @return {Context}                                                                                                // 290
   * @api public                                                                                                      // 291
   */                                                                                                                 // 292
                                                                                                                      // 293
  page.show = function(path, state, dispatch, push) {                                                                 // 294
    var ctx = new Context(path, state);                                                                               // 295
    page.current = ctx.path;                                                                                          // 296
    if (false !== dispatch) page.dispatch(ctx);                                                                       // 297
    if (false !== ctx.handled && false !== push) ctx.pushState();                                                     // 298
    return ctx;                                                                                                       // 299
  };                                                                                                                  // 300
                                                                                                                      // 301
  /**                                                                                                                 // 302
   * Goes back in the history                                                                                         // 303
   * Back should always let the current route push state and then go back.                                            // 304
   *                                                                                                                  // 305
   * @param {String} path - fallback path to go back if no more history exists, if undefined defaults to page.base    // 306
   * @param {Object} [state]                                                                                          // 307
   * @api public                                                                                                      // 308
   */                                                                                                                 // 309
                                                                                                                      // 310
  page.back = function(path, state) {                                                                                 // 311
    if (page.len > 0) {                                                                                               // 312
      // this may need more testing to see if all browsers                                                            // 313
      // wait for the next tick to go back in history                                                                 // 314
      history.back();                                                                                                 // 315
      page.len--;                                                                                                     // 316
    } else if (path) {                                                                                                // 317
      setTimeout(function() {                                                                                         // 318
        page.show(path, state);                                                                                       // 319
      });                                                                                                             // 320
    }else{                                                                                                            // 321
      setTimeout(function() {                                                                                         // 322
        page.show(base, state);                                                                                       // 323
      });                                                                                                             // 324
    }                                                                                                                 // 325
  };                                                                                                                  // 326
                                                                                                                      // 327
                                                                                                                      // 328
  /**                                                                                                                 // 329
   * Register route to redirect from one path to other                                                                // 330
   * or just redirect to another route                                                                                // 331
   *                                                                                                                  // 332
   * @param {String} from - if param 'to' is undefined redirects to 'from'                                            // 333
   * @param {String} [to]                                                                                             // 334
   * @api public                                                                                                      // 335
   */                                                                                                                 // 336
  page.redirect = function(from, to) {                                                                                // 337
    // Define route from a path to another                                                                            // 338
    if ('string' === typeof from && 'string' === typeof to) {                                                         // 339
      page(from, function(e) {                                                                                        // 340
        setTimeout(function() {                                                                                       // 341
          page.replace(to);                                                                                           // 342
        }, 0);                                                                                                        // 343
      });                                                                                                             // 344
    }                                                                                                                 // 345
                                                                                                                      // 346
    // Wait for the push state and replace it with another                                                            // 347
    if ('string' === typeof from && 'undefined' === typeof to) {                                                      // 348
      setTimeout(function() {                                                                                         // 349
        page.replace(from);                                                                                           // 350
      }, 0);                                                                                                          // 351
    }                                                                                                                 // 352
  };                                                                                                                  // 353
                                                                                                                      // 354
  /**                                                                                                                 // 355
   * Replace `path` with optional `state` object.                                                                     // 356
   *                                                                                                                  // 357
   * @param {String} path                                                                                             // 358
   * @param {Object} state                                                                                            // 359
   * @return {Context}                                                                                                // 360
   * @api public                                                                                                      // 361
   */                                                                                                                 // 362
                                                                                                                      // 363
                                                                                                                      // 364
  page.replace = function(path, state, init, dispatch) {                                                              // 365
    var ctx = new Context(path, state);                                                                               // 366
    page.current = ctx.path;                                                                                          // 367
    ctx.init = init;                                                                                                  // 368
    ctx.save(); // save before dispatching, which may redirect                                                        // 369
    if (false !== dispatch) page.dispatch(ctx);                                                                       // 370
    return ctx;                                                                                                       // 371
  };                                                                                                                  // 372
                                                                                                                      // 373
  /**                                                                                                                 // 374
   * Dispatch the given `ctx`.                                                                                        // 375
   *                                                                                                                  // 376
   * @param {Object} ctx                                                                                              // 377
   * @api private                                                                                                     // 378
   */                                                                                                                 // 379
                                                                                                                      // 380
  page.dispatch = function(ctx) {                                                                                     // 381
    var prev = prevContext,                                                                                           // 382
      i = 0,                                                                                                          // 383
      j = 0;                                                                                                          // 384
                                                                                                                      // 385
    prevContext = ctx;                                                                                                // 386
                                                                                                                      // 387
    function nextExit() {                                                                                             // 388
      var fn = page.exits[j++];                                                                                       // 389
      if (!fn) return nextEnter();                                                                                    // 390
      fn(prev, nextExit);                                                                                             // 391
    }                                                                                                                 // 392
                                                                                                                      // 393
    function nextEnter() {                                                                                            // 394
      var fn = page.callbacks[i++];                                                                                   // 395
                                                                                                                      // 396
      if (ctx.path !== page.current) {                                                                                // 397
        ctx.handled = false;                                                                                          // 398
        return;                                                                                                       // 399
      }                                                                                                               // 400
      if (!fn) return unhandled(ctx);                                                                                 // 401
      fn(ctx, nextEnter);                                                                                             // 402
    }                                                                                                                 // 403
                                                                                                                      // 404
    if (prev) {                                                                                                       // 405
      nextExit();                                                                                                     // 406
    } else {                                                                                                          // 407
      nextEnter();                                                                                                    // 408
    }                                                                                                                 // 409
  };                                                                                                                  // 410
                                                                                                                      // 411
  /**                                                                                                                 // 412
   * Unhandled `ctx`. When it's not the initial                                                                       // 413
   * popstate then redirect. If you wish to handle                                                                    // 414
   * 404s on your own use `page('*', callback)`.                                                                      // 415
   *                                                                                                                  // 416
   * @param {Context} ctx                                                                                             // 417
   * @api private                                                                                                     // 418
   */                                                                                                                 // 419
                                                                                                                      // 420
  function unhandled(ctx) {                                                                                           // 421
    if (ctx.handled) return;                                                                                          // 422
    var current;                                                                                                      // 423
                                                                                                                      // 424
    if (hashbang) {                                                                                                   // 425
      current = base + location.hash.replace('#!', '');                                                               // 426
    } else {                                                                                                          // 427
      current = location.pathname + location.search;                                                                  // 428
    }                                                                                                                 // 429
                                                                                                                      // 430
    if (current === ctx.canonicalPath) return;                                                                        // 431
    page.stop();                                                                                                      // 432
    ctx.handled = false;                                                                                              // 433
    location.href = ctx.canonicalPath;                                                                                // 434
  }                                                                                                                   // 435
                                                                                                                      // 436
  /**                                                                                                                 // 437
   * Register an exit route on `path` with                                                                            // 438
   * callback `fn()`, which will be called                                                                            // 439
   * on the previous context when a new                                                                               // 440
   * page is visited.                                                                                                 // 441
   */                                                                                                                 // 442
  page.exit = function(path, fn) {                                                                                    // 443
    if (typeof path === 'function') {                                                                                 // 444
      return page.exit('*', path);                                                                                    // 445
    }                                                                                                                 // 446
                                                                                                                      // 447
    var route = new Route(path);                                                                                      // 448
    for (var i = 1; i < arguments.length; ++i) {                                                                      // 449
      page.exits.push(route.middleware(arguments[i]));                                                                // 450
    }                                                                                                                 // 451
  };                                                                                                                  // 452
                                                                                                                      // 453
  /**                                                                                                                 // 454
   * Remove URL encoding from the given `str`.                                                                        // 455
   * Accommodates whitespace in both x-www-form-urlencoded                                                            // 456
   * and regular percent-encoded form.                                                                                // 457
   *                                                                                                                  // 458
   * @param {str} URL component to decode                                                                             // 459
   */                                                                                                                 // 460
  function decodeURLEncodedURIComponent(val) {                                                                        // 461
    if (typeof val !== 'string') { return val; }                                                                      // 462
    return decodeURLComponents ? decodeURIComponent(val.replace(/\+/g, ' ')) : val;                                   // 463
  }                                                                                                                   // 464
                                                                                                                      // 465
  /**                                                                                                                 // 466
   * Initialize a new "request" `Context`                                                                             // 467
   * with the given `path` and optional initial `state`.                                                              // 468
   *                                                                                                                  // 469
   * @param {String} path                                                                                             // 470
   * @param {Object} state                                                                                            // 471
   * @api public                                                                                                      // 472
   */                                                                                                                 // 473
                                                                                                                      // 474
  function Context(path, state) {                                                                                     // 475
    if ('/' === path[0] && 0 !== path.indexOf(base)) path = base + (hashbang ? '#!' : '') + path;                     // 476
    var i = path.indexOf('?');                                                                                        // 477
                                                                                                                      // 478
    this.canonicalPath = path;                                                                                        // 479
    this.path = path.replace(base, '') || '/';                                                                        // 480
    if (hashbang) this.path = this.path.replace('#!', '') || '/';                                                     // 481
                                                                                                                      // 482
    this.title = document.title;                                                                                      // 483
    this.state = state || {};                                                                                         // 484
    this.state.path = path;                                                                                           // 485
    this.querystring = ~i ? decodeURLEncodedURIComponent(path.slice(i + 1)) : '';                                     // 486
    this.pathname = decodeURLEncodedURIComponent(~i ? path.slice(0, i) : path);                                       // 487
    this.params = {};                                                                                                 // 488
                                                                                                                      // 489
    // fragment                                                                                                       // 490
    this.hash = '';                                                                                                   // 491
    if (!hashbang) {                                                                                                  // 492
      if (!~this.path.indexOf('#')) return;                                                                           // 493
      var parts = this.path.split('#');                                                                               // 494
      this.path = parts[0];                                                                                           // 495
      this.hash = decodeURLEncodedURIComponent(parts[1]) || '';                                                       // 496
      this.querystring = this.querystring.split('#')[0];                                                              // 497
    }                                                                                                                 // 498
  }                                                                                                                   // 499
                                                                                                                      // 500
  /**                                                                                                                 // 501
   * Expose `Context`.                                                                                                // 502
   */                                                                                                                 // 503
                                                                                                                      // 504
  page.Context = Context;                                                                                             // 505
                                                                                                                      // 506
  /**                                                                                                                 // 507
   * Push state.                                                                                                      // 508
   *                                                                                                                  // 509
   * @api private                                                                                                     // 510
   */                                                                                                                 // 511
                                                                                                                      // 512
  Context.prototype.pushState = function() {                                                                          // 513
    page.len++;                                                                                                       // 514
    history.pushState(this.state, this.title, hashbang && this.path !== '/' ? '#!' + this.path : this.canonicalPath);
  };                                                                                                                  // 516
                                                                                                                      // 517
  /**                                                                                                                 // 518
   * Save the context state.                                                                                          // 519
   *                                                                                                                  // 520
   * @api public                                                                                                      // 521
   */                                                                                                                 // 522
                                                                                                                      // 523
  Context.prototype.save = function() {                                                                               // 524
    history.replaceState(this.state, this.title, hashbang && this.path !== '/' ? '#!' + this.path : this.canonicalPath);
  };                                                                                                                  // 526
                                                                                                                      // 527
  /**                                                                                                                 // 528
   * Initialize `Route` with the given HTTP `path`,                                                                   // 529
   * and an array of `callbacks` and `options`.                                                                       // 530
   *                                                                                                                  // 531
   * Options:                                                                                                         // 532
   *                                                                                                                  // 533
   *   - `sensitive`    enable case-sensitive routes                                                                  // 534
   *   - `strict`       enable strict matching for trailing slashes                                                   // 535
   *                                                                                                                  // 536
   * @param {String} path                                                                                             // 537
   * @param {Object} options.                                                                                         // 538
   * @api private                                                                                                     // 539
   */                                                                                                                 // 540
                                                                                                                      // 541
  function Route(path, options) {                                                                                     // 542
    options = options || {};                                                                                          // 543
    this.path = (path === '*') ? '(.*)' : path;                                                                       // 544
    this.method = 'GET';                                                                                              // 545
    this.regexp = pathtoRegexp(this.path,                                                                             // 546
      this.keys = [],                                                                                                 // 547
      options.sensitive,                                                                                              // 548
      options.strict);                                                                                                // 549
  }                                                                                                                   // 550
                                                                                                                      // 551
  /**                                                                                                                 // 552
   * Expose `Route`.                                                                                                  // 553
   */                                                                                                                 // 554
                                                                                                                      // 555
  page.Route = Route;                                                                                                 // 556
                                                                                                                      // 557
  /**                                                                                                                 // 558
   * Return route middleware with                                                                                     // 559
   * the given callback `fn()`.                                                                                       // 560
   *                                                                                                                  // 561
   * @param {Function} fn                                                                                             // 562
   * @return {Function}                                                                                               // 563
   * @api public                                                                                                      // 564
   */                                                                                                                 // 565
                                                                                                                      // 566
  Route.prototype.middleware = function(fn) {                                                                         // 567
    var self = this;                                                                                                  // 568
    return function(ctx, next) {                                                                                      // 569
      if (self.match(ctx.path, ctx.params)) return fn(ctx, next);                                                     // 570
      next();                                                                                                         // 571
    };                                                                                                                // 572
  };                                                                                                                  // 573
                                                                                                                      // 574
  /**                                                                                                                 // 575
   * Check if this route matches `path`, if so                                                                        // 576
   * populate `params`.                                                                                               // 577
   *                                                                                                                  // 578
   * @param {String} path                                                                                             // 579
   * @param {Object} params                                                                                           // 580
   * @return {Boolean}                                                                                                // 581
   * @api private                                                                                                     // 582
   */                                                                                                                 // 583
                                                                                                                      // 584
  Route.prototype.match = function(path, params) {                                                                    // 585
    var keys = this.keys,                                                                                             // 586
      qsIndex = path.indexOf('?'),                                                                                    // 587
      pathname = ~qsIndex ? path.slice(0, qsIndex) : path,                                                            // 588
      m = this.regexp.exec(decodeURIComponent(pathname));                                                             // 589
                                                                                                                      // 590
    if (!m) return false;                                                                                             // 591
                                                                                                                      // 592
    for (var i = 1, len = m.length; i < len; ++i) {                                                                   // 593
      var key = keys[i - 1];                                                                                          // 594
      var val = decodeURLEncodedURIComponent(m[i]);                                                                   // 595
      if (val !== undefined || !(hasOwnProperty.call(params, key.name))) {                                            // 596
        params[key.name] = val;                                                                                       // 597
      }                                                                                                               // 598
    }                                                                                                                 // 599
                                                                                                                      // 600
    return true;                                                                                                      // 601
  };                                                                                                                  // 602
                                                                                                                      // 603
                                                                                                                      // 604
  /**                                                                                                                 // 605
   * Handle "populate" events.                                                                                        // 606
   */                                                                                                                 // 607
                                                                                                                      // 608
  var onpopstate = (function () {                                                                                     // 609
    var loaded = false;                                                                                               // 610
    if ('undefined' === typeof window) {                                                                              // 611
      return;                                                                                                         // 612
    }                                                                                                                 // 613
    if (document.readyState === 'complete') {                                                                         // 614
      loaded = true;                                                                                                  // 615
    } else {                                                                                                          // 616
      window.addEventListener('load', function() {                                                                    // 617
        setTimeout(function() {                                                                                       // 618
          loaded = true;                                                                                              // 619
        }, 0);                                                                                                        // 620
      });                                                                                                             // 621
    }                                                                                                                 // 622
    return function onpopstate(e) {                                                                                   // 623
      if (!loaded) return;                                                                                            // 624
      if (e.state) {                                                                                                  // 625
        var path = e.state.path;                                                                                      // 626
        page.replace(path, e.state);                                                                                  // 627
      } else {                                                                                                        // 628
        page.show(location.pathname + location.hash, undefined, undefined, false);                                    // 629
      }                                                                                                               // 630
    };                                                                                                                // 631
  })();                                                                                                               // 632
  /**                                                                                                                 // 633
   * Handle "click" events.                                                                                           // 634
   */                                                                                                                 // 635
                                                                                                                      // 636
  function onclick(e) {                                                                                               // 637
                                                                                                                      // 638
    if (1 !== which(e)) return;                                                                                       // 639
                                                                                                                      // 640
    if (e.metaKey || e.ctrlKey || e.shiftKey) return;                                                                 // 641
    if (e.defaultPrevented) return;                                                                                   // 642
                                                                                                                      // 643
                                                                                                                      // 644
                                                                                                                      // 645
    // ensure link                                                                                                    // 646
    var el = e.target;                                                                                                // 647
    while (el && 'A' !== el.nodeName) el = el.parentNode;                                                             // 648
    if (!el || 'A' !== el.nodeName) return;                                                                           // 649
                                                                                                                      // 650
                                                                                                                      // 651
                                                                                                                      // 652
    // Ignore if tag has                                                                                              // 653
    // 1. "download" attribute                                                                                        // 654
    // 2. rel="external" attribute                                                                                    // 655
    if (el.hasAttribute('download') || el.getAttribute('rel') === 'external') return;                                 // 656
                                                                                                                      // 657
    // ensure non-hash for the same path                                                                              // 658
    var link = el.getAttribute('href');                                                                               // 659
    if (!hashbang && el.pathname === location.pathname && (el.hash || '#' === link)) return;                          // 660
                                                                                                                      // 661
                                                                                                                      // 662
                                                                                                                      // 663
    // Check for mailto: in the href                                                                                  // 664
    if (link && link.indexOf('mailto:') > -1) return;                                                                 // 665
                                                                                                                      // 666
    // check target                                                                                                   // 667
    if (el.target) return;                                                                                            // 668
                                                                                                                      // 669
    // x-origin                                                                                                       // 670
    if (!sameOrigin(el.href)) return;                                                                                 // 671
                                                                                                                      // 672
                                                                                                                      // 673
                                                                                                                      // 674
    // rebuild path                                                                                                   // 675
    var path = el.pathname + el.search + (el.hash || '');                                                             // 676
                                                                                                                      // 677
    path = path[0] !== '/' ? '/' + path : path;                                                                       // 678
                                                                                                                      // 679
    // strip leading "/[drive letter]:" on NW.js on Windows                                                           // 680
    if (typeof process !== 'undefined' && path.match(/^\/[a-zA-Z]:\//)) {                                             // 681
      path = path.replace(/^\/[a-zA-Z]:\//, '/');                                                                     // 682
    }                                                                                                                 // 683
                                                                                                                      // 684
    // same page                                                                                                      // 685
    var orig = path;                                                                                                  // 686
                                                                                                                      // 687
    if (path.indexOf(base) === 0) {                                                                                   // 688
      path = path.substr(base.length);                                                                                // 689
    }                                                                                                                 // 690
                                                                                                                      // 691
    if (hashbang) path = path.replace('#!', '');                                                                      // 692
                                                                                                                      // 693
    if (base && orig === path) return;                                                                                // 694
                                                                                                                      // 695
    e.preventDefault();                                                                                               // 696
    page.show(orig);                                                                                                  // 697
  }                                                                                                                   // 698
                                                                                                                      // 699
  /**                                                                                                                 // 700
   * Event button.                                                                                                    // 701
   */                                                                                                                 // 702
                                                                                                                      // 703
  function which(e) {                                                                                                 // 704
    e = e || window.event;                                                                                            // 705
    return null === e.which ? e.button : e.which;                                                                     // 706
  }                                                                                                                   // 707
                                                                                                                      // 708
  /**                                                                                                                 // 709
   * Check if `href` is the same origin.                                                                              // 710
   */                                                                                                                 // 711
                                                                                                                      // 712
  function sameOrigin(href) {                                                                                         // 713
    var origin = location.protocol + '//' + location.hostname;                                                        // 714
    if (location.port) origin += ':' + location.port;                                                                 // 715
    return (href && (0 === href.indexOf(origin)));                                                                    // 716
  }                                                                                                                   // 717
                                                                                                                      // 718
  page.sameOrigin = sameOrigin;                                                                                       // 719
                                                                                                                      // 720
}).call(this,require('_process'))                                                                                     // 721
                                                                                                                      // 722
},{"_process":1,"path-to-regexp":4}],4:[function(require,module,exports){                                             // 723
var isArray = require('isarray');                                                                                     // 724
                                                                                                                      // 725
/**                                                                                                                   // 726
 * Expose `pathToRegexp`.                                                                                             // 727
 */                                                                                                                   // 728
module.exports = pathToRegexp;                                                                                        // 729
                                                                                                                      // 730
/**                                                                                                                   // 731
 * The main path matching regexp utility.                                                                             // 732
 *                                                                                                                    // 733
 * @type {RegExp}                                                                                                     // 734
 */                                                                                                                   // 735
var PATH_REGEXP = new RegExp([                                                                                        // 736
  // Match escaped characters that would otherwise appear in future matches.                                          // 737
  // This allows the user to escape special characters that won't transform.                                          // 738
  '(\\\\.)',                                                                                                          // 739
  // Match Express-style parameters and un-named parameters with a prefix                                             // 740
  // and optional suffixes. Matches appear as:                                                                        // 741
  //                                                                                                                  // 742
  // "/:test(\\d+)?" => ["/", "test", "\d+", undefined, "?"]                                                          // 743
  // "/route(\\d+)" => [undefined, undefined, undefined, "\d+", undefined]                                            // 744
  '([\\/.])?(?:\\:(\\w+)(?:\\(((?:\\\\.|[^)])*)\\))?|\\(((?:\\\\.|[^)])*)\\))([+*?])?',                               // 745
  // Match regexp special characters that are always escaped.                                                         // 746
  '([.+*?=^!:${}()[\\]|\\/])'                                                                                         // 747
].join('|'), 'g');                                                                                                    // 748
                                                                                                                      // 749
/**                                                                                                                   // 750
 * Escape the capturing group by escaping special characters and meaning.                                             // 751
 *                                                                                                                    // 752
 * @param  {String} group                                                                                             // 753
 * @return {String}                                                                                                   // 754
 */                                                                                                                   // 755
function escapeGroup (group) {                                                                                        // 756
  return group.replace(/([=!:$\/()])/g, '\\$1');                                                                      // 757
}                                                                                                                     // 758
                                                                                                                      // 759
/**                                                                                                                   // 760
 * Attach the keys as a property of the regexp.                                                                       // 761
 *                                                                                                                    // 762
 * @param  {RegExp} re                                                                                                // 763
 * @param  {Array}  keys                                                                                              // 764
 * @return {RegExp}                                                                                                   // 765
 */                                                                                                                   // 766
function attachKeys (re, keys) {                                                                                      // 767
  re.keys = keys;                                                                                                     // 768
  return re;                                                                                                          // 769
}                                                                                                                     // 770
                                                                                                                      // 771
/**                                                                                                                   // 772
 * Get the flags for a regexp from the options.                                                                       // 773
 *                                                                                                                    // 774
 * @param  {Object} options                                                                                           // 775
 * @return {String}                                                                                                   // 776
 */                                                                                                                   // 777
function flags (options) {                                                                                            // 778
  return options.sensitive ? '' : 'i';                                                                                // 779
}                                                                                                                     // 780
                                                                                                                      // 781
/**                                                                                                                   // 782
 * Pull out keys from a regexp.                                                                                       // 783
 *                                                                                                                    // 784
 * @param  {RegExp} path                                                                                              // 785
 * @param  {Array}  keys                                                                                              // 786
 * @return {RegExp}                                                                                                   // 787
 */                                                                                                                   // 788
function regexpToRegexp (path, keys) {                                                                                // 789
  // Use a negative lookahead to match only capturing groups.                                                         // 790
  var groups = path.source.match(/\((?!\?)/g);                                                                        // 791
                                                                                                                      // 792
  if (groups) {                                                                                                       // 793
    for (var i = 0; i < groups.length; i++) {                                                                         // 794
      keys.push({                                                                                                     // 795
        name:      i,                                                                                                 // 796
        delimiter: null,                                                                                              // 797
        optional:  false,                                                                                             // 798
        repeat:    false                                                                                              // 799
      });                                                                                                             // 800
    }                                                                                                                 // 801
  }                                                                                                                   // 802
                                                                                                                      // 803
  return attachKeys(path, keys);                                                                                      // 804
}                                                                                                                     // 805
                                                                                                                      // 806
/**                                                                                                                   // 807
 * Transform an array into a regexp.                                                                                  // 808
 *                                                                                                                    // 809
 * @param  {Array}  path                                                                                              // 810
 * @param  {Array}  keys                                                                                              // 811
 * @param  {Object} options                                                                                           // 812
 * @return {RegExp}                                                                                                   // 813
 */                                                                                                                   // 814
function arrayToRegexp (path, keys, options) {                                                                        // 815
  var parts = [];                                                                                                     // 816
                                                                                                                      // 817
  for (var i = 0; i < path.length; i++) {                                                                             // 818
    parts.push(pathToRegexp(path[i], keys, options).source);                                                          // 819
  }                                                                                                                   // 820
                                                                                                                      // 821
  var regexp = new RegExp('(?:' + parts.join('|') + ')', flags(options));                                             // 822
  return attachKeys(regexp, keys);                                                                                    // 823
}                                                                                                                     // 824
                                                                                                                      // 825
/**                                                                                                                   // 826
 * Replace the specific tags with regexp strings.                                                                     // 827
 *                                                                                                                    // 828
 * @param  {String} path                                                                                              // 829
 * @param  {Array}  keys                                                                                              // 830
 * @return {String}                                                                                                   // 831
 */                                                                                                                   // 832
function replacePath (path, keys) {                                                                                   // 833
  var index = 0;                                                                                                      // 834
                                                                                                                      // 835
  function replace (_, escaped, prefix, key, capture, group, suffix, escape) {                                        // 836
    if (escaped) {                                                                                                    // 837
      return escaped;                                                                                                 // 838
    }                                                                                                                 // 839
                                                                                                                      // 840
    if (escape) {                                                                                                     // 841
      return '\\' + escape;                                                                                           // 842
    }                                                                                                                 // 843
                                                                                                                      // 844
    var repeat   = suffix === '+' || suffix === '*';                                                                  // 845
    var optional = suffix === '?' || suffix === '*';                                                                  // 846
                                                                                                                      // 847
    keys.push({                                                                                                       // 848
      name:      key || index++,                                                                                      // 849
      delimiter: prefix || '/',                                                                                       // 850
      optional:  optional,                                                                                            // 851
      repeat:    repeat                                                                                               // 852
    });                                                                                                               // 853
                                                                                                                      // 854
    prefix = prefix ? ('\\' + prefix) : '';                                                                           // 855
    capture = escapeGroup(capture || group || '[^' + (prefix || '\\/') + ']+?');                                      // 856
                                                                                                                      // 857
    if (repeat) {                                                                                                     // 858
      capture = capture + '(?:' + prefix + capture + ')*';                                                            // 859
    }                                                                                                                 // 860
                                                                                                                      // 861
    if (optional) {                                                                                                   // 862
      return '(?:' + prefix + '(' + capture + '))?';                                                                  // 863
    }                                                                                                                 // 864
                                                                                                                      // 865
    // Basic parameter support.                                                                                       // 866
    return prefix + '(' + capture + ')';                                                                              // 867
  }                                                                                                                   // 868
                                                                                                                      // 869
  return path.replace(PATH_REGEXP, replace);                                                                          // 870
}                                                                                                                     // 871
                                                                                                                      // 872
/**                                                                                                                   // 873
 * Normalize the given path string, returning a regular expression.                                                   // 874
 *                                                                                                                    // 875
 * An empty array can be passed in for the keys, which will hold the                                                  // 876
 * placeholder key descriptions. For example, using `/user/:id`, `keys` will                                          // 877
 * contain `[{ name: 'id', delimiter: '/', optional: false, repeat: false }]`.                                        // 878
 *                                                                                                                    // 879
 * @param  {(String|RegExp|Array)} path                                                                               // 880
 * @param  {Array}                 [keys]                                                                             // 881
 * @param  {Object}                [options]                                                                          // 882
 * @return {RegExp}                                                                                                   // 883
 */                                                                                                                   // 884
function pathToRegexp (path, keys, options) {                                                                         // 885
  keys = keys || [];                                                                                                  // 886
                                                                                                                      // 887
  if (!isArray(keys)) {                                                                                               // 888
    options = keys;                                                                                                   // 889
    keys = [];                                                                                                        // 890
  } else if (!options) {                                                                                              // 891
    options = {};                                                                                                     // 892
  }                                                                                                                   // 893
                                                                                                                      // 894
  if (path instanceof RegExp) {                                                                                       // 895
    return regexpToRegexp(path, keys, options);                                                                       // 896
  }                                                                                                                   // 897
                                                                                                                      // 898
  if (isArray(path)) {                                                                                                // 899
    return arrayToRegexp(path, keys, options);                                                                        // 900
  }                                                                                                                   // 901
                                                                                                                      // 902
  var strict = options.strict;                                                                                        // 903
  var end = options.end !== false;                                                                                    // 904
  var route = replacePath(path, keys);                                                                                // 905
  var endsWithSlash = path.charAt(path.length - 1) === '/';                                                           // 906
                                                                                                                      // 907
  // In non-strict mode we allow a slash at the end of match. If the path to                                          // 908
  // match already ends with a slash, we remove it for consistency. The slash                                         // 909
  // is valid at the end of a path match, not in the middle. This is important                                        // 910
  // in non-ending mode, where "/test/" shouldn't match "/test//route".                                               // 911
  if (!strict) {                                                                                                      // 912
    route = (endsWithSlash ? route.slice(0, -2) : route) + '(?:\\/(?=$))?';                                           // 913
  }                                                                                                                   // 914
                                                                                                                      // 915
  if (end) {                                                                                                          // 916
    route += '$';                                                                                                     // 917
  } else {                                                                                                            // 918
    // In non-ending mode, we need the capturing groups to match as much as                                           // 919
    // possible by using a positive lookahead to the end or next path segment.                                        // 920
    route += strict && endsWithSlash ? '' : '(?=\\/|$)';                                                              // 921
  }                                                                                                                   // 922
                                                                                                                      // 923
  return attachKeys(new RegExp('^' + route, flags(options)), keys);                                                   // 924
}                                                                                                                     // 925
                                                                                                                      // 926
},{"isarray":5}],5:[function(require,module,exports){                                                                 // 927
module.exports = Array.isArray || function (arr) {                                                                    // 928
  return Object.prototype.toString.call(arr) == '[object Array]';                                                     // 929
};                                                                                                                    // 930
                                                                                                                      // 931
},{}],6:[function(require,module,exports){                                                                            // 932
module.exports = require('./lib/');                                                                                   // 933
                                                                                                                      // 934
},{"./lib/":7}],7:[function(require,module,exports){                                                                  // 935
// Load modules                                                                                                       // 936
                                                                                                                      // 937
var Stringify = require('./stringify');                                                                               // 938
var Parse = require('./parse');                                                                                       // 939
                                                                                                                      // 940
                                                                                                                      // 941
// Declare internals                                                                                                  // 942
                                                                                                                      // 943
var internals = {};                                                                                                   // 944
                                                                                                                      // 945
                                                                                                                      // 946
module.exports = {                                                                                                    // 947
    stringify: Stringify,                                                                                             // 948
    parse: Parse                                                                                                      // 949
};                                                                                                                    // 950
                                                                                                                      // 951
},{"./parse":8,"./stringify":9}],8:[function(require,module,exports){                                                 // 952
// Load modules                                                                                                       // 953
                                                                                                                      // 954
var Utils = require('./utils');                                                                                       // 955
                                                                                                                      // 956
                                                                                                                      // 957
// Declare internals                                                                                                  // 958
                                                                                                                      // 959
var internals = {                                                                                                     // 960
    delimiter: '&',                                                                                                   // 961
    depth: 5,                                                                                                         // 962
    arrayLimit: 20,                                                                                                   // 963
    parameterLimit: 1000,                                                                                             // 964
    strictNullHandling: false                                                                                         // 965
};                                                                                                                    // 966
                                                                                                                      // 967
                                                                                                                      // 968
internals.parseValues = function (str, options) {                                                                     // 969
                                                                                                                      // 970
    var obj = {};                                                                                                     // 971
    var parts = str.split(options.delimiter, options.parameterLimit === Infinity ? undefined : options.parameterLimit);
                                                                                                                      // 973
    for (var i = 0, il = parts.length; i < il; ++i) {                                                                 // 974
        var part = parts[i];                                                                                          // 975
        var pos = part.indexOf(']=') === -1 ? part.indexOf('=') : part.indexOf(']=') + 1;                             // 976
                                                                                                                      // 977
        if (pos === -1) {                                                                                             // 978
            obj[Utils.decode(part)] = '';                                                                             // 979
                                                                                                                      // 980
            if (options.strictNullHandling) {                                                                         // 981
                obj[Utils.decode(part)] = null;                                                                       // 982
            }                                                                                                         // 983
        }                                                                                                             // 984
        else {                                                                                                        // 985
            var key = Utils.decode(part.slice(0, pos));                                                               // 986
            var val = Utils.decode(part.slice(pos + 1));                                                              // 987
                                                                                                                      // 988
            if (!Object.prototype.hasOwnProperty.call(obj, key)) {                                                    // 989
                obj[key] = val;                                                                                       // 990
            }                                                                                                         // 991
            else {                                                                                                    // 992
                obj[key] = [].concat(obj[key]).concat(val);                                                           // 993
            }                                                                                                         // 994
        }                                                                                                             // 995
    }                                                                                                                 // 996
                                                                                                                      // 997
    return obj;                                                                                                       // 998
};                                                                                                                    // 999
                                                                                                                      // 1000
                                                                                                                      // 1001
internals.parseObject = function (chain, val, options) {                                                              // 1002
                                                                                                                      // 1003
    if (!chain.length) {                                                                                              // 1004
        return val;                                                                                                   // 1005
    }                                                                                                                 // 1006
                                                                                                                      // 1007
    var root = chain.shift();                                                                                         // 1008
                                                                                                                      // 1009
    var obj;                                                                                                          // 1010
    if (root === '[]') {                                                                                              // 1011
        obj = [];                                                                                                     // 1012
        obj = obj.concat(internals.parseObject(chain, val, options));                                                 // 1013
    }                                                                                                                 // 1014
    else {                                                                                                            // 1015
        obj = Object.create(null);                                                                                    // 1016
        var cleanRoot = root[0] === '[' && root[root.length - 1] === ']' ? root.slice(1, root.length - 1) : root;     // 1017
        var index = parseInt(cleanRoot, 10);                                                                          // 1018
        var indexString = '' + index;                                                                                 // 1019
        if (!isNaN(index) &&                                                                                          // 1020
            root !== cleanRoot &&                                                                                     // 1021
            indexString === cleanRoot &&                                                                              // 1022
            index >= 0 &&                                                                                             // 1023
            (options.parseArrays &&                                                                                   // 1024
             index <= options.arrayLimit)) {                                                                          // 1025
                                                                                                                      // 1026
            obj = [];                                                                                                 // 1027
            obj[index] = internals.parseObject(chain, val, options);                                                  // 1028
        }                                                                                                             // 1029
        else {                                                                                                        // 1030
            obj[cleanRoot] = internals.parseObject(chain, val, options);                                              // 1031
        }                                                                                                             // 1032
    }                                                                                                                 // 1033
                                                                                                                      // 1034
    return obj;                                                                                                       // 1035
};                                                                                                                    // 1036
                                                                                                                      // 1037
                                                                                                                      // 1038
internals.parseKeys = function (key, val, options) {                                                                  // 1039
                                                                                                                      // 1040
    if (!key) {                                                                                                       // 1041
        return;                                                                                                       // 1042
    }                                                                                                                 // 1043
                                                                                                                      // 1044
    // Transform dot notation to bracket notation                                                                     // 1045
                                                                                                                      // 1046
    if (options.allowDots) {                                                                                          // 1047
        key = key.replace(/\.([^\.\[]+)/g, '[$1]');                                                                   // 1048
    }                                                                                                                 // 1049
                                                                                                                      // 1050
    // The regex chunks                                                                                               // 1051
                                                                                                                      // 1052
    var parent = /^([^\[\]]*)/;                                                                                       // 1053
    var child = /(\[[^\[\]]*\])/g;                                                                                    // 1054
                                                                                                                      // 1055
    // Get the parent                                                                                                 // 1056
                                                                                                                      // 1057
    var segment = parent.exec(key);                                                                                   // 1058
                                                                                                                      // 1059
    // Stash the parent if it exists                                                                                  // 1060
                                                                                                                      // 1061
    var keys = [];                                                                                                    // 1062
    if (segment[1]) {                                                                                                 // 1063
        keys.push(segment[1]);                                                                                        // 1064
    }                                                                                                                 // 1065
                                                                                                                      // 1066
    // Loop through children appending to the array until we hit depth                                                // 1067
                                                                                                                      // 1068
    var i = 0;                                                                                                        // 1069
    while ((segment = child.exec(key)) !== null && i < options.depth) {                                               // 1070
                                                                                                                      // 1071
        ++i;                                                                                                          // 1072
        keys.push(segment[1]);                                                                                        // 1073
    }                                                                                                                 // 1074
                                                                                                                      // 1075
    // If there's a remainder, just add whatever is left                                                              // 1076
                                                                                                                      // 1077
    if (segment) {                                                                                                    // 1078
        keys.push('[' + key.slice(segment.index) + ']');                                                              // 1079
    }                                                                                                                 // 1080
                                                                                                                      // 1081
    return internals.parseObject(keys, val, options);                                                                 // 1082
};                                                                                                                    // 1083
                                                                                                                      // 1084
                                                                                                                      // 1085
module.exports = function (str, options) {                                                                            // 1086
                                                                                                                      // 1087
    if (str === '' ||                                                                                                 // 1088
        str === null ||                                                                                               // 1089
        typeof str === 'undefined') {                                                                                 // 1090
                                                                                                                      // 1091
        return Object.create(null);                                                                                   // 1092
    }                                                                                                                 // 1093
                                                                                                                      // 1094
    options = options || {};                                                                                          // 1095
    options.delimiter = typeof options.delimiter === 'string' || Utils.isRegExp(options.delimiter) ? options.delimiter : internals.delimiter;
    options.depth = typeof options.depth === 'number' ? options.depth : internals.depth;                              // 1097
    options.arrayLimit = typeof options.arrayLimit === 'number' ? options.arrayLimit : internals.arrayLimit;          // 1098
    options.parseArrays = options.parseArrays !== false;                                                              // 1099
    options.allowDots = options.allowDots !== false;                                                                  // 1100
    options.parameterLimit = typeof options.parameterLimit === 'number' ? options.parameterLimit : internals.parameterLimit;
    options.strictNullHandling = typeof options.strictNullHandling === 'boolean' ? options.strictNullHandling : internals.strictNullHandling;
                                                                                                                      // 1103
                                                                                                                      // 1104
    var tempObj = typeof str === 'string' ? internals.parseValues(str, options) : str;                                // 1105
    var obj = Object.create(null);                                                                                    // 1106
                                                                                                                      // 1107
    // Iterate over the keys and setup the new object                                                                 // 1108
                                                                                                                      // 1109
    var keys = Object.keys(tempObj);                                                                                  // 1110
    for (var i = 0, il = keys.length; i < il; ++i) {                                                                  // 1111
        var key = keys[i];                                                                                            // 1112
        var newObj = internals.parseKeys(key, tempObj[key], options);                                                 // 1113
        obj = Utils.merge(obj, newObj);                                                                               // 1114
    }                                                                                                                 // 1115
                                                                                                                      // 1116
    return Utils.compact(obj);                                                                                        // 1117
};                                                                                                                    // 1118
                                                                                                                      // 1119
},{"./utils":10}],9:[function(require,module,exports){                                                                // 1120
// Load modules                                                                                                       // 1121
                                                                                                                      // 1122
var Utils = require('./utils');                                                                                       // 1123
                                                                                                                      // 1124
                                                                                                                      // 1125
// Declare internals                                                                                                  // 1126
                                                                                                                      // 1127
var internals = {                                                                                                     // 1128
    delimiter: '&',                                                                                                   // 1129
    arrayPrefixGenerators: {                                                                                          // 1130
        brackets: function (prefix, key) {                                                                            // 1131
                                                                                                                      // 1132
            return prefix + '[]';                                                                                     // 1133
        },                                                                                                            // 1134
        indices: function (prefix, key) {                                                                             // 1135
                                                                                                                      // 1136
            return prefix + '[' + key + ']';                                                                          // 1137
        },                                                                                                            // 1138
        repeat: function (prefix, key) {                                                                              // 1139
                                                                                                                      // 1140
            return prefix;                                                                                            // 1141
        }                                                                                                             // 1142
    },                                                                                                                // 1143
    strictNullHandling: false                                                                                         // 1144
};                                                                                                                    // 1145
                                                                                                                      // 1146
                                                                                                                      // 1147
internals.stringify = function (obj, prefix, generateArrayPrefix, strictNullHandling, filter) {                       // 1148
                                                                                                                      // 1149
    if (typeof filter === 'function') {                                                                               // 1150
        obj = filter(prefix, obj);                                                                                    // 1151
    }                                                                                                                 // 1152
    else if (Utils.isBuffer(obj)) {                                                                                   // 1153
        obj = obj.toString();                                                                                         // 1154
    }                                                                                                                 // 1155
    else if (obj instanceof Date) {                                                                                   // 1156
        obj = obj.toISOString();                                                                                      // 1157
    }                                                                                                                 // 1158
    else if (obj === null) {                                                                                          // 1159
        if (strictNullHandling) {                                                                                     // 1160
            return Utils.encode(prefix);                                                                              // 1161
        }                                                                                                             // 1162
                                                                                                                      // 1163
        obj = '';                                                                                                     // 1164
    }                                                                                                                 // 1165
                                                                                                                      // 1166
    if (typeof obj === 'string' ||                                                                                    // 1167
        typeof obj === 'number' ||                                                                                    // 1168
        typeof obj === 'boolean') {                                                                                   // 1169
                                                                                                                      // 1170
        return [Utils.encode(prefix) + '=' + Utils.encode(obj)];                                                      // 1171
    }                                                                                                                 // 1172
                                                                                                                      // 1173
    var values = [];                                                                                                  // 1174
                                                                                                                      // 1175
    if (typeof obj === 'undefined') {                                                                                 // 1176
        return values;                                                                                                // 1177
    }                                                                                                                 // 1178
                                                                                                                      // 1179
    var objKeys = Array.isArray(filter) ? filter : Object.keys(obj);                                                  // 1180
    for (var i = 0, il = objKeys.length; i < il; ++i) {                                                               // 1181
        var key = objKeys[i];                                                                                         // 1182
                                                                                                                      // 1183
        if (Array.isArray(obj)) {                                                                                     // 1184
            values = values.concat(internals.stringify(obj[key], generateArrayPrefix(prefix, key), generateArrayPrefix, strictNullHandling, filter));
        }                                                                                                             // 1186
        else {                                                                                                        // 1187
            values = values.concat(internals.stringify(obj[key], prefix + '[' + key + ']', generateArrayPrefix, strictNullHandling, filter));
        }                                                                                                             // 1189
    }                                                                                                                 // 1190
                                                                                                                      // 1191
    return values;                                                                                                    // 1192
};                                                                                                                    // 1193
                                                                                                                      // 1194
                                                                                                                      // 1195
module.exports = function (obj, options) {                                                                            // 1196
                                                                                                                      // 1197
    options = options || {};                                                                                          // 1198
    var delimiter = typeof options.delimiter === 'undefined' ? internals.delimiter : options.delimiter;               // 1199
    var strictNullHandling = typeof options.strictNullHandling === 'boolean' ? options.strictNullHandling : internals.strictNullHandling;
    var objKeys;                                                                                                      // 1201
    var filter;                                                                                                       // 1202
    if (typeof options.filter === 'function') {                                                                       // 1203
        filter = options.filter;                                                                                      // 1204
        obj = filter('', obj);                                                                                        // 1205
    }                                                                                                                 // 1206
    else if (Array.isArray(options.filter)) {                                                                         // 1207
        objKeys = filter = options.filter;                                                                            // 1208
    }                                                                                                                 // 1209
                                                                                                                      // 1210
    var keys = [];                                                                                                    // 1211
                                                                                                                      // 1212
    if (typeof obj !== 'object' ||                                                                                    // 1213
        obj === null) {                                                                                               // 1214
                                                                                                                      // 1215
        return '';                                                                                                    // 1216
    }                                                                                                                 // 1217
                                                                                                                      // 1218
    var arrayFormat;                                                                                                  // 1219
    if (options.arrayFormat in internals.arrayPrefixGenerators) {                                                     // 1220
        arrayFormat = options.arrayFormat;                                                                            // 1221
    }                                                                                                                 // 1222
    else if ('indices' in options) {                                                                                  // 1223
        arrayFormat = options.indices ? 'indices' : 'repeat';                                                         // 1224
    }                                                                                                                 // 1225
    else {                                                                                                            // 1226
        arrayFormat = 'indices';                                                                                      // 1227
    }                                                                                                                 // 1228
                                                                                                                      // 1229
    var generateArrayPrefix = internals.arrayPrefixGenerators[arrayFormat];                                           // 1230
                                                                                                                      // 1231
    if (!objKeys) {                                                                                                   // 1232
        objKeys = Object.keys(obj);                                                                                   // 1233
    }                                                                                                                 // 1234
    for (var i = 0, il = objKeys.length; i < il; ++i) {                                                               // 1235
        var key = objKeys[i];                                                                                         // 1236
        keys = keys.concat(internals.stringify(obj[key], key, generateArrayPrefix, strictNullHandling, filter));      // 1237
    }                                                                                                                 // 1238
                                                                                                                      // 1239
    return keys.join(delimiter);                                                                                      // 1240
};                                                                                                                    // 1241
                                                                                                                      // 1242
},{"./utils":10}],10:[function(require,module,exports){                                                               // 1243
// Load modules                                                                                                       // 1244
                                                                                                                      // 1245
                                                                                                                      // 1246
// Declare internals                                                                                                  // 1247
                                                                                                                      // 1248
var internals = {};                                                                                                   // 1249
internals.hexTable = new Array(256);                                                                                  // 1250
for (var i = 0; i < 256; ++i) {                                                                                       // 1251
    internals.hexTable[i] = '%' + ((i < 16 ? '0' : '') + i.toString(16)).toUpperCase();                               // 1252
}                                                                                                                     // 1253
                                                                                                                      // 1254
                                                                                                                      // 1255
exports.arrayToObject = function (source) {                                                                           // 1256
                                                                                                                      // 1257
    var obj = Object.create(null);                                                                                    // 1258
    for (var i = 0, il = source.length; i < il; ++i) {                                                                // 1259
        if (typeof source[i] !== 'undefined') {                                                                       // 1260
                                                                                                                      // 1261
            obj[i] = source[i];                                                                                       // 1262
        }                                                                                                             // 1263
    }                                                                                                                 // 1264
                                                                                                                      // 1265
    return obj;                                                                                                       // 1266
};                                                                                                                    // 1267
                                                                                                                      // 1268
                                                                                                                      // 1269
exports.merge = function (target, source) {                                                                           // 1270
                                                                                                                      // 1271
    if (!source) {                                                                                                    // 1272
        return target;                                                                                                // 1273
    }                                                                                                                 // 1274
                                                                                                                      // 1275
    if (typeof source !== 'object') {                                                                                 // 1276
        if (Array.isArray(target)) {                                                                                  // 1277
            target.push(source);                                                                                      // 1278
        }                                                                                                             // 1279
        else if (typeof target === 'object') {                                                                        // 1280
            target[source] = true;                                                                                    // 1281
        }                                                                                                             // 1282
        else {                                                                                                        // 1283
            target = [target, source];                                                                                // 1284
        }                                                                                                             // 1285
                                                                                                                      // 1286
        return target;                                                                                                // 1287
    }                                                                                                                 // 1288
                                                                                                                      // 1289
    if (typeof target !== 'object') {                                                                                 // 1290
        target = [target].concat(source);                                                                             // 1291
        return target;                                                                                                // 1292
    }                                                                                                                 // 1293
                                                                                                                      // 1294
    if (Array.isArray(target) &&                                                                                      // 1295
        !Array.isArray(source)) {                                                                                     // 1296
                                                                                                                      // 1297
        target = exports.arrayToObject(target);                                                                       // 1298
    }                                                                                                                 // 1299
                                                                                                                      // 1300
    var keys = Object.keys(source);                                                                                   // 1301
    for (var k = 0, kl = keys.length; k < kl; ++k) {                                                                  // 1302
        var key = keys[k];                                                                                            // 1303
        var value = source[key];                                                                                      // 1304
                                                                                                                      // 1305
        if (!target[key]) {                                                                                           // 1306
            target[key] = value;                                                                                      // 1307
        }                                                                                                             // 1308
        else {                                                                                                        // 1309
            target[key] = exports.merge(target[key], value);                                                          // 1310
        }                                                                                                             // 1311
    }                                                                                                                 // 1312
                                                                                                                      // 1313
    return target;                                                                                                    // 1314
};                                                                                                                    // 1315
                                                                                                                      // 1316
                                                                                                                      // 1317
exports.decode = function (str) {                                                                                     // 1318
                                                                                                                      // 1319
    try {                                                                                                             // 1320
        return decodeURIComponent(str.replace(/\+/g, ' '));                                                           // 1321
    } catch (e) {                                                                                                     // 1322
        return str;                                                                                                   // 1323
    }                                                                                                                 // 1324
};                                                                                                                    // 1325
                                                                                                                      // 1326
exports.encode = function (str) {                                                                                     // 1327
                                                                                                                      // 1328
    // This code was originally written by Brian White (mscdex) for the io.js core querystring library.               // 1329
    // It has been adapted here for stricter adherence to RFC 3986                                                    // 1330
    if (str.length === 0) {                                                                                           // 1331
        return str;                                                                                                   // 1332
    }                                                                                                                 // 1333
                                                                                                                      // 1334
    if (typeof str !== 'string') {                                                                                    // 1335
        str = '' + str;                                                                                               // 1336
    }                                                                                                                 // 1337
                                                                                                                      // 1338
    var out = '';                                                                                                     // 1339
    for (var i = 0, il = str.length; i < il; ++i) {                                                                   // 1340
        var c = str.charCodeAt(i);                                                                                    // 1341
                                                                                                                      // 1342
        if (c === 0x2D || // -                                                                                        // 1343
            c === 0x2E || // .                                                                                        // 1344
            c === 0x5F || // _                                                                                        // 1345
            c === 0x7E || // ~                                                                                        // 1346
            (c >= 0x30 && c <= 0x39) || // 0-9                                                                        // 1347
            (c >= 0x41 && c <= 0x5A) || // a-z                                                                        // 1348
            (c >= 0x61 && c <= 0x7A)) { // A-Z                                                                        // 1349
                                                                                                                      // 1350
            out += str[i];                                                                                            // 1351
            continue;                                                                                                 // 1352
        }                                                                                                             // 1353
                                                                                                                      // 1354
        if (c < 0x80) {                                                                                               // 1355
            out += internals.hexTable[c];                                                                             // 1356
            continue;                                                                                                 // 1357
        }                                                                                                             // 1358
                                                                                                                      // 1359
        if (c < 0x800) {                                                                                              // 1360
            out += internals.hexTable[0xC0 | (c >> 6)] + internals.hexTable[0x80 | (c & 0x3F)];                       // 1361
            continue;                                                                                                 // 1362
        }                                                                                                             // 1363
                                                                                                                      // 1364
        if (c < 0xD800 || c >= 0xE000) {                                                                              // 1365
            out += internals.hexTable[0xE0 | (c >> 12)] + internals.hexTable[0x80 | ((c >> 6) & 0x3F)] + internals.hexTable[0x80 | (c & 0x3F)];
            continue;                                                                                                 // 1367
        }                                                                                                             // 1368
                                                                                                                      // 1369
        ++i;                                                                                                          // 1370
        c = 0x10000 + (((c & 0x3FF) << 10) | (str.charCodeAt(i) & 0x3FF));                                            // 1371
        out += internals.hexTable[0xF0 | (c >> 18)] + internals.hexTable[0x80 | ((c >> 12) & 0x3F)] + internals.hexTable[0x80 | ((c >> 6) & 0x3F)] + internals.hexTable[0x80 | (c & 0x3F)];
    }                                                                                                                 // 1373
                                                                                                                      // 1374
    return out;                                                                                                       // 1375
};                                                                                                                    // 1376
                                                                                                                      // 1377
exports.compact = function (obj, refs) {                                                                              // 1378
                                                                                                                      // 1379
    if (typeof obj !== 'object' ||                                                                                    // 1380
        obj === null) {                                                                                               // 1381
                                                                                                                      // 1382
        return obj;                                                                                                   // 1383
    }                                                                                                                 // 1384
                                                                                                                      // 1385
    refs = refs || [];                                                                                                // 1386
    var lookup = refs.indexOf(obj);                                                                                   // 1387
    if (lookup !== -1) {                                                                                              // 1388
        return refs[lookup];                                                                                          // 1389
    }                                                                                                                 // 1390
                                                                                                                      // 1391
    refs.push(obj);                                                                                                   // 1392
                                                                                                                      // 1393
    if (Array.isArray(obj)) {                                                                                         // 1394
        var compacted = [];                                                                                           // 1395
                                                                                                                      // 1396
        for (var i = 0, il = obj.length; i < il; ++i) {                                                               // 1397
            if (typeof obj[i] !== 'undefined') {                                                                      // 1398
                compacted.push(obj[i]);                                                                               // 1399
            }                                                                                                         // 1400
        }                                                                                                             // 1401
                                                                                                                      // 1402
        return compacted;                                                                                             // 1403
    }                                                                                                                 // 1404
                                                                                                                      // 1405
    var keys = Object.keys(obj);                                                                                      // 1406
    for (i = 0, il = keys.length; i < il; ++i) {                                                                      // 1407
        var key = keys[i];                                                                                            // 1408
        obj[key] = exports.compact(obj[key], refs);                                                                   // 1409
    }                                                                                                                 // 1410
                                                                                                                      // 1411
    return obj;                                                                                                       // 1412
};                                                                                                                    // 1413
                                                                                                                      // 1414
                                                                                                                      // 1415
exports.isRegExp = function (obj) {                                                                                   // 1416
                                                                                                                      // 1417
    return Object.prototype.toString.call(obj) === '[object RegExp]';                                                 // 1418
};                                                                                                                    // 1419
                                                                                                                      // 1420
                                                                                                                      // 1421
exports.isBuffer = function (obj) {                                                                                   // 1422
                                                                                                                      // 1423
    if (obj === null ||                                                                                               // 1424
        typeof obj === 'undefined') {                                                                                 // 1425
                                                                                                                      // 1426
        return false;                                                                                                 // 1427
    }                                                                                                                 // 1428
                                                                                                                      // 1429
    return !!(obj.constructor &&                                                                                      // 1430
              obj.constructor.isBuffer &&                                                                             // 1431
              obj.constructor.isBuffer(obj));                                                                         // 1432
};                                                                                                                    // 1433
                                                                                                                      // 1434
},{}]},{},[2])                                                                                                        // 1435
//# sourceMappingURL=kadira:flow-router/client.browserify.js                                                          // 1436
                                                                                                                      // 1437
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/kadira_flow-router/client/triggers.js                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
// a set of utility functions for triggers                                                                            // 1
                                                                                                                      // 2
Triggers = {};                                                                                                        // 3
                                                                                                                      // 4
// Apply filters for a set of triggers                                                                                // 5
// @triggers - a set of triggers                                                                                      // 6
// @filter - filter with array fileds with `only` and `except`                                                        // 7
//           support only either `only` or `except`, but not both                                                     // 8
Triggers.applyFilters = function(triggers, filter) {                                                                  // 9
  if(!(triggers instanceof Array)) {                                                                                  // 10
    triggers = [triggers];                                                                                            // 11
  }                                                                                                                   // 12
                                                                                                                      // 13
  if(!filter) {                                                                                                       // 14
    return triggers;                                                                                                  // 15
  }                                                                                                                   // 16
                                                                                                                      // 17
  if(filter.only && filter.except) {                                                                                  // 18
    throw new Error("Triggers don't support only and except filters at once");                                        // 19
  }                                                                                                                   // 20
                                                                                                                      // 21
  if(filter.only && !(filter.only instanceof Array)) {                                                                // 22
    throw new Error("only filters needs to be an array");                                                             // 23
  }                                                                                                                   // 24
                                                                                                                      // 25
  if(filter.except && !(filter.except instanceof Array)) {                                                            // 26
    throw new Error("except filters needs to be an array");                                                           // 27
  }                                                                                                                   // 28
                                                                                                                      // 29
  if(filter.only) {                                                                                                   // 30
    return Triggers.createRouteBoundTriggers(triggers, filter.only);                                                  // 31
  }                                                                                                                   // 32
                                                                                                                      // 33
  if(filter.except) {                                                                                                 // 34
    return Triggers.createRouteBoundTriggers(triggers, filter.except, true);                                          // 35
  }                                                                                                                   // 36
                                                                                                                      // 37
  throw new Error("Provided a filter but not supported");                                                             // 38
};                                                                                                                    // 39
                                                                                                                      // 40
//  create triggers by bounding them to a set of route names                                                          // 41
//  @triggers - a set of triggers                                                                                     // 42
//  @names - list of route names to be bound (trigger runs only for these names)                                      // 43
//  @negate - negate the result (triggers won't run for above names)                                                  // 44
Triggers.createRouteBoundTriggers = function(triggers, names, negate) {                                               // 45
  var namesMap = {};                                                                                                  // 46
  _.each(names, function(name) {                                                                                      // 47
    namesMap[name] = true;                                                                                            // 48
  });                                                                                                                 // 49
                                                                                                                      // 50
  var filteredTriggers = _.map(triggers, function(originalTrigger) {                                                  // 51
    var modifiedTrigger = function(context, next) {                                                                   // 52
      var routeName = context.route.name;                                                                             // 53
      var matched = (namesMap[routeName])? 1: -1;                                                                     // 54
      matched = (negate)? matched * -1 : matched;                                                                     // 55
                                                                                                                      // 56
      if(matched === 1) {                                                                                             // 57
        originalTrigger(context, next);                                                                               // 58
      }                                                                                                               // 59
    };                                                                                                                // 60
    return modifiedTrigger;                                                                                           // 61
  });                                                                                                                 // 62
                                                                                                                      // 63
  return filteredTriggers;                                                                                            // 64
};                                                                                                                    // 65
                                                                                                                      // 66
//  run triggers and abort if redirected or callback stopped                                                          // 67
//  @triggers - a set of triggers                                                                                     // 68
//  @context - context we need to pass (it must have the route)                                                       // 69
//  @redirectFn - function which used to redirect                                                                     // 70
//  @after - called after if only all the triggers runs                                                               // 71
Triggers.runTriggers = function(triggers, context, redirectFn, after) {                                               // 72
  var abort = false;                                                                                                  // 73
  var inCurrentLoop = true;                                                                                           // 74
  var alreadyRedirected = false;                                                                                      // 75
                                                                                                                      // 76
  for(var lc=0; lc<triggers.length; lc++) {                                                                           // 77
    var trigger = triggers[lc];                                                                                       // 78
    trigger(context, doRedirect, doStop);                                                                             // 79
                                                                                                                      // 80
    if(abort) {                                                                                                       // 81
      return;                                                                                                         // 82
    }                                                                                                                 // 83
  }                                                                                                                   // 84
                                                                                                                      // 85
  // mark that, we've exceeds the currentEventloop for                                                                // 86
  // this set of triggers.                                                                                            // 87
  inCurrentLoop = false;                                                                                              // 88
  after();                                                                                                            // 89
                                                                                                                      // 90
  function doRedirect(url, params, queryParams) {                                                                     // 91
    if(alreadyRedirected) {                                                                                           // 92
      throw new Error("already redirected");                                                                          // 93
    }                                                                                                                 // 94
                                                                                                                      // 95
    if(!inCurrentLoop) {                                                                                              // 96
      throw new Error("redirect needs to be done in sync");                                                           // 97
    }                                                                                                                 // 98
                                                                                                                      // 99
    if(!url) {                                                                                                        // 100
      throw new Error("trigger redirect requires an URL");                                                            // 101
    }                                                                                                                 // 102
                                                                                                                      // 103
    abort = true;                                                                                                     // 104
    alreadyRedirected = true;                                                                                         // 105
    redirectFn(url, params, queryParams);                                                                             // 106
  }                                                                                                                   // 107
                                                                                                                      // 108
  function doStop() {                                                                                                 // 109
    abort = true;                                                                                                     // 110
  }                                                                                                                   // 111
};                                                                                                                    // 112
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/kadira_flow-router/client/router.js                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
Router = function () {                                                                                                // 1
  var self = this;                                                                                                    // 2
  this.globals = [];                                                                                                  // 3
  this.subscriptions = Function.prototype;                                                                            // 4
                                                                                                                      // 5
  this._tracker = this._buildTracker();                                                                               // 6
  this._current = {};                                                                                                 // 7
                                                                                                                      // 8
  // tracks the current path change                                                                                   // 9
  this._onEveryPath = new Tracker.Dependency();                                                                       // 10
                                                                                                                      // 11
  this._globalRoute = new Route(this);                                                                                // 12
                                                                                                                      // 13
  // holds onRoute callbacks                                                                                          // 14
  this._onRouteCallbacks = [];                                                                                        // 15
                                                                                                                      // 16
  // if _askedToWait is true. We don't automatically start the router                                                 // 17
  // in Meteor.startup callback. (see client/_init.js)                                                                // 18
  // Instead user need to call `.initialize()                                                                         // 19
  this._askedToWait = false;                                                                                          // 20
  this._initialized = false;                                                                                          // 21
  this._triggersEnter = [];                                                                                           // 22
  this._triggersExit = [];                                                                                            // 23
  this._routes = [];                                                                                                  // 24
  this._routesMap = {};                                                                                               // 25
  this._updateCallbacks();                                                                                            // 26
  this.notFound = this.notfound = null;                                                                               // 27
  // indicate it's okay (or not okay) to run the tracker                                                              // 28
  // when doing subscriptions                                                                                         // 29
  // using a number and increment it help us to support FlowRouter.go()                                               // 30
  // and legitimate reruns inside tracker on the same event loop.                                                     // 31
  // this is a solution for #145                                                                                      // 32
  this.safeToRun = 0;                                                                                                 // 33
                                                                                                                      // 34
  // Meteor exposes to the client the path prefix that was defined using the                                          // 35
  // ROOT_URL environement variable on the server using the global runtime                                            // 36
  // configuration. See #315.                                                                                         // 37
  this._basePath = __meteor_runtime_config__.ROOT_URL_PATH_PREFIX || '';                                              // 38
                                                                                                                      // 39
  // this is a chain contains a list of old routes                                                                    // 40
  // most of the time, there is only one old route                                                                    // 41
  // but when it's the time for a trigger redirect we've a chain                                                      // 42
  this._oldRouteChain = [];                                                                                           // 43
                                                                                                                      // 44
  this.env = {                                                                                                        // 45
    replaceState: new Meteor.EnvironmentVariable(),                                                                   // 46
    reload: new Meteor.EnvironmentVariable(),                                                                         // 47
    trailingSlash: new Meteor.EnvironmentVariable()                                                                   // 48
  };                                                                                                                  // 49
                                                                                                                      // 50
  // redirect function used inside triggers                                                                           // 51
  this._redirectFn = function(pathDef, fields, queryParams) {                                                         // 52
    if (/^http(s)?:\/\//.test(pathDef)) {                                                                             // 53
        var message = "Redirects to URLs outside of the app are not supported in this version of Flow Router. Use 'window.location = yourUrl' instead";
        throw new Error(message);                                                                                     // 55
    }                                                                                                                 // 56
    self.withReplaceState(function() {                                                                                // 57
      var path = FlowRouter.path(pathDef, fields, queryParams);                                                       // 58
      self._page.redirect(path);                                                                                      // 59
    });                                                                                                               // 60
  };                                                                                                                  // 61
  this._initTriggersAPI();                                                                                            // 62
};                                                                                                                    // 63
                                                                                                                      // 64
Router.prototype.route = function(pathDef, options, group) {                                                          // 65
  if (!/^\/.*/.test(pathDef)) {                                                                                       // 66
    var message = "route's path must start with '/'";                                                                 // 67
    throw new Error(message);                                                                                         // 68
  }                                                                                                                   // 69
                                                                                                                      // 70
  options = options || {};                                                                                            // 71
  var self = this;                                                                                                    // 72
  var route = new Route(this, pathDef, options, group);                                                               // 73
                                                                                                                      // 74
  // calls when the page route being activates                                                                        // 75
  route._actionHandle = function (context, next) {                                                                    // 76
    var oldRoute = self._current.route;                                                                               // 77
    self._oldRouteChain.push(oldRoute);                                                                               // 78
                                                                                                                      // 79
    var queryParams = self._qs.parse(context.querystring);                                                            // 80
    // _qs.parse() gives us a object without prototypes,                                                              // 81
    // created with Object.create(null)                                                                               // 82
    // Meteor's check doesn't play nice with it.                                                                      // 83
    // So, we need to fix it by cloning it.                                                                           // 84
    // see more: https://github.com/meteorhacks/flow-router/issues/164                                                // 85
    queryParams = JSON.parse(JSON.stringify(queryParams));                                                            // 86
                                                                                                                      // 87
    self._current = {                                                                                                 // 88
      path: context.path,                                                                                             // 89
      context: context,                                                                                               // 90
      params: context.params,                                                                                         // 91
      queryParams: queryParams,                                                                                       // 92
      route: route,                                                                                                   // 93
      oldRoute: oldRoute                                                                                              // 94
    };                                                                                                                // 95
                                                                                                                      // 96
    // we need to invalidate if all the triggers have been completed                                                  // 97
    // if not that means, we've been redirected to another path                                                       // 98
    // then we don't need to invalidate                                                                               // 99
    var afterAllTriggersRan = function() {                                                                            // 100
      self._invalidateTracker();                                                                                      // 101
    };                                                                                                                // 102
                                                                                                                      // 103
    var triggers = self._triggersEnter.concat(route._triggersEnter);                                                  // 104
    Triggers.runTriggers(                                                                                             // 105
      triggers,                                                                                                       // 106
      self._current,                                                                                                  // 107
      self._redirectFn,                                                                                               // 108
      afterAllTriggersRan                                                                                             // 109
    );                                                                                                                // 110
  };                                                                                                                  // 111
                                                                                                                      // 112
  // calls when you exit from the page js route                                                                       // 113
  route._exitHandle = function(context, next) {                                                                       // 114
    var triggers = self._triggersExit.concat(route._triggersExit);                                                    // 115
    Triggers.runTriggers(                                                                                             // 116
      triggers,                                                                                                       // 117
      self._current,                                                                                                  // 118
      self._redirectFn,                                                                                               // 119
      next                                                                                                            // 120
    );                                                                                                                // 121
  };                                                                                                                  // 122
                                                                                                                      // 123
  this._routes.push(route);                                                                                           // 124
  if (options.name) {                                                                                                 // 125
    this._routesMap[options.name] = route;                                                                            // 126
  }                                                                                                                   // 127
                                                                                                                      // 128
  this._updateCallbacks();                                                                                            // 129
  this._triggerRouteRegister(route);                                                                                  // 130
                                                                                                                      // 131
  return route;                                                                                                       // 132
};                                                                                                                    // 133
                                                                                                                      // 134
Router.prototype.group = function(options) {                                                                          // 135
  return new Group(this, options);                                                                                    // 136
};                                                                                                                    // 137
                                                                                                                      // 138
Router.prototype.path = function(pathDef, fields, queryParams) {                                                      // 139
  if (this._routesMap[pathDef]) {                                                                                     // 140
    pathDef = this._routesMap[pathDef].pathDef;                                                                       // 141
  }                                                                                                                   // 142
                                                                                                                      // 143
  var path = "";                                                                                                      // 144
                                                                                                                      // 145
  // Prefix the path with the router global prefix                                                                    // 146
  if (this._basePath) {                                                                                               // 147
    path += "/" + this._basePath + "/";                                                                               // 148
  }                                                                                                                   // 149
                                                                                                                      // 150
  fields = fields || {};                                                                                              // 151
  var regExp = /(:[\w\(\)\\\+\*\.\?]+)+/g;                                                                            // 152
  path += pathDef.replace(regExp, function(key) {                                                                     // 153
    var firstRegexpChar = key.indexOf("(");                                                                           // 154
    // get the content behind : and (\\d+/)                                                                           // 155
    key = key.substring(1, (firstRegexpChar > 0)? firstRegexpChar: undefined);                                        // 156
    // remove +?*                                                                                                     // 157
    key = key.replace(/[\+\*\?]+/g, "");                                                                              // 158
                                                                                                                      // 159
    // this is to allow page js to keep the custom characters as it is                                                // 160
    // we need to encode 2 times otherwise "/" char does not work properly                                            // 161
    // So, in that case, when I includes "/" it will think it's a part of the                                         // 162
    // route. encoding 2times fixes it                                                                                // 163
    return encodeURIComponent(encodeURIComponent(fields[key] || ""));                                                 // 164
  });                                                                                                                 // 165
                                                                                                                      // 166
  // Replace multiple slashes with single slash                                                                       // 167
  path = path.replace(/\/\/+/g, "/");                                                                                 // 168
                                                                                                                      // 169
  // remove trailing slash                                                                                            // 170
  // but keep the root slash if it's the only one                                                                     // 171
  path = path.match(/^\/{1}$/) ? path: path.replace(/\/$/, "");                                                       // 172
                                                                                                                      // 173
  // explictly asked to add a trailing slash                                                                          // 174
  if(this.env.trailingSlash.get() && _.last(path) !== "/") {                                                          // 175
    path += "/";                                                                                                      // 176
  }                                                                                                                   // 177
                                                                                                                      // 178
  var strQueryParams = this._qs.stringify(queryParams || {});                                                         // 179
  if(strQueryParams) {                                                                                                // 180
    path += "?" + strQueryParams;                                                                                     // 181
  }                                                                                                                   // 182
                                                                                                                      // 183
  return path;                                                                                                        // 184
};                                                                                                                    // 185
                                                                                                                      // 186
Router.prototype.go = function(pathDef, fields, queryParams) {                                                        // 187
  var path = this.path(pathDef, fields, queryParams);                                                                 // 188
                                                                                                                      // 189
  var useReplaceState = this.env.replaceState.get();                                                                  // 190
  if(useReplaceState) {                                                                                               // 191
    this._page.replace(path);                                                                                         // 192
  } else {                                                                                                            // 193
    this._page(path);                                                                                                 // 194
  }                                                                                                                   // 195
};                                                                                                                    // 196
                                                                                                                      // 197
Router.prototype.reload = function() {                                                                                // 198
  var self = this;                                                                                                    // 199
                                                                                                                      // 200
  self.env.reload.withValue(true, function() {                                                                        // 201
    self._page.replace(self._current.path);                                                                           // 202
  });                                                                                                                 // 203
};                                                                                                                    // 204
                                                                                                                      // 205
Router.prototype.redirect = function(path) {                                                                          // 206
  this._page.redirect(path);                                                                                          // 207
};                                                                                                                    // 208
                                                                                                                      // 209
Router.prototype.setParams = function(newParams) {                                                                    // 210
  if(!this._current.route) {return false;}                                                                            // 211
                                                                                                                      // 212
  var pathDef = this._current.route.pathDef;                                                                          // 213
  var existingParams = this._current.params;                                                                          // 214
  var params = {};                                                                                                    // 215
  _.each(_.keys(existingParams), function(key) {                                                                      // 216
    params[key] = existingParams[key];                                                                                // 217
  });                                                                                                                 // 218
                                                                                                                      // 219
  params = _.extend(params, newParams);                                                                               // 220
  var queryParams = this._current.queryParams;                                                                        // 221
                                                                                                                      // 222
  this.go(pathDef, params, queryParams);                                                                              // 223
  return true;                                                                                                        // 224
};                                                                                                                    // 225
                                                                                                                      // 226
Router.prototype.setQueryParams = function(newParams) {                                                               // 227
  if(!this._current.route) {return false;}                                                                            // 228
                                                                                                                      // 229
  var queryParams = _.clone(this._current.queryParams);                                                               // 230
  _.extend(queryParams, newParams);                                                                                   // 231
                                                                                                                      // 232
  for (var k in queryParams) {                                                                                        // 233
    if (queryParams[k] === null || queryParams[k] === undefined) {                                                    // 234
      delete queryParams[k];                                                                                          // 235
    }                                                                                                                 // 236
  }                                                                                                                   // 237
                                                                                                                      // 238
  var pathDef = this._current.route.pathDef;                                                                          // 239
  var params = this._current.params;                                                                                  // 240
  this.go(pathDef, params, queryParams);                                                                              // 241
  return true;                                                                                                        // 242
};                                                                                                                    // 243
                                                                                                                      // 244
// .current is not reactive                                                                                           // 245
// This is by design. use .getParam() instead                                                                         // 246
// If you really need to watch the path change, use .watchPathChange()                                                // 247
Router.prototype.current = function() {                                                                               // 248
  // We can't trust outside, that's why we clone this                                                                 // 249
  // Anyway, we can't clone the whole object since it has non-jsonable values                                         // 250
  // That's why we clone what's really needed.                                                                        // 251
  var current = _.clone(this._current);                                                                               // 252
  current.queryParams = EJSON.clone(current.queryParams);                                                             // 253
  current.params = EJSON.clone(current.params);                                                                       // 254
  return current;                                                                                                     // 255
};                                                                                                                    // 256
                                                                                                                      // 257
// Implementing Reactive APIs                                                                                         // 258
var reactiveApis = [                                                                                                  // 259
  'getParam', 'getQueryParam',                                                                                        // 260
  'getRouteName', 'watchPathChange'                                                                                   // 261
];                                                                                                                    // 262
reactiveApis.forEach(function(api) {                                                                                  // 263
  Router.prototype[api] = function(arg1) {                                                                            // 264
    // when this is calling, there may not be any route initiated                                                     // 265
    // so we need to handle it                                                                                        // 266
    var currentRoute = this._current.route;                                                                           // 267
    if(!currentRoute) {                                                                                               // 268
      this._onEveryPath.depend();                                                                                     // 269
      return;                                                                                                         // 270
    }                                                                                                                 // 271
                                                                                                                      // 272
    // currently, there is only one argument. If we've more let's add more args                                       // 273
    // this is not clean code, but better in performance                                                              // 274
    return currentRoute[api].call(currentRoute, arg1);                                                                // 275
  };                                                                                                                  // 276
});                                                                                                                   // 277
                                                                                                                      // 278
Router.prototype.subsReady = function() {                                                                             // 279
  var callback = null;                                                                                                // 280
  var args = _.toArray(arguments);                                                                                    // 281
                                                                                                                      // 282
  if (typeof _.last(args) === "function") {                                                                           // 283
    callback = args.pop();                                                                                            // 284
  }                                                                                                                   // 285
                                                                                                                      // 286
  var currentRoute = this.current().route;                                                                            // 287
  var globalRoute = this._globalRoute;                                                                                // 288
                                                                                                                      // 289
  // we need to depend for every route change and                                                                     // 290
  // rerun subscriptions to check the ready state                                                                     // 291
  this._onEveryPath.depend();                                                                                         // 292
                                                                                                                      // 293
  if(!currentRoute) {                                                                                                 // 294
    return false;                                                                                                     // 295
  }                                                                                                                   // 296
                                                                                                                      // 297
  var subscriptions;                                                                                                  // 298
  if(args.length === 0) {                                                                                             // 299
    subscriptions = _.values(globalRoute.getAllSubscriptions());                                                      // 300
    subscriptions = subscriptions.concat(_.values(currentRoute.getAllSubscriptions()));                               // 301
  } else {                                                                                                            // 302
    subscriptions = _.map(args, function(subName) {                                                                   // 303
      return globalRoute.getSubscription(subName) || currentRoute.getSubscription(subName);                           // 304
    });                                                                                                               // 305
  }                                                                                                                   // 306
                                                                                                                      // 307
  var isReady = function() {                                                                                          // 308
    var ready =  _.every(subscriptions, function(sub) {                                                               // 309
      return sub && sub.ready();                                                                                      // 310
    });                                                                                                               // 311
                                                                                                                      // 312
    return ready;                                                                                                     // 313
  };                                                                                                                  // 314
                                                                                                                      // 315
  if (callback) {                                                                                                     // 316
    Tracker.autorun(function(c) {                                                                                     // 317
      if (isReady()) {                                                                                                // 318
        callback();                                                                                                   // 319
        c.stop();                                                                                                     // 320
      }                                                                                                               // 321
    });                                                                                                               // 322
  } else {                                                                                                            // 323
    return isReady();                                                                                                 // 324
  }                                                                                                                   // 325
};                                                                                                                    // 326
                                                                                                                      // 327
Router.prototype.withReplaceState = function(fn) {                                                                    // 328
  return this.env.replaceState.withValue(true, fn);                                                                   // 329
};                                                                                                                    // 330
                                                                                                                      // 331
Router.prototype.withTrailingSlash = function(fn) {                                                                   // 332
  return this.env.trailingSlash.withValue(true, fn);                                                                  // 333
};                                                                                                                    // 334
                                                                                                                      // 335
Router.prototype._notfoundRoute = function(context) {                                                                 // 336
  this._current = {                                                                                                   // 337
    path: context.path,                                                                                               // 338
    context: context,                                                                                                 // 339
    params: [],                                                                                                       // 340
    queryParams: {},                                                                                                  // 341
  };                                                                                                                  // 342
                                                                                                                      // 343
  // XXX this.notfound kept for backwards compatibility                                                               // 344
  this.notFound = this.notFound || this.notfound;                                                                     // 345
  if(!this.notFound) {                                                                                                // 346
    console.error("There is no route for the path:", context.path);                                                   // 347
    return;                                                                                                           // 348
  }                                                                                                                   // 349
                                                                                                                      // 350
  this._current.route = new Route(this, "*", this.notFound);                                                          // 351
  this._invalidateTracker();                                                                                          // 352
};                                                                                                                    // 353
                                                                                                                      // 354
Router.prototype.initialize = function(options) {                                                                     // 355
  options = options || {};                                                                                            // 356
                                                                                                                      // 357
  if(this._initialized) {                                                                                             // 358
    throw new Error("FlowRouter is already initialized");                                                             // 359
  }                                                                                                                   // 360
                                                                                                                      // 361
  var self = this;                                                                                                    // 362
  this._updateCallbacks();                                                                                            // 363
                                                                                                                      // 364
  // Implementing idempotent routing                                                                                  // 365
  // by overriding page.js`s "show" method.                                                                           // 366
  // Why?                                                                                                             // 367
  // It is impossible to bypass exit triggers,                                                                        // 368
  // because they execute before the handler and                                                                      // 369
  // can not know what the next path is, inside exit trigger.                                                         // 370
  //                                                                                                                  // 371
  // we need override both show, replace to make this work                                                            // 372
  // since we use redirect when we are talking about withReplaceState                                                 // 373
  _.each(['show', 'replace'], function(fnName) {                                                                      // 374
    var original = self._page[fnName];                                                                                // 375
    self._page[fnName] = function(path, state, dispatch, push) {                                                      // 376
      var reload = self.env.reload.get();                                                                             // 377
      if (!reload && self._current.path === path) {                                                                   // 378
        return;                                                                                                       // 379
      }                                                                                                               // 380
                                                                                                                      // 381
      original.call(this, path, state, dispatch, push);                                                               // 382
    };                                                                                                                // 383
  });                                                                                                                 // 384
                                                                                                                      // 385
  // this is very ugly part of pagejs and it does decoding few times                                                  // 386
  // in unpredicatable manner. See #168                                                                               // 387
  // this is the default behaviour and we need keep it like that                                                      // 388
  // we are doing a hack. see .path()                                                                                 // 389
  this._page.base(this._basePath);                                                                                    // 390
  this._page({                                                                                                        // 391
    decodeURLComponents: true,                                                                                        // 392
    hashbang: !!options.hashbang                                                                                      // 393
  });                                                                                                                 // 394
                                                                                                                      // 395
  this._initialized = true;                                                                                           // 396
};                                                                                                                    // 397
                                                                                                                      // 398
Router.prototype._buildTracker = function() {                                                                         // 399
  var self = this;                                                                                                    // 400
                                                                                                                      // 401
  // main autorun function                                                                                            // 402
  var tracker = Tracker.autorun(function () {                                                                         // 403
    if(!self._current || !self._current.route) {                                                                      // 404
      return;                                                                                                         // 405
    }                                                                                                                 // 406
                                                                                                                      // 407
    // see the definition of `this._processingContexts`                                                               // 408
    var currentContext = self._current;                                                                               // 409
    var route = currentContext.route;                                                                                 // 410
    var path = currentContext.path;                                                                                   // 411
                                                                                                                      // 412
    if(self.safeToRun === 0) {                                                                                        // 413
      var message =                                                                                                   // 414
        "You can't use reactive data sources like Session" +                                                          // 415
        " inside the `.subscriptions` method!";                                                                       // 416
      throw new Error(message);                                                                                       // 417
    }                                                                                                                 // 418
                                                                                                                      // 419
    // We need to run subscriptions inside a Tracker                                                                  // 420
    // to stop subs when switching between routes                                                                     // 421
    // But we don't need to run this tracker with                                                                     // 422
    // other reactive changes inside the .subscription method                                                         // 423
    // We tackle this with the `safeToRun` variable                                                                   // 424
    self._globalRoute.clearSubscriptions();                                                                           // 425
    self.subscriptions.call(self._globalRoute, path);                                                                 // 426
    route.callSubscriptions(currentContext);                                                                          // 427
                                                                                                                      // 428
    // otherwise, computations inside action will trigger to re-run                                                   // 429
    // this computation. which we do not need.                                                                        // 430
    Tracker.nonreactive(function() {                                                                                  // 431
      var isRouteChange = currentContext.oldRoute !== currentContext.route;                                           // 432
      var isFirstRoute = !currentContext.oldRoute;                                                                    // 433
      // first route is not a route change                                                                            // 434
      if(isFirstRoute) {                                                                                              // 435
        isRouteChange = false;                                                                                        // 436
      }                                                                                                               // 437
                                                                                                                      // 438
      // Clear oldRouteChain just before calling the action                                                           // 439
      // We still need to get a copy of the oldestRoute first                                                         // 440
      // It's very important to get the oldest route and registerRouteClose() it                                      // 441
      // See: https://github.com/kadirahq/flow-router/issues/314                                                      // 442
      var oldestRoute = self._oldRouteChain[0];                                                                       // 443
      self._oldRouteChain = [];                                                                                       // 444
                                                                                                                      // 445
      currentContext.route.registerRouteChange(currentContext, isRouteChange);                                        // 446
      route.callAction(currentContext);                                                                               // 447
                                                                                                                      // 448
      Tracker.afterFlush(function() {                                                                                 // 449
        self._onEveryPath.changed();                                                                                  // 450
        if(isRouteChange) {                                                                                           // 451
          // We need to trigger that route (definition itself) has changed.                                           // 452
          // So, we need to re-run all the register callbacks to current route                                        // 453
          // This is pretty important, otherwise tracker                                                              // 454
          // can't identify new route's items                                                                         // 455
                                                                                                                      // 456
          // We also need to afterFlush, otherwise this will re-run                                                   // 457
          // helpers on templates which are marked for destroying                                                     // 458
          if(oldestRoute) {                                                                                           // 459
            oldestRoute.registerRouteClose();                                                                         // 460
          }                                                                                                           // 461
        }                                                                                                             // 462
      });                                                                                                             // 463
    });                                                                                                               // 464
                                                                                                                      // 465
    self.safeToRun--;                                                                                                 // 466
  });                                                                                                                 // 467
                                                                                                                      // 468
  return tracker;                                                                                                     // 469
};                                                                                                                    // 470
                                                                                                                      // 471
Router.prototype._invalidateTracker = function() {                                                                    // 472
  var self = this;                                                                                                    // 473
  this.safeToRun++;                                                                                                   // 474
  this._tracker.invalidate();                                                                                         // 475
  // After the invalidation we need to flush to make changes imediately                                               // 476
  // otherwise, we have face some issues context mix-maches and so on.                                                // 477
  // But there are some cases we can't flush. So we need to ready for that.                                           // 478
                                                                                                                      // 479
  // we clearly know, we can't flush inside an autorun                                                                // 480
  // this may leads some issues on flow-routing                                                                       // 481
  // we may need to do some warning                                                                                   // 482
  if(!Tracker.currentComputation) {                                                                                   // 483
    // Still there are some cases where we can't flush                                                                // 484
    //  eg:- when there is a flush currently                                                                          // 485
    // But we've no public API or hacks to get that state                                                             // 486
    // So, this is the only solution                                                                                  // 487
    try {                                                                                                             // 488
      Tracker.flush();                                                                                                // 489
    } catch(ex) {                                                                                                     // 490
      // only handling "while flushing" errors                                                                        // 491
      if(!/Tracker\.flush while flushing/.test(ex.message)) {                                                         // 492
        return;                                                                                                       // 493
      }                                                                                                               // 494
                                                                                                                      // 495
      // XXX: fix this with a proper solution by removing subscription mgt.                                           // 496
      // from the router. Then we don't need to run invalidate using a tracker                                        // 497
                                                                                                                      // 498
      // this happens when we are trying to invoke a route change                                                     // 499
      // with inside a route chnage. (eg:- Template.onCreated)                                                        // 500
      // Since we use page.js and tracker, we don't have much control                                                 // 501
      // over this process.                                                                                           // 502
      // only solution is to defer route execution.                                                                   // 503
                                                                                                                      // 504
      // It's possible to have more than one path want to defer                                                       // 505
      // But, we only need to pick the last one.                                                                      // 506
      // self._nextPath = self._current.path;                                                                         // 507
      Meteor.defer(function() {                                                                                       // 508
        var path = self._nextPath;                                                                                    // 509
        if(!path) {                                                                                                   // 510
          return;                                                                                                     // 511
        }                                                                                                             // 512
                                                                                                                      // 513
        delete self._nextPath;                                                                                        // 514
        self.env.reload.withValue(true, function() {                                                                  // 515
          self.go(path);                                                                                              // 516
        });                                                                                                           // 517
      });                                                                                                             // 518
    }                                                                                                                 // 519
  }                                                                                                                   // 520
};                                                                                                                    // 521
                                                                                                                      // 522
Router.prototype._updateCallbacks = function () {                                                                     // 523
  var self = this;                                                                                                    // 524
                                                                                                                      // 525
  self._page.callbacks = [];                                                                                          // 526
  self._page.exits = [];                                                                                              // 527
                                                                                                                      // 528
  _.each(self._routes, function(route) {                                                                              // 529
    self._page(route.pathDef, route._actionHandle);                                                                   // 530
    self._page.exit(route.pathDef, route._exitHandle);                                                                // 531
  });                                                                                                                 // 532
                                                                                                                      // 533
  self._page("*", function(context) {                                                                                 // 534
    self._notfoundRoute(context);                                                                                     // 535
  });                                                                                                                 // 536
};                                                                                                                    // 537
                                                                                                                      // 538
Router.prototype._initTriggersAPI = function() {                                                                      // 539
  var self = this;                                                                                                    // 540
  this.triggers = {                                                                                                   // 541
    enter: function(triggers, filter) {                                                                               // 542
      triggers = Triggers.applyFilters(triggers, filter);                                                             // 543
      if(triggers.length) {                                                                                           // 544
        self._triggersEnter = self._triggersEnter.concat(triggers);                                                   // 545
      }                                                                                                               // 546
    },                                                                                                                // 547
                                                                                                                      // 548
    exit: function(triggers, filter) {                                                                                // 549
      triggers = Triggers.applyFilters(triggers, filter);                                                             // 550
      if(triggers.length) {                                                                                           // 551
        self._triggersExit = self._triggersExit.concat(triggers);                                                     // 552
      }                                                                                                               // 553
    }                                                                                                                 // 554
  };                                                                                                                  // 555
};                                                                                                                    // 556
                                                                                                                      // 557
Router.prototype.wait = function() {                                                                                  // 558
  if(this._initialized) {                                                                                             // 559
    throw new Error("can't wait after FlowRouter has been initialized");                                              // 560
  }                                                                                                                   // 561
                                                                                                                      // 562
  this._askedToWait = true;                                                                                           // 563
};                                                                                                                    // 564
                                                                                                                      // 565
Router.prototype.onRouteRegister = function(cb) {                                                                     // 566
  this._onRouteCallbacks.push(cb);                                                                                    // 567
};                                                                                                                    // 568
                                                                                                                      // 569
Router.prototype._triggerRouteRegister = function(currentRoute) {                                                     // 570
  // We should only need to send a safe set of fields on the route                                                    // 571
  // object.                                                                                                          // 572
  // This is not to hide what's inside the route object, but to show                                                  // 573
  // these are the public APIs                                                                                        // 574
  var routePublicApi = _.pick(currentRoute, 'name', 'pathDef', 'path');                                               // 575
  var omittingOptionFields = [                                                                                        // 576
    'triggersEnter', 'triggersExit', 'action', 'subscriptions', 'name'                                                // 577
  ];                                                                                                                  // 578
  routePublicApi.options = _.omit(currentRoute.options, omittingOptionFields);                                        // 579
                                                                                                                      // 580
  _.each(this._onRouteCallbacks, function(cb) {                                                                       // 581
    cb(routePublicApi);                                                                                               // 582
  });                                                                                                                 // 583
};                                                                                                                    // 584
                                                                                                                      // 585
Router.prototype._page = page;                                                                                        // 586
Router.prototype._qs = qs;                                                                                            // 587
                                                                                                                      // 588
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/kadira_flow-router/client/group.js                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
Group = function(router, options, parent) {                                                                           // 1
  options = options || {};                                                                                            // 2
                                                                                                                      // 3
  if (options.prefix && !/^\/.*/.test(options.prefix)) {                                                              // 4
    var message = "group's prefix must start with '/'";                                                               // 5
    throw new Error(message);                                                                                         // 6
  }                                                                                                                   // 7
                                                                                                                      // 8
  this._router = router;                                                                                              // 9
  this.prefix = options.prefix || '';                                                                                 // 10
  this.name = options.name;                                                                                           // 11
  this.options = options;                                                                                             // 12
                                                                                                                      // 13
  this._triggersEnter = options.triggersEnter || [];                                                                  // 14
  this._triggersExit = options.triggersExit || [];                                                                    // 15
  this._subscriptions = options.subscriptions || Function.prototype;                                                  // 16
                                                                                                                      // 17
  this.parent = parent;                                                                                               // 18
  if (this.parent) {                                                                                                  // 19
    this.prefix = parent.prefix + this.prefix;                                                                        // 20
                                                                                                                      // 21
    this._triggersEnter = parent._triggersEnter.concat(this._triggersEnter);                                          // 22
    this._triggersExit = this._triggersExit.concat(parent._triggersExit);                                             // 23
  }                                                                                                                   // 24
};                                                                                                                    // 25
                                                                                                                      // 26
Group.prototype.route = function(pathDef, options, group) {                                                           // 27
  options = options || {};                                                                                            // 28
                                                                                                                      // 29
  if (!/^\/.*/.test(pathDef)) {                                                                                       // 30
    var message = "route's path must start with '/'";                                                                 // 31
    throw new Error(message);                                                                                         // 32
  }                                                                                                                   // 33
                                                                                                                      // 34
  group = group || this;                                                                                              // 35
  pathDef = this.prefix + pathDef;                                                                                    // 36
                                                                                                                      // 37
  var triggersEnter = options.triggersEnter || [];                                                                    // 38
  options.triggersEnter = this._triggersEnter.concat(triggersEnter);                                                  // 39
                                                                                                                      // 40
  var triggersExit = options.triggersExit || [];                                                                      // 41
  options.triggersExit = triggersExit.concat(this._triggersExit);                                                     // 42
                                                                                                                      // 43
  return this._router.route(pathDef, options, group);                                                                 // 44
};                                                                                                                    // 45
                                                                                                                      // 46
Group.prototype.group = function(options) {                                                                           // 47
  return new Group(this._router, options, this);                                                                      // 48
};                                                                                                                    // 49
                                                                                                                      // 50
Group.prototype.callSubscriptions = function(current) {                                                               // 51
  if (this.parent) {                                                                                                  // 52
    this.parent.callSubscriptions(current);                                                                           // 53
  }                                                                                                                   // 54
                                                                                                                      // 55
  this._subscriptions.call(current.route, current.params, current.queryParams);                                       // 56
};                                                                                                                    // 57
                                                                                                                      // 58
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/kadira_flow-router/client/route.js                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
Route = function(router, pathDef, options, group) {                                                                   // 1
  options = options || {};                                                                                            // 2
                                                                                                                      // 3
  this.options = options;                                                                                             // 4
  this.pathDef = pathDef                                                                                              // 5
                                                                                                                      // 6
  // Route.path is deprecated and will be removed in 3.0                                                              // 7
  this.path = pathDef;                                                                                                // 8
                                                                                                                      // 9
  if (options.name) {                                                                                                 // 10
    this.name = options.name;                                                                                         // 11
  }                                                                                                                   // 12
                                                                                                                      // 13
  this._action = options.action || Function.prototype;                                                                // 14
  this._subscriptions = options.subscriptions || Function.prototype;                                                  // 15
  this._triggersEnter = options.triggersEnter || [];                                                                  // 16
  this._triggersExit = options.triggersExit || [];                                                                    // 17
  this._subsMap = {};                                                                                                 // 18
  this._router = router;                                                                                              // 19
                                                                                                                      // 20
  this._params = new ReactiveDict();                                                                                  // 21
  this._queryParams = new ReactiveDict();                                                                             // 22
  this._routeCloseDep = new Tracker.Dependency();                                                                     // 23
                                                                                                                      // 24
  // tracks the changes in the URL                                                                                    // 25
  this._pathChangeDep = new Tracker.Dependency();                                                                     // 26
                                                                                                                      // 27
  this.group = group;                                                                                                 // 28
};                                                                                                                    // 29
                                                                                                                      // 30
Route.prototype.clearSubscriptions = function() {                                                                     // 31
  this._subsMap = {};                                                                                                 // 32
};                                                                                                                    // 33
                                                                                                                      // 34
Route.prototype.register = function(name, sub, options) {                                                             // 35
  this._subsMap[name] = sub;                                                                                          // 36
};                                                                                                                    // 37
                                                                                                                      // 38
                                                                                                                      // 39
Route.prototype.getSubscription = function(name) {                                                                    // 40
  return this._subsMap[name];                                                                                         // 41
};                                                                                                                    // 42
                                                                                                                      // 43
                                                                                                                      // 44
Route.prototype.getAllSubscriptions = function() {                                                                    // 45
  return this._subsMap;                                                                                               // 46
};                                                                                                                    // 47
                                                                                                                      // 48
Route.prototype.callAction = function(current) {                                                                      // 49
  var self = this;                                                                                                    // 50
  self._action(current.params, current.queryParams);                                                                  // 51
};                                                                                                                    // 52
                                                                                                                      // 53
Route.prototype.callSubscriptions = function(current) {                                                               // 54
  this.clearSubscriptions();                                                                                          // 55
  if (this.group) {                                                                                                   // 56
    this.group.callSubscriptions(current);                                                                            // 57
  }                                                                                                                   // 58
                                                                                                                      // 59
  this._subscriptions(current.params, current.queryParams);                                                           // 60
};                                                                                                                    // 61
                                                                                                                      // 62
Route.prototype.getRouteName = function() {                                                                           // 63
  this._routeCloseDep.depend();                                                                                       // 64
  return this.name;                                                                                                   // 65
};                                                                                                                    // 66
                                                                                                                      // 67
Route.prototype.getParam = function(key) {                                                                            // 68
  this._routeCloseDep.depend();                                                                                       // 69
  return this._params.get(key);                                                                                       // 70
};                                                                                                                    // 71
                                                                                                                      // 72
Route.prototype.getQueryParam = function(key) {                                                                       // 73
  this._routeCloseDep.depend();                                                                                       // 74
  return this._queryParams.get(key);                                                                                  // 75
};                                                                                                                    // 76
                                                                                                                      // 77
Route.prototype.watchPathChange = function() {                                                                        // 78
  this._pathChangeDep.depend();                                                                                       // 79
};                                                                                                                    // 80
                                                                                                                      // 81
Route.prototype.registerRouteClose = function() {                                                                     // 82
  this._params = new ReactiveDict();                                                                                  // 83
  this._queryParams = new ReactiveDict();                                                                             // 84
  this._routeCloseDep.changed();                                                                                      // 85
  this._pathChangeDep.changed();                                                                                      // 86
};                                                                                                                    // 87
                                                                                                                      // 88
Route.prototype.registerRouteChange = function(currentContext, routeChanging) {                                       // 89
  // register params                                                                                                  // 90
  var params = currentContext.params;                                                                                 // 91
  this._updateReactiveDict(this._params, params);                                                                     // 92
                                                                                                                      // 93
  // register query params                                                                                            // 94
  var queryParams = currentContext.queryParams;                                                                       // 95
  this._updateReactiveDict(this._queryParams, queryParams);                                                           // 96
                                                                                                                      // 97
  // if the route is changing, we need to defer triggering path changing                                              // 98
  // if we did this, old route's path watchers will detect this                                                       // 99
  // Real issue is, above watcher will get removed with the new route                                                 // 100
  // So, we don't need to trigger it now                                                                              // 101
  // We are doing it on the route close event. So, if they exists they'll                                             // 102
  // get notify that                                                                                                  // 103
  if(!routeChanging) {                                                                                                // 104
    this._pathChangeDep.changed();                                                                                    // 105
  }                                                                                                                   // 106
};                                                                                                                    // 107
                                                                                                                      // 108
Route.prototype._updateReactiveDict = function(dict, newValues) {                                                     // 109
  var currentKeys = _.keys(newValues);                                                                                // 110
  var oldKeys = _.keys(dict.keyDeps);                                                                                 // 111
                                                                                                                      // 112
  // set new values                                                                                                   // 113
  //  params is an array. So, _.each(params) does not works                                                           // 114
  //  to iterate params                                                                                               // 115
  _.each(currentKeys, function(key) {                                                                                 // 116
    dict.set(key, newValues[key]);                                                                                    // 117
  });                                                                                                                 // 118
                                                                                                                      // 119
  // remove keys which does not exisits here                                                                          // 120
  var removedKeys = _.difference(oldKeys, currentKeys);                                                               // 121
  _.each(removedKeys, function(key) {                                                                                 // 122
    dict.set(key, undefined);                                                                                         // 123
  });                                                                                                                 // 124
};                                                                                                                    // 125
                                                                                                                      // 126
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/kadira_flow-router/client/_init.js                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
// Export Router Instance                                                                                             // 1
FlowRouter = new Router();                                                                                            // 2
FlowRouter.Router = Router;                                                                                           // 3
FlowRouter.Route = Route;                                                                                             // 4
                                                                                                                      // 5
// Initialize FlowRouter                                                                                              // 6
Meteor.startup(function () {                                                                                          // 7
  if(!FlowRouter._askedToWait) {                                                                                      // 8
    FlowRouter.initialize();                                                                                          // 9
  }                                                                                                                   // 10
});                                                                                                                   // 11
                                                                                                                      // 12
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/kadira_flow-router/lib/router.js                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
Router.prototype.url = function() {                                                                                   // 1
  var path = this.path.apply(this, arguments);                                                                        // 2
  return Meteor.absoluteUrl(path.replace(/^\//, ''));                                                                 // 3
};                                                                                                                    // 4
                                                                                                                      // 5
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['kadira:flow-router'] = {
  FlowRouter: FlowRouter
};

})();
