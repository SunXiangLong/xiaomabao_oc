cordova.define("cordova-plugin-unicall-app.UnicallAppInfo", function(require, exports, module) { /**
 * Created by lil on 16/4/7.
 */

var exec = require('cordova/exec');
var Dispatcher = function(){
    var List = function(){
        var u=[];
        this.add=function(l){
            for(var i in u){
                if(l === u[i])
                    return;//duplicate callback
            }
            u[u.length] = l;
        }
        this.remove=function(l){
            var _u = [];
            for(var i in u){
                if(l !== u[i])
                    _u[_u.length] = u[i];
            }
            u =_u;
        }
        this.forEach =function(func){
            for(var i in u){
                func(u[i]);
            }
        }
    }
    var funcMap = {};
    var fire = function(e){
        if(funcMap[e.type]){
            var callbacks = [];
            funcMap[e.type].forEach(function(l){
                callbacks[callbacks.length] = l;
            });
            for(var i in callbacks){
                try{
                    callbacks[i](e.msg);
                }catch(e){
                    console.log(e);
                }

            }
        }
    }
    this.addEventListener = function(type,callback){
        if(callback === undefined || callback === null || typeof callback !== 'function')
            return;
        type = type.toLowerCase();
        if(funcMap[type] === undefined || funcMap[type] === null)
            funcMap[type] = new List;
        funcMap[type].add(callback)
    };
    this.removeEventListener = function(type,callback){
        if(callback === undefined || callback === null)
            return;
        type = type.toLowerCase();
        if(funcMap[type])
            funcMap[type].remove(callback)
    };
    this.dispatchEvent = function(onType,msg){
        var type = onType.toLowerCase();
        if(type.substring(0,2).toLowerCase() === 'on' )
            type = type.substring(2);
        var event = {
            type:type,
            msg:msg
        }
        fire(event)
    };
};
var cordovaEventDispatcher = new Dispatcher;

var onMessage= function(message){
    cordovaEventDispatcher.dispatchEvent(message.type,message.payload)
};
var onFail=function(err){
    console.log(err);
};
module.exports = {

    /**
     * Get an object with the keys 'version', 'build' and 'identifier'.
     *
     * @param {Function} success    Callback method called on success.
     * @param {Function} fail       Callback method called on failure.
     */
    initial: function(){
        exec(onMessage, onFail, 'UnicallAppInfo', 'initializePlugin', []);
    },
    sendMessage:function(tp,msg){
        var msg={
            type:tp,
            payload:(msg||{})
        };
        exec(null, null, 'UnicallAppInfo', 'dispatchEvent2APP', [msg]);
    },
    addEventListener:function(type ,callback){
        cordovaEventDispatcher.addEventListener(type ,callback);
    },
    removeEventListener:function(type ,callback){
        cordovaEventDispatcher.removeEventListener(type ,callback);
    }
};

});
