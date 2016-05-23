(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/views/rating.js                                              //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by Junwei on 16/4/25.                                       //
 */                                                                    //
                                                                       //
Template.rating.helpers({                                              // 5
  'showBack': function () {                                            // 6
    FlowRouter.watchPathChange();                                      // 7
    var close = FlowRouter.current().queryParams.close || 'agent';     // 8
    if (close == 'visitor') {                                          // 9
      return true;                                                     // 10
    }                                                                  //
  },                                                                   //
  'title': function () {                                               // 13
    return Meteor.settings['public'].tenant_livechat_settings.chatTitle;
  },                                                                   //
  'introMsg': function () {                                            // 16
    FlowRouter.watchPathChange();                                      // 17
    var close = FlowRouter.current().queryParams.close || 'agent';     // 18
    return close === 'visitor' ? Meteor.settings['public'].tenant_livechat_settings.surveyByVisitor : Meteor.settings['public'].tenant_livechat_settings.surveyByAgent;
  }                                                                    //
});                                                                    //
                                                                       //
var submitRating = function (rating) {                                 // 23
  var tenantId = Meteor.settings['public'].tenant_livechat_settings.tenantId || '';
  Meteor.call("saveSatisfaction", {                                    // 25
    channelId: "webchat",                                              // 26
    tenantId: tenantId,                                                // 27
    messageId: visitor.getRoom(),                                      // 28
    surveyResult: rating                                               // 29
  }, function (error, result) {                                        //
    if (rating) {                                                      // 31
      FlowRouter.go('result', { type: 'livechat' }, { status: result });
    }                                                                  //
  });                                                                  //
};                                                                     //
                                                                       //
//回调解决直接关闭房间会重新建房间导致BUG                                                //
var doRating = function (rating, callback) {                           // 38
  if (FlowRouter.current().queryParams.close == 'visitor') {           // 39
    Session.set("whoEndMsg", "visitor");                               // 40
    Meteor.call("visitorHideRoom", visitor.getRoom(), function (error, result) {
      submitRating(rating);                                            // 42
      if (typeof callback == 'function') {                             // 43
        callback();                                                    // 44
      }                                                                //
    });                                                                //
  } else {                                                             //
    submitRating(rating);                                              // 48
    if (typeof callback == 'function') {                               // 49
      callback();                                                      // 50
    }                                                                  //
  }                                                                    //
};                                                                     //
                                                                       //
Template.rating.events({                                               // 55
  'submit .rating-form': function (event) {                            // 56
    event.preventDefault();                                            // 57
    var rating = $('[name="rating"]:checked').val();                   // 58
    //如果访客主动关闭,先服务端关闭房间再提交.                                            //
    doRating(rating);                                                  // 60
  }                                                                    //
});                                                                    //
                                                                       //
Template.pageHeader.events({                                           // 64
  'click .btn-close': function (event) {                               // 65
    event.preventDefault();                                            // 66
    //如果是访客关闭的,要关闭房间.                                                  //
    doRating('', function () {                                         // 68
      visitor.ticketOrLivechat();                                      // 69
    });                                                                //
  }                                                                    //
});                                                                    //
/////////////////////////////////////////////////////////////////////////

}).call(this);
