(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/tasks/new_nexpose_exception_push/item_views/vuln-5f83ac608f9086018c43b0c074d6c479831b70d7c5214202b43da37119b05e16.js', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js'], function($, Template, Moment) {
    var VulnItemView;
    return VulnItemView = (function(_super) {

      __extends(VulnItemView, _super);

      function VulnItemView() {
        this.onBeforeRender = __bind(this.onBeforeRender, this);
        return VulnItemView.__super__.constructor.apply(this, arguments);
      }

      VulnItemView.prototype.template = HandlebarsTemplates['tasks/new_nexpose_exception_push/item_views/vuln'];

      VulnItemView.prototype.initialize = function(opts) {
        return $.extend(this, opts);
      };

      VulnItemView.prototype.events = {
        'click input[value=all]': '_enableMassAssignment',
        'click input[value=single]': '_disableMassAssignment',
        'change select[name="group_reason"]': '_assignDropdowns',
        'input input[name="group_comment"]': '_assignComments',
        'change .datetime': '_triggerDateSet'
      };

      VulnItemView.prototype.onBeforeRender = function() {
        var exception_reasons, reasons;
        exception_reasons = this.controller.EXCEPTION_REASONS;
        reasons = _.map(exception_reasons, function(val, key) {
          return {
            value: key,
            text: val
          };
        });
        this.model.set('reasons', reasons);
        this.model.set('date', "");
        return this.model.set('itemIndex', this.itemIndex);
      };

      VulnItemView.prototype.onShow = function() {
        $(".datetime", this.el).each(function() {
          return $(this).datepicker({
            minDate: 1
          });
        });
        return this._setDefaultSelections();
      };

      VulnItemView.prototype._triggerDateSet = function(e) {
        return $(e.target).trigger('dateSet');
      };

      VulnItemView.prototype._assignDropdowns = function(e) {
        var $select, html, val;
        $select = $(e.target);
        val = $select.val();
        html = $(':selected', $select).html();
        return $('table td select', this.el).each(function() {
          var $span;
          $(this).val(val);
          $span = $('span', $(this).closest('td'));
          $span.html(html);
          return $span.data('value', $(':selected', this).val());
        });
      };

      VulnItemView.prototype._assignComments = function(e) {
        var val;
        val = $(e.target).val();
        return $('table td input.comment', this.el).each(function() {
          var $span;
          $(this).val(val);
          $span = $('span', $(this).closest('td'));
          $span.html(val);
          return $span.data('value', val);
        });
      };

      VulnItemView.prototype._enableMassAssignment = function(e) {
        return $('table td input, table td select', this.el).each(function() {
          $('.mass-assign', this.el).removeClass("invisible");
          $('table td select', this.el).each(function() {
            var $span;
            $(this).hide();
            $span = $('span', $(this).closest('td'));
            $span.html($(':selected', this).html());
            $span.data('value', $(':selected', this).val());
            return $span.show();
          });
          return $('table td input.comment', this.el).each(function() {
            var $span;
            $(this).addClass('hide-input');
            $span = $('span', $(this).closest('td'));
            $span.html($(this).val());
            $span.data('value', $(this).val());
            return $span.show();
          });
        });
      };

      VulnItemView.prototype._disableMassAssignment = function(e) {
        return $('table td input, table td select', this.el).each(function() {
          $('.mass-assign', this.el).addClass("invisible");
          $('table td select', this.el).each(function() {
            var $span;
            $(this).show();
            $span = $('span', $(this).closest('td'));
            $(this).val($span.data('value'));
            return $span.hide();
          });
          return $('table td input.comment', this.el).each(function() {
            var $span;
            $span = $('span', $(this).closest('td'));
            $(this).val($span.data('value'));
            $(this).removeClass('hide-input');
            return $span.hide();
          });
        });
      };

      VulnItemView.prototype._setDefaultSelections = function() {
        return $('.hidden-selection', this.el).each(function() {
          var $options, option;
          option = $(this).data('reason');
          $options = $(this).closest('td');
          return $("option[value='" + option + "']", $options).attr('selected', true);
        });
      };

      return VulnItemView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
