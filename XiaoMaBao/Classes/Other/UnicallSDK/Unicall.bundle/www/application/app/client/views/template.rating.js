(function(){
Template.__checkName("rating");
Template["rating"] = new Template("Template.rating", (function() {
  var view = this;
  return HTML.DIV({
    "class": "rating"
  }, "\n        ", Blaze._TemplateWith(function() {
    return {
      title: Spacebars.call(view.lookup("title")),
      showBack: Spacebars.call(view.lookup("showBack")),
      showClose: Spacebars.call(true)
    };
  }, function() {
    return Spacebars.include(view.lookupTemplate("pageHeader"));
  }), "\n        ", HTML.FORM({
    "class": "content rating-form"
  }, "\n            ", HTML.DIV({
    "class": "intro-msg"
  }, "\n                ", HTML.P(Blaze.View("lookup:introMsg", function() {
    return Spacebars.mustache(view.lookup("introMsg"));
  })), "\n            "), "\n            ", HTML.Raw('<ul class="rating-list">\n                <li>\n                    <label><input type="radio" name="rating" value="5" checked="checked">非常满意</label>\n                </li>\n                <li>\n                    <label><input type="radio" name="rating" value="4">满意</label>\n                </li>\n                <li>\n                    <label><input type="radio" name="rating" value="3">一般</label>\n                </li>\n                <li>\n                    <label><input type="radio" name="rating" value="2">不满意</label>\n                </li>\n                <li>\n                    <label><input type="radio" name="rating" value="1">非常不满意</label>\n                </li>\n            </ul>'), "\n            ", HTML.Raw('<div class="bar bar-standard confirm">\n                <button type="submit" class="btn btn-block">提交</button>\n            </div>'), "\n        "), "\n    ");
}));

}).call(this);
