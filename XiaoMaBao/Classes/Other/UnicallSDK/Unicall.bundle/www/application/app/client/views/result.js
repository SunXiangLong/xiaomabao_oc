(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/views/result.js                                              //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by Junwei on 16/4/25.                                       //
 */                                                                    //
var settings = {                                                       // 4
  introMsg: {                                                          // 5
    ticket: {                                                          // 6
      "true": '留言已经提交成功!\n我们会认真处理您的留言',                                // 7
      "false": '留言失败'                                                  // 8
    },                                                                 //
    livechat: {                                                        // 10
      "true": '您的评价已提交!\n感谢您对我的真诚评价',                                  // 11
      "false": '评价失败'                                                  // 12
    }                                                                  //
  }                                                                    //
};                                                                     //
                                                                       //
Template.result.helpers({                                              // 17
  showBack: function () {                                              // 18
    return false;                                                      // 19
  },                                                                   //
  showClose: function () {                                             // 21
    return false;                                                      // 22
  },                                                                   //
  title: function () {                                                 // 24
    var titles = {                                                     // 25
      ticket: Meteor.settings["public"].tenant_livechat_settings.ticketTitle,
      livechat: Meteor.settings["public"].tenant_livechat_settings.chatTitle
    };                                                                 //
    return titles[FlowRouter.current().params.type];                   // 29
  },                                                                   //
  status: function () {                                                // 31
    if (FlowRouter.current().queryParams.status == 'true') {           // 32
      return 'icon-check';                                             // 33
    } else {                                                           //
      return 'icon-close';                                             // 35
    }                                                                  //
  },                                                                   //
  introMsg: function () {                                              // 38
    var current = FlowRouter.current();                                // 39
    return settings.introMsg[current.params.type][current.queryParams.status];
  }                                                                    //
});                                                                    //
Template.result.events({                                               // 43
  'click .btn-confirm': function (event) {                             // 44
    event.preventDefault();                                            // 45
    Session.set("hasSendMsg", false);                                  // 46
    outerAgent.closeWindow();                                          // 47
    visitor.ticketOrLivechat();                                        // 48
  }                                                                    //
});                                                                    //
/////////////////////////////////////////////////////////////////////////

}).call(this);
