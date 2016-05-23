(function(){
Template.__checkName("ticket");
Template["ticket"] = new Template("Template.ticket", (function() {
  var view = this;
  return HTML.DIV({
    "class": "ticket"
  }, "\n        ", Blaze._TemplateWith(function() {
    return {
      title: Spacebars.call(view.lookup("title")),
      showBack: Spacebars.call(true),
      showClose: Spacebars.call(false)
    };
  }, function() {
    return Spacebars.include(view.lookupTemplate("pageHeader"));
  }), "\n        ", HTML.FORM({
    "class": "input-group content ticket-form"
  }, "\n            ", HTML.DIV({
    "class": "ticket-messages"
  }, "\n                ", HTML.TEXTAREA({
    required: "",
    name: "messages",
    placeholder: "非常抱歉，目前没有人工客服在线，请输入您的留言内容，我们会尽快联系您！\n*必填，便于我们与您联系",
    maxlength: "500"
  }), "\n            "), "\n            ", HTML.Raw('<div class="table-view-divider"></div>'), "\n            ", HTML.Raw('<div class="input-row">\n                <label><em class="alert">*</em>您的姓名</label>\n                <input required="" type="text" name="name" placeholder="必填，便于我们与您联系" maxlength="16">\n            </div>'), "\n            ", HTML.Raw('<div class="table-view-divider"></div>'), "\n            ", HTML.Raw('<div class="input-row">\n                <label><em class="alert">*</em>联系电话</label>\n                <input required="" type="text" name="phone" placeholder="必填，便于我们与您联系" maxlength="16">\n            </div>'), "\n            ", HTML.DIV({
    "class": "msg-error"
  }, HTML.SPAN({
    "class": function() {
      return [ "hide ", Spacebars.mustache(view.lookup("isValid")) ];
    }
  }, "必填字段不能为空!")), "\n            ", HTML.Raw('<div class="bar bar-standard submit">\n                <button type="submit" class="btn btn-block">提交</button>\n            </div>'), "\n        "), "\n    ");
}));

}).call(this);
