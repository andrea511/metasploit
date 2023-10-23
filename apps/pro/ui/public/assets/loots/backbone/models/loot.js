(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery'], function($) {
    var Loot;
    return Loot = (function(_super) {

      __extends(Loot, _super);

      function Loot() {
        this.url = __bind(this.url, this);
        return Loot.__super__.constructor.apply(this, arguments);
      }

      Loot.prototype.defaults = {
        content_type: 'text/plain',
        info: '',
        data: null,
        host_id: 0,
        workspace_id: 0
      };

      Loot.prototype.url = function() {
        return "/workspaces/" + (this.get('workspace_id')) + "/loots/" + this.id + ".json";
      };

      return Loot;

    })(Backbone.Model);
  });

}).call(this);
