(function(){
Template.__checkName("pageHeader");
Template["pageHeader"] = new Template("Template.pageHeader", (function() {
  var view = this;
  return HTML.HEADER({
    "class": "bar bar-nav",
    style: function() {
      return [ "background-color: ", Spacebars.mustache(view.lookup("bgColor")), ";" ];
    }
  }, "\n        ", HTML.BUTTON({
    "class": function() {
      return [ "btn btn-link btn-nav btn-return pull-left hide ", Blaze.If(function() {
        return Spacebars.call(view.lookup("showBack"));
      }, function() {
        return "show";
      }) ];
    },
    style: function() {
      return [ "color: ", Spacebars.mustache(view.lookup("fontColor")), ";" ];
    }
  }, "\n            ", HTML.Raw('<span class="icon icon-left-nav"></span>'), "\n            返回\n        "), "\n        ", HTML.BUTTON({
    "class": function() {
      return [ "btn btn-link btn-nav btn-close pull-right hide ", Blaze.If(function() {
        return Spacebars.call(view.lookup("showClose"));
      }, function() {
        return "show";
      }) ];
    },
    style: function() {
      return [ "color: ", Spacebars.mustache(view.lookup("fontColor")), ";" ];
    }
  }, "\n            关闭\n        "), "\n        ", HTML.H1({
    "class": "title",
    style: function() {
      return [ "color: ", Spacebars.mustache(view.lookup("fontColor")), ";" ];
    }
  }, Blaze.View("lookup:title", function() {
    return Spacebars.mustache(view.lookup("title"));
  })), "\n    ");
}));

}).call(this);
