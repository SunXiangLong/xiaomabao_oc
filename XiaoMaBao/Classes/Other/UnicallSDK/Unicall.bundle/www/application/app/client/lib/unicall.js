(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/lib/unicall.js                                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by Junwei on 15/12/4.                                       //
 */                                                                    //
(function () {                                                         // 4
    this.Tools = (function () {                                        // 5
        function Tools() {}                                            // 6
                                                                       //
        Tools.prototype.getUrlParameterByName = function (name) {      // 8
            var regex, results;                                        // 9
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            regex = new RegExp("[\\?&]" + name + "=([^&#]*)");         // 11
            var searchPath = location.search;                          // 12
            if (searchPath !== undefined && searchPath !== null) {     // 13
                if (searchPath === '') {                               // 14
                    searchPath = location.href.substring(location.href.indexOf('?'));
                }                                                      //
            }                                                          //
            results = regex.exec(searchPath);                          // 18
            if (results) {                                             // 19
                return decodeURIComponent(results[1].replace(/\+/g, " "));
            } else {                                                   //
                return "";                                             // 22
            }                                                          //
        };                                                             //
                                                                       //
        Tools.prototype.parseUrl = function (url) {                    // 26
            var reURLInformation;                                      // 27
            reURLInformation = new RegExp(['^(https?:)//', '(([^:/?#]*)(?::([0-9]+))?)', '(/[^?#]*)', '(\\?[^#]*|)', '(#.*|)$'].join(''));
            return reURLInformation.exec(url);                         // 29
        };                                                             //
                                                                       //
        Tools.prototype.getPath = function () {                        // 32
            return this.parseUrl(Meteor.absoluteUrl())[5];             // 33
        };                                                             //
                                                                       //
        return Tools;                                                  // 36
    })();                                                              //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);
