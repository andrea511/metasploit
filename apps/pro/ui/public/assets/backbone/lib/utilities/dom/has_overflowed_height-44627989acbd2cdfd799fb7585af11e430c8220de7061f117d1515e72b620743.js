(function() {

  define(['jquery'], function($) {
    return $.fn.hasOverflowedHeight = function() {
      var el, ret, t, text;
      el = $(this[0]);
      if (el.css("overflow") === "hidden") {
        text = el.html();
        t = $(el[0].cloneNode(true)).hide().css("position", "absolute").css("overflow", "visible").height("auto").width(el.width());
        el.after(t);
        ret = t.height() > el.height();
        t.remove();
        return ret;
      } else {
        throw new Error("Element must have overflow:hidden to use isOverflowHeight");
      }
    };
  });

}).call(this);
