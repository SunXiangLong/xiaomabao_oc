(function(){
Template.__checkName("room");
Template["room"] = new Template("Template.room", (function() {
  var view = this;
  return HTML.DIV({
    "class": "livechat-room"
  }, HTML.Raw("\n        <!--临时修改手机header-->\n        "), Blaze.If(function() {
    return Spacebars.call(view.lookup("isCordova"));
  }, function() {
    return [ "\n            ", Blaze._TemplateWith(function() {
      return {
        title: Spacebars.call(view.lookup("title")),
        showBack: Spacebars.call(true),
        showClose: Spacebars.call(true)
      };
    }, function() {
      return Spacebars.include(view.lookupTemplate("pageHeader"));
    }), "\n        " ];
  }, function() {
    return [ "\n        ", HTML.DIV({
      "class": "title",
      style: function() {
        return [ "background-color:", Spacebars.mustache(view.lookup("color")), ";color:", Spacebars.mustache(view.lookup("fontColor")) ];
      }
    }, "\n            ", HTML.H1(Blaze.View("lookup:title", function() {
      return Spacebars.mustache(view.lookup("title"));
    })), "\n            ", Blaze.If(function() {
      return Spacebars.call(view.lookup("ifOpened"));
    }, function() {
      return [ "\n               ", HTML.Comment(' <img src={{getAbUrl "packages/rocketchat_livechat/public/min.png"}} style=\'right:40px;top:6px\' alt="">'), "\n                ", HTML.IMG({
        id: "btn_over",
        style: "width:auto;height:auto;",
        "class": "msg",
        src: function() {
          return Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/leaveRoom.png");
        },
        alt: ""
      }), "\n            " ];
    }, function() {
      return [ "\n                ", HTML.IMG({
        "class": "msg",
        src: function() {
          return Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/msg.png");
        },
        alt: ""
      }), "\n            " ];
    }), "\n\n            ", HTML.DIV({
      "class": "msgcount"
    }, "\n                ", HTML.SPAN(), "\n            "), "\n        "), "\n        " ];
  }), "\n        ", HTML.DIV({
    "class": "messages"
  }, "\n            ", HTML.DIV({
    "class": "wrapper"
  }, "\n                ", HTML.UL({
    id: "msg-list"
  }, "\n                    ", Blaze.If(function() {
    return Spacebars.call(view.lookup("refreshNotice"));
  }, function() {
    return [ "\n                        ", HTML.LI("\n                            ", HTML.DIV({
      style: "text-align:center;"
    }, HTML.SPAN(HTML.IMG({
      src: function() {
        return Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/load.gif");
      }
    }))), "\n                        "), "\n                    " ];
  }), "\n                    ", Blaze.Each(function() {
    return Spacebars.call(view.lookup("messages"));
  }, function() {
    return [ "\n                        ", Blaze._TemplateWith(function() {
      return Spacebars.dataMustache(view.lookup("nrrargs"), "message", view.lookup("."));
    }, function() {
      return Spacebars.include(view.lookupTemplate("nrr"), function() {
        return null;
      });
    }), "\n                    " ];
  }), "\n                "), "\n            "), "\n            ", HTML.Raw('<!--<div class="new-message not">-->'), "\n                ", HTML.Raw("<!--<span>New messages</span>-->"), "\n            ", HTML.Raw("<!--</div>-->"), "\n\n            ", HTML.Raw('<div class="error">\n                <span></span>\n            </div>'), "\n            ", HTML.DIV({
    "class": "msgTime"
  }, "\n                ", HTML.SPAN(Blaze.View("lookup:time", function() {
    return Spacebars.mustache(view.lookup("time"));
  })), "\n            "), "\n        "), HTML.Raw("\n        <!--音频播放器-->\n        "), HTML.DIV({
    style: "position: absolute;top: 0;left: 0;width: 0;height: 0"
  }, "\n            ", HTML.AUDIO({
    id: "voice-player",
    preload: "metadata",
    src: function() {
      return Spacebars.mustache(view.lookup("getAudioUrl"));
    }
  }), "\n        "), "\n        ", HTML.DIV({
    "class": "footer"
  }, "\n            ", HTML.Raw('<!--<div class="tool_banner">\n                {{#if supportUploadFile}}\n                    <div class="file-uploader"\n                         style="background: url({{getAbUrl "packages/rocketchat_livechat/public/choice.png"}})">\n                        <input id="uploadFileInput" type="file" accept="*/*">\n                    </div>\n                {{/if}}\n                <a href="javascript:;" title="发送图片"><img\n                        src="{{getAbUrl "packages/rocketchat_livechat/public/choice.png"}}" alt="发送图片"></a>\n                <a href="javascript:;" title="截屏"><img src="{{getAbUrl "packages/rocketchat_livechat/public/cut.png"}}"\n                                                       alt="截屏"></a>\n            </div>-->'), "\n            ", HTML.DIV({
    "class": "input-wrapper"
  }, "\n                ", HTML.TEXTAREA({
    "class": "input-message",
    placeholder: "请输入........",
    rows: "3"
  }), "\n                ", HTML.DIV({
    "class": "file-uploader",
    style: function() {
      return [ "width: 40px;height: 40px;display: inline-block;float: right;margin-right: 10px;\n                             background: url(", Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/sendFile.png"), ");" ];
    }
  }, "\n                    ", Blaze.If(function() {
    return Spacebars.call(view.lookup("supportUploadFile"));
  }, function() {
    return [ "\n                        ", Blaze.If(function() {
      return Spacebars.call(view.lookup("isCordova"));
    }, function() {
      return [ "\n                            ", HTML.INPUT({
        id: "uploadFileInput",
        title: "发送文件",
        type: "file",
        accept: "image/*",
        style: ""
      }), "\n                        " ];
    }, function() {
      return [ "\n                            ", HTML.INPUT({
        id: "uploadFileInput",
        title: "发送文件",
        type: "file",
        accept: "*/*",
        style: ""
      }), "\n                        " ];
    }), "\n                    " ];
  }, function() {
    return [ "\n                        ", HTML.DIV({
      "class": "old-ie-notice",
      id: "showIE8NoticeButton"
    }), "\n                    " ];
  }), "\n                "), "\n                ", HTML.Raw('<!--<div class="tool_btns">-->'), "\n                    ", HTML.Raw('<!--<a href="javascript:;" id="btn_over">结束</a>-->'), "\n                    ", HTML.Raw('<!--<a href="javascript:;" id="btn_send">发送</a>-->'), "\n                ", HTML.Raw("<!--</div>-->"), "\n            "), "\n        "), "\n        ", Blaze.If(function() {
    return Spacebars.call(view.lookup("browserSupportNoticer"));
  }, function() {
    return [ "\n        ", HTML.DIV({
      "class": "system-notice"
    }, "\n            ", HTML.DIV({
      "class": "system-notice-closer",
      style: function() {
        return [ "background: url(", Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/ie8ErrorClose.png"), ");" ];
      }
    }), "\n            ", HTML.DIV({
      "class": "system-notice-icon",
      style: function() {
        return [ "background: url(", Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/ie8Error.png"), ");" ];
      }
    }), "\n            ", HTML.DIV({
      "class": "system-notice-text"
    }, "您的IE浏览器版本过低", HTML.BR(), "请使用IE10及以上版本"), "\n            ", HTML.DIV({
      "class": "system-notice-arrow1"
    }), "\n            ", HTML.DIV({
      "class": "system-notice-arrow2"
    }), "\n        "), "\n        " ];
  }), "\n        ", HTML.DIV({
    "class": "xCover"
  }, "\n            ", HTML.DIV({
    "class": "xContent"
  }, "\n                ", HTML.DIV({
    "class": "title",
    style: function() {
      return [ "background-color:", Spacebars.mustache(view.lookup("color")), ";color:", Spacebars.mustache(view.lookup("fontColor")) ];
    }
  }, "\n                    ", HTML.H1(Blaze.View("lookup:title", function() {
    return Spacebars.mustache(view.lookup("title"));
  })), "\n                    ", HTML.IMG({
    id: "btn_close",
    "class": "btn_close",
    style: "right: 15px;top: 14px;width:auto; height:auto;",
    src: function() {
      return Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/leaveRoom.png");
    }
  }), "\n                "), "\n                ", HTML.DIV({
    "class": "infotext"
  }, "\n                    ", HTML.SPAN(Blaze.View("lookup:getClosingMsg", function() {
    return Spacebars.mustache(view.lookup("getClosingMsg"));
  }), " "), "\n                "), "\n                ", HTML.Raw('<div class="btn-area">\n                    <ul>\n                        <li>\n                            <label>\n                                <input type="radio" name="SatisfactionDegree" value="非常满意" checked="checked"><span style="margin-left: 20px;">非常满意</span>\n                            </label>\n                        </li>\n                        <li>\n                            <label>\n                                <input type="radio" name="SatisfactionDegree" value="满意"><span style="margin-left: 20px;">满意</span>\n                            </label>\n                        </li>\n                        <li><label>\n                            <input type="radio" name="SatisfactionDegree" value="一般"><span style="margin-left: 20px;">一般</span>\n                        </label></li>\n                        <li>\n                            <label>\n                                <input type="radio" name="SatisfactionDegree" value="不满意"><span style="margin-left: 20px;">不满意</span>\n                            </label>\n                        </li>\n                        <li>\n                            <label>\n                                <input type="radio" name="SatisfactionDegree" value="非常不满意"><span style="margin-left: 20px;">非常不满意</span>\n                            </label>\n                        </li>\n                    </ul>\n                </div>'), "\n                ", HTML.Raw('<div class="survey-submit">\n                    <input type="button" id="btn_cancel" value="取消" class="cancel">\n                    <input type="button" id="btn_submit" class="submit" value="提交">\n                </div>'), "\n            "), "\n        "), "\n        ", HTML.DIV({
    id: "submit-success",
    style: "z-index:21;position:absolute;top:0px;left:0px;width:100%;height:100%;display: none;background-color: grey;"
  }, "\n            ", HTML.DIV({
    style: "position:fixed;width:100%;height:100%;top:0px;background-color: #ffffff;"
  }, "\n                ", HTML.DIV({
    "class": "title",
    style: function() {
      return [ "background-color:", Spacebars.mustache(view.lookup("color")), ";color:", Spacebars.mustache(view.lookup("fontColor")) ];
    }
  }, "\n                    ", HTML.H1(Blaze.View("lookup:title", function() {
    return Spacebars.mustache(view.lookup("title"));
  })), "\n                "), "\n                ", HTML.DIV({
    style: "position: fixed;top: 46px;height: 65%;width: 100%;text-align: center;"
  }, "\n                    ", HTML.SPAN(HTML.IMG({
    style: "position: relative;margin-top: 80px;",
    src: function() {
      return Spacebars.mustache(view.lookup("getAbUrl"), "packages/rocketchat_livechat/public/CreateTicketSuccess.png");
    }
  })), "\n                    ", HTML.Raw('<div style="position: fixed;bottom: 45%;font-size: 18px;color: #777777;text-align: center;width: 100%;">您的评价已提交!<br>感谢您对我的真诚评价</div>'), "\n                "), "\n                ", HTML.Raw('<div style="text-align: center;position: fixed;bottom: 0px;height: 30%;width: 100%;">\n                    <button id="btn_okxxx" style="width:80%;height: 30px;background-color: white;border: 1px solid #eeeeee;margin-top: 20px;cursor: pointer;">\n                        确定\n                    </button>\n                </div>'), "\n            "), "\n        "), "\n    ");
}));

}).call(this);
