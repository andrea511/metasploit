(function() {

  define([], function() {
    return this.Pro.module("Views", function(Views, App, Backbone, Marionette, jQuery, _) {
      var TemplatePathHelpers;
      TemplatePathHelpers = {
        lookups: ["backbone/apps/", "backbone/lib/components/", "backbone/lib/shared/", "backbone/lib/concerns"],
        templatePath: function(template) {
          var lookup, path, _i, _j, _len, _len1, _ref, _ref1;
          if (template === false) {
            return;
          }
          _ref = [template, this.withTemplate(template)];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            path = _ref[_i];
            _ref1 = this.lookups;
            for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
              lookup = _ref1[_j];
              if (JST[lookup + path]) {
                return JST[lookup + path];
              }
            }
          }
        },
        withTemplate: function(path) {
          var array;
          array = path.split("/");
          array.splice(-1, 0, "templates");
          return array.join("/");
        },
        selectText: function(element) {
          var range, selection;
          if (document.body.createTextRange) {
            range = document.body.createTextRange();
            range.moveToElementText(element);
            return range.select();
          } else if (window.getSelection) {
            selection = window.getSelection();
            range = document.createRange();
            range.selectNodeContents(element);
            selection.removeAllRanges();
            return selection.addRange(range);
          }
        }
      };
      _.extend(Marionette.ItemView.prototype, TemplatePathHelpers);
      _.extend(Marionette.CollectionView.prototype, TemplatePathHelpers);
      _.extend(Marionette.View.prototype, {
        templateHelpers: function() {},
        _getDefaults: function() {
          return _.clone(_.result(this, "defaults"));
        }
      });
      return _.extend(Marionette.Renderer, {
        render: function(template, data) {
          var templateFunc;
          if (template === false) {
            return;
          }
          templateFunc;

          if (typeof template === "function") {
            templateFunc = template;
          } else {
            templateFunc = Marionette.TemplateCache.get(template);
          }
          return templateFunc(data);
        }
      });
    });
  });

}).call(this);
