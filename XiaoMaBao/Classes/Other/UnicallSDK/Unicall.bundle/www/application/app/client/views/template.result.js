(function(){
Template.__checkName("result");
Template["result"] = new Template("Template.result", (function() {
  var view = this;
  return HTML.DIV({
    "class": "result"
  }, "\n        ", Blaze._TemplateWith(function() {
    return {
      title: Spacebars.call(view.lookup("title")),
      showBack: Spacebars.call(view.lookup("showBack")),
      showClose: Spacebars.call(view.lookup("showClose"))
    };
  }, function() {
    return Spacebars.include(view.lookupTemplate("pageHeader"));
  }), "\n        ", HTML.DIV({
    "class": "content"
  }, "\n            ", HTML.DIV({
    "class": "result-icon"
  }, "\n                ", HTML.SPAN({
    "class": function() {
      return [ "icon ", Spacebars.mustache(view.lookup("status")), " icon-large" ];
    }
  }), "\n            "), "\n            ", HTML.DIV({
    "class": "intro-msg"
  }, "\n                ", HTML.P(Blaze.View("lookup:introMsg", function() {
    return Spacebars.mustache(view.lookup("introMsg"));
  })), "\n            "), "\n            ", HTML.Raw('<div class="bar bar-standard confirm">\n                <button type="button" class="btn btn-block btn-confirm">确定</button>\n            </div>'), "\n        "), "\n    ");
}));

}).call(this);
