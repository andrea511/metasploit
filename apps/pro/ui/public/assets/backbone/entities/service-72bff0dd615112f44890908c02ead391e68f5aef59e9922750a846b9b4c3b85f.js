(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Service = (function(_super) {

        __extends(Service, _super);

        function Service() {
          return Service.__super__.constructor.apply(this, arguments);
        }

        Service.PROTOS = ['tcp', 'udp'];

        Service.prototype.url = function() {};

        return Service;

      })(App.Entities.Model);
      Entities.ServiceCollection = (function(_super) {

        __extends(ServiceCollection, _super);

        function ServiceCollection() {
          return ServiceCollection.__super__.constructor.apply(this, arguments);
        }

        ServiceCollection.prototype.initialize = function(models, _arg) {
          this.host_id = _arg.host_id, this.index = _arg.index;
          if (this.index) {
            return this.url = Routes.workspace_services_path(WORKSPACE_ID);
          } else {
            return this.url = "/hosts/" + this.host_id + "/show_services/json";
          }
        };

        ServiceCollection.prototype.model = Entities.Service;

        return ServiceCollection;

      })(App.Entities.Collection);
      API = {
        getServices: function(opts) {
          if (opts == null) {
            opts = {};
          }
          return new Entities.ServiceCollection([], opts);
        },
        getService: function(id) {
          return new Entities.Service({
            id: id
          });
        },
        newService: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Service(attributes);
        }
      };
      App.reqres.setHandler("services:entities", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getServices(opts);
      });
      App.reqres.setHandler("services:entity", function(id) {
        return API.getService(id);
      });
      return App.reqres.setHandler("new:service:entity", function(attributes) {
        return API.newService(attributes);
      });
    });
  });

}).call(this);
