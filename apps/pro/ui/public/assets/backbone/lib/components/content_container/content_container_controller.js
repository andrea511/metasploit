(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/content_container/content_container_views'], function() {
    return this.Pro.module("Components.ContentContainer", function(ContentContainer, App, Backbone, Marionette, $, _) {
      ContentContainer.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          this.contentView = options.contentView, this.headerView = options.headerView;
          this.layout = new ContentContainer.Layout();
          this.listenTo(this.layout, 'show', function() {
            if (this.contentView != null) {
              this.show(this.contentView, {
                region: this.layout.content
              });
            }
            if (this.headerView != null) {
              return this.show(this.headerView, {
                region: this.layout.header
              });
            }
          });
          return this.setMainView(this.layout);
        };

        Controller.prototype.showContentRegion = function(contentView) {
          this.contentView = contentView;
          return this.show(this.contentView, {
            region: this.layout.content
          });
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('contentContainer:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new ContentContainer.Controller(options);
      });
    });
  });

}).call(this);
