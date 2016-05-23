(function(){
Template.__checkName("message");
Template["message"] = new Template("Template.message", (function() {
  var view = this;
  return HTML.LI({
    id: function() {
      return Spacebars.mustache(view.lookup("_id"));
    },
    "class": function() {
      return [ "message sequential ", Spacebars.mustache(view.lookup("system")), " ", Spacebars.mustache(view.lookup("t")), " ", Spacebars.mustache(view.lookup("own")), " ", Spacebars.mustache(view.lookup("isTemp")), " ", Spacebars.mustache(view.lookup("error")) ];
    },
    data_username: function() {
      return Spacebars.mustache(Spacebars.dot(view.lookup("u"), "username"));
    },
    data_date: "currentTime"
  }, "\n        ", HTML.SPAN({
    "class": "thumb thumb-small",
    href: "#",
    data_username: function() {
      return Spacebars.mustache(Spacebars.dot(view.lookup("u"), "username"));
    },
    tabindex: "1"
  }, Blaze._TemplateWith(function() {
    return {
      username: Spacebars.call(Spacebars.dot(view.lookup("u"), "username"))
    };
  }, function() {
    return Spacebars.include(view.lookupTemplate("avatar"));
  })), "\n        ", HTML.SPAN({
    "class": "user",
    href: "#",
    data_username: function() {
      return Spacebars.mustache(Spacebars.dot(view.lookup("u"), "username"));
    },
    tabindex: "1"
  }, Blaze.View("lookup:messageOwner", function() {
    return Spacebars.makeRaw(Spacebars.mustache(view.lookup("messageOwner")));
  })), "\n		", HTML.DIV({
    "class": "info"
  }, "\n			", HTML.SPAN({
    "class": "time"
  }, Blaze.View("lookup:time", function() {
    return Spacebars.mustache(view.lookup("time"));
  })), "\n            ", Blaze.If(function() {
    return Spacebars.call(view.lookup("edit"));
  }, function() {
    return [ "\n                ", HTML.SPAN({
      "class": "edited"
    }, "(", Blaze.View("lookup:_", function() {
      return Spacebars.mustache(view.lookup("_"), "edited");
    }), ")"), "\n            " ];
  }), "\n		"), "\n\n        ", HTML.DIV({
    "class": "body",
    dir: "auto",
    style: "word-break:break-all;"
  }, "\n            ", Blaze.View("lookup:body", function() {
    return Spacebars.makeRaw(Spacebars.mustache(view.lookup("body")));
  }), "\n            ", Blaze.If(function() {
    return Spacebars.call(view.lookup("payloadFile"));
  }, function() {
    return [ "\n                ", Blaze.If(function() {
      return Spacebars.call(view.lookup("imagePayload"));
    }, function() {
      return [ "\n                    ", HTML.DIV({
        style: "padding:0px;"
      }, "\n\n                        ", HTML.Comment('<img class="image-loading" src="{{imageLoadingUrl}}">'), "\n                        ", HTML.Comment('<img class="image-reload" src="{{imageLoadingUrl}}">'), "\n                        ", Blaze.If(function() {
        return Spacebars.call(view.lookup("isCordova"));
      }, function() {
        return [ "\n                            ", HTML.A({
          href: "javascript:void(0);",
          title: "预览"
        }, "\n                                ", HTML.IMG({
          title: "预览",
          "class": "image s3-swipebox",
          id: function() {
            return Spacebars.mustache(view.lookup("payloadFile"));
          },
          "data-url": function() {
            return Spacebars.mustache(Spacebars.dot(view.lookup("s3url"), "uri"));
          }
        }), "\n                            "), "\n                        " ];
      }, function() {
        return [ "\n                            ", HTML.IMG({
          title: "预览",
          "class": "image",
          id: function() {
            return Spacebars.mustache(view.lookup("payloadFile"));
          }
        }), "\n                        " ];
      }), "\n                    "), "\n                " ];
    }), "\n                ", Blaze.If(function() {
      return Spacebars.call(view.lookup("audioPayload"));
    }, function() {
      return [ "\n                    ", Blaze.If(function() {
        return Spacebars.call(view.lookup("isIE"));
      }, function() {
        return [ "\n                        ", HTML.IFRAME({
          style: "width:220px;height:40px;overflow: hidden;",
          src: function() {
            return Spacebars.mustache(view.lookup("audioPlayerUrl"));
          }
        }), "\n                    " ];
      }, function() {
        return [ "\n                        ", HTML.DIV({
          "class": "arrowBorder"
        }), "\n                        ", HTML.DIV({
          "class": "arrow"
        }), "\n                        ", HTML.DIV({
          "class": "msgBody audioMsg",
          style: function() {
            return [ "width:", Spacebars.mustache(view.lookup("audioWidth")), "px;" ];
          },
          "data-msgid": function() {
            return Spacebars.mustache(view.lookup("_id"));
          },
          "data-src": function() {
            return Spacebars.mustache(view.lookup("payloadFile"));
          },
          "data-duration": function() {
            return Spacebars.mustache(Spacebars.dot(view.lookup("s3url"), "duration"));
          }
        }, "\n                            ", HTML.I({
          "class": "audioIcon"
        }), "\n                            ", HTML.SPAN({
          "class": "msgExtend"
        }, "\n                                ", Blaze.View("lookup:s3url.duration", function() {
          return Spacebars.mustache(Spacebars.dot(view.lookup("s3url"), "duration"));
        }), "''\n                                ", HTML.I({
          "class": function() {
            return Spacebars.mustache(view.lookup("isUnread"));
          }
        }), "\n                            "), "\n                        "), "\n                    " ];
      }), "\n                " ];
    }), "\n            " ];
  }), "\n        "), "\n    ");
}));

}).call(this);
