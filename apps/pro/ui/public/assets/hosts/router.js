(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/hosts/backbone/controllers/host_view_controller-6e6371c826a1b256cf4c95c1118e7e80f9813613e56a22c3ca34b6388c52bc1a.js'], function($, HostViewController) {
    var Router;
    Router = (function(_super) {

      __extends(Router, _super);

      function Router() {
        return Router.__super__.constructor.apply(this, arguments);
      }

      Router.prototype.appRoutes = {
        ':tab': 'Tab',
        '': 'Tab'
      };

      return Router;

    })(Backbone.Marionette.AppRouter);
    return new Router({
      controller: new HostViewController({
        id: HOST_ID
      })
    });
  });

}).call(this);
