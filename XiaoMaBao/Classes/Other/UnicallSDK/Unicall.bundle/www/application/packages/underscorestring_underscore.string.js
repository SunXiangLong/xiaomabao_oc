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

/* Package-scope variables */
var module, exports, makeString, width, seperator, cut, preserveSpaces, trailingSpaces, words, result, current_column, index, s;

(function(){

///////////////////////////////////////////////////////////////////////
//                                                                   //
// packages/underscorestring_underscore.string/packages/underscorest //
//                                                                   //
///////////////////////////////////////////////////////////////////////
                                                                     //
(function () {                                                       // 1
                                                                     // 2
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/underscorestring:underscore.string/meteor-pre.js                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
// Defining this will trick dist/underscore.string.js into putting its exports into module.exports                    // 1
// Credit to Tim Heckel for this trick - see https://github.com/TimHeckel/meteor-underscore-string                    // 2
module = {};                                                                                                          // 3
                                                                                                                      // 4
// This also needed, otherwise above doesn't work???                                                                  // 5
exports = {};                                                                                                         // 6
                                                                                                                      // 7
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                     // 17
}).call(this);                                                       // 18
                                                                     // 19
                                                                     // 20
                                                                     // 21
                                                                     // 22
                                                                     // 23
                                                                     // 24
(function () {                                                       // 25
                                                                     // 26
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/underscorestring:underscore.string/dist/underscore.string.js                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
/* underscore.string 3.2.1 | MIT licensed | http://epeli.github.com/underscore.string/ */                             // 1
                                                                                                                      // 2
!function(e){if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.s=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
var trim = _dereq_('./trim');                                                                                         // 4
var decap = _dereq_('./decapitalize');                                                                                // 5
                                                                                                                      // 6
module.exports = function camelize(str, decapitalize) {                                                               // 7
  str = trim(str).replace(/[-_\s]+(.)?/g, function(match, c) {                                                        // 8
    return c ? c.toUpperCase() : "";                                                                                  // 9
  });                                                                                                                 // 10
                                                                                                                      // 11
  if (decapitalize === true) {                                                                                        // 12
    return decap(str);                                                                                                // 13
  } else {                                                                                                            // 14
    return str;                                                                                                       // 15
  }                                                                                                                   // 16
};                                                                                                                    // 17
                                                                                                                      // 18
},{"./decapitalize":10,"./trim":62}],2:[function(_dereq_,module,exports){                                             // 19
var makeString = _dereq_('./helper/makeString');                                                                      // 20
                                                                                                                      // 21
module.exports = function capitalize(str, lowercaseRest) {                                                            // 22
  str = makeString(str);                                                                                              // 23
  var remainingChars = !lowercaseRest ? str.slice(1) : str.slice(1).toLowerCase();                                    // 24
                                                                                                                      // 25
  return str.charAt(0).toUpperCase() + remainingChars;                                                                // 26
};                                                                                                                    // 27
                                                                                                                      // 28
},{"./helper/makeString":21}],3:[function(_dereq_,module,exports){                                                    // 29
var makeString = _dereq_('./helper/makeString');                                                                      // 30
                                                                                                                      // 31
module.exports = function chars(str) {                                                                                // 32
  return makeString(str).split('');                                                                                   // 33
};                                                                                                                    // 34
                                                                                                                      // 35
},{"./helper/makeString":21}],4:[function(_dereq_,module,exports){                                                    // 36
module.exports = function chop(str, step) {                                                                           // 37
  if (str == null) return [];                                                                                         // 38
  str = String(str);                                                                                                  // 39
  step = ~~step;                                                                                                      // 40
  return step > 0 ? str.match(new RegExp('.{1,' + step + '}', 'g')) : [str];                                          // 41
};                                                                                                                    // 42
                                                                                                                      // 43
},{}],5:[function(_dereq_,module,exports){                                                                            // 44
var capitalize = _dereq_('./capitalize');                                                                             // 45
var camelize = _dereq_('./camelize');                                                                                 // 46
var makeString = _dereq_('./helper/makeString');                                                                      // 47
                                                                                                                      // 48
module.exports = function classify(str) {                                                                             // 49
  str = makeString(str);                                                                                              // 50
  return capitalize(camelize(str.replace(/[\W_]/g, ' ')).replace(/\s/g, ''));                                         // 51
};                                                                                                                    // 52
                                                                                                                      // 53
},{"./camelize":1,"./capitalize":2,"./helper/makeString":21}],6:[function(_dereq_,module,exports){                    // 54
var trim = _dereq_('./trim');                                                                                         // 55
                                                                                                                      // 56
module.exports = function clean(str) {                                                                                // 57
  return trim(str).replace(/\s\s+/g, ' ');                                                                            // 58
};                                                                                                                    // 59
                                                                                                                      // 60
},{"./trim":62}],7:[function(_dereq_,module,exports){                                                                 // 61
                                                                                                                      // 62
var makeString = _dereq_('./helper/makeString');                                                                      // 63
                                                                                                                      // 64
var from  = "ąàáäâãåæăćčĉęèéëêĝĥìíïîĵłľńňòóöőôõðøśșšŝťțŭùúüűûñÿýçżźž",                                                // 65
    to    = "aaaaaaaaaccceeeeeghiiiijllnnoooooooossssttuuuuuunyyczzz";                                                // 66
                                                                                                                      // 67
from += from.toUpperCase();                                                                                           // 68
to += to.toUpperCase();                                                                                               // 69
                                                                                                                      // 70
module.exports = function cleanDiacritics(str) {                                                                      // 71
    return makeString(str).replace(/.{1}/g, function(c){                                                              // 72
      var index = from.indexOf(c);                                                                                    // 73
      return index === -1 ? c : to.charAt(index);                                                                     // 74
  });                                                                                                                 // 75
};                                                                                                                    // 76
                                                                                                                      // 77
},{"./helper/makeString":21}],8:[function(_dereq_,module,exports){                                                    // 78
var makeString = _dereq_('./helper/makeString');                                                                      // 79
                                                                                                                      // 80
module.exports = function(str, substr) {                                                                              // 81
  str = makeString(str);                                                                                              // 82
  substr = makeString(substr);                                                                                        // 83
                                                                                                                      // 84
  if (str.length === 0 || substr.length === 0) return 0;                                                              // 85
                                                                                                                      // 86
  return str.split(substr).length - 1;                                                                                // 87
};                                                                                                                    // 88
                                                                                                                      // 89
},{"./helper/makeString":21}],9:[function(_dereq_,module,exports){                                                    // 90
var trim = _dereq_('./trim');                                                                                         // 91
                                                                                                                      // 92
module.exports = function dasherize(str) {                                                                            // 93
  return trim(str).replace(/([A-Z])/g, '-$1').replace(/[-_\s]+/g, '-').toLowerCase();                                 // 94
};                                                                                                                    // 95
                                                                                                                      // 96
},{"./trim":62}],10:[function(_dereq_,module,exports){                                                                // 97
var makeString = _dereq_('./helper/makeString');                                                                      // 98
                                                                                                                      // 99
module.exports = function decapitalize(str) {                                                                         // 100
  str = makeString(str);                                                                                              // 101
  return str.charAt(0).toLowerCase() + str.slice(1);                                                                  // 102
};                                                                                                                    // 103
                                                                                                                      // 104
},{"./helper/makeString":21}],11:[function(_dereq_,module,exports){                                                   // 105
var makeString = _dereq_('./helper/makeString');                                                                      // 106
                                                                                                                      // 107
function getIndent(str) {                                                                                             // 108
  var matches = str.match(/^[\s\\t]*/gm);                                                                             // 109
  var indent = matches[0].length;                                                                                     // 110
                                                                                                                      // 111
  for (var i = 1; i < matches.length; i++) {                                                                          // 112
    indent = Math.min(matches[i].length, indent);                                                                     // 113
  }                                                                                                                   // 114
                                                                                                                      // 115
  return indent;                                                                                                      // 116
}                                                                                                                     // 117
                                                                                                                      // 118
module.exports = function dedent(str, pattern) {                                                                      // 119
  str = makeString(str);                                                                                              // 120
  var indent = getIndent(str);                                                                                        // 121
  var reg;                                                                                                            // 122
                                                                                                                      // 123
  if (indent === 0) return str;                                                                                       // 124
                                                                                                                      // 125
  if (typeof pattern === 'string') {                                                                                  // 126
    reg = new RegExp('^' + pattern, 'gm');                                                                            // 127
  } else {                                                                                                            // 128
    reg = new RegExp('^[ \\t]{' + indent + '}', 'gm');                                                                // 129
  }                                                                                                                   // 130
                                                                                                                      // 131
  return str.replace(reg, '');                                                                                        // 132
};                                                                                                                    // 133
                                                                                                                      // 134
},{"./helper/makeString":21}],12:[function(_dereq_,module,exports){                                                   // 135
var makeString = _dereq_('./helper/makeString');                                                                      // 136
var toPositive = _dereq_('./helper/toPositive');                                                                      // 137
                                                                                                                      // 138
module.exports = function endsWith(str, ends, position) {                                                             // 139
  str = makeString(str);                                                                                              // 140
  ends = '' + ends;                                                                                                   // 141
  if (typeof position == 'undefined') {                                                                               // 142
    position = str.length - ends.length;                                                                              // 143
  } else {                                                                                                            // 144
    position = Math.min(toPositive(position), str.length) - ends.length;                                              // 145
  }                                                                                                                   // 146
  return position >= 0 && str.indexOf(ends, position) === position;                                                   // 147
};                                                                                                                    // 148
                                                                                                                      // 149
},{"./helper/makeString":21,"./helper/toPositive":23}],13:[function(_dereq_,module,exports){                          // 150
var makeString = _dereq_('./helper/makeString');                                                                      // 151
var escapeChars = _dereq_('./helper/escapeChars');                                                                    // 152
var reversedEscapeChars = {};                                                                                         // 153
                                                                                                                      // 154
var regexString = "[";                                                                                                // 155
for(var key in escapeChars) {                                                                                         // 156
  regexString += key;                                                                                                 // 157
}                                                                                                                     // 158
regexString += "]";                                                                                                   // 159
                                                                                                                      // 160
var regex = new RegExp( regexString, 'g');                                                                            // 161
                                                                                                                      // 162
module.exports = function escapeHTML(str) {                                                                           // 163
                                                                                                                      // 164
  return makeString(str).replace(regex, function(m) {                                                                 // 165
    return '&' + escapeChars[m] + ';';                                                                                // 166
  });                                                                                                                 // 167
};                                                                                                                    // 168
                                                                                                                      // 169
},{"./helper/escapeChars":18,"./helper/makeString":21}],14:[function(_dereq_,module,exports){                         // 170
module.exports = function() {                                                                                         // 171
  var result = {};                                                                                                    // 172
                                                                                                                      // 173
  for (var prop in this) {                                                                                            // 174
    if (!this.hasOwnProperty(prop) || prop.match(/^(?:include|contains|reverse|join)$/)) continue;                    // 175
    result[prop] = this[prop];                                                                                        // 176
  }                                                                                                                   // 177
                                                                                                                      // 178
  return result;                                                                                                      // 179
};                                                                                                                    // 180
                                                                                                                      // 181
},{}],15:[function(_dereq_,module,exports){                                                                           // 182
//  Underscore.string                                                                                                 // 183
//  (c) 2010 Esa-Matti Suuronen <esa-matti aet suuronen dot org>                                                      // 184
//  Underscore.string is freely distributable under the terms of the MIT license.                                     // 185
//  Documentation: https://github.com/epeli/underscore.string                                                         // 186
//  Some code is borrowed from MooTools and Alexandru Marasteanu.                                                     // 187
//  Version '3.2.1'                                                                                                   // 188
                                                                                                                      // 189
'use strict';                                                                                                         // 190
                                                                                                                      // 191
function s(value) {                                                                                                   // 192
  /* jshint validthis: true */                                                                                        // 193
  if (!(this instanceof s)) return new s(value);                                                                      // 194
  this._wrapped = value;                                                                                              // 195
}                                                                                                                     // 196
                                                                                                                      // 197
s.VERSION = '3.2.1';                                                                                                  // 198
                                                                                                                      // 199
s.isBlank          = _dereq_('./isBlank');                                                                            // 200
s.stripTags        = _dereq_('./stripTags');                                                                          // 201
s.capitalize       = _dereq_('./capitalize');                                                                         // 202
s.decapitalize     = _dereq_('./decapitalize');                                                                       // 203
s.chop             = _dereq_('./chop');                                                                               // 204
s.trim             = _dereq_('./trim');                                                                               // 205
s.clean            = _dereq_('./clean');                                                                              // 206
s.cleanDiacritics  = _dereq_('./cleanDiacritics');                                                                    // 207
s.count            = _dereq_('./count');                                                                              // 208
s.chars            = _dereq_('./chars');                                                                              // 209
s.swapCase         = _dereq_('./swapCase');                                                                           // 210
s.escapeHTML       = _dereq_('./escapeHTML');                                                                         // 211
s.unescapeHTML     = _dereq_('./unescapeHTML');                                                                       // 212
s.splice           = _dereq_('./splice');                                                                             // 213
s.insert           = _dereq_('./insert');                                                                             // 214
s.replaceAll       = _dereq_('./replaceAll');                                                                         // 215
s.include          = _dereq_('./include');                                                                            // 216
s.join             = _dereq_('./join');                                                                               // 217
s.lines            = _dereq_('./lines');                                                                              // 218
s.dedent           = _dereq_('./dedent');                                                                             // 219
s.reverse          = _dereq_('./reverse');                                                                            // 220
s.startsWith       = _dereq_('./startsWith');                                                                         // 221
s.endsWith         = _dereq_('./endsWith');                                                                           // 222
s.pred             = _dereq_('./pred');                                                                               // 223
s.succ             = _dereq_('./succ');                                                                               // 224
s.titleize         = _dereq_('./titleize');                                                                           // 225
s.camelize         = _dereq_('./camelize');                                                                           // 226
s.underscored      = _dereq_('./underscored');                                                                        // 227
s.dasherize        = _dereq_('./dasherize');                                                                          // 228
s.classify         = _dereq_('./classify');                                                                           // 229
s.humanize         = _dereq_('./humanize');                                                                           // 230
s.ltrim            = _dereq_('./ltrim');                                                                              // 231
s.rtrim            = _dereq_('./rtrim');                                                                              // 232
s.truncate         = _dereq_('./truncate');                                                                           // 233
s.prune            = _dereq_('./prune');                                                                              // 234
s.words            = _dereq_('./words');                                                                              // 235
s.pad              = _dereq_('./pad');                                                                                // 236
s.lpad             = _dereq_('./lpad');                                                                               // 237
s.rpad             = _dereq_('./rpad');                                                                               // 238
s.lrpad            = _dereq_('./lrpad');                                                                              // 239
s.sprintf          = _dereq_('./sprintf');                                                                            // 240
s.vsprintf         = _dereq_('./vsprintf');                                                                           // 241
s.toNumber         = _dereq_('./toNumber');                                                                           // 242
s.numberFormat     = _dereq_('./numberFormat');                                                                       // 243
s.strRight         = _dereq_('./strRight');                                                                           // 244
s.strRightBack     = _dereq_('./strRightBack');                                                                       // 245
s.strLeft          = _dereq_('./strLeft');                                                                            // 246
s.strLeftBack      = _dereq_('./strLeftBack');                                                                        // 247
s.toSentence       = _dereq_('./toSentence');                                                                         // 248
s.toSentenceSerial = _dereq_('./toSentenceSerial');                                                                   // 249
s.slugify          = _dereq_('./slugify');                                                                            // 250
s.surround         = _dereq_('./surround');                                                                           // 251
s.quote            = _dereq_('./quote');                                                                              // 252
s.unquote          = _dereq_('./unquote');                                                                            // 253
s.repeat           = _dereq_('./repeat');                                                                             // 254
s.naturalCmp       = _dereq_('./naturalCmp');                                                                         // 255
s.levenshtein      = _dereq_('./levenshtein');                                                                        // 256
s.toBoolean        = _dereq_('./toBoolean');                                                                          // 257
s.exports          = _dereq_('./exports');                                                                            // 258
s.escapeRegExp     = _dereq_('./helper/escapeRegExp');                                                                // 259
s.wrap             = _dereq_('./wrap');                                                                               // 260
                                                                                                                      // 261
// Aliases                                                                                                            // 262
s.strip     = s.trim;                                                                                                 // 263
s.lstrip    = s.ltrim;                                                                                                // 264
s.rstrip    = s.rtrim;                                                                                                // 265
s.center    = s.lrpad;                                                                                                // 266
s.rjust     = s.lpad;                                                                                                 // 267
s.ljust     = s.rpad;                                                                                                 // 268
s.contains  = s.include;                                                                                              // 269
s.q         = s.quote;                                                                                                // 270
s.toBool    = s.toBoolean;                                                                                            // 271
s.camelcase = s.camelize;                                                                                             // 272
                                                                                                                      // 273
                                                                                                                      // 274
// Implement chaining                                                                                                 // 275
s.prototype = {                                                                                                       // 276
  value: function value() {                                                                                           // 277
    return this._wrapped;                                                                                             // 278
  }                                                                                                                   // 279
};                                                                                                                    // 280
                                                                                                                      // 281
function fn2method(key, fn) {                                                                                         // 282
    if (typeof fn !== "function") return;                                                                             // 283
    s.prototype[key] = function() {                                                                                   // 284
      var args = [this._wrapped].concat(Array.prototype.slice.call(arguments));                                       // 285
      var res = fn.apply(null, args);                                                                                 // 286
      // if the result is non-string stop the chain and return the value                                              // 287
      return typeof res === 'string' ? new s(res) : res;                                                              // 288
    };                                                                                                                // 289
}                                                                                                                     // 290
                                                                                                                      // 291
// Copy functions to instance methods for chaining                                                                    // 292
for (var key in s) fn2method(key, s[key]);                                                                            // 293
                                                                                                                      // 294
fn2method("tap", function tap(string, fn) {                                                                           // 295
  return fn(string);                                                                                                  // 296
});                                                                                                                   // 297
                                                                                                                      // 298
function prototype2method(methodName) {                                                                               // 299
  fn2method(methodName, function(context) {                                                                           // 300
    var args = Array.prototype.slice.call(arguments, 1);                                                              // 301
    return String.prototype[methodName].apply(context, args);                                                         // 302
  });                                                                                                                 // 303
}                                                                                                                     // 304
                                                                                                                      // 305
var prototypeMethods = [                                                                                              // 306
  "toUpperCase",                                                                                                      // 307
  "toLowerCase",                                                                                                      // 308
  "split",                                                                                                            // 309
  "replace",                                                                                                          // 310
  "slice",                                                                                                            // 311
  "substring",                                                                                                        // 312
  "substr",                                                                                                           // 313
  "concat"                                                                                                            // 314
];                                                                                                                    // 315
                                                                                                                      // 316
for (var key in prototypeMethods) prototype2method(prototypeMethods[key]);                                            // 317
                                                                                                                      // 318
                                                                                                                      // 319
module.exports = s;                                                                                                   // 320
                                                                                                                      // 321
},{"./camelize":1,"./capitalize":2,"./chars":3,"./chop":4,"./classify":5,"./clean":6,"./cleanDiacritics":7,"./count":8,"./dasherize":9,"./decapitalize":10,"./dedent":11,"./endsWith":12,"./escapeHTML":13,"./exports":14,"./helper/escapeRegExp":19,"./humanize":24,"./include":25,"./insert":26,"./isBlank":27,"./join":28,"./levenshtein":29,"./lines":30,"./lpad":31,"./lrpad":32,"./ltrim":33,"./naturalCmp":34,"./numberFormat":35,"./pad":36,"./pred":37,"./prune":38,"./quote":39,"./repeat":40,"./replaceAll":41,"./reverse":42,"./rpad":43,"./rtrim":44,"./slugify":45,"./splice":46,"./sprintf":47,"./startsWith":48,"./strLeft":49,"./strLeftBack":50,"./strRight":51,"./strRightBack":52,"./stripTags":53,"./succ":54,"./surround":55,"./swapCase":56,"./titleize":57,"./toBoolean":58,"./toNumber":59,"./toSentence":60,"./toSentenceSerial":61,"./trim":62,"./truncate":63,"./underscored":64,"./unescapeHTML":65,"./unquote":66,"./vsprintf":67,"./words":68,"./wrap":69}],16:[function(_dereq_,module,exports){
var makeString = _dereq_('./makeString');                                                                             // 323
                                                                                                                      // 324
module.exports = function adjacent(str, direction) {                                                                  // 325
  str = makeString(str);                                                                                              // 326
  if (str.length === 0) {                                                                                             // 327
    return '';                                                                                                        // 328
  }                                                                                                                   // 329
  return str.slice(0, -1) + String.fromCharCode(str.charCodeAt(str.length - 1) + direction);                          // 330
};                                                                                                                    // 331
                                                                                                                      // 332
},{"./makeString":21}],17:[function(_dereq_,module,exports){                                                          // 333
var escapeRegExp = _dereq_('./escapeRegExp');                                                                         // 334
                                                                                                                      // 335
module.exports = function defaultToWhiteSpace(characters) {                                                           // 336
  if (characters == null)                                                                                             // 337
    return '\\s';                                                                                                     // 338
  else if (characters.source)                                                                                         // 339
    return characters.source;                                                                                         // 340
  else                                                                                                                // 341
    return '[' + escapeRegExp(characters) + ']';                                                                      // 342
};                                                                                                                    // 343
                                                                                                                      // 344
},{"./escapeRegExp":19}],18:[function(_dereq_,module,exports){                                                        // 345
/* We're explicitly defining the list of entities we want to escape.                                                  // 346
nbsp is an HTML entity, but we don't want to escape all space characters in a string, hence its omission in this map. // 347
                                                                                                                      // 348
*/                                                                                                                    // 349
var escapeChars = {                                                                                                   // 350
  '¢' : 'cent',                                                                                                       // 351
  '£' : 'pound',                                                                                                      // 352
  '¥' : 'yen',                                                                                                        // 353
  '€': 'euro',                                                                                                        // 354
  '©' :'copy',                                                                                                        // 355
  '®' : 'reg',                                                                                                        // 356
  '<' : 'lt',                                                                                                         // 357
  '>' : 'gt',                                                                                                         // 358
  '"' : 'quot',                                                                                                       // 359
  '&' : 'amp',                                                                                                        // 360
  "'": '#39'                                                                                                          // 361
};                                                                                                                    // 362
                                                                                                                      // 363
module.exports = escapeChars;                                                                                         // 364
                                                                                                                      // 365
},{}],19:[function(_dereq_,module,exports){                                                                           // 366
var makeString = _dereq_('./makeString');                                                                             // 367
                                                                                                                      // 368
module.exports = function escapeRegExp(str) {                                                                         // 369
  return makeString(str).replace(/([.*+?^=!:${}()|[\]\/\\])/g, '\\$1');                                               // 370
};                                                                                                                    // 371
                                                                                                                      // 372
},{"./makeString":21}],20:[function(_dereq_,module,exports){                                                          // 373
/*                                                                                                                    // 374
We're explicitly defining the list of entities that might see in escape HTML strings                                  // 375
*/                                                                                                                    // 376
var htmlEntities = {                                                                                                  // 377
  nbsp: ' ',                                                                                                          // 378
  cent: '¢',                                                                                                          // 379
  pound: '£',                                                                                                         // 380
  yen: '¥',                                                                                                           // 381
  euro: '€',                                                                                                          // 382
  copy: '©',                                                                                                          // 383
  reg: '®',                                                                                                           // 384
  lt: '<',                                                                                                            // 385
  gt: '>',                                                                                                            // 386
  quot: '"',                                                                                                          // 387
  amp: '&',                                                                                                           // 388
  apos: "'"                                                                                                           // 389
};                                                                                                                    // 390
                                                                                                                      // 391
module.exports = htmlEntities;                                                                                        // 392
                                                                                                                      // 393
},{}],21:[function(_dereq_,module,exports){                                                                           // 394
/**                                                                                                                   // 395
 * Ensure some object is a coerced to a string                                                                        // 396
 **/                                                                                                                  // 397
module.exports = function makeString(object) {                                                                        // 398
  if (object == null) return '';                                                                                      // 399
  return '' + object;                                                                                                 // 400
};                                                                                                                    // 401
                                                                                                                      // 402
},{}],22:[function(_dereq_,module,exports){                                                                           // 403
module.exports = function strRepeat(str, qty){                                                                        // 404
  if (qty < 1) return '';                                                                                             // 405
  var result = '';                                                                                                    // 406
  while (qty > 0) {                                                                                                   // 407
    if (qty & 1) result += str;                                                                                       // 408
    qty >>= 1, str += str;                                                                                            // 409
  }                                                                                                                   // 410
  return result;                                                                                                      // 411
};                                                                                                                    // 412
                                                                                                                      // 413
},{}],23:[function(_dereq_,module,exports){                                                                           // 414
module.exports = function toPositive(number) {                                                                        // 415
  return number < 0 ? 0 : (+number || 0);                                                                             // 416
};                                                                                                                    // 417
                                                                                                                      // 418
},{}],24:[function(_dereq_,module,exports){                                                                           // 419
var capitalize = _dereq_('./capitalize');                                                                             // 420
var underscored = _dereq_('./underscored');                                                                           // 421
var trim = _dereq_('./trim');                                                                                         // 422
                                                                                                                      // 423
module.exports = function humanize(str) {                                                                             // 424
  return capitalize(trim(underscored(str).replace(/_id$/, '').replace(/_/g, ' ')));                                   // 425
};                                                                                                                    // 426
                                                                                                                      // 427
},{"./capitalize":2,"./trim":62,"./underscored":64}],25:[function(_dereq_,module,exports){                            // 428
var makeString = _dereq_('./helper/makeString');                                                                      // 429
                                                                                                                      // 430
module.exports = function include(str, needle) {                                                                      // 431
  if (needle === '') return true;                                                                                     // 432
  return makeString(str).indexOf(needle) !== -1;                                                                      // 433
};                                                                                                                    // 434
                                                                                                                      // 435
},{"./helper/makeString":21}],26:[function(_dereq_,module,exports){                                                   // 436
var splice = _dereq_('./splice');                                                                                     // 437
                                                                                                                      // 438
module.exports = function insert(str, i, substr) {                                                                    // 439
  return splice(str, i, 0, substr);                                                                                   // 440
};                                                                                                                    // 441
                                                                                                                      // 442
},{"./splice":46}],27:[function(_dereq_,module,exports){                                                              // 443
var makeString = _dereq_('./helper/makeString');                                                                      // 444
                                                                                                                      // 445
module.exports = function isBlank(str) {                                                                              // 446
  return (/^\s*$/).test(makeString(str));                                                                             // 447
};                                                                                                                    // 448
                                                                                                                      // 449
},{"./helper/makeString":21}],28:[function(_dereq_,module,exports){                                                   // 450
var makeString = _dereq_('./helper/makeString');                                                                      // 451
var slice = [].slice;                                                                                                 // 452
                                                                                                                      // 453
module.exports = function join() {                                                                                    // 454
  var args = slice.call(arguments),                                                                                   // 455
    separator = args.shift();                                                                                         // 456
                                                                                                                      // 457
  return args.join(makeString(separator));                                                                            // 458
};                                                                                                                    // 459
                                                                                                                      // 460
},{"./helper/makeString":21}],29:[function(_dereq_,module,exports){                                                   // 461
var makeString = _dereq_('./helper/makeString');                                                                      // 462
                                                                                                                      // 463
/**                                                                                                                   // 464
 * Based on the implementation here: https://github.com/hiddentao/fast-levenshtein                                    // 465
 */                                                                                                                   // 466
module.exports = function levenshtein(str1, str2) {                                                                   // 467
  'use strict';                                                                                                       // 468
  str1 = makeString(str1);                                                                                            // 469
  str2 = makeString(str2);                                                                                            // 470
                                                                                                                      // 471
  // Short cut cases                                                                                                  // 472
  if (str1 === str2) return 0;                                                                                        // 473
  if (!str1 || !str2) return Math.max(str1.length, str2.length);                                                      // 474
                                                                                                                      // 475
  // two rows                                                                                                         // 476
  var prevRow = new Array(str2.length + 1);                                                                           // 477
                                                                                                                      // 478
  // initialise previous row                                                                                          // 479
  for (var i = 0; i < prevRow.length; ++i) {                                                                          // 480
    prevRow[i] = i;                                                                                                   // 481
  }                                                                                                                   // 482
                                                                                                                      // 483
  // calculate current row distance from previous row                                                                 // 484
  for (i = 0; i < str1.length; ++i) {                                                                                 // 485
    var nextCol = i + 1;                                                                                              // 486
                                                                                                                      // 487
    for (var j = 0; j < str2.length; ++j) {                                                                           // 488
      var curCol = nextCol;                                                                                           // 489
                                                                                                                      // 490
      // substution                                                                                                   // 491
      nextCol = prevRow[j] + ( (str1.charAt(i) === str2.charAt(j)) ? 0 : 1 );                                         // 492
      // insertion                                                                                                    // 493
      var tmp = curCol + 1;                                                                                           // 494
      if (nextCol > tmp) {                                                                                            // 495
        nextCol = tmp;                                                                                                // 496
      }                                                                                                               // 497
      // deletion                                                                                                     // 498
      tmp = prevRow[j + 1] + 1;                                                                                       // 499
      if (nextCol > tmp) {                                                                                            // 500
        nextCol = tmp;                                                                                                // 501
      }                                                                                                               // 502
                                                                                                                      // 503
      // copy current col value into previous (in preparation for next iteration)                                     // 504
      prevRow[j] = curCol;                                                                                            // 505
    }                                                                                                                 // 506
                                                                                                                      // 507
    // copy last col value into previous (in preparation for next iteration)                                          // 508
    prevRow[j] = nextCol;                                                                                             // 509
  }                                                                                                                   // 510
                                                                                                                      // 511
  return nextCol;                                                                                                     // 512
};                                                                                                                    // 513
                                                                                                                      // 514
},{"./helper/makeString":21}],30:[function(_dereq_,module,exports){                                                   // 515
module.exports = function lines(str) {                                                                                // 516
  if (str == null) return [];                                                                                         // 517
  return String(str).split(/\r\n?|\n/);                                                                               // 518
};                                                                                                                    // 519
                                                                                                                      // 520
},{}],31:[function(_dereq_,module,exports){                                                                           // 521
var pad = _dereq_('./pad');                                                                                           // 522
                                                                                                                      // 523
module.exports = function lpad(str, length, padStr) {                                                                 // 524
  return pad(str, length, padStr);                                                                                    // 525
};                                                                                                                    // 526
                                                                                                                      // 527
},{"./pad":36}],32:[function(_dereq_,module,exports){                                                                 // 528
var pad = _dereq_('./pad');                                                                                           // 529
                                                                                                                      // 530
module.exports = function lrpad(str, length, padStr) {                                                                // 531
  return pad(str, length, padStr, 'both');                                                                            // 532
};                                                                                                                    // 533
                                                                                                                      // 534
},{"./pad":36}],33:[function(_dereq_,module,exports){                                                                 // 535
var makeString = _dereq_('./helper/makeString');                                                                      // 536
var defaultToWhiteSpace = _dereq_('./helper/defaultToWhiteSpace');                                                    // 537
var nativeTrimLeft = String.prototype.trimLeft;                                                                       // 538
                                                                                                                      // 539
module.exports = function ltrim(str, characters) {                                                                    // 540
  str = makeString(str);                                                                                              // 541
  if (!characters && nativeTrimLeft) return nativeTrimLeft.call(str);                                                 // 542
  characters = defaultToWhiteSpace(characters);                                                                       // 543
  return str.replace(new RegExp('^' + characters + '+'), '');                                                         // 544
};                                                                                                                    // 545
                                                                                                                      // 546
},{"./helper/defaultToWhiteSpace":17,"./helper/makeString":21}],34:[function(_dereq_,module,exports){                 // 547
module.exports = function naturalCmp(str1, str2) {                                                                    // 548
  if (str1 == str2) return 0;                                                                                         // 549
  if (!str1) return -1;                                                                                               // 550
  if (!str2) return 1;                                                                                                // 551
                                                                                                                      // 552
  var cmpRegex = /(\.\d+|\d+|\D+)/g,                                                                                  // 553
    tokens1 = String(str1).match(cmpRegex),                                                                           // 554
    tokens2 = String(str2).match(cmpRegex),                                                                           // 555
    count = Math.min(tokens1.length, tokens2.length);                                                                 // 556
                                                                                                                      // 557
  for (var i = 0; i < count; i++) {                                                                                   // 558
    var a = tokens1[i],                                                                                               // 559
      b = tokens2[i];                                                                                                 // 560
                                                                                                                      // 561
    if (a !== b) {                                                                                                    // 562
      var num1 = +a;                                                                                                  // 563
      var num2 = +b;                                                                                                  // 564
      if (num1 === num1 && num2 === num2) {                                                                           // 565
        return num1 > num2 ? 1 : -1;                                                                                  // 566
      }                                                                                                               // 567
      return a < b ? -1 : 1;                                                                                          // 568
    }                                                                                                                 // 569
  }                                                                                                                   // 570
                                                                                                                      // 571
  if (tokens1.length != tokens2.length)                                                                               // 572
    return tokens1.length - tokens2.length;                                                                           // 573
                                                                                                                      // 574
  return str1 < str2 ? -1 : 1;                                                                                        // 575
};                                                                                                                    // 576
                                                                                                                      // 577
},{}],35:[function(_dereq_,module,exports){                                                                           // 578
module.exports = function numberFormat(number, dec, dsep, tsep) {                                                     // 579
  if (isNaN(number) || number == null) return '';                                                                     // 580
                                                                                                                      // 581
  number = number.toFixed(~~dec);                                                                                     // 582
  tsep = typeof tsep == 'string' ? tsep : ',';                                                                        // 583
                                                                                                                      // 584
  var parts = number.split('.'),                                                                                      // 585
    fnums = parts[0],                                                                                                 // 586
    decimals = parts[1] ? (dsep || '.') + parts[1] : '';                                                              // 587
                                                                                                                      // 588
  return fnums.replace(/(\d)(?=(?:\d{3})+$)/g, '$1' + tsep) + decimals;                                               // 589
};                                                                                                                    // 590
                                                                                                                      // 591
},{}],36:[function(_dereq_,module,exports){                                                                           // 592
var makeString = _dereq_('./helper/makeString');                                                                      // 593
var strRepeat = _dereq_('./helper/strRepeat');                                                                        // 594
                                                                                                                      // 595
module.exports = function pad(str, length, padStr, type) {                                                            // 596
  str = makeString(str);                                                                                              // 597
  length = ~~length;                                                                                                  // 598
                                                                                                                      // 599
  var padlen = 0;                                                                                                     // 600
                                                                                                                      // 601
  if (!padStr)                                                                                                        // 602
    padStr = ' ';                                                                                                     // 603
  else if (padStr.length > 1)                                                                                         // 604
    padStr = padStr.charAt(0);                                                                                        // 605
                                                                                                                      // 606
  switch (type) {                                                                                                     // 607
    case 'right':                                                                                                     // 608
      padlen = length - str.length;                                                                                   // 609
      return str + strRepeat(padStr, padlen);                                                                         // 610
    case 'both':                                                                                                      // 611
      padlen = length - str.length;                                                                                   // 612
      return strRepeat(padStr, Math.ceil(padlen / 2)) + str + strRepeat(padStr, Math.floor(padlen / 2));              // 613
    default: // 'left'                                                                                                // 614
      padlen = length - str.length;                                                                                   // 615
      return strRepeat(padStr, padlen) + str;                                                                         // 616
  }                                                                                                                   // 617
};                                                                                                                    // 618
                                                                                                                      // 619
},{"./helper/makeString":21,"./helper/strRepeat":22}],37:[function(_dereq_,module,exports){                           // 620
var adjacent = _dereq_('./helper/adjacent');                                                                          // 621
                                                                                                                      // 622
module.exports = function succ(str) {                                                                                 // 623
  return adjacent(str, -1);                                                                                           // 624
};                                                                                                                    // 625
                                                                                                                      // 626
},{"./helper/adjacent":16}],38:[function(_dereq_,module,exports){                                                     // 627
/**                                                                                                                   // 628
 * _s.prune: a more elegant version of truncate                                                                       // 629
 * prune extra chars, never leaving a half-chopped word.                                                              // 630
 * @author github.com/rwz                                                                                             // 631
 */                                                                                                                   // 632
var makeString = _dereq_('./helper/makeString');                                                                      // 633
var rtrim = _dereq_('./rtrim');                                                                                       // 634
                                                                                                                      // 635
module.exports = function prune(str, length, pruneStr) {                                                              // 636
  str = makeString(str);                                                                                              // 637
  length = ~~length;                                                                                                  // 638
  pruneStr = pruneStr != null ? String(pruneStr) : '...';                                                             // 639
                                                                                                                      // 640
  if (str.length <= length) return str;                                                                               // 641
                                                                                                                      // 642
  var tmpl = function(c) {                                                                                            // 643
    return c.toUpperCase() !== c.toLowerCase() ? 'A' : ' ';                                                           // 644
  },                                                                                                                  // 645
    template = str.slice(0, length + 1).replace(/.(?=\W*\w*$)/g, tmpl); // 'Hello, world' -> 'HellAA AAAAA'           // 646
                                                                                                                      // 647
  if (template.slice(template.length - 2).match(/\w\w/))                                                              // 648
    template = template.replace(/\s*\S+$/, '');                                                                       // 649
  else                                                                                                                // 650
    template = rtrim(template.slice(0, template.length - 1));                                                         // 651
                                                                                                                      // 652
  return (template + pruneStr).length > str.length ? str : str.slice(0, template.length) + pruneStr;                  // 653
};                                                                                                                    // 654
                                                                                                                      // 655
},{"./helper/makeString":21,"./rtrim":44}],39:[function(_dereq_,module,exports){                                      // 656
var surround = _dereq_('./surround');                                                                                 // 657
                                                                                                                      // 658
module.exports = function quote(str, quoteChar) {                                                                     // 659
  return surround(str, quoteChar || '"');                                                                             // 660
};                                                                                                                    // 661
                                                                                                                      // 662
},{"./surround":55}],40:[function(_dereq_,module,exports){                                                            // 663
var makeString = _dereq_('./helper/makeString');                                                                      // 664
var strRepeat = _dereq_('./helper/strRepeat');                                                                        // 665
                                                                                                                      // 666
module.exports = function repeat(str, qty, separator) {                                                               // 667
  str = makeString(str);                                                                                              // 668
                                                                                                                      // 669
  qty = ~~qty;                                                                                                        // 670
                                                                                                                      // 671
  // using faster implementation if separator is not needed;                                                          // 672
  if (separator == null) return strRepeat(str, qty);                                                                  // 673
                                                                                                                      // 674
  // this one is about 300x slower in Google Chrome                                                                   // 675
  for (var repeat = []; qty > 0; repeat[--qty] = str) {}                                                              // 676
  return repeat.join(separator);                                                                                      // 677
};                                                                                                                    // 678
                                                                                                                      // 679
},{"./helper/makeString":21,"./helper/strRepeat":22}],41:[function(_dereq_,module,exports){                           // 680
var makeString = _dereq_('./helper/makeString');                                                                      // 681
                                                                                                                      // 682
module.exports = function replaceAll(str, find, replace, ignorecase) {                                                // 683
  var flags = (ignorecase === true)?'gi':'g';                                                                         // 684
  var reg = new RegExp(find, flags);                                                                                  // 685
                                                                                                                      // 686
  return makeString(str).replace(reg, replace);                                                                       // 687
};                                                                                                                    // 688
                                                                                                                      // 689
},{"./helper/makeString":21}],42:[function(_dereq_,module,exports){                                                   // 690
var chars = _dereq_('./chars');                                                                                       // 691
                                                                                                                      // 692
module.exports = function reverse(str) {                                                                              // 693
  return chars(str).reverse().join('');                                                                               // 694
};                                                                                                                    // 695
                                                                                                                      // 696
},{"./chars":3}],43:[function(_dereq_,module,exports){                                                                // 697
var pad = _dereq_('./pad');                                                                                           // 698
                                                                                                                      // 699
module.exports = function rpad(str, length, padStr) {                                                                 // 700
  return pad(str, length, padStr, 'right');                                                                           // 701
};                                                                                                                    // 702
                                                                                                                      // 703
},{"./pad":36}],44:[function(_dereq_,module,exports){                                                                 // 704
var makeString = _dereq_('./helper/makeString');                                                                      // 705
var defaultToWhiteSpace = _dereq_('./helper/defaultToWhiteSpace');                                                    // 706
var nativeTrimRight = String.prototype.trimRight;                                                                     // 707
                                                                                                                      // 708
module.exports = function rtrim(str, characters) {                                                                    // 709
  str = makeString(str);                                                                                              // 710
  if (!characters && nativeTrimRight) return nativeTrimRight.call(str);                                               // 711
  characters = defaultToWhiteSpace(characters);                                                                       // 712
  return str.replace(new RegExp(characters + '+$'), '');                                                              // 713
};                                                                                                                    // 714
                                                                                                                      // 715
},{"./helper/defaultToWhiteSpace":17,"./helper/makeString":21}],45:[function(_dereq_,module,exports){                 // 716
var makeString = _dereq_('./helper/makeString');                                                                      // 717
var defaultToWhiteSpace = _dereq_('./helper/defaultToWhiteSpace');                                                    // 718
var trim = _dereq_('./trim');                                                                                         // 719
var dasherize = _dereq_('./dasherize');                                                                               // 720
var cleanDiacritics = _dereq_("./cleanDiacritics");                                                                   // 721
                                                                                                                      // 722
module.exports = function slugify(str) {                                                                              // 723
  return trim(dasherize(cleanDiacritics(str).replace(/[^\w\s-]/g, '-')), '-');                                        // 724
};                                                                                                                    // 725
                                                                                                                      // 726
},{"./cleanDiacritics":7,"./dasherize":9,"./helper/defaultToWhiteSpace":17,"./helper/makeString":21,"./trim":62}],46:[function(_dereq_,module,exports){
var chars = _dereq_('./chars');                                                                                       // 728
                                                                                                                      // 729
module.exports = function splice(str, i, howmany, substr) {                                                           // 730
  var arr = chars(str);                                                                                               // 731
  arr.splice(~~i, ~~howmany, substr);                                                                                 // 732
  return arr.join('');                                                                                                // 733
};                                                                                                                    // 734
                                                                                                                      // 735
},{"./chars":3}],47:[function(_dereq_,module,exports){                                                                // 736
// sprintf() for JavaScript 0.7-beta1                                                                                 // 737
// http://www.diveintojavascript.com/projects/javascript-sprintf                                                      // 738
//                                                                                                                    // 739
// Copyright (c) Alexandru Marasteanu <alexaholic [at) gmail (dot] com>                                               // 740
// All rights reserved.                                                                                               // 741
var strRepeat = _dereq_('./helper/strRepeat');                                                                        // 742
var toString = Object.prototype.toString;                                                                             // 743
var sprintf = (function() {                                                                                           // 744
  function get_type(variable) {                                                                                       // 745
    return toString.call(variable).slice(8, -1).toLowerCase();                                                        // 746
  }                                                                                                                   // 747
                                                                                                                      // 748
  var str_repeat = strRepeat;                                                                                         // 749
                                                                                                                      // 750
  var str_format = function() {                                                                                       // 751
    if (!str_format.cache.hasOwnProperty(arguments[0])) {                                                             // 752
      str_format.cache[arguments[0]] = str_format.parse(arguments[0]);                                                // 753
    }                                                                                                                 // 754
    return str_format.format.call(null, str_format.cache[arguments[0]], arguments);                                   // 755
  };                                                                                                                  // 756
                                                                                                                      // 757
  str_format.format = function(parse_tree, argv) {                                                                    // 758
    var cursor = 1, tree_length = parse_tree.length, node_type = '', arg, output = [], i, k, match, pad, pad_character, pad_length;
    for (i = 0; i < tree_length; i++) {                                                                               // 760
      node_type = get_type(parse_tree[i]);                                                                            // 761
      if (node_type === 'string') {                                                                                   // 762
        output.push(parse_tree[i]);                                                                                   // 763
      }                                                                                                               // 764
      else if (node_type === 'array') {                                                                               // 765
        match = parse_tree[i]; // convenience purposes only                                                           // 766
        if (match[2]) { // keyword argument                                                                           // 767
          arg = argv[cursor];                                                                                         // 768
          for (k = 0; k < match[2].length; k++) {                                                                     // 769
            if (!arg.hasOwnProperty(match[2][k])) {                                                                   // 770
              throw new Error(sprintf('[_.sprintf] property "%s" does not exist', match[2][k]));                      // 771
            }                                                                                                         // 772
            arg = arg[match[2][k]];                                                                                   // 773
          }                                                                                                           // 774
        } else if (match[1]) { // positional argument (explicit)                                                      // 775
          arg = argv[match[1]];                                                                                       // 776
        }                                                                                                             // 777
        else { // positional argument (implicit)                                                                      // 778
          arg = argv[cursor++];                                                                                       // 779
        }                                                                                                             // 780
                                                                                                                      // 781
        if (/[^s]/.test(match[8]) && (get_type(arg) != 'number')) {                                                   // 782
          throw new Error(sprintf('[_.sprintf] expecting number but found %s', get_type(arg)));                       // 783
        }                                                                                                             // 784
        switch (match[8]) {                                                                                           // 785
          case 'b': arg = arg.toString(2); break;                                                                     // 786
          case 'c': arg = String.fromCharCode(arg); break;                                                            // 787
          case 'd': arg = parseInt(arg, 10); break;                                                                   // 788
          case 'e': arg = match[7] ? arg.toExponential(match[7]) : arg.toExponential(); break;                        // 789
          case 'f': arg = match[7] ? parseFloat(arg).toFixed(match[7]) : parseFloat(arg); break;                      // 790
          case 'o': arg = arg.toString(8); break;                                                                     // 791
          case 's': arg = ((arg = String(arg)) && match[7] ? arg.substring(0, match[7]) : arg); break;                // 792
          case 'u': arg = Math.abs(arg); break;                                                                       // 793
          case 'x': arg = arg.toString(16); break;                                                                    // 794
          case 'X': arg = arg.toString(16).toUpperCase(); break;                                                      // 795
        }                                                                                                             // 796
        arg = (/[def]/.test(match[8]) && match[3] && arg >= 0 ? '+'+ arg : arg);                                      // 797
        pad_character = match[4] ? match[4] == '0' ? '0' : match[4].charAt(1) : ' ';                                  // 798
        pad_length = match[6] - String(arg).length;                                                                   // 799
        pad = match[6] ? str_repeat(pad_character, pad_length) : '';                                                  // 800
        output.push(match[5] ? arg + pad : pad + arg);                                                                // 801
      }                                                                                                               // 802
    }                                                                                                                 // 803
    return output.join('');                                                                                           // 804
  };                                                                                                                  // 805
                                                                                                                      // 806
  str_format.cache = {};                                                                                              // 807
                                                                                                                      // 808
  str_format.parse = function(fmt) {                                                                                  // 809
    var _fmt = fmt, match = [], parse_tree = [], arg_names = 0;                                                       // 810
    while (_fmt) {                                                                                                    // 811
      if ((match = /^[^\x25]+/.exec(_fmt)) !== null) {                                                                // 812
        parse_tree.push(match[0]);                                                                                    // 813
      }                                                                                                               // 814
      else if ((match = /^\x25{2}/.exec(_fmt)) !== null) {                                                            // 815
        parse_tree.push('%');                                                                                         // 816
      }                                                                                                               // 817
      else if ((match = /^\x25(?:([1-9]\d*)\$|\(([^\)]+)\))?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosuxX])/.exec(_fmt)) !== null) {
        if (match[2]) {                                                                                               // 819
          arg_names |= 1;                                                                                             // 820
          var field_list = [], replacement_field = match[2], field_match = [];                                        // 821
          if ((field_match = /^([a-z_][a-z_\d]*)/i.exec(replacement_field)) !== null) {                               // 822
            field_list.push(field_match[1]);                                                                          // 823
            while ((replacement_field = replacement_field.substring(field_match[0].length)) !== '') {                 // 824
              if ((field_match = /^\.([a-z_][a-z_\d]*)/i.exec(replacement_field)) !== null) {                         // 825
                field_list.push(field_match[1]);                                                                      // 826
              }                                                                                                       // 827
              else if ((field_match = /^\[(\d+)\]/.exec(replacement_field)) !== null) {                               // 828
                field_list.push(field_match[1]);                                                                      // 829
              }                                                                                                       // 830
              else {                                                                                                  // 831
                throw new Error('[_.sprintf] huh?');                                                                  // 832
              }                                                                                                       // 833
            }                                                                                                         // 834
          }                                                                                                           // 835
          else {                                                                                                      // 836
            throw new Error('[_.sprintf] huh?');                                                                      // 837
          }                                                                                                           // 838
          match[2] = field_list;                                                                                      // 839
        }                                                                                                             // 840
        else {                                                                                                        // 841
          arg_names |= 2;                                                                                             // 842
        }                                                                                                             // 843
        if (arg_names === 3) {                                                                                        // 844
          throw new Error('[_.sprintf] mixing positional and named placeholders is not (yet) supported');             // 845
        }                                                                                                             // 846
        parse_tree.push(match);                                                                                       // 847
      }                                                                                                               // 848
      else {                                                                                                          // 849
        throw new Error('[_.sprintf] huh?');                                                                          // 850
      }                                                                                                               // 851
      _fmt = _fmt.substring(match[0].length);                                                                         // 852
    }                                                                                                                 // 853
    return parse_tree;                                                                                                // 854
  };                                                                                                                  // 855
                                                                                                                      // 856
  return str_format;                                                                                                  // 857
})();                                                                                                                 // 858
                                                                                                                      // 859
module.exports = sprintf;                                                                                             // 860
                                                                                                                      // 861
},{"./helper/strRepeat":22}],48:[function(_dereq_,module,exports){                                                    // 862
var makeString = _dereq_('./helper/makeString');                                                                      // 863
var toPositive = _dereq_('./helper/toPositive');                                                                      // 864
                                                                                                                      // 865
module.exports = function startsWith(str, starts, position) {                                                         // 866
  str = makeString(str);                                                                                              // 867
  starts = '' + starts;                                                                                               // 868
  position = position == null ? 0 : Math.min(toPositive(position), str.length);                                       // 869
  return str.lastIndexOf(starts, position) === position;                                                              // 870
};                                                                                                                    // 871
                                                                                                                      // 872
},{"./helper/makeString":21,"./helper/toPositive":23}],49:[function(_dereq_,module,exports){                          // 873
var makeString = _dereq_('./helper/makeString');                                                                      // 874
                                                                                                                      // 875
module.exports = function strLeft(str, sep) {                                                                         // 876
  str = makeString(str);                                                                                              // 877
  sep = makeString(sep);                                                                                              // 878
  var pos = !sep ? -1 : str.indexOf(sep);                                                                             // 879
  return~ pos ? str.slice(0, pos) : str;                                                                              // 880
};                                                                                                                    // 881
                                                                                                                      // 882
},{"./helper/makeString":21}],50:[function(_dereq_,module,exports){                                                   // 883
var makeString = _dereq_('./helper/makeString');                                                                      // 884
                                                                                                                      // 885
module.exports = function strLeftBack(str, sep) {                                                                     // 886
  str = makeString(str);                                                                                              // 887
  sep = makeString(sep);                                                                                              // 888
  var pos = str.lastIndexOf(sep);                                                                                     // 889
  return~ pos ? str.slice(0, pos) : str;                                                                              // 890
};                                                                                                                    // 891
                                                                                                                      // 892
},{"./helper/makeString":21}],51:[function(_dereq_,module,exports){                                                   // 893
var makeString = _dereq_('./helper/makeString');                                                                      // 894
                                                                                                                      // 895
module.exports = function strRight(str, sep) {                                                                        // 896
  str = makeString(str);                                                                                              // 897
  sep = makeString(sep);                                                                                              // 898
  var pos = !sep ? -1 : str.indexOf(sep);                                                                             // 899
  return~ pos ? str.slice(pos + sep.length, str.length) : str;                                                        // 900
};                                                                                                                    // 901
                                                                                                                      // 902
},{"./helper/makeString":21}],52:[function(_dereq_,module,exports){                                                   // 903
var makeString = _dereq_('./helper/makeString');                                                                      // 904
                                                                                                                      // 905
module.exports = function strRightBack(str, sep) {                                                                    // 906
  str = makeString(str);                                                                                              // 907
  sep = makeString(sep);                                                                                              // 908
  var pos = !sep ? -1 : str.lastIndexOf(sep);                                                                         // 909
  return~ pos ? str.slice(pos + sep.length, str.length) : str;                                                        // 910
};                                                                                                                    // 911
                                                                                                                      // 912
},{"./helper/makeString":21}],53:[function(_dereq_,module,exports){                                                   // 913
var makeString = _dereq_('./helper/makeString');                                                                      // 914
                                                                                                                      // 915
module.exports = function stripTags(str) {                                                                            // 916
  return makeString(str).replace(/<\/?[^>]+>/g, '');                                                                  // 917
};                                                                                                                    // 918
                                                                                                                      // 919
},{"./helper/makeString":21}],54:[function(_dereq_,module,exports){                                                   // 920
var adjacent = _dereq_('./helper/adjacent');                                                                          // 921
                                                                                                                      // 922
module.exports = function succ(str) {                                                                                 // 923
  return adjacent(str, 1);                                                                                            // 924
};                                                                                                                    // 925
                                                                                                                      // 926
},{"./helper/adjacent":16}],55:[function(_dereq_,module,exports){                                                     // 927
module.exports = function surround(str, wrapper) {                                                                    // 928
  return [wrapper, str, wrapper].join('');                                                                            // 929
};                                                                                                                    // 930
                                                                                                                      // 931
},{}],56:[function(_dereq_,module,exports){                                                                           // 932
var makeString = _dereq_('./helper/makeString');                                                                      // 933
                                                                                                                      // 934
module.exports = function swapCase(str) {                                                                             // 935
  return makeString(str).replace(/\S/g, function(c) {                                                                 // 936
    return c === c.toUpperCase() ? c.toLowerCase() : c.toUpperCase();                                                 // 937
  });                                                                                                                 // 938
};                                                                                                                    // 939
                                                                                                                      // 940
},{"./helper/makeString":21}],57:[function(_dereq_,module,exports){                                                   // 941
var makeString = _dereq_('./helper/makeString');                                                                      // 942
                                                                                                                      // 943
module.exports = function titleize(str) {                                                                             // 944
  return makeString(str).toLowerCase().replace(/(?:^|\s|-)\S/g, function(c) {                                         // 945
    return c.toUpperCase();                                                                                           // 946
  });                                                                                                                 // 947
};                                                                                                                    // 948
                                                                                                                      // 949
},{"./helper/makeString":21}],58:[function(_dereq_,module,exports){                                                   // 950
var trim = _dereq_('./trim');                                                                                         // 951
                                                                                                                      // 952
function boolMatch(s, matchers) {                                                                                     // 953
  var i, matcher, down = s.toLowerCase();                                                                             // 954
  matchers = [].concat(matchers);                                                                                     // 955
  for (i = 0; i < matchers.length; i += 1) {                                                                          // 956
    matcher = matchers[i];                                                                                            // 957
    if (!matcher) continue;                                                                                           // 958
    if (matcher.test && matcher.test(s)) return true;                                                                 // 959
    if (matcher.toLowerCase() === down) return true;                                                                  // 960
  }                                                                                                                   // 961
}                                                                                                                     // 962
                                                                                                                      // 963
module.exports = function toBoolean(str, trueValues, falseValues) {                                                   // 964
  if (typeof str === "number") str = "" + str;                                                                        // 965
  if (typeof str !== "string") return !!str;                                                                          // 966
  str = trim(str);                                                                                                    // 967
  if (boolMatch(str, trueValues || ["true", "1"])) return true;                                                       // 968
  if (boolMatch(str, falseValues || ["false", "0"])) return false;                                                    // 969
};                                                                                                                    // 970
                                                                                                                      // 971
},{"./trim":62}],59:[function(_dereq_,module,exports){                                                                // 972
var trim = _dereq_('./trim');                                                                                         // 973
                                                                                                                      // 974
module.exports = function toNumber(num, precision) {                                                                  // 975
  if (num == null) return 0;                                                                                          // 976
  var factor = Math.pow(10, isFinite(precision) ? precision : 0);                                                     // 977
  return Math.round(num * factor) / factor;                                                                           // 978
};                                                                                                                    // 979
                                                                                                                      // 980
},{"./trim":62}],60:[function(_dereq_,module,exports){                                                                // 981
var rtrim = _dereq_('./rtrim');                                                                                       // 982
                                                                                                                      // 983
module.exports = function toSentence(array, separator, lastSeparator, serial) {                                       // 984
  separator = separator || ', ';                                                                                      // 985
  lastSeparator = lastSeparator || ' and ';                                                                           // 986
  var a = array.slice(),                                                                                              // 987
    lastMember = a.pop();                                                                                             // 988
                                                                                                                      // 989
  if (array.length > 2 && serial) lastSeparator = rtrim(separator) + lastSeparator;                                   // 990
                                                                                                                      // 991
  return a.length ? a.join(separator) + lastSeparator + lastMember : lastMember;                                      // 992
};                                                                                                                    // 993
                                                                                                                      // 994
},{"./rtrim":44}],61:[function(_dereq_,module,exports){                                                               // 995
var toSentence = _dereq_('./toSentence');                                                                             // 996
                                                                                                                      // 997
module.exports = function toSentenceSerial(array, sep, lastSep) {                                                     // 998
  return toSentence(array, sep, lastSep, true);                                                                       // 999
};                                                                                                                    // 1000
                                                                                                                      // 1001
},{"./toSentence":60}],62:[function(_dereq_,module,exports){                                                          // 1002
var makeString = _dereq_('./helper/makeString');                                                                      // 1003
var defaultToWhiteSpace = _dereq_('./helper/defaultToWhiteSpace');                                                    // 1004
var nativeTrim = String.prototype.trim;                                                                               // 1005
                                                                                                                      // 1006
module.exports = function trim(str, characters) {                                                                     // 1007
  str = makeString(str);                                                                                              // 1008
  if (!characters && nativeTrim) return nativeTrim.call(str);                                                         // 1009
  characters = defaultToWhiteSpace(characters);                                                                       // 1010
  return str.replace(new RegExp('^' + characters + '+|' + characters + '+$', 'g'), '');                               // 1011
};                                                                                                                    // 1012
                                                                                                                      // 1013
},{"./helper/defaultToWhiteSpace":17,"./helper/makeString":21}],63:[function(_dereq_,module,exports){                 // 1014
var makeString = _dereq_('./helper/makeString');                                                                      // 1015
                                                                                                                      // 1016
module.exports = function truncate(str, length, truncateStr) {                                                        // 1017
  str = makeString(str);                                                                                              // 1018
  truncateStr = truncateStr || '...';                                                                                 // 1019
  length = ~~length;                                                                                                  // 1020
  return str.length > length ? str.slice(0, length) + truncateStr : str;                                              // 1021
};                                                                                                                    // 1022
                                                                                                                      // 1023
},{"./helper/makeString":21}],64:[function(_dereq_,module,exports){                                                   // 1024
var trim = _dereq_('./trim');                                                                                         // 1025
                                                                                                                      // 1026
module.exports = function underscored(str) {                                                                          // 1027
  return trim(str).replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/[-\s]+/g, '_').toLowerCase();                      // 1028
};                                                                                                                    // 1029
                                                                                                                      // 1030
},{"./trim":62}],65:[function(_dereq_,module,exports){                                                                // 1031
var makeString = _dereq_('./helper/makeString');                                                                      // 1032
var htmlEntities = _dereq_('./helper/htmlEntities');                                                                  // 1033
                                                                                                                      // 1034
module.exports = function unescapeHTML(str) {                                                                         // 1035
  return makeString(str).replace(/\&([^;]+);/g, function(entity, entityCode) {                                        // 1036
    var match;                                                                                                        // 1037
                                                                                                                      // 1038
    if (entityCode in htmlEntities) {                                                                                 // 1039
      return htmlEntities[entityCode];                                                                                // 1040
    } else if (match = entityCode.match(/^#x([\da-fA-F]+)$/)) {                                                       // 1041
      return String.fromCharCode(parseInt(match[1], 16));                                                             // 1042
    } else if (match = entityCode.match(/^#(\d+)$/)) {                                                                // 1043
      return String.fromCharCode(~~match[1]);                                                                         // 1044
    } else {                                                                                                          // 1045
      return entity;                                                                                                  // 1046
    }                                                                                                                 // 1047
  });                                                                                                                 // 1048
};                                                                                                                    // 1049
                                                                                                                      // 1050
},{"./helper/htmlEntities":20,"./helper/makeString":21}],66:[function(_dereq_,module,exports){                        // 1051
module.exports = function unquote(str, quoteChar) {                                                                   // 1052
  quoteChar = quoteChar || '"';                                                                                       // 1053
  if (str[0] === quoteChar && str[str.length - 1] === quoteChar)                                                      // 1054
    return str.slice(1, str.length - 1);                                                                              // 1055
  else return str;                                                                                                    // 1056
};                                                                                                                    // 1057
                                                                                                                      // 1058
},{}],67:[function(_dereq_,module,exports){                                                                           // 1059
var sprintf = _dereq_('./sprintf');                                                                                   // 1060
                                                                                                                      // 1061
module.exports = function vsprintf(fmt, argv) {                                                                       // 1062
  argv.unshift(fmt);                                                                                                  // 1063
  return sprintf.apply(null, argv);                                                                                   // 1064
};                                                                                                                    // 1065
                                                                                                                      // 1066
},{"./sprintf":47}],68:[function(_dereq_,module,exports){                                                             // 1067
var isBlank = _dereq_('./isBlank');                                                                                   // 1068
var trim = _dereq_('./trim');                                                                                         // 1069
                                                                                                                      // 1070
module.exports = function words(str, delimiter) {                                                                     // 1071
  if (isBlank(str)) return [];                                                                                        // 1072
  return trim(str, delimiter).split(delimiter || /\s+/);                                                              // 1073
};                                                                                                                    // 1074
                                                                                                                      // 1075
},{"./isBlank":27,"./trim":62}],69:[function(_dereq_,module,exports){                                                 // 1076
// Wrap                                                                                                               // 1077
// wraps a string by a certain width                                                                                  // 1078
                                                                                                                      // 1079
makeString = _dereq_('./helper/makeString');                                                                          // 1080
                                                                                                                      // 1081
module.exports = function wrap(str, options){                                                                         // 1082
	str = makeString(str);                                                                                               // 1083
                                                                                                                      // 1084
	options = options || {};                                                                                             // 1085
                                                                                                                      // 1086
	width = options.width || 75;                                                                                         // 1087
	seperator = options.seperator || '\n';                                                                               // 1088
	cut = options.cut || false;                                                                                          // 1089
	preserveSpaces = options.preserveSpaces || false;                                                                    // 1090
	trailingSpaces = options.trailingSpaces || false;                                                                    // 1091
                                                                                                                      // 1092
	if(width <= 0){                                                                                                      // 1093
		return str;                                                                                                         // 1094
	}                                                                                                                    // 1095
                                                                                                                      // 1096
	else if(!cut){                                                                                                       // 1097
                                                                                                                      // 1098
		words = str.split(" ");                                                                                             // 1099
		result = "";                                                                                                        // 1100
		current_column = 0;                                                                                                 // 1101
                                                                                                                      // 1102
		while(words.length > 0){                                                                                            // 1103
			                                                                                                                   // 1104
			// if adding a space and the next word would cause this line to be longer than width...                            // 1105
			if(1 + words[0].length + current_column > width){                                                                  // 1106
				//start a new line if this line is not already empty                                                              // 1107
				if(current_column > 0){                                                                                           // 1108
					// add a space at the end of the line is preserveSpaces is true                                                  // 1109
					if (preserveSpaces){                                                                                             // 1110
						result += ' ';                                                                                                  // 1111
						current_column++;                                                                                               // 1112
					}                                                                                                                // 1113
					// fill the rest of the line with spaces if trailingSpaces option is true                                        // 1114
					else if(trailingSpaces){                                                                                         // 1115
						while(current_column < width){                                                                                  // 1116
							result += ' ';                                                                                                 // 1117
							current_column++;                                                                                              // 1118
						}						                                                                                                         // 1119
					}                                                                                                                // 1120
					//start new line                                                                                                 // 1121
					result += seperator;                                                                                             // 1122
					current_column = 0;                                                                                              // 1123
				}                                                                                                                 // 1124
			}                                                                                                                  // 1125
                                                                                                                      // 1126
			// if not at the begining of the line, add a space in front of the word                                            // 1127
			if(current_column > 0){                                                                                            // 1128
				result += " ";                                                                                                    // 1129
				current_column++;                                                                                                 // 1130
			}                                                                                                                  // 1131
                                                                                                                      // 1132
			// tack on the next word, update current column, a pop words array                                                 // 1133
			result += words[0];                                                                                                // 1134
			current_column += words[0].length;                                                                                 // 1135
			words.shift();                                                                                                     // 1136
                                                                                                                      // 1137
		}                                                                                                                   // 1138
                                                                                                                      // 1139
		// fill the rest of the line with spaces if trailingSpaces option is true                                           // 1140
		if(trailingSpaces){                                                                                                 // 1141
			while(current_column < width){                                                                                     // 1142
				result += ' ';                                                                                                    // 1143
				current_column++;                                                                                                 // 1144
			}						                                                                                                            // 1145
		}                                                                                                                   // 1146
                                                                                                                      // 1147
		return result;                                                                                                      // 1148
                                                                                                                      // 1149
	}                                                                                                                    // 1150
                                                                                                                      // 1151
	else {                                                                                                               // 1152
                                                                                                                      // 1153
		index = 0;                                                                                                          // 1154
		result = "";                                                                                                        // 1155
                                                                                                                      // 1156
		// walk through each character and add seperators where appropriate                                                 // 1157
		while(index < str.length){                                                                                          // 1158
			if(index % width == 0 && index > 0){                                                                               // 1159
				result += seperator;                                                                                              // 1160
			}                                                                                                                  // 1161
			result += str.charAt(index);                                                                                       // 1162
			index++;                                                                                                           // 1163
		}                                                                                                                   // 1164
                                                                                                                      // 1165
		// fill the rest of the line with spaces if trailingSpaces option is true                                           // 1166
		if(trailingSpaces){                                                                                                 // 1167
			while(index % width > 0){                                                                                          // 1168
				result += ' ';                                                                                                    // 1169
				index++;                                                                                                          // 1170
			}						                                                                                                            // 1171
		}                                                                                                                   // 1172
		                                                                                                                    // 1173
		return result;                                                                                                      // 1174
	}                                                                                                                    // 1175
};                                                                                                                    // 1176
},{"./helper/makeString":21}]},{},[15])                                                                               // 1177
(15)                                                                                                                  // 1178
});                                                                                                                   // 1179
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                     // 1213
}).call(this);                                                       // 1214
                                                                     // 1215
                                                                     // 1216
                                                                     // 1217
                                                                     // 1218
                                                                     // 1219
                                                                     // 1220
(function () {                                                       // 1221
                                                                     // 1222
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/underscorestring:underscore.string/meteor-post.js                                                         //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
// s will be picked up by Meteor and exported                                                                         // 1
s = module.exports;                                                                                                   // 2
                                                                                                                      // 3
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                     // 1233
}).call(this);                                                       // 1234
                                                                     // 1235
///////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['underscorestring:underscore.string'] = {
  s: s
};

})();
