(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview', 'apps/vulns/show/components/comment/comment_view', 'entities/note'], function($) {
    return this.Pro.module("Components.CustomNoteCell", function(CustomNoteCell, App, Backbone, Marionette, $, _) {
      return CustomNoteCell.View = (function(_super) {

        __extends(View, _super);

        function View() {
          return View.__super__.constructor.apply(this, arguments);
        }

        View.prototype.initialize = function(opts) {
          var data;
          data = {
            workspace_id: WORKSPACE_ID,
            type: 'Mdm::Vuln',
            type_id: parseInt(this.model.id),
            data: {
              comment: this.model.get('comment.data.comment')
            }
          };
          return this.commentModel = App.request('new:note:entity', data);
        };

        View.prototype.template = function(data) {
          var comment;
          if (data['comment.data.comment']) {
            comment = data['comment.data.comment'];
          } else {
            comment = '';
          }
          return "<textarea rows=\"1\" id=\"comments\" type=\"text\" name=\"comment\">" + comment + "</textarea>\n<img class=\"btn more-text\" src=\"/assets/icons/buttom_more-7136ef601f6f896bafce9a49dd2841ecc0be81984871cf677951f03acebb21c9.svg\" />\n<div class=\"error\" style=\"display:none;\"></div>";
        };

        View.prototype.ui = {
          commentBtn: 'img.btn.more-text',
          commentInput: 'textarea#comments',
          error: '.error'
        };

        View.prototype.events = {
          'click @ui.commentBtn': '_commentModal',
          'focusout @ui.commentInput': '_saveComment'
        };

        View.prototype._commentModal = function() {
          var commentView,
            _this = this;
          commentView = new Pro.Components.Comment.View({
            model: this.commentModel
          });
          return App.execute('showModal', commentView, {
            modal: {
              title: 'Comment',
              description: '',
              width: 300
            },
            buttons: [
              {
                name: 'Cancel',
                "class": 'close'
              }, {
                name: 'OK',
                "class": 'btn primary'
              }
            ],
            doneCallback: function() {
              _this.commentModel.set('data', {
                comment: commentView.getComment()
              });
              return _this._setComment(commentView.getComment());
            }
          });
        };

        View.prototype._saveComment = function() {
          var commentModel, data,
            _this = this;
          data = _.extend(this.commentModel.attributes, {
            data: {
              comment: this.ui.commentInput.val()
            }
          });
          commentModel = App.request('new:note:entity', data);
          return commentModel.save({}, {
            success: function(model) {
              _this.commentModel.set('data', {
                comment: model.get('data').comment
              });
              _this.ui.error.html();
              return _this.ui.error.hide();
            },
            error: function(model, response) {
              _this.ui.error.html(response.responseJSON.error.data[0]);
              return _this.ui.error.show();
            }
          });
        };

        View.prototype._setComment = function(comment) {
          return this.ui.commentInput.val(comment);
        };

        return View;

      })(App.Views.Layout);
    });
  });

}).call(this);
