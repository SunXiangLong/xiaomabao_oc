(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/startup/settings.js                                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
/**                                                                    //
 * Created by lil on 16/4/7.                                           //
 */                                                                    //
(function () {                                                         // 4
  Meteor.startup(function () {                                         // 5
    if (Meteor.isCordova) {                                            // 6
      Meteor.settings = Meteor.settings || {};                         // 7
      Meteor.settings["public"] = Meteor.settings["public"] || {};     // 8
      Meteor.settings["public"].tenant_livechat_settings = Meteor.settings["public"].tenant_livechat_settings || { "mini-title-text": "您需要帮助吗?", "chat-title-text": "开始聊天", "ticket-title-text": "欢迎留言", "title-bg-color": "#434a50", "title-font-color": "#FFF", "display-model": "border" };
      outerAgent.registerCallbackOnLivechatReady(function (appInfo) {  // 10
        Meteor.call('load-app-setting', appInfo.tenantId, appInfo.appKey, function (err, res) {
          if (err) {                                                   // 12
            console.log(err);                                          // 13
          } else {                                                     //
            if (Meteor.settings["public"].tenant_livechat_settings) Meteor.settings["public"].tenant_livechat_settings = res.settings;
            Meteor.settings["public"].unicallAppKey = appInfo.appKey;  // 17
            if (res.hasOperator === true) {                            // 18
              FlowRouter.go('index', null, { tenant_id: btoa(appInfo.tenantId) });
            } else {                                                   //
              FlowRouter.go('ticket', null, { tenant_id: btoa(appInfo.tenantId) });
            }                                                          //
          }                                                            //
        });                                                            //
      });                                                              //
      outerAgent.registerCallbackOnSignReady(function (accessInfo) {   // 26
        accessInfo.tenantId;                                           // 27
        accessInfo.appKey;                                             // 28
        accessInfo.signature;                                          // 29
        accessInfo.time;                                               // 30
        accessInfo.expireTime;                                         // 31
        Meteor.call('verify-app-agent', accessInfo, function (err, res) {
          if (err) {                                                   // 33
            outerAgent.signACK({ success: false });                    // 34
          } else {                                                     //
            outerAgent.signACK(res);                                   // 36
          }                                                            //
        });                                                            //
      });                                                              //
      outerAgent.registerCallbackOnToggleWindow(function () {          // 40
        if (FlowRouter.getRouteName() === 'ticket') {                  // 41
          Meteor.call('load-active-agent-count', Meteor.settings["public"].tenant_livechat_settings.tenantId, function (error, result) {
            if (result && result > 0) {                                // 43
              FlowRouter.go('index', null, { tenant_id: btoa(Meteor.settings["public"].tenant_livechat_settings.tenantId) });
            }                                                          //
          });                                                          //
        }                                                              //
      });                                                              //
      outerAgent.registerCallbackOnUserInfo(function (userInfo) {      // 49
        //暂时放在前台处理,今后应该避免前台存储                                          //
        //Meteor.settings.public.appUsername = userInfo.nickname||'';  //
        Meteor.settings["public"].appUsername = userInfo.nickname || '';
        if (Meteor.user()) {                                           // 53
          Meteor.call('update-visitor-name', userInfo.nickname, function (err, result) {
            console.log(err);                                          // 55
          });                                                          //
        } else {                                                       //
          outerAgent.cacheUniqueUserInfo(userInfo);                    // 58
        }                                                              //
      });                                                              //
      outerAgent.registerCallbackOnUserInterest(function (userInterest) {
        userInterest.iconUrl;                                          // 62
        userInterest.url;                                              // 63
        userInterest.title;                                            // 64
        userInterest.desc;                                             // 65
        outerAgent.cacheUniqueSystemMessage({                          // 66
          msg: userInterest.title || '',                               // 67
          type: "merchandise",                                         // 68
          token: visitor.getToken(),                                   // 69
          clientType: Meteor.isCordova ? device.platform : 'webchat',  // 70
          data: {                                                      // 71
            iconUrl: userInterest.iconUrl,                             // 72
            url: userInterest.url,                                     // 73
            title: userInterest.title,                                 // 74
            content: userInterest.desc                                 // 75
          }                                                            //
        });                                                            //
      });                                                              //
      if (Meteor.settings["public"].DevTenantId) {                     // 79
        ////workbench接收签名请求                                            //
        outerAgent.addEventListener('serverSign', function (data) {    // 81
          /*@"signature": __signature_at_backend_server__,             //
           @"appKey":__app_key__,                                      //
           @"tenantId":tenantId};UnicallAppInfo937486515*/             //
          Meteor.call('sign-app-agent', data.appKey, function (err, res) {
            if (err) {                                                 // 86
              console.log(err);                                        // 87
            } else {                                                   //
              var sign = res;                                          // 89
              outerAgent.sendMessage('serverSign', { appKey: data.appKey, tenantId: data.tenantId, sign: sign });
            }                                                          //
          });                                                          //
        });                                                            //
      }                                                                //
      //ready之前需要trigger register                                      //
      visitor.register();                                              // 96
      outerAgent.ready();                                              // 97
      if (Meteor.settings["public"].DevTenantId) {                     // 98
        outerAgent.sendMessage('Mock ServerSign', { appKey: "d1d5d65c-27b5-407c-9773-30f383162afe", tenantId: Meteor.settings["public"].DevTenantId });
      }                                                                //
      //outerAgent.mock.sendUserInterest({iconUrl:"123",url:"456",title:'你好',desc:"描述123"});
      /*var agent = getUnicallAppInfoAgent();                          //
      agent.registerCallbackOnSignReady(function(info){                //
        /!*@"signature": __signature_at_backend_server__,              //
         @"appKey":__app_key__,                                        //
         @"tenantId":tenantId};UnicallAppInfo937486515*!/              //
        Meteor.call('verify-app-agent',info,function(err,res){         //
          if(err){                                                     //
            outerAgent.signACK({success:false});                       //
          }else{                                                       //
            outerAgent.signACK({success:true});                        //
            if(Meteor.settings.public.tenant_livechat_settings)        //
              Meteor.settings.public.tenant_livechat_settings = res.settings;
            Meteor.settings.public.unicallAppKey = info.appKey;        //
            if(res.hasOperator === true){                              //
              FlowRouter.go('index', null, {tenant_id:info.tenantId});
            }else{                                                     //
              FlowRouter.go('ticket', null, {tenant_id:info.tenantId});
            }                                                          //
          }                                                            //
        })                                                             //
      });                                                              //
      agent.addEventListener('serverSign',function(data){              //
        /!*@"signature": __signature_at_backend_server__,              //
         @"appKey":__app_key__,                                        //
         @"tenantId":tenantId};UnicallAppInfo937486515*!/              //
        Meteor.call('sign-app-agent',data.appKey,function(err,res){    //
          if(err){                                                     //
            console.log(err)                                           //
          }else{                                                       //
            var sign = res;                                            //
            agent.sendMessage('serverSign',{appKey:data.appKey,tenantId:data.tenantId,sign:sign});
          }                                                            //
        })                                                             //
      });                                                              //
      agent.livechatLoadReady();                                       //
      if(Meteor.settings.public.DevTenantId){                          //
        agent.sendMessage('Mock ServerSign',{appKey:"123456789",tenantId:Meteor.settings.public.DevTenantId})
      }*/                                                              //
    } else {}                                                          //
  });                                                                  //
}).call(this);                                                         //
/////////////////////////////////////////////////////////////////////////

}).call(this);
