(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/cordova/app.js                                               //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by Junwei on 16/4/12.                                       //
 */                                                                    //
if (Meteor.isCordova) {                                                // 4
  document.addEventListener('deviceready', function () {               // 5
    //设置键盘禁止滚动                                                         //
    if (device.platform.toLowerCase() !== 'android' && cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.disableScroll(true);                    // 8
    }                                                                  //
                                                                       //
    window.addEventListener('native.keyboardshow', function () {       // 11
      if (device.platform.toLowerCase() !== 'android') {               // 12
        $(".livechat-room").animate({ "height": window.innerHeight }, 200);
        //$('.ticket .content').height(window.innerHeight);  #TODO 真机存在BUG,临时不启用
        //$('.ticket .ticket-messages').height('22%');                 //
      }                                                                //
    });                                                                //
    window.addEventListener('native.keyboardhide', function () {       // 18
      if (device.platform.toLowerCase() !== 'android') {               // 19
        $(".livechat-room").animate({ "height": window.innerHeight }, 200);
        //$('.ticket .content').height(window.innerHeight);            //
        //$('.ticket .ticket-messages').height('55%');                 //
      }                                                                //
    });                                                                //
  });                                                                  //
}                                                                      //
/////////////////////////////////////////////////////////////////////////

}).call(this);
