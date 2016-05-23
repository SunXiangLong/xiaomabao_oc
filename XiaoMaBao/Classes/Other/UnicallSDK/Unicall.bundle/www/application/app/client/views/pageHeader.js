(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/views/pageHeader.js                                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by Junwei on 16/4/25.                                       //
 */                                                                    //
Template.pageHeader.helpers({                                          // 4
  bgColor: function () {                                               // 5
    return Meteor.settings['public'].tenant_livechat_settings.backgroundColor;
  },                                                                   //
  fontColor: function () {                                             // 8
    return Meteor.settings['public'].tenant_livechat_settings.fontColor;
  }                                                                    //
});                                                                    //
                                                                       //
Template.pageHeader.events({                                           // 13
  'click .btn-return': function (event) {                              // 14
    event.preventDefault();                                            // 15
    var current = FlowRouter.current();                                // 16
    if (current.route.name == 'rating') {                              // 17
      history.go(-1);                                                  // 18
    } else {                                                           //
      outerAgent.toggleWindow();                                       // 20
    }                                                                  //
  },                                                                   //
  'click .btn-close': function (event) {                               // 23
    event.preventDefault();                                            // 24
    var current = FlowRouter.current();                                // 25
    //聊天中,关闭去到评价.                                                      //
    if (current.route.name == 'index' && visitor.getRoom() && Session.get("hasSendMsg")) {
      FlowRouter.go('/rating?close=visitor');                          // 28
    } else if (current.route.name == 'rating') {                       //
      Session.set("hasSendMsg", false);                                // 30
      outerAgent.closeWindow();                                        // 31
    } else {                                                           //
      visitor.ticketOrLivechat();                                      // 34
      Session.set("hasSendMsg", false);                                // 35
      outerAgent.closeWindow();                                        // 36
    }                                                                  //
  }                                                                    //
});                                                                    //
/////////////////////////////////////////////////////////////////////////

}).call(this);
