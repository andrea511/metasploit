(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/tasks/new_nexpose_exception_push/collections/vulns-a89d85bb2f67e35a527b8d7861b52df42d6aa5b85bd2848cfde1016a58066bca.js', '/assets/tasks/new_nexpose_exception_push/backbone/views/item_views/vuln-f693862ea413314b6eec9b7fc06930a0fe7c66c76867dc0166526252d2ddb248.js'], function($, Template, VulnItemView) {
    var VulnsCollection;
    return VulnsCollection = (function(_super) {

      __extends(VulnsCollection, _super);

      function VulnsCollection() {
        this.buildChildView = __bind(this.buildChildView, this);
        return VulnsCollection.__super__.constructor.apply(this, arguments);
      }

      VulnsCollection.prototype.template = HandlebarsTemplates['tasks/new_nexpose_exception_push/collections/vulns'];

      VulnsCollection.prototype.childView = VulnItemView;

      VulnsCollection.prototype.emptyView = VulnItemView;

      VulnsCollection.prototype.initialize = function(opts) {
        return $.extend(this, opts);
      };

      VulnsCollection.prototype.buildChildView = function(child, ChildViewClass, childViewOptions) {
        var exception_reasons, options, reasons;
        exception_reasons = this.controller.EXCEPTION_REASONS;
        reasons = _.map(exception_reasons, function(val, key) {
          return {
            value: key,
            text: val
          };
        });
        child.set('console', {
          consoles: reasons,
          console: 'OTHER'
        });
        child.set('date', "");
        child.set('expire_date', "");
        options = _.extend({
          model: child
        }, childViewOptions, {
          controller: this.controller
        });
        return new ChildViewClass(options);
      };

      VulnsCollection.prototype.childViewOptions = function(child, index) {
        return {
          itemIndex: index
        };
      };

      return VulnsCollection;

    })(Backbone.Marionette.CollectionView);
  });

}).call(this);
