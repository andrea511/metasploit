(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/templates/fuzzing/layouts/fuzzing_xss_attack_layout-8c86f35eda9da3ddad8a4b6435861828e0a634d36a76c4b923c80c3b51a50518.js', '/assets/fuzzing/backbone/views/item_views/request_item_view-c819cf48afe2485388bfd20e680065c93b51ebd8256a9c65c882a08ec3723ba2.js', '/assets/fuzzing/backbone/views/item_views/replayer_parameters_item_view-3ff0a2d0d8cd42a3826f2bb5d1ab1d54e6a0667f2229446bab7d8804e18ad29e.js', '/assets/fuzzing/backbone/views/item_views/replayer_target_browsers_item_view-a7ac58e32a16cea1d79d81f6e08037761b7492a06acd1ccce384693870648851.js'], function(Template, RequestItemView, ReplayerParametersItemView, ReplayerTargetBrowsersItemView) {
    var FuzzingXSSAttackLayout;
    return FuzzingXSSAttackLayout = (function(_super) {

      __extends(FuzzingXSSAttackLayout, _super);

      function FuzzingXSSAttackLayout() {
        return FuzzingXSSAttackLayout.__super__.constructor.apply(this, arguments);
      }

      FuzzingXSSAttackLayout.prototype.template = HandlebarsTemplates['fuzzing/layouts/fuzzing_xss_attack_layout'];

      FuzzingXSSAttackLayout.prototype.regions = {
        request: '.request',
        parameters: '.parameters',
        target_browsers: '.target-browsers',
        xss_crafter: '.xss-crafter'
      };

      FuzzingXSSAttackLayout.prototype.onRender = function() {
        this.request.show(new RequestItemView);
        this.parameters.show(new ReplayerParametersItemView);
        return this.target_browsers.show(new ReplayerTargetBrowsersItemView);
        /*
              @.xss_crafter.show(new XssCrafterItemView)
        */

      };

      return FuzzingXSSAttackLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
