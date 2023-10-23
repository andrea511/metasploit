(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview', 'apps/vulns/show/templates/comment_view', 'entities/note'], function($) {
    return this.Pro.module("Components.Comment", function(Comment, App, Backbone, Marionette, $, _) {
      return Comment.View = (function(_super) {

        __extends(View, _super);

        function View() {
          return View.__super__.constructor.apply(this, arguments);
        }

        View.prototype.template = View.prototype.templatePath('vulns/show/comment_view');

        View.prototype.className = 'comment-view';

        View.prototype.ui = {
          comment: 'textarea',
          error: '.error'
        };

        View.prototype.triggers = {
          'mouseout @ui.comment': 'center'
        };

        View.prototype.getComment = function() {
          return this.ui.comment.val();
        };

        View.prototype.onFormSubmit = function() {
          var commentModel, defer,
            _this = this;
          defer = $.Deferred();
          defer.promise();
          commentModel = App.request('new:note:entity', {
            data: {
              comment: this.ui.comment.val()
            },
            workspace_id: WORKSPACE_ID,
            type: this.model.get('type'),
            type_id: this.model.get('type_id')
          });
          commentModel.save({}, {
            success: function(model) {
              _this.model.set('data', {
                comment: model.get('data').comment
              });
              return defer.resolve();
            },
            error: function(model, response) {
              _this.ui.error.html(response.responseJSON.error.data[0]);
              return _this.ui.error.show();
            }
          });
          return defer;
        };

        return View;

      })(App.Views.Layout);
    });
  });

}).call(this);
