(function(){
Template.__checkName("loading");
Template["loading"] = new Template("Template.loading", (function() {
  var view = this;
  return HTML.DIV({
    style: "position: fixed;top: 0;bottom: 0;width: 100%;padding-top: 10px;text-align: center;background-color:#ffffff;"
  }, "\n        ", HTML.IMG({
    src: function() {
      return Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/apploading.gif");
    },
    style: "margin:50% 0 50% 0;"
  }), HTML.Raw("\n        <div>荣联云客服</div>\n        <div>copyright 2016</div>\n    "));
}));

}).call(this);
