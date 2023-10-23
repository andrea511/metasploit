(function() {

  jQuery(function($) {
    var MyPlugin;
    MyPlugin = (function() {

      MyPlugin.prototype.defaults = {
        hidableClass: 'hidable'
      };

      function MyPlugin($element, options) {
        this.$element = $element;
        this.config = $.extend({}, this.defaults, options, true);
        this.$element.data('MyPlugin', this);
        this.init();
      }

      MyPlugin.prototype.foo = function() {
        return console.log(this);
      };

      MyPlugin.prototype.init = function() {
        if (this.$element.hasClass(this.config.hidableClass)) {
          return this.$element.hover(function() {
            return this.$element.hide();
          });
        }
      };

      return MyPlugin;

    })();
    return $.fn.myPlugin = function(options) {
      var object;
      object = $(this).data('MyPlugin');
      return object || this.each(function() {
        return new MyPlugin($(this), options);
      });
    };
  });

}).call(this);
