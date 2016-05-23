(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/views/ticket.js                                              //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
Template.ticket.helpers({                                              // 1
  isValid: function () {                                               // 2
    if (Session.get('ticket_invalid')) {                               // 3
      return 'show';                                                   // 4
    }                                                                  //
  },                                                                   //
  'title': function () {                                               // 7
    return Meteor.settings['public'].tenant_livechat_settings.ticketTitle;
  }                                                                    //
});                                                                    //
Template.ticket.events({                                               // 11
  "submit .ticket-form": function (event) {                            // 12
    event.preventDefault();                                            // 13
    var target = event.target;                                         // 14
    if (!event.target.checkValidity()) {                               // 15
      Session.set('ticket_invalid', true);                             // 16
    } else {                                                           //
      Session.set('ticket_invalid', false);                            // 18
      var tenantId = Meteor.settings['public'].tenant_livechat_settings.tenantId || '';
      var data = {                                                     // 20
        tenantId: tenantId,                                            // 21
        content: target.messages.value,                                // 22
        name: target.name.value,                                       // 23
        phone: target.phone.value,                                     // 24
        appKey: Meteor.settings['public'].tenant_livechat_settings.appKey,
        appName: Meteor.settings['public'].tenant_livechat_settings.appName,
        apiSource: 'ios',                                              // 27
        source: ''                                                     // 28
      };                                                               //
      Meteor.call("sendMessageToEmail", data, function (error, result) {
        FlowRouter.go('result', { type: 'ticket' }, { status: result });
      });                                                              //
    }                                                                  //
  }                                                                    //
});                                                                    //
/////////////////////////////////////////////////////////////////////////

}).call(this);
