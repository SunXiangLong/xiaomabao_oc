(function(){
Template.__checkName("avatar");
Template["avatar"] = new Template("Template.avatar", (function() {
  var view = this;
  return HTML.DIV({
    "class": "avatar"
  }, HTML.Raw('\n		<!--<div class="avatar-image" style="width: 30px; height: 30px; text-align: center;line-height: 30px;font-size: 12px;color: #ffffff;font-weight: 600;{{color}} ">-->\n            <!--{{code}}-->\n        <!--</div>-->\n        '), HTML.DIV({
    style: function() {
      return [ "width: 30px; height: 30px; text-align: center;line-height: 30px;font-size: 12px;color: #ffffff;font-weight: 600;background-position: center; background-repeat: no-repeat;background-image: URL(", Spacebars.mustache(view.lookup("avatarUrl")), ");" ];
    }
  }, "\n\n        "), "\n	");
}));

}).call(this);
