(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview', 'lib/components/tooltip/templates/view'], function($) {
    return this.Pro.module("Components.Tooltip", function(Tooltip, App, Backbone, Marionette, $, _) {
      var ARROW_PAD_LEFT, WAIT_TO_CHANGE_DOM;
      WAIT_TO_CHANGE_DOM = 350;
      ARROW_PAD_LEFT = 103;
      return Tooltip.View = (function(_super) {

        __extends(View, _super);

        function View() {
          return View.__super__.constructor.apply(this, arguments);
        }

        View.prototype.template = View.prototype.templatePath("tooltip/view");

        View.prototype.events = {
          'click a.help': 'inlineClick',
          'mouseover a.help': '_mouseOver',
          'mouseout a.help': '_mouseOut'
        };

        View.prototype.ui = {
          inlineHelp: '.inline-help'
        };

        View.prototype.regions = {
          contentRegion: '.content-region'
        };

        View.prototype.onShow = function() {
          var $helpLink, $newHelpLink, $targetLi;
          $helpLink = this.ui.inlineHelp.children('a');
          $targetLi = $("." + ($helpLink.data('field')), this.$el);
          if ($targetLi.length < 1) {
            $targetLi = this.ui.inlineHelp.parents('li').first();
          }
          $targetLi.append($helpLink.clone());
          $newHelpLink = $targetLi.children('a');
          $helpLink.remove();
          if (this.ui.inlineHelp.find('div.wrap').length === 0) {
            this.ui.inlineHelp.wrapInner('<div class="wrap" />');
            this.ui.inlineHelp.find('h3').nextUntil('h3').wrapAll($('<div/>', {
              'class': 'content'
            }));
          }
          if (this.ui.inlineHelp.find('div.arrow').length === 0) {
            return this.ui.inlineHelp.prepend("<div class='arrow' />");
          }
        };

        View.prototype._mouseOver = function() {
          return $('a.help', this.$el).find('img').attr('src', '/assets/icons/silky/information_hover-14a9d682776bb882f5a94d77a6503aa1e2ad652adfe979d5790e09b4ba9930fe.png');
        };

        View.prototype._mouseOut = function() {
          return $('a.help', this.$el).find('img').attr('src', '/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png');
        };

        View.prototype._helpDivSelector = function(fieldKey) {
          return ".inline-help[data-field=\"" + fieldKey + "\"]";
        };

        View.prototype._hideAllHelp = function(notClause) {
          return $('.inline-help:visible').not(notClause).fadeOut().each(function() {
            var _this = this;
            return setTimeout((function() {
              return $(_this).appendTo($(_this).data('old_parent'));
            }), ARROW_PAD_LEFT);
          });
        };

        View.prototype.inlineClick = function(e) {
          var $helpDiv, $helpLink, arrowShift, left, pos, real_left, width,
            _this = this;
          if ($(e.currentTarget).data('showing')) {
            return;
          }
          $helpLink = $('a.help', this.$el);
          $(e.currentTarget).data('showing', true);
          _.defer((function() {
            return $(e.currentTarget).data('showing', false);
          }), 300);
          if (e) {
            e.preventDefault();
          }
          pos = $helpLink.offset();
          width = $helpLink.width();
          $helpDiv = $(this._helpDivSelector($helpLink.data('field')));
          this._hideAllHelp($helpDiv);
          $('body').unbind('click.reset-help');
          if ($helpDiv.is(':visible')) {
            $helpDiv.fadeOut();
            return setTimeout((function() {
              return $helpDiv.appendTo($helpDiv.data('old_parent'));
            }), ARROW_PAD_LEFT);
          } else {
            $helpDiv.data('old_parent', $helpDiv.parent().first());
            $helpDiv.appendTo($('body'));
            arrowShift = $helpDiv.width() - ARROW_PAD_LEFT;
            left = pos.left - arrowShift;
            real_left = left < 10 ? 10 : left;
            $('.arrow', $helpDiv).css({
              right: (78 + real_left - left) + 'px'
            });
            $helpDiv.css("left", "" + real_left + "px");
            $helpDiv.css("top", "" + (pos.top + 20) + "px");
            $helpDiv.fadeIn();
            return window.setTimeout(function() {
              return $('body').bind('click.reset-help', function(e) {
                if ($(e.target).parents('a.help').length || $(e.target).parents('inline-help').length) {
                  return;
                }
                $('body').unbind('click.reset-help');
                $helpDiv.fadeOut();
                setTimeout((function() {
                  return $helpDiv.appendTo($helpDiv.data('old_parent'));
                }), ARROW_PAD_LEFT);
                return e.preventDefault();
              });
            });
          }
        };

        return View;

      })(App.Views.Layout);
    });
  });

}).call(this);
