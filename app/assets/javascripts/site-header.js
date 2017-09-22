Upcase.siteHeader = {
  init: function() {
    if($(".js-site-nav-button").length === 0) {
      return false;
    }

    var _this = this;

    $(document).on("ready", function(){
      _this.setSiteNavButtonClasses();
    });

    $(window).on("scroll", _.throttle(function(){
      _this.setSiteNavButtonClasses();
    }));
  },

  setSiteNavButtonClasses: function () {
    var button = $(".js-site-nav-button");
    var body = $("body");
    var buttonClass = "button--empty";
    var heroHeight = $(".hero").outerHeight();
    var scrollPosition = $(document).scrollTop();

    if(scrollPosition > heroHeight) {
      body.addClass("light");
      button.removeClass(buttonClass);
    } else {
      body.removeClass("light");
      button.addClass(buttonClass);
    }
  },
}

Upcase.siteHeader.init();
