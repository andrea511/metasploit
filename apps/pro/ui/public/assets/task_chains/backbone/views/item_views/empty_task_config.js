(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/empty_task_config-cccff914824880e254ee3c35a4e4f251747b33845dc9815f0fea05bb6e12f353.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js'], function($, Template, TaskConfigView) {
    var EmptyTaskConfig;
    return EmptyTaskConfig = (function(_super) {

      __extends(EmptyTaskConfig, _super);

      function EmptyTaskConfig() {
        return EmptyTaskConfig.__super__.constructor.apply(this, arguments);
      }

      EmptyTaskConfig.prototype.template = HandlebarsTemplates['task_chains/item_views/empty_task_config'];

      return EmptyTaskConfig;

    })(TaskConfigView);
  });

}).call(this);
