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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
// packages/tomwasd_flow-router-ie8/packages/tomwasd_flow-router-ie8.js                                             //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                    //
(function () {                                                                                                      // 1
                                                                                                                    // 2
///////////////////////////////////////////////////////////////////////////////////////////////////////////////     // 3
//                                                                                                           //     // 4
// packages/tomwasd:flow-router-ie8/polyfills.js                                                             //     // 5
//                                                                                                           //     // 6
///////////////////////////////////////////////////////////////////////////////////////////////////////////////     // 7
                                                                                                             //     // 8
// Events polyfill                                                                                           // 1   // 9
// Reference: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener                  // 2   // 10
// Window.prototype.addEventListener and Window.prototype.removeEVentListener changed to:                    // 3   // 11
// Window.constructor.prototype.addEventListener and Window.constructor.prototype.removeEventListener        // 4   // 12
// due to error in IE8                                                                                       // 5   // 13
(function() {                                                                                                // 6   // 14
  if (!Event.prototype.preventDefault) {                                                                     // 7   // 15
    Event.prototype.preventDefault=function() {                                                              // 8   // 16
      this.returnValue=false;                                                                                // 9   // 17
    };                                                                                                       // 10  // 18
  }                                                                                                          // 11  // 19
  if (!Event.prototype.stopPropagation) {                                                                    // 12  // 20
    Event.prototype.stopPropagation=function() {                                                             // 13  // 21
      this.cancelBubble=true;                                                                                // 14  // 22
    };                                                                                                       // 15  // 23
  }                                                                                                          // 16  // 24
  if (!Element.prototype.addEventListener) {                                                                 // 17  // 25
    var eventListeners=[];                                                                                   // 18  // 26
                                                                                                             // 19  // 27
    var addEventListener=function(type,listener /*, useCapture (will be ignored) */) {                       // 20  // 28
      var self=this;                                                                                         // 21  // 29
      var wrapper=function(e) {                                                                              // 22  // 30
        e.target=e.srcElement;                                                                               // 23  // 31
        e.currentTarget=self;                                                                                // 24  // 32
        if (listener.handleEvent) {                                                                          // 25  // 33
          listener.handleEvent(e);                                                                           // 26  // 34
        } else {                                                                                             // 27  // 35
          listener.call(self,e);                                                                             // 28  // 36
        }                                                                                                    // 29  // 37
      };                                                                                                     // 30  // 38
      if (type=="DOMContentLoaded") {                                                                        // 31  // 39
        var wrapper2=function(e) {                                                                           // 32  // 40
          if (document.readyState=="complete") {                                                             // 33  // 41
            wrapper(e);                                                                                      // 34  // 42
          }                                                                                                  // 35  // 43
        };                                                                                                   // 36  // 44
        document.attachEvent("onreadystatechange",wrapper2);                                                 // 37  // 45
        eventListeners.push({object:this,type:type,listener:listener,wrapper:wrapper2});                     // 38  // 46
                                                                                                             // 39  // 47
        if (document.readyState=="complete") {                                                               // 40  // 48
          var e=new Event();                                                                                 // 41  // 49
          e.srcElement=window;                                                                               // 42  // 50
          wrapper2(e);                                                                                       // 43  // 51
        }                                                                                                    // 44  // 52
      } else {                                                                                               // 45  // 53
        this.attachEvent("on"+type,wrapper);                                                                 // 46  // 54
        eventListeners.push({object:this,type:type,listener:listener,wrapper:wrapper});                      // 47  // 55
      }                                                                                                      // 48  // 56
    };                                                                                                       // 49  // 57
    var removeEventListener=function(type,listener /*, useCapture (will be ignored) */) {                    // 50  // 58
      var counter=0;                                                                                         // 51  // 59
      while (counter<eventListeners.length) {                                                                // 52  // 60
        var eventListener=eventListeners[counter];                                                           // 53  // 61
        if (eventListener.object==this && eventListener.type==type && eventListener.listener==listener) {    // 54  // 62
          if (type=="DOMContentLoaded") {                                                                    // 55  // 63
            this.detachEvent("onreadystatechange",eventListener.wrapper);                                    // 56  // 64
          } else {                                                                                           // 57  // 65
            this.detachEvent("on"+type,eventListener.wrapper);                                               // 58  // 66
          }                                                                                                  // 59  // 67
          eventListeners.splice(counter, 1);                                                                 // 60  // 68
          break;                                                                                             // 61  // 69
        }                                                                                                    // 62  // 70
        ++counter;                                                                                           // 63  // 71
      }                                                                                                      // 64  // 72
    };                                                                                                       // 65  // 73
    Element.prototype.addEventListener=addEventListener;                                                     // 66  // 74
    Element.prototype.removeEventListener=removeEventListener;                                               // 67  // 75
    if (HTMLDocument) {                                                                                      // 68  // 76
      HTMLDocument.prototype.addEventListener=addEventListener;                                              // 69  // 77
      HTMLDocument.prototype.removeEventListener=removeEventListener;                                        // 70  // 78
    }                                                                                                        // 71  // 79
    if (Window) {                                                                                            // 72  // 80
      Window.constructor.prototype.addEventListener=addEventListener;                                        // 73  // 81
      Window.constructor.prototype.removeEventListener=removeEventListener;                                  // 74  // 82
    }                                                                                                        // 75  // 83
  }                                                                                                          // 76  // 84
})();                                                                                                        // 77  // 85
                                                                                                             // 78  // 86
// forEach polyfill                                                                                          // 79  // 87
// Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach // 80  // 88
                                                                                                             // 81  // 89
if (!Array.prototype.forEach) {                                                                              // 82  // 90
                                                                                                             // 83  // 91
  Array.prototype.forEach = function(callback, thisArg) {                                                    // 84  // 92
                                                                                                             // 85  // 93
    var T, k;                                                                                                // 86  // 94
                                                                                                             // 87  // 95
    if (this == null) {                                                                                      // 88  // 96
      throw new TypeError(' this is null or not defined');                                                   // 89  // 97
    }                                                                                                        // 90  // 98
                                                                                                             // 91  // 99
    // 1. Let O be the result of calling ToObject passing the |this| value as the argument.                  // 92  // 100
    var O = Object(this);                                                                                    // 93  // 101
                                                                                                             // 94  // 102
    // 2. Let lenValue be the result of calling the Get internal method of O with the argument "length".     // 95  // 103
    // 3. Let len be ToUint32(lenValue).                                                                     // 96  // 104
    var len = O.length >>> 0;                                                                                // 97  // 105
                                                                                                             // 98  // 106
    // 4. If IsCallable(callback) is false, throw a TypeError exception.                                     // 99  // 107
    // See: http://es5.github.com/#x9.11                                                                     // 100
    if (typeof callback !== "function") {                                                                    // 101
      throw new TypeError(callback + ' is not a function');                                                  // 102
    }                                                                                                        // 103
                                                                                                             // 104
    // 5. If thisArg was supplied, let T be thisArg; else let T be undefined.                                // 105
    if (arguments.length > 1) {                                                                              // 106
      T = thisArg;                                                                                           // 107
    }                                                                                                        // 108
                                                                                                             // 109
    // 6. Let k be 0                                                                                         // 110
    k = 0;                                                                                                   // 111
                                                                                                             // 112
    // 7. Repeat, while k < len                                                                              // 113
    while (k < len) {                                                                                        // 114
                                                                                                             // 115
      var kValue;                                                                                            // 116
                                                                                                             // 117
      // a. Let Pk be ToString(k).                                                                           // 118
      //   This is implicit for LHS operands of the in operator                                              // 119
      // b. Let kPresent be the result of calling the HasProperty internal method of O with argument Pk.     // 120
      //   This step can be combined with c                                                                  // 121
      // c. If kPresent is true, then                                                                        // 122
      if (k in O) {                                                                                          // 123
                                                                                                             // 124
        // i. Let kValue be the result of calling the Get internal method of O with argument Pk.             // 125
        kValue = O[k];                                                                                       // 126
                                                                                                             // 127
        // ii. Call the Call internal method of callback with T as the this value and                        // 128
        // argument list containing kValue, k, and O.                                                        // 129
        callback.call(T, kValue, k, O);                                                                      // 130
      }                                                                                                      // 131
      // d. Increase k by 1.                                                                                 // 132
      k++;                                                                                                   // 133
    }                                                                                                        // 134
    // 8. return undefined                                                                                   // 135
  };                                                                                                         // 136
}                                                                                                            // 137
                                                                                                             // 138
// Object.create polyfill                                                                                    // 139
// Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/create // 140
                                                                                                             // 141
if (typeof Object.create != 'function') {                                                                    // 142
  // Production steps of ECMA-262, Edition 5, 15.2.3.5                                                       // 143
  // Reference: http://es5.github.io/#x15.2.3.5                                                              // 144
  Object.create = (function() {                                                                              // 145
    // To save on memory, use a shared constructor                                                           // 146
    function Temp() {}                                                                                       // 147
                                                                                                             // 148
    // make a safe reference to Object.prototype.hasOwnProperty                                              // 149
    var hasOwn = Object.prototype.hasOwnProperty;                                                            // 150
                                                                                                             // 151
    return function (O) {                                                                                    // 152
      // 1. If Type(O) is not Object or Null throw a TypeError exception.                                    // 153
      if (typeof O != 'object') {                                                                            // 154
        throw TypeError('Object prototype may only be an Object or null');                                   // 155
      }                                                                                                      // 156
                                                                                                             // 157
      // 2. Let obj be the result of creating a new object as if by the                                      // 158
      //    expression new Object() where Object is the standard built-in                                    // 159
      //    constructor with that name                                                                       // 160
      // 3. Set the [[Prototype]] internal property of obj to O.                                             // 161
      Temp.prototype = O;                                                                                    // 162
      var obj = new Temp();                                                                                  // 163
      Temp.prototype = null; // Let's not keep a stray reference to O...                                     // 164
                                                                                                             // 165
      // 4. If the argument Properties is present and not undefined, add                                     // 166
      //    own properties to obj as if by calling the standard built-in                                     // 167
      //    function Object.defineProperties with arguments obj and                                          // 168
      //    Properties.                                                                                      // 169
      if (arguments.length > 1) {                                                                            // 170
        // Object.defineProperties does ToObject on its first argument.                                      // 171
        var Properties = Object(arguments[1]);                                                               // 172
        for (var prop in Properties) {                                                                       // 173
          if (hasOwn.call(Properties, prop)) {                                                               // 174
            obj[prop] = Properties[prop];                                                                    // 175
          }                                                                                                  // 176
        }                                                                                                    // 177
      }                                                                                                      // 178
                                                                                                             // 179
      // 5. Return obj                                                                                       // 180
      return obj;                                                                                            // 181
    };                                                                                                       // 182
  })();                                                                                                      // 183
}                                                                                                            // 184
                                                                                                             // 185
// isArray polyfill                                                                                          // 186
// Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/isArray // 187
if (!Array.isArray) {                                                                                        // 188
  Array.isArray = function(arg) {                                                                            // 189
    return Object.prototype.toString.call(arg) === '[object Array]';                                         // 190
  };                                                                                                         // 191
}                                                                                                            // 192
                                                                                                             // 193
// Object.keys polyfill                                                                                      // 194
// Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/keys   // 195
if (!Object.keys) {                                                                                          // 196
  Object.keys = (function() {                                                                                // 197
    'use strict';                                                                                            // 198
    var hasOwnProperty = Object.prototype.hasOwnProperty,                                                    // 199
        hasDontEnumBug = !({ toString: null }).propertyIsEnumerable('toString'),                             // 200
        dontEnums = [                                                                                        // 201
          'toString',                                                                                        // 202
          'toLocaleString',                                                                                  // 203
          'valueOf',                                                                                         // 204
          'hasOwnProperty',                                                                                  // 205
          'isPrototypeOf',                                                                                   // 206
          'propertyIsEnumerable',                                                                            // 207
          'constructor'                                                                                      // 208
        ],                                                                                                   // 209
        dontEnumsLength = dontEnums.length;                                                                  // 210
                                                                                                             // 211
    return function(obj) {                                                                                   // 212
      if (typeof obj !== 'object' && (typeof obj !== 'function' || obj === null)) {                          // 213
        throw new TypeError('Object.keys called on non-object');                                             // 214
      }                                                                                                      // 215
                                                                                                             // 216
      var result = [], prop, i;                                                                              // 217
                                                                                                             // 218
      for (prop in obj) {                                                                                    // 219
        if (hasOwnProperty.call(obj, prop)) {                                                                // 220
          result.push(prop);                                                                                 // 221
        }                                                                                                    // 222
      }                                                                                                      // 223
                                                                                                             // 224
      if (hasDontEnumBug) {                                                                                  // 225
        for (i = 0; i < dontEnumsLength; i++) {                                                              // 226
          if (hasOwnProperty.call(obj, dontEnums[i])) {                                                      // 227
            result.push(dontEnums[i]);                                                                       // 228
          }                                                                                                  // 229
        }                                                                                                    // 230
      }                                                                                                      // 231
      return result;                                                                                         // 232
    };                                                                                                       // 233
  }());                                                                                                      // 234
}                                                                                                            // 235
///////////////////////////////////////////////////////////////////////////////////////////////////////////////     // 244
                                                                                                                    // 245
}).call(this);                                                                                                      // 246
                                                                                                                    // 247
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
if (typeof Package === 'undefined') Package = {};
Package['tomwasd:flow-router-ie8'] = {};

})();
