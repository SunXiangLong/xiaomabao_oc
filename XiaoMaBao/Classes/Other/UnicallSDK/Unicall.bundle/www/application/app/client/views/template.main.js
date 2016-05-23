(function(){
Template.body.addContent((function() {
  var view = this;
  return "";
}));
Meteor.startup(Template.body.renderToDocument);

Template.__checkName("main");
Template["main"] = new Template("Template.main", (function() {
  var view = this;
  return HTML.DIV({
    "class": function() {
      return Spacebars.mustache(view.lookup("platform"));
    }
  }, "\n        ", Blaze._TemplateWith(function() {
    return {
      template: Spacebars.call(view.lookup("center"))
    };
  }, function() {
    return Spacebars.include(function() {
      return Spacebars.call(Template.__dynamic);
    });
  }), "\n    ");
}));

}).call(this);
