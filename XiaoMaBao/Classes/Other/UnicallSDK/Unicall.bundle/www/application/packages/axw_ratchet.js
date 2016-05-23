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
var $ = Package.jquery.$;
var jQuery = Package.jquery.jQuery;

(function(){

///////////////////////////////////////////////////////////////////////
//                                                                   //
// packages/axw_ratchet/packages/axw_ratchet.js                      //
//                                                                   //
///////////////////////////////////////////////////////////////////////
                                                                     //
(function () {                                                       // 1
                                                                     // 2
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/axw:ratchet/ratchet-2/js/ratchet.js                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
/*!                                                                                                                   // 1
 * =====================================================                                                              // 2
 * Ratchet v2.0.2 (http://goratchet.com)                                                                              // 3
 * Copyright 2014 Connor Sears                                                                                        // 4
 * Licensed under MIT (https://github.com/twbs/ratchet/blob/master/LICENSE)                                           // 5
 *                                                                                                                    // 6
 * v2.0.2 designed by @connors.                                                                                       // 7
 * =====================================================                                                              // 8
 */                                                                                                                   // 9
/* ========================================================================                                           // 10
 * Ratchet: modals.js v2.0.2                                                                                          // 11
 * http://goratchet.com/components#modals                                                                             // 12
 * ========================================================================                                           // 13
 * Copyright 2014 Connor Sears                                                                                        // 14
 * Licensed under MIT (https://github.com/twbs/ratchet/blob/master/LICENSE)                                           // 15
 * ======================================================================== */                                        // 16
                                                                                                                      // 17
!(function () {                                                                                                       // 18
  'use strict';                                                                                                       // 19
                                                                                                                      // 20
  var findModals = function (target) {                                                                                // 21
    var i;                                                                                                            // 22
    var modals = document.querySelectorAll('a');                                                                      // 23
                                                                                                                      // 24
    for (; target && target !== document; target = target.parentNode) {                                               // 25
      for (i = modals.length; i--;) {                                                                                 // 26
        if (modals[i] === target) {                                                                                   // 27
          return target;                                                                                              // 28
        }                                                                                                             // 29
      }                                                                                                               // 30
    }                                                                                                                 // 31
  };                                                                                                                  // 32
                                                                                                                      // 33
  var getModal = function (event) {                                                                                   // 34
    var modalToggle = findModals(event.target);                                                                       // 35
    if (modalToggle && modalToggle.hash) {                                                                            // 36
      return document.querySelector(modalToggle.hash);                                                                // 37
    }                                                                                                                 // 38
  };                                                                                                                  // 39
                                                                                                                      // 40
  window.addEventListener('touchend', function (event) {                                                              // 41
    var modal = getModal(event);                                                                                      // 42
    if (modal) {                                                                                                      // 43
      if (modal && modal.classList.contains('modal')) {                                                               // 44
        modal.classList.toggle('active');                                                                             // 45
      }                                                                                                               // 46
      event.preventDefault(); // prevents rewriting url (apps can still use hash values in url)                       // 47
    }                                                                                                                 // 48
  });                                                                                                                 // 49
}());                                                                                                                 // 50
                                                                                                                      // 51
/* ========================================================================                                           // 52
 * Ratchet: popovers.js v2.0.2                                                                                        // 53
 * http://goratchet.com/components#popovers                                                                           // 54
 * ========================================================================                                           // 55
 * Copyright 2014 Connor Sears                                                                                        // 56
 * Licensed under MIT (https://github.com/twbs/ratchet/blob/master/LICENSE)                                           // 57
 * ======================================================================== */                                        // 58
                                                                                                                      // 59
!(function () {                                                                                                       // 60
  'use strict';                                                                                                       // 61
                                                                                                                      // 62
  var popover;                                                                                                        // 63
                                                                                                                      // 64
  var findPopovers = function (target) {                                                                              // 65
    var i;                                                                                                            // 66
    var popovers = document.querySelectorAll('a');                                                                    // 67
                                                                                                                      // 68
    for (; target && target !== document; target = target.parentNode) {                                               // 69
      for (i = popovers.length; i--;) {                                                                               // 70
        if (popovers[i] === target) {                                                                                 // 71
          return target;                                                                                              // 72
        }                                                                                                             // 73
      }                                                                                                               // 74
    }                                                                                                                 // 75
  };                                                                                                                  // 76
                                                                                                                      // 77
  var onPopoverHidden = function () {                                                                                 // 78
    popover.style.display = 'none';                                                                                   // 79
    popover.removeEventListener('webkitTransitionEnd', onPopoverHidden);                                              // 80
  };                                                                                                                  // 81
                                                                                                                      // 82
  var backdrop = (function () {                                                                                       // 83
    var element = document.createElement('div');                                                                      // 84
                                                                                                                      // 85
    element.classList.add('backdrop');                                                                                // 86
                                                                                                                      // 87
    element.addEventListener('touchend', function () {                                                                // 88
      popover.addEventListener('webkitTransitionEnd', onPopoverHidden);                                               // 89
      popover.classList.remove('visible');                                                                            // 90
      popover.parentNode.removeChild(backdrop);                                                                       // 91
    });                                                                                                               // 92
                                                                                                                      // 93
    return element;                                                                                                   // 94
  }());                                                                                                               // 95
                                                                                                                      // 96
  var getPopover = function (e) {                                                                                     // 97
    var anchor = findPopovers(e.target);                                                                              // 98
                                                                                                                      // 99
    if (!anchor || !anchor.hash || (anchor.hash.indexOf('/') > 0)) {                                                  // 100
      return;                                                                                                         // 101
    }                                                                                                                 // 102
                                                                                                                      // 103
    try {                                                                                                             // 104
      popover = document.querySelector(anchor.hash);                                                                  // 105
    }                                                                                                                 // 106
    catch (error) {                                                                                                   // 107
      popover = null;                                                                                                 // 108
    }                                                                                                                 // 109
                                                                                                                      // 110
    if (popover === null) {                                                                                           // 111
      return;                                                                                                         // 112
    }                                                                                                                 // 113
                                                                                                                      // 114
    if (!popover || !popover.classList.contains('popover')) {                                                         // 115
      return;                                                                                                         // 116
    }                                                                                                                 // 117
                                                                                                                      // 118
    return popover;                                                                                                   // 119
  };                                                                                                                  // 120
                                                                                                                      // 121
  var showHidePopover = function (e) {                                                                                // 122
    var popover = getPopover(e);                                                                                      // 123
                                                                                                                      // 124
    if (!popover) {                                                                                                   // 125
      return;                                                                                                         // 126
    }                                                                                                                 // 127
                                                                                                                      // 128
    popover.style.display = 'block';                                                                                  // 129
    popover.offsetHeight;                                                                                             // 130
    popover.classList.add('visible');                                                                                 // 131
                                                                                                                      // 132
    popover.parentNode.appendChild(backdrop);                                                                         // 133
  };                                                                                                                  // 134
                                                                                                                      // 135
  window.addEventListener('touchend', showHidePopover);                                                               // 136
                                                                                                                      // 137
}());                                                                                                                 // 138
                                                                                                                      // 139
/* ========================================================================                                           // 140
 * Ratchet: push.js v2.0.2                                                                                            // 141
 * http://goratchet.com/components#push                                                                               // 142
 * ========================================================================                                           // 143
 * inspired by @defunkt's jquery.pjax.js                                                                              // 144
 * Copyright 2014 Connor Sears                                                                                        // 145
 * Licensed under MIT (https://github.com/twbs/ratchet/blob/master/LICENSE)                                           // 146
 * ======================================================================== */                                        // 147
                                                                                                                      // 148
/* global _gaq: true */                                                                                               // 149
                                                                                                                      // 150
!(function () {                                                                                                       // 151
  'use strict';                                                                                                       // 152
                                                                                                                      // 153
  var noop = function () {};                                                                                          // 154
                                                                                                                      // 155
                                                                                                                      // 156
  // Pushstate caching                                                                                                // 157
  // ==================                                                                                               // 158
                                                                                                                      // 159
  var isScrolling;                                                                                                    // 160
  var maxCacheLength = 20;                                                                                            // 161
  var cacheMapping   = sessionStorage;                                                                                // 162
  var domCache       = {};                                                                                            // 163
  var transitionMap  = {                                                                                              // 164
    slideIn  : 'slide-out',                                                                                           // 165
    slideOut : 'slide-in',                                                                                            // 166
    fade     : 'fade'                                                                                                 // 167
  };                                                                                                                  // 168
                                                                                                                      // 169
  var bars = {                                                                                                        // 170
    bartab             : '.bar-tab',                                                                                  // 171
    barnav             : '.bar-nav',                                                                                  // 172
    barfooter          : '.bar-footer',                                                                               // 173
    barheadersecondary : '.bar-header-secondary'                                                                      // 174
  };                                                                                                                  // 175
                                                                                                                      // 176
  var cacheReplace = function (data, updates) {                                                                       // 177
    PUSH.id = data.id;                                                                                                // 178
    if (updates) {                                                                                                    // 179
      data = getCached(data.id);                                                                                      // 180
    }                                                                                                                 // 181
    cacheMapping[data.id] = JSON.stringify(data);                                                                     // 182
    window.history.replaceState(data.id, data.title, data.url);                                                       // 183
    domCache[data.id] = document.body.cloneNode(true);                                                                // 184
  };                                                                                                                  // 185
                                                                                                                      // 186
  var cachePush = function () {                                                                                       // 187
    var id = PUSH.id;                                                                                                 // 188
                                                                                                                      // 189
    var cacheForwardStack = JSON.parse(cacheMapping.cacheForwardStack || '[]');                                       // 190
    var cacheBackStack    = JSON.parse(cacheMapping.cacheBackStack    || '[]');                                       // 191
                                                                                                                      // 192
    cacheBackStack.push(id);                                                                                          // 193
                                                                                                                      // 194
    while (cacheForwardStack.length) {                                                                                // 195
      delete cacheMapping[cacheForwardStack.shift()];                                                                 // 196
    }                                                                                                                 // 197
    while (cacheBackStack.length > maxCacheLength) {                                                                  // 198
      delete cacheMapping[cacheBackStack.shift()];                                                                    // 199
    }                                                                                                                 // 200
                                                                                                                      // 201
    window.history.pushState(null, '', cacheMapping[PUSH.id].url);                                                    // 202
                                                                                                                      // 203
    cacheMapping.cacheForwardStack = JSON.stringify(cacheForwardStack);                                               // 204
    cacheMapping.cacheBackStack    = JSON.stringify(cacheBackStack);                                                  // 205
  };                                                                                                                  // 206
                                                                                                                      // 207
  var cachePop = function (id, direction) {                                                                           // 208
    var forward           = direction === 'forward';                                                                  // 209
    var cacheForwardStack = JSON.parse(cacheMapping.cacheForwardStack || '[]');                                       // 210
    var cacheBackStack    = JSON.parse(cacheMapping.cacheBackStack    || '[]');                                       // 211
    var pushStack         = forward ? cacheBackStack    : cacheForwardStack;                                          // 212
    var popStack          = forward ? cacheForwardStack : cacheBackStack;                                             // 213
                                                                                                                      // 214
    if (PUSH.id) {                                                                                                    // 215
      pushStack.push(PUSH.id);                                                                                        // 216
    }                                                                                                                 // 217
    popStack.pop();                                                                                                   // 218
                                                                                                                      // 219
    cacheMapping.cacheForwardStack = JSON.stringify(cacheForwardStack);                                               // 220
    cacheMapping.cacheBackStack    = JSON.stringify(cacheBackStack);                                                  // 221
  };                                                                                                                  // 222
                                                                                                                      // 223
  var getCached = function (id) {                                                                                     // 224
    return JSON.parse(cacheMapping[id] || null) || {};                                                                // 225
  };                                                                                                                  // 226
                                                                                                                      // 227
  var getTarget = function (e) {                                                                                      // 228
    var target = findTarget(e.target);                                                                                // 229
                                                                                                                      // 230
    if (!target ||                                                                                                    // 231
        e.which > 1 ||                                                                                                // 232
        e.metaKey ||                                                                                                  // 233
        e.ctrlKey ||                                                                                                  // 234
        isScrolling ||                                                                                                // 235
        location.protocol !== target.protocol ||                                                                      // 236
        location.host     !== target.host ||                                                                          // 237
        !target.hash && /#/.test(target.href) ||                                                                      // 238
        target.hash && target.href.replace(target.hash, '') === location.href.replace(location.hash, '') ||           // 239
        target.getAttribute('data-ignore') === 'push') { return; }                                                    // 240
                                                                                                                      // 241
    return target;                                                                                                    // 242
  };                                                                                                                  // 243
                                                                                                                      // 244
                                                                                                                      // 245
  // Main event handlers (touchend, popstate)                                                                         // 246
  // ==========================================                                                                       // 247
                                                                                                                      // 248
  var touchend = function (e) {                                                                                       // 249
    var target = getTarget(e);                                                                                        // 250
                                                                                                                      // 251
    if (!target) {                                                                                                    // 252
      return;                                                                                                         // 253
    }                                                                                                                 // 254
                                                                                                                      // 255
    e.preventDefault();                                                                                               // 256
                                                                                                                      // 257
    PUSH({                                                                                                            // 258
      url        : target.href,                                                                                       // 259
      hash       : target.hash,                                                                                       // 260
      timeout    : target.getAttribute('data-timeout'),                                                               // 261
      transition : target.getAttribute('data-transition')                                                             // 262
    });                                                                                                               // 263
  };                                                                                                                  // 264
                                                                                                                      // 265
  var popstate = function (e) {                                                                                       // 266
    var key;                                                                                                          // 267
    var barElement;                                                                                                   // 268
    var activeObj;                                                                                                    // 269
    var activeDom;                                                                                                    // 270
    var direction;                                                                                                    // 271
    var transition;                                                                                                   // 272
    var transitionFrom;                                                                                               // 273
    var transitionFromObj;                                                                                            // 274
    var id = e.state;                                                                                                 // 275
                                                                                                                      // 276
    if (!id || !cacheMapping[id]) {                                                                                   // 277
      return;                                                                                                         // 278
    }                                                                                                                 // 279
                                                                                                                      // 280
    direction = PUSH.id < id ? 'forward' : 'back';                                                                    // 281
                                                                                                                      // 282
    cachePop(id, direction);                                                                                          // 283
                                                                                                                      // 284
    activeObj = getCached(id);                                                                                        // 285
    activeDom = domCache[id];                                                                                         // 286
                                                                                                                      // 287
    if (activeObj.title) {                                                                                            // 288
      document.title = activeObj.title;                                                                               // 289
    }                                                                                                                 // 290
                                                                                                                      // 291
    if (direction === 'back') {                                                                                       // 292
      transitionFrom    = JSON.parse(direction === 'back' ? cacheMapping.cacheForwardStack : cacheMapping.cacheBackStack);
      transitionFromObj = getCached(transitionFrom[transitionFrom.length - 1]);                                       // 294
    } else {                                                                                                          // 295
      transitionFromObj = activeObj;                                                                                  // 296
    }                                                                                                                 // 297
                                                                                                                      // 298
    if (direction === 'back' && !transitionFromObj.id) {                                                              // 299
      return (PUSH.id = id);                                                                                          // 300
    }                                                                                                                 // 301
                                                                                                                      // 302
    transition = direction === 'back' ? transitionMap[transitionFromObj.transition] : transitionFromObj.transition;   // 303
                                                                                                                      // 304
    if (!activeDom) {                                                                                                 // 305
      return PUSH({                                                                                                   // 306
        id         : activeObj.id,                                                                                    // 307
        url        : activeObj.url,                                                                                   // 308
        title      : activeObj.title,                                                                                 // 309
        timeout    : activeObj.timeout,                                                                               // 310
        transition : transition,                                                                                      // 311
        ignorePush : true                                                                                             // 312
      });                                                                                                             // 313
    }                                                                                                                 // 314
                                                                                                                      // 315
    if (transitionFromObj.transition) {                                                                               // 316
      activeObj = extendWithDom(activeObj, '.content', activeDom.cloneNode(true));                                    // 317
      for (key in bars) {                                                                                             // 318
        if (bars.hasOwnProperty(key)) {                                                                               // 319
          barElement = document.querySelector(bars[key]);                                                             // 320
          if (activeObj[key]) {                                                                                       // 321
            swapContent(activeObj[key], barElement);                                                                  // 322
          } else if (barElement) {                                                                                    // 323
            barElement.parentNode.removeChild(barElement);                                                            // 324
          }                                                                                                           // 325
        }                                                                                                             // 326
      }                                                                                                               // 327
    }                                                                                                                 // 328
                                                                                                                      // 329
    swapContent(                                                                                                      // 330
      (activeObj.contents || activeDom).cloneNode(true),                                                              // 331
      document.querySelector('.content'),                                                                             // 332
      transition                                                                                                      // 333
    );                                                                                                                // 334
                                                                                                                      // 335
    PUSH.id = id;                                                                                                     // 336
                                                                                                                      // 337
    document.body.offsetHeight; // force reflow to prevent scroll                                                     // 338
  };                                                                                                                  // 339
                                                                                                                      // 340
                                                                                                                      // 341
  // Core PUSH functionality                                                                                          // 342
  // =======================                                                                                          // 343
                                                                                                                      // 344
  var PUSH = function (options) {                                                                                     // 345
    var key;                                                                                                          // 346
    var xhr = PUSH.xhr;                                                                                               // 347
                                                                                                                      // 348
    options.container = options.container || options.transition ? document.querySelector('.content') : document.body; // 349
                                                                                                                      // 350
    for (key in bars) {                                                                                               // 351
      if (bars.hasOwnProperty(key)) {                                                                                 // 352
        options[key] = options[key] || document.querySelector(bars[key]);                                             // 353
      }                                                                                                               // 354
    }                                                                                                                 // 355
                                                                                                                      // 356
    if (xhr && xhr.readyState < 4) {                                                                                  // 357
      xhr.onreadystatechange = noop;                                                                                  // 358
      xhr.abort();                                                                                                    // 359
    }                                                                                                                 // 360
                                                                                                                      // 361
    xhr = new XMLHttpRequest();                                                                                       // 362
    xhr.open('GET', options.url, true);                                                                               // 363
    xhr.setRequestHeader('X-PUSH', 'true');                                                                           // 364
                                                                                                                      // 365
    xhr.onreadystatechange = function () {                                                                            // 366
      if (options._timeout) {                                                                                         // 367
        clearTimeout(options._timeout);                                                                               // 368
      }                                                                                                               // 369
      if (xhr.readyState === 4) {                                                                                     // 370
        xhr.status === 200 ? success(xhr, options) : failure(options.url);                                            // 371
      }                                                                                                               // 372
    };                                                                                                                // 373
                                                                                                                      // 374
    if (!PUSH.id) {                                                                                                   // 375
      cacheReplace({                                                                                                  // 376
        id         : +new Date(),                                                                                     // 377
        url        : window.location.href,                                                                            // 378
        title      : document.title,                                                                                  // 379
        timeout    : options.timeout,                                                                                 // 380
        transition : null                                                                                             // 381
      });                                                                                                             // 382
    }                                                                                                                 // 383
                                                                                                                      // 384
    if (options.timeout) {                                                                                            // 385
      options._timeout = setTimeout(function () {  xhr.abort('timeout'); }, options.timeout);                         // 386
    }                                                                                                                 // 387
                                                                                                                      // 388
    xhr.send();                                                                                                       // 389
                                                                                                                      // 390
    if (xhr.readyState && !options.ignorePush) {                                                                      // 391
      cachePush();                                                                                                    // 392
    }                                                                                                                 // 393
  };                                                                                                                  // 394
                                                                                                                      // 395
                                                                                                                      // 396
  // Main XHR handlers                                                                                                // 397
  // =================                                                                                                // 398
                                                                                                                      // 399
  var success = function (xhr, options) {                                                                             // 400
    var key;                                                                                                          // 401
    var barElement;                                                                                                   // 402
    var data = parseXHR(xhr, options);                                                                                // 403
                                                                                                                      // 404
    if (!data.contents) {                                                                                             // 405
      return locationReplace(options.url);                                                                            // 406
    }                                                                                                                 // 407
                                                                                                                      // 408
    if (data.title) {                                                                                                 // 409
      document.title = data.title;                                                                                    // 410
    }                                                                                                                 // 411
                                                                                                                      // 412
    if (options.transition) {                                                                                         // 413
      for (key in bars) {                                                                                             // 414
        if (bars.hasOwnProperty(key)) {                                                                               // 415
          barElement = document.querySelector(bars[key]);                                                             // 416
          if (data[key]) {                                                                                            // 417
            swapContent(data[key], barElement);                                                                       // 418
          } else if (barElement) {                                                                                    // 419
            barElement.parentNode.removeChild(barElement);                                                            // 420
          }                                                                                                           // 421
        }                                                                                                             // 422
      }                                                                                                               // 423
    }                                                                                                                 // 424
                                                                                                                      // 425
    swapContent(data.contents, options.container, options.transition, function () {                                   // 426
      cacheReplace({                                                                                                  // 427
        id         : options.id || +new Date(),                                                                       // 428
        url        : data.url,                                                                                        // 429
        title      : data.title,                                                                                      // 430
        timeout    : options.timeout,                                                                                 // 431
        transition : options.transition                                                                               // 432
      }, options.id);                                                                                                 // 433
      triggerStateChange();                                                                                           // 434
    });                                                                                                               // 435
                                                                                                                      // 436
    if (!options.ignorePush && window._gaq) {                                                                         // 437
      _gaq.push(['_trackPageview']); // google analytics                                                              // 438
    }                                                                                                                 // 439
    if (!options.hash) {                                                                                              // 440
      return;                                                                                                         // 441
    }                                                                                                                 // 442
  };                                                                                                                  // 443
                                                                                                                      // 444
  var failure = function (url) {                                                                                      // 445
    throw new Error('Could not get: ' + url);                                                                         // 446
  };                                                                                                                  // 447
                                                                                                                      // 448
                                                                                                                      // 449
  // PUSH helpers                                                                                                     // 450
  // ============                                                                                                     // 451
                                                                                                                      // 452
  var swapContent = function (swap, container, transition, complete) {                                                // 453
    var enter;                                                                                                        // 454
    var containerDirection;                                                                                           // 455
    var swapDirection;                                                                                                // 456
                                                                                                                      // 457
    if (!transition) {                                                                                                // 458
      if (container) {                                                                                                // 459
        container.innerHTML = swap.innerHTML;                                                                         // 460
      } else if (swap.classList.contains('content')) {                                                                // 461
        document.body.appendChild(swap);                                                                              // 462
      } else {                                                                                                        // 463
        document.body.insertBefore(swap, document.querySelector('.content'));                                         // 464
      }                                                                                                               // 465
    } else {                                                                                                          // 466
      enter  = /in$/.test(transition);                                                                                // 467
                                                                                                                      // 468
      if (transition === 'fade') {                                                                                    // 469
        container.classList.add('in');                                                                                // 470
        container.classList.add('fade');                                                                              // 471
        swap.classList.add('fade');                                                                                   // 472
      }                                                                                                               // 473
                                                                                                                      // 474
      if (/slide/.test(transition)) {                                                                                 // 475
        swap.classList.add('sliding-in', enter ? 'right' : 'left');                                                   // 476
        swap.classList.add('sliding');                                                                                // 477
        container.classList.add('sliding');                                                                           // 478
      }                                                                                                               // 479
                                                                                                                      // 480
      container.parentNode.insertBefore(swap, container);                                                             // 481
    }                                                                                                                 // 482
                                                                                                                      // 483
    if (!transition) {                                                                                                // 484
      complete && complete();                                                                                         // 485
    }                                                                                                                 // 486
                                                                                                                      // 487
    if (transition === 'fade') {                                                                                      // 488
      container.offsetWidth; // force reflow                                                                          // 489
      container.classList.remove('in');                                                                               // 490
      var fadeContainerEnd = function () {                                                                            // 491
        container.removeEventListener('webkitTransitionEnd', fadeContainerEnd);                                       // 492
        swap.classList.add('in');                                                                                     // 493
        swap.addEventListener('webkitTransitionEnd', fadeSwapEnd);                                                    // 494
      };                                                                                                              // 495
      var fadeSwapEnd = function () {                                                                                 // 496
        swap.removeEventListener('webkitTransitionEnd', fadeSwapEnd);                                                 // 497
        container.parentNode.removeChild(container);                                                                  // 498
        swap.classList.remove('fade');                                                                                // 499
        swap.classList.remove('in');                                                                                  // 500
        complete && complete();                                                                                       // 501
      };                                                                                                              // 502
      container.addEventListener('webkitTransitionEnd', fadeContainerEnd);                                            // 503
                                                                                                                      // 504
    }                                                                                                                 // 505
                                                                                                                      // 506
    if (/slide/.test(transition)) {                                                                                   // 507
      var slideEnd = function () {                                                                                    // 508
        swap.removeEventListener('webkitTransitionEnd', slideEnd);                                                    // 509
        swap.classList.remove('sliding', 'sliding-in');                                                               // 510
        swap.classList.remove(swapDirection);                                                                         // 511
        container.parentNode.removeChild(container);                                                                  // 512
        complete && complete();                                                                                       // 513
      };                                                                                                              // 514
                                                                                                                      // 515
      container.offsetWidth; // force reflow                                                                          // 516
      swapDirection      = enter ? 'right' : 'left';                                                                  // 517
      containerDirection = enter ? 'left' : 'right';                                                                  // 518
      container.classList.add(containerDirection);                                                                    // 519
      swap.classList.remove(swapDirection);                                                                           // 520
      swap.addEventListener('webkitTransitionEnd', slideEnd);                                                         // 521
    }                                                                                                                 // 522
  };                                                                                                                  // 523
                                                                                                                      // 524
  var triggerStateChange = function () {                                                                              // 525
    var e = new CustomEvent('push', {                                                                                 // 526
      detail: { state: getCached(PUSH.id) },                                                                          // 527
      bubbles: true,                                                                                                  // 528
      cancelable: true                                                                                                // 529
    });                                                                                                               // 530
                                                                                                                      // 531
    window.dispatchEvent(e);                                                                                          // 532
  };                                                                                                                  // 533
                                                                                                                      // 534
  var findTarget = function (target) {                                                                                // 535
    var i;                                                                                                            // 536
    var toggles = document.querySelectorAll('a');                                                                     // 537
                                                                                                                      // 538
    for (; target && target !== document; target = target.parentNode) {                                               // 539
      for (i = toggles.length; i--;) {                                                                                // 540
        if (toggles[i] === target) {                                                                                  // 541
          return target;                                                                                              // 542
        }                                                                                                             // 543
      }                                                                                                               // 544
    }                                                                                                                 // 545
  };                                                                                                                  // 546
                                                                                                                      // 547
  var locationReplace = function (url) {                                                                              // 548
    window.history.replaceState(null, '', '#');                                                                       // 549
    window.location.replace(url);                                                                                     // 550
  };                                                                                                                  // 551
                                                                                                                      // 552
  var extendWithDom = function (obj, fragment, dom) {                                                                 // 553
    var i;                                                                                                            // 554
    var result = {};                                                                                                  // 555
                                                                                                                      // 556
    for (i in obj) {                                                                                                  // 557
      if (obj.hasOwnProperty(i)) {                                                                                    // 558
        result[i] = obj[i];                                                                                           // 559
      }                                                                                                               // 560
    }                                                                                                                 // 561
                                                                                                                      // 562
    Object.keys(bars).forEach(function (key) {                                                                        // 563
      var el = dom.querySelector(bars[key]);                                                                          // 564
      if (el) {                                                                                                       // 565
        el.parentNode.removeChild(el);                                                                                // 566
      }                                                                                                               // 567
      result[key] = el;                                                                                               // 568
    });                                                                                                               // 569
                                                                                                                      // 570
    result.contents = dom.querySelector(fragment);                                                                    // 571
                                                                                                                      // 572
    return result;                                                                                                    // 573
  };                                                                                                                  // 574
                                                                                                                      // 575
  var parseXHR = function (xhr, options) {                                                                            // 576
    var head;                                                                                                         // 577
    var body;                                                                                                         // 578
    var data = {};                                                                                                    // 579
    var responseText = xhr.responseText;                                                                              // 580
                                                                                                                      // 581
    data.url = options.url;                                                                                           // 582
                                                                                                                      // 583
    if (!responseText) {                                                                                              // 584
      return data;                                                                                                    // 585
    }                                                                                                                 // 586
                                                                                                                      // 587
    if (/<html/i.test(responseText)) {                                                                                // 588
      head           = document.createElement('div');                                                                 // 589
      body           = document.createElement('div');                                                                 // 590
      head.innerHTML = responseText.match(/<head[^>]*>([\s\S.]*)<\/head>/i)[0];                                       // 591
      body.innerHTML = responseText.match(/<body[^>]*>([\s\S.]*)<\/body>/i)[0];                                       // 592
    } else {                                                                                                          // 593
      head           = body = document.createElement('div');                                                          // 594
      head.innerHTML = responseText;                                                                                  // 595
    }                                                                                                                 // 596
                                                                                                                      // 597
    data.title = head.querySelector('title');                                                                         // 598
    var text = 'innerText' in data.title ? 'innerText' : 'textContent';                                               // 599
    data.title = data.title && data.title[text].trim();                                                               // 600
                                                                                                                      // 601
    if (options.transition) {                                                                                         // 602
      data = extendWithDom(data, '.content', body);                                                                   // 603
    } else {                                                                                                          // 604
      data.contents = body;                                                                                           // 605
    }                                                                                                                 // 606
                                                                                                                      // 607
    return data;                                                                                                      // 608
  };                                                                                                                  // 609
                                                                                                                      // 610
                                                                                                                      // 611
  // Attach PUSH event handlers                                                                                       // 612
  // ==========================                                                                                       // 613
                                                                                                                      // 614
  window.addEventListener('touchstart', function () { isScrolling = false; });                                        // 615
  window.addEventListener('touchmove', function () { isScrolling = true; });                                          // 616
  window.addEventListener('touchend', touchend);                                                                      // 617
  window.addEventListener('click', function (e) { if (getTarget(e)) {e.preventDefault();} });                         // 618
  window.addEventListener('popstate', popstate);                                                                      // 619
  window.PUSH = PUSH;                                                                                                 // 620
                                                                                                                      // 621
}());                                                                                                                 // 622
                                                                                                                      // 623
/* ========================================================================                                           // 624
 * Ratchet: segmented-controllers.js v2.0.2                                                                           // 625
 * http://goratchet.com/components#segmentedControls                                                                  // 626
 * ========================================================================                                           // 627
 * Copyright 2014 Connor Sears                                                                                        // 628
 * Licensed under MIT (https://github.com/twbs/ratchet/blob/master/LICENSE)                                           // 629
 * ======================================================================== */                                        // 630
                                                                                                                      // 631
!(function () {                                                                                                       // 632
  'use strict';                                                                                                       // 633
                                                                                                                      // 634
  var getTarget = function (target) {                                                                                 // 635
    var i;                                                                                                            // 636
    var segmentedControls = document.querySelectorAll('.segmented-control .control-item');                            // 637
                                                                                                                      // 638
    for (; target && target !== document; target = target.parentNode) {                                               // 639
      for (i = segmentedControls.length; i--;) {                                                                      // 640
        if (segmentedControls[i] === target) {                                                                        // 641
          return target;                                                                                              // 642
        }                                                                                                             // 643
      }                                                                                                               // 644
    }                                                                                                                 // 645
  };                                                                                                                  // 646
                                                                                                                      // 647
  window.addEventListener('touchend', function (e) {                                                                  // 648
    var activeTab;                                                                                                    // 649
    var activeBodies;                                                                                                 // 650
    var targetBody;                                                                                                   // 651
    var targetTab     = getTarget(e.target);                                                                          // 652
    var className     = 'active';                                                                                     // 653
    var classSelector = '.' + className;                                                                              // 654
                                                                                                                      // 655
    if (!targetTab) {                                                                                                 // 656
      return;                                                                                                         // 657
    }                                                                                                                 // 658
                                                                                                                      // 659
    activeTab = targetTab.parentNode.querySelector(classSelector);                                                    // 660
                                                                                                                      // 661
    if (activeTab) {                                                                                                  // 662
      activeTab.classList.remove(className);                                                                          // 663
    }                                                                                                                 // 664
                                                                                                                      // 665
    targetTab.classList.add(className);                                                                               // 666
                                                                                                                      // 667
    if (!targetTab.hash) {                                                                                            // 668
      return;                                                                                                         // 669
    }                                                                                                                 // 670
                                                                                                                      // 671
    targetBody = document.querySelector(targetTab.hash);                                                              // 672
                                                                                                                      // 673
    if (!targetBody) {                                                                                                // 674
      return;                                                                                                         // 675
    }                                                                                                                 // 676
                                                                                                                      // 677
    activeBodies = targetBody.parentNode.querySelectorAll(classSelector);                                             // 678
                                                                                                                      // 679
    for (var i = 0; i < activeBodies.length; i++) {                                                                   // 680
      activeBodies[i].classList.remove(className);                                                                    // 681
    }                                                                                                                 // 682
                                                                                                                      // 683
    targetBody.classList.add(className);                                                                              // 684
  });                                                                                                                 // 685
                                                                                                                      // 686
  window.addEventListener('click', function (e) { if (getTarget(e.target)) {e.preventDefault();} });                  // 687
}());                                                                                                                 // 688
                                                                                                                      // 689
/* ========================================================================                                           // 690
 * Ratchet: sliders.js v2.0.2                                                                                         // 691
 * http://goratchet.com/components#sliders                                                                            // 692
 * ========================================================================                                           // 693
   Adapted from Brad Birdsall's swipe                                                                                 // 694
 * Copyright 2014 Connor Sears                                                                                        // 695
 * Licensed under MIT (https://github.com/twbs/ratchet/blob/master/LICENSE)                                           // 696
 * ======================================================================== */                                        // 697
                                                                                                                      // 698
!(function () {                                                                                                       // 699
  'use strict';                                                                                                       // 700
                                                                                                                      // 701
  var pageX;                                                                                                          // 702
  var pageY;                                                                                                          // 703
  var slider;                                                                                                         // 704
  var deltaX;                                                                                                         // 705
  var deltaY;                                                                                                         // 706
  var offsetX;                                                                                                        // 707
  var lastSlide;                                                                                                      // 708
  var startTime;                                                                                                      // 709
  var resistance;                                                                                                     // 710
  var sliderWidth;                                                                                                    // 711
  var slideNumber;                                                                                                    // 712
  var isScrolling;                                                                                                    // 713
  var scrollableArea;                                                                                                 // 714
                                                                                                                      // 715
  var getSlider = function (target) {                                                                                 // 716
    var i;                                                                                                            // 717
    var sliders = document.querySelectorAll('.slider > .slide-group');                                                // 718
                                                                                                                      // 719
    for (; target && target !== document; target = target.parentNode) {                                               // 720
      for (i = sliders.length; i--;) {                                                                                // 721
        if (sliders[i] === target) {                                                                                  // 722
          return target;                                                                                              // 723
        }                                                                                                             // 724
      }                                                                                                               // 725
    }                                                                                                                 // 726
  };                                                                                                                  // 727
                                                                                                                      // 728
  var getScroll = function () {                                                                                       // 729
    if ('webkitTransform' in slider.style) {                                                                          // 730
      var translate3d = slider.style.webkitTransform.match(/translate3d\(([^,]*)/);                                   // 731
      var ret = translate3d ? translate3d[1] : 0;                                                                     // 732
      return parseInt(ret, 10);                                                                                       // 733
    }                                                                                                                 // 734
  };                                                                                                                  // 735
                                                                                                                      // 736
  var setSlideNumber = function (offset) {                                                                            // 737
    var round = offset ? (deltaX < 0 ? 'ceil' : 'floor') : 'round';                                                   // 738
    slideNumber = Math[round](getScroll() / (scrollableArea / slider.children.length));                               // 739
    slideNumber += offset;                                                                                            // 740
    slideNumber = Math.min(slideNumber, 0);                                                                           // 741
    slideNumber = Math.max(-(slider.children.length - 1), slideNumber);                                               // 742
  };                                                                                                                  // 743
                                                                                                                      // 744
  var onTouchStart = function (e) {                                                                                   // 745
    slider = getSlider(e.target);                                                                                     // 746
                                                                                                                      // 747
    if (!slider) {                                                                                                    // 748
      return;                                                                                                         // 749
    }                                                                                                                 // 750
                                                                                                                      // 751
    var firstItem  = slider.querySelector('.slide');                                                                  // 752
                                                                                                                      // 753
    scrollableArea = firstItem.offsetWidth * slider.children.length;                                                  // 754
    isScrolling    = undefined;                                                                                       // 755
    sliderWidth    = slider.offsetWidth;                                                                              // 756
    resistance     = 1;                                                                                               // 757
    lastSlide      = -(slider.children.length - 1);                                                                   // 758
    startTime      = +new Date();                                                                                     // 759
    pageX          = e.touches[0].pageX;                                                                              // 760
    pageY          = e.touches[0].pageY;                                                                              // 761
    deltaX         = 0;                                                                                               // 762
    deltaY         = 0;                                                                                               // 763
                                                                                                                      // 764
    setSlideNumber(0);                                                                                                // 765
                                                                                                                      // 766
    slider.style['-webkit-transition-duration'] = 0;                                                                  // 767
  };                                                                                                                  // 768
                                                                                                                      // 769
  var onTouchMove = function (e) {                                                                                    // 770
    if (e.touches.length > 1 || !slider) {                                                                            // 771
      return; // Exit if a pinch || no slider                                                                         // 772
    }                                                                                                                 // 773
                                                                                                                      // 774
    deltaX = e.touches[0].pageX - pageX;                                                                              // 775
    deltaY = e.touches[0].pageY - pageY;                                                                              // 776
    pageX  = e.touches[0].pageX;                                                                                      // 777
    pageY  = e.touches[0].pageY;                                                                                      // 778
                                                                                                                      // 779
    if (typeof isScrolling === 'undefined') {                                                                         // 780
      isScrolling = Math.abs(deltaY) > Math.abs(deltaX);                                                              // 781
    }                                                                                                                 // 782
                                                                                                                      // 783
    if (isScrolling) {                                                                                                // 784
      return;                                                                                                         // 785
    }                                                                                                                 // 786
                                                                                                                      // 787
    offsetX = (deltaX / resistance) + getScroll();                                                                    // 788
                                                                                                                      // 789
    e.preventDefault();                                                                                               // 790
                                                                                                                      // 791
    resistance = slideNumber === 0         && deltaX > 0 ? (pageX / sliderWidth) + 1.25 :                             // 792
                 slideNumber === lastSlide && deltaX < 0 ? (Math.abs(pageX) / sliderWidth) + 1.25 : 1;                // 793
                                                                                                                      // 794
    slider.style.webkitTransform = 'translate3d(' + offsetX + 'px,0,0)';                                              // 795
  };                                                                                                                  // 796
                                                                                                                      // 797
  var onTouchEnd = function (e) {                                                                                     // 798
    if (!slider || isScrolling) {                                                                                     // 799
      return;                                                                                                         // 800
    }                                                                                                                 // 801
                                                                                                                      // 802
    setSlideNumber(                                                                                                   // 803
      (+new Date()) - startTime < 1000 && Math.abs(deltaX) > 15 ? (deltaX < 0 ? -1 : 1) : 0                           // 804
    );                                                                                                                // 805
                                                                                                                      // 806
    offsetX = slideNumber * sliderWidth;                                                                              // 807
                                                                                                                      // 808
    slider.style['-webkit-transition-duration'] = '.2s';                                                              // 809
    slider.style.webkitTransform = 'translate3d(' + offsetX + 'px,0,0)';                                              // 810
                                                                                                                      // 811
    e = new CustomEvent('slide', {                                                                                    // 812
      detail: { slideNumber: Math.abs(slideNumber) },                                                                 // 813
      bubbles: true,                                                                                                  // 814
      cancelable: true                                                                                                // 815
    });                                                                                                               // 816
                                                                                                                      // 817
    slider.parentNode.dispatchEvent(e);                                                                               // 818
  };                                                                                                                  // 819
                                                                                                                      // 820
  window.addEventListener('touchstart', onTouchStart);                                                                // 821
  window.addEventListener('touchmove', onTouchMove);                                                                  // 822
  window.addEventListener('touchend', onTouchEnd);                                                                    // 823
                                                                                                                      // 824
}());                                                                                                                 // 825
                                                                                                                      // 826
/* ========================================================================                                           // 827
 * Ratchet: toggles.js v2.0.2                                                                                         // 828
 * http://goratchet.com/components#toggles                                                                            // 829
 * ========================================================================                                           // 830
   Adapted from Brad Birdsall's swipe                                                                                 // 831
 * Copyright 2014 Connor Sears                                                                                        // 832
 * Licensed under MIT (https://github.com/twbs/ratchet/blob/master/LICENSE)                                           // 833
 * ======================================================================== */                                        // 834
                                                                                                                      // 835
!(function () {                                                                                                       // 836
  'use strict';                                                                                                       // 837
                                                                                                                      // 838
  var start     = {};                                                                                                 // 839
  var touchMove = false;                                                                                              // 840
  var distanceX = false;                                                                                              // 841
  var toggle    = false;                                                                                              // 842
                                                                                                                      // 843
  var findToggle = function (target) {                                                                                // 844
    var i;                                                                                                            // 845
    var toggles = document.querySelectorAll('.toggle');                                                               // 846
                                                                                                                      // 847
    for (; target && target !== document; target = target.parentNode) {                                               // 848
      for (i = toggles.length; i--;) {                                                                                // 849
        if (toggles[i] === target) {                                                                                  // 850
          return target;                                                                                              // 851
        }                                                                                                             // 852
      }                                                                                                               // 853
    }                                                                                                                 // 854
  };                                                                                                                  // 855
                                                                                                                      // 856
  window.addEventListener('touchstart', function (e) {                                                                // 857
    e = e.originalEvent || e;                                                                                         // 858
                                                                                                                      // 859
    toggle = findToggle(e.target);                                                                                    // 860
                                                                                                                      // 861
    if (!toggle) {                                                                                                    // 862
      return;                                                                                                         // 863
    }                                                                                                                 // 864
                                                                                                                      // 865
    var handle      = toggle.querySelector('.toggle-handle');                                                         // 866
    var toggleWidth = toggle.clientWidth;                                                                             // 867
    var handleWidth = handle.clientWidth;                                                                             // 868
    var offset      = toggle.classList.contains('active') ? (toggleWidth - handleWidth) : 0;                          // 869
                                                                                                                      // 870
    start     = { pageX : e.touches[0].pageX - offset, pageY : e.touches[0].pageY };                                  // 871
    touchMove = false;                                                                                                // 872
  });                                                                                                                 // 873
                                                                                                                      // 874
  window.addEventListener('touchmove', function (e) {                                                                 // 875
    e = e.originalEvent || e;                                                                                         // 876
                                                                                                                      // 877
    if (e.touches.length > 1) {                                                                                       // 878
      return; // Exit if a pinch                                                                                      // 879
    }                                                                                                                 // 880
                                                                                                                      // 881
    if (!toggle) {                                                                                                    // 882
      return;                                                                                                         // 883
    }                                                                                                                 // 884
                                                                                                                      // 885
    var handle      = toggle.querySelector('.toggle-handle');                                                         // 886
    var current     = e.touches[0];                                                                                   // 887
    var toggleWidth = toggle.clientWidth;                                                                             // 888
    var handleWidth = handle.clientWidth;                                                                             // 889
    var offset      = toggleWidth - handleWidth;                                                                      // 890
                                                                                                                      // 891
    touchMove = true;                                                                                                 // 892
    distanceX = current.pageX - start.pageX;                                                                          // 893
                                                                                                                      // 894
    if (Math.abs(distanceX) < Math.abs(current.pageY - start.pageY)) {                                                // 895
      return;                                                                                                         // 896
    }                                                                                                                 // 897
                                                                                                                      // 898
    e.preventDefault();                                                                                               // 899
                                                                                                                      // 900
    if (distanceX < 0) {                                                                                              // 901
      return (handle.style.webkitTransform = 'translate3d(0,0,0)');                                                   // 902
    }                                                                                                                 // 903
    if (distanceX > offset) {                                                                                         // 904
      return (handle.style.webkitTransform = 'translate3d(' + offset + 'px,0,0)');                                    // 905
    }                                                                                                                 // 906
                                                                                                                      // 907
    handle.style.webkitTransform = 'translate3d(' + distanceX + 'px,0,0)';                                            // 908
                                                                                                                      // 909
    toggle.classList[(distanceX > (toggleWidth / 2 - handleWidth / 2)) ? 'add' : 'remove']('active');                 // 910
  });                                                                                                                 // 911
                                                                                                                      // 912
  window.addEventListener('touchend', function (e) {                                                                  // 913
    if (!toggle) {                                                                                                    // 914
      return;                                                                                                         // 915
    }                                                                                                                 // 916
                                                                                                                      // 917
    var handle      = toggle.querySelector('.toggle-handle');                                                         // 918
    var toggleWidth = toggle.clientWidth;                                                                             // 919
    var handleWidth = handle.clientWidth;                                                                             // 920
    var offset      = (toggleWidth - handleWidth);                                                                    // 921
    var slideOn     = (!touchMove && !toggle.classList.contains('active')) || (touchMove && (distanceX > (toggleWidth / 2 - handleWidth / 2)));
                                                                                                                      // 923
    if (slideOn) {                                                                                                    // 924
      handle.style.webkitTransform = 'translate3d(' + offset + 'px,0,0)';                                             // 925
    } else {                                                                                                          // 926
      handle.style.webkitTransform = 'translate3d(0,0,0)';                                                            // 927
    }                                                                                                                 // 928
                                                                                                                      // 929
    toggle.classList[slideOn ? 'add' : 'remove']('active');                                                           // 930
                                                                                                                      // 931
    e = new CustomEvent('toggle', {                                                                                   // 932
      detail: { isActive: slideOn },                                                                                  // 933
      bubbles: true,                                                                                                  // 934
      cancelable: true                                                                                                // 935
    });                                                                                                               // 936
                                                                                                                      // 937
    toggle.dispatchEvent(e);                                                                                          // 938
                                                                                                                      // 939
    touchMove = false;                                                                                                // 940
    toggle    = false;                                                                                                // 941
  });                                                                                                                 // 942
                                                                                                                      // 943
}());                                                                                                                 // 944
                                                                                                                      // 945
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                     // 955
}).call(this);                                                       // 956
                                                                     // 957
                                                                     // 958
                                                                     // 959
                                                                     // 960
                                                                     // 961
                                                                     // 962
(function () {                                                       // 963
                                                                     // 964
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/axw:ratchet/ratchet-2/js/ratchet.min.js                                                                   //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
/*!                                                                                                                   // 1
 * =====================================================                                                              // 2
 * Ratchet v2.0.2 (http://goratchet.com)                                                                              // 3
 * Copyright 2014 Connor Sears                                                                                        // 4
 * Licensed under MIT (https://github.com/twbs/ratchet/blob/master/LICENSE)                                           // 5
 *                                                                                                                    // 6
 * v2.0.2 designed by @connors.                                                                                       // 7
 * =====================================================                                                              // 8
 */                                                                                                                   // 9
!function(){"use strict";var a=function(a){for(var b,c=document.querySelectorAll("a");a&&a!==document;a=a.parentNode)for(b=c.length;b--;)if(c[b]===a)return a},b=function(b){var c=a(b.target);return c&&c.hash?document.querySelector(c.hash):void 0};window.addEventListener("touchend",function(a){var c=b(a);c&&(c&&c.classList.contains("modal")&&c.classList.toggle("active"),a.preventDefault())})}(),!function(){"use strict";var a,b=function(a){for(var b,c=document.querySelectorAll("a");a&&a!==document;a=a.parentNode)for(b=c.length;b--;)if(c[b]===a)return a},c=function(){a.style.display="none",a.removeEventListener("webkitTransitionEnd",c)},d=function(){var b=document.createElement("div");return b.classList.add("backdrop"),b.addEventListener("touchend",function(){a.addEventListener("webkitTransitionEnd",c),a.classList.remove("visible"),a.parentNode.removeChild(d)}),b}(),e=function(c){var d=b(c.target);if(d&&d.hash&&!(d.hash.indexOf("/")>0)){try{a=document.querySelector(d.hash)}catch(e){a=null}if(null!==a&&a&&a.classList.contains("popover"))return a}},f=function(a){var b=e(a);b&&(b.style.display="block",b.offsetHeight,b.classList.add("visible"),b.parentNode.appendChild(d))};window.addEventListener("touchend",f)}(),!function(){"use strict";var a,b=function(){},c=20,d=sessionStorage,e={},f={slideIn:"slide-out",slideOut:"slide-in",fade:"fade"},g={bartab:".bar-tab",barnav:".bar-nav",barfooter:".bar-footer",barheadersecondary:".bar-header-secondary"},h=function(a,b){o.id=a.id,b&&(a=k(a.id)),d[a.id]=JSON.stringify(a),window.history.replaceState(a.id,a.title,a.url),e[a.id]=document.body.cloneNode(!0)},i=function(){var a=o.id,b=JSON.parse(d.cacheForwardStack||"[]"),e=JSON.parse(d.cacheBackStack||"[]");for(e.push(a);b.length;)delete d[b.shift()];for(;e.length>c;)delete d[e.shift()];window.history.pushState(null,"",d[o.id].url),d.cacheForwardStack=JSON.stringify(b),d.cacheBackStack=JSON.stringify(e)},j=function(a,b){var c="forward"===b,e=JSON.parse(d.cacheForwardStack||"[]"),f=JSON.parse(d.cacheBackStack||"[]"),g=c?f:e,h=c?e:f;o.id&&g.push(o.id),h.pop(),d.cacheForwardStack=JSON.stringify(e),d.cacheBackStack=JSON.stringify(f)},k=function(a){return JSON.parse(d[a]||null)||{}},l=function(b){var c=t(b.target);if(!(!c||b.which>1||b.metaKey||b.ctrlKey||a||location.protocol!==c.protocol||location.host!==c.host||!c.hash&&/#/.test(c.href)||c.hash&&c.href.replace(c.hash,"")===location.href.replace(location.hash,"")||"push"===c.getAttribute("data-ignore")))return c},m=function(a){var b=l(a);b&&(a.preventDefault(),o({url:b.href,hash:b.hash,timeout:b.getAttribute("data-timeout"),transition:b.getAttribute("data-transition")}))},n=function(a){var b,c,h,i,l,m,n,p,q=a.state;if(q&&d[q]){if(l=o.id<q?"forward":"back",j(q,l),h=k(q),i=e[q],h.title&&(document.title=h.title),"back"===l?(n=JSON.parse("back"===l?d.cacheForwardStack:d.cacheBackStack),p=k(n[n.length-1])):p=h,"back"===l&&!p.id)return o.id=q;if(m="back"===l?f[p.transition]:p.transition,!i)return o({id:h.id,url:h.url,title:h.title,timeout:h.timeout,transition:m,ignorePush:!0});if(p.transition){h=v(h,".content",i.cloneNode(!0));for(b in g)g.hasOwnProperty(b)&&(c=document.querySelector(g[b]),h[b]?r(h[b],c):c&&c.parentNode.removeChild(c))}r((h.contents||i).cloneNode(!0),document.querySelector(".content"),m),o.id=q,document.body.offsetHeight}},o=function(a){var c,d=o.xhr;a.container=a.container||a.transition?document.querySelector(".content"):document.body;for(c in g)g.hasOwnProperty(c)&&(a[c]=a[c]||document.querySelector(g[c]));d&&d.readyState<4&&(d.onreadystatechange=b,d.abort()),d=new XMLHttpRequest,d.open("GET",a.url,!0),d.setRequestHeader("X-PUSH","true"),d.onreadystatechange=function(){a._timeout&&clearTimeout(a._timeout),4===d.readyState&&(200===d.status?p(d,a):q(a.url))},o.id||h({id:+new Date,url:window.location.href,title:document.title,timeout:a.timeout,transition:null}),a.timeout&&(a._timeout=setTimeout(function(){d.abort("timeout")},a.timeout)),d.send(),d.readyState&&!a.ignorePush&&i()},p=function(a,b){var c,d,e=w(a,b);if(!e.contents)return u(b.url);if(e.title&&(document.title=e.title),b.transition)for(c in g)g.hasOwnProperty(c)&&(d=document.querySelector(g[c]),e[c]?r(e[c],d):d&&d.parentNode.removeChild(d));r(e.contents,b.container,b.transition,function(){h({id:b.id||+new Date,url:e.url,title:e.title,timeout:b.timeout,transition:b.transition},b.id),s()}),!b.ignorePush&&window._gaq&&_gaq.push(["_trackPageview"]),!b.hash},q=function(a){throw new Error("Could not get: "+a)},r=function(a,b,c,d){var e,f,g;if(c?(e=/in$/.test(c),"fade"===c&&(b.classList.add("in"),b.classList.add("fade"),a.classList.add("fade")),/slide/.test(c)&&(a.classList.add("sliding-in",e?"right":"left"),a.classList.add("sliding"),b.classList.add("sliding")),b.parentNode.insertBefore(a,b)):b?b.innerHTML=a.innerHTML:a.classList.contains("content")?document.body.appendChild(a):document.body.insertBefore(a,document.querySelector(".content")),c||d&&d(),"fade"===c){b.offsetWidth,b.classList.remove("in");var h=function(){b.removeEventListener("webkitTransitionEnd",h),a.classList.add("in"),a.addEventListener("webkitTransitionEnd",i)},i=function(){a.removeEventListener("webkitTransitionEnd",i),b.parentNode.removeChild(b),a.classList.remove("fade"),a.classList.remove("in"),d&&d()};b.addEventListener("webkitTransitionEnd",h)}if(/slide/.test(c)){var j=function(){a.removeEventListener("webkitTransitionEnd",j),a.classList.remove("sliding","sliding-in"),a.classList.remove(g),b.parentNode.removeChild(b),d&&d()};b.offsetWidth,g=e?"right":"left",f=e?"left":"right",b.classList.add(f),a.classList.remove(g),a.addEventListener("webkitTransitionEnd",j)}},s=function(){var a=new CustomEvent("push",{detail:{state:k(o.id)},bubbles:!0,cancelable:!0});window.dispatchEvent(a)},t=function(a){for(var b,c=document.querySelectorAll("a");a&&a!==document;a=a.parentNode)for(b=c.length;b--;)if(c[b]===a)return a},u=function(a){window.history.replaceState(null,"","#"),window.location.replace(a)},v=function(a,b,c){var d,e={};for(d in a)a.hasOwnProperty(d)&&(e[d]=a[d]);return Object.keys(g).forEach(function(a){var b=c.querySelector(g[a]);b&&b.parentNode.removeChild(b),e[a]=b}),e.contents=c.querySelector(b),e},w=function(a,b){var c,d,e={},f=a.responseText;if(e.url=b.url,!f)return e;/<html/i.test(f)?(c=document.createElement("div"),d=document.createElement("div"),c.innerHTML=f.match(/<head[^>]*>([\s\S.]*)<\/head>/i)[0],d.innerHTML=f.match(/<body[^>]*>([\s\S.]*)<\/body>/i)[0]):(c=d=document.createElement("div"),c.innerHTML=f),e.title=c.querySelector("title");var g="innerText"in e.title?"innerText":"textContent";return e.title=e.title&&e.title[g].trim(),b.transition?e=v(e,".content",d):e.contents=d,e};window.addEventListener("touchstart",function(){a=!1}),window.addEventListener("touchmove",function(){a=!0}),window.addEventListener("touchend",m),window.addEventListener("click",function(a){l(a)&&a.preventDefault()}),window.addEventListener("popstate",n),window.PUSH=o}(),!function(){"use strict";var a=function(a){for(var b,c=document.querySelectorAll(".segmented-control .control-item");a&&a!==document;a=a.parentNode)for(b=c.length;b--;)if(c[b]===a)return a};window.addEventListener("touchend",function(b){var c,d,e,f=a(b.target),g="active",h="."+g;if(f&&(c=f.parentNode.querySelector(h),c&&c.classList.remove(g),f.classList.add(g),f.hash&&(e=document.querySelector(f.hash)))){d=e.parentNode.querySelectorAll(h);for(var i=0;i<d.length;i++)d[i].classList.remove(g);e.classList.add(g)}}),window.addEventListener("click",function(b){a(b.target)&&b.preventDefault()})}(),!function(){"use strict";var a,b,c,d,e,f,g,h,i,j,k,l,m,n=function(a){for(var b,c=document.querySelectorAll(".slider > .slide-group");a&&a!==document;a=a.parentNode)for(b=c.length;b--;)if(c[b]===a)return a},o=function(){if("webkitTransform"in c.style){var a=c.style.webkitTransform.match(/translate3d\(([^,]*)/),b=a?a[1]:0;return parseInt(b,10)}},p=function(a){var b=a?0>d?"ceil":"floor":"round";k=Math[b](o()/(m/c.children.length)),k+=a,k=Math.min(k,0),k=Math.max(-(c.children.length-1),k)},q=function(f){if(c=n(f.target)){var k=c.querySelector(".slide");m=k.offsetWidth*c.children.length,l=void 0,j=c.offsetWidth,i=1,g=-(c.children.length-1),h=+new Date,a=f.touches[0].pageX,b=f.touches[0].pageY,d=0,e=0,p(0),c.style["-webkit-transition-duration"]=0}},r=function(h){h.touches.length>1||!c||(d=h.touches[0].pageX-a,e=h.touches[0].pageY-b,a=h.touches[0].pageX,b=h.touches[0].pageY,"undefined"==typeof l&&(l=Math.abs(e)>Math.abs(d)),l||(f=d/i+o(),h.preventDefault(),i=0===k&&d>0?a/j+1.25:k===g&&0>d?Math.abs(a)/j+1.25:1,c.style.webkitTransform="translate3d("+f+"px,0,0)"))},s=function(a){c&&!l&&(p(+new Date-h<1e3&&Math.abs(d)>15?0>d?-1:1:0),f=k*j,c.style["-webkit-transition-duration"]=".2s",c.style.webkitTransform="translate3d("+f+"px,0,0)",a=new CustomEvent("slide",{detail:{slideNumber:Math.abs(k)},bubbles:!0,cancelable:!0}),c.parentNode.dispatchEvent(a))};window.addEventListener("touchstart",q),window.addEventListener("touchmove",r),window.addEventListener("touchend",s)}(),!function(){"use strict";var a={},b=!1,c=!1,d=!1,e=function(a){for(var b,c=document.querySelectorAll(".toggle");a&&a!==document;a=a.parentNode)for(b=c.length;b--;)if(c[b]===a)return a};window.addEventListener("touchstart",function(c){if(c=c.originalEvent||c,d=e(c.target)){var f=d.querySelector(".toggle-handle"),g=d.clientWidth,h=f.clientWidth,i=d.classList.contains("active")?g-h:0;a={pageX:c.touches[0].pageX-i,pageY:c.touches[0].pageY},b=!1}}),window.addEventListener("touchmove",function(e){if(e=e.originalEvent||e,!(e.touches.length>1)&&d){var f=d.querySelector(".toggle-handle"),g=e.touches[0],h=d.clientWidth,i=f.clientWidth,j=h-i;if(b=!0,c=g.pageX-a.pageX,!(Math.abs(c)<Math.abs(g.pageY-a.pageY))){if(e.preventDefault(),0>c)return f.style.webkitTransform="translate3d(0,0,0)";if(c>j)return f.style.webkitTransform="translate3d("+j+"px,0,0)";f.style.webkitTransform="translate3d("+c+"px,0,0)",d.classList[c>h/2-i/2?"add":"remove"]("active")}}}),window.addEventListener("touchend",function(a){if(d){var e=d.querySelector(".toggle-handle"),f=d.clientWidth,g=e.clientWidth,h=f-g,i=!b&&!d.classList.contains("active")||b&&c>f/2-g/2;e.style.webkitTransform=i?"translate3d("+h+"px,0,0)":"translate3d(0,0,0)",d.classList[i?"add":"remove"]("active"),a=new CustomEvent("toggle",{detail:{isActive:i},bubbles:!0,cancelable:!0}),d.dispatchEvent(a),b=!1,d=!1}})}();
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                     // 982
}).call(this);                                                       // 983
                                                                     // 984
///////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['axw:ratchet'] = {};

})();
