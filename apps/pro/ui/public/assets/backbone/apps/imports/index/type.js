(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model'], function() {
    return this.Pro.module("ImportsApp.Index", function(Index, App, Backbone, Marionette, $, _) {
      Index.Type = {
        File: 'file',
        Nexpose: 'nexpose',
        Sonar: 'sonar'
      };
      return Index.ImportTypeSelection = (function(_super) {

        __extends(ImportTypeSelection, _super);

        function ImportTypeSelection() {
          return ImportTypeSelection.__super__.constructor.apply(this, arguments);
        }

        ImportTypeSelection.prototype.defaults = {
          type: Index.Type.Nexpose,
          showTypeSelection: true
        };

        return ImportTypeSelection;

      })(App.Entities.Model);
    });
  });

}).call(this);
