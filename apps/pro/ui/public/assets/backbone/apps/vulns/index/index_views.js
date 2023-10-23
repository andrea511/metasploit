(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview'], function() {
    return this.Pro.module('VulnsApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      Index.NameCellView = (function(_super) {

        __extends(NameCellView, _super);

        function NameCellView() {
          this.template = __bind(this.template, this);
          return NameCellView.__super__.constructor.apply(this, arguments);
        }

        NameCellView.prototype.initialize = function(attribute, idAttribute) {
          var _ref, _ref1;
          this.attribute = attribute;
          this.idAttribute = idAttribute;
          if ((_ref = this.attribute) == null) {
            this.attribute = 'name';
          }
          return (_ref1 = this.idAttribute) != null ? _ref1 : this.idAttribute = 'id';
        };

        NameCellView.prototype.template = function(data) {
          var id, maxLength, text, truncatedText, workspaceVulnsPath;
          maxLength = 75;
          id = data[this.idAttribute];
          workspaceVulnsPath = _.escape(Routes.workspace_vulns_path(WORKSPACE_ID));
          text = _.escapeHTML(_.unescapeHTML(data.name)) || '';
          truncatedText = text.length > maxLength ? text.substring(0, maxLength) + '…' : text;
          return "<a href='" + workspaceVulnsPath + "#vulns/" + id + "'> " + truncatedText + " </a>";
        };

        return NameCellView;

      })(Pro.Views.ItemView);
      return Index.AddressCellView = (function(_super) {

        __extends(AddressCellView, _super);

        function AddressCellView() {
          return AddressCellView.__super__.constructor.apply(this, arguments);
        }

        AddressCellView.prototype.template = function(data) {
          return "<a href='" + (Routes.host_path(data.host_id)) + "'>" + data['host.address'] + "</a>";
        };

        return AddressCellView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
