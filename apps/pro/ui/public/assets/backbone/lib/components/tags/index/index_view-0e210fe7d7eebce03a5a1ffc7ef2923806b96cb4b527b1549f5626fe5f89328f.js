(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'lib/components/tags/index/templates/layout', 'lib/components/tags/index/templates/tag_composite', 'base_view', 'base_itemview', 'base_layout', 'base_compositeview'], function($, Template, TokenInput, ModalForm) {
    return this.Pro.module('Components.Tags.Index', function(Index, App, Backbone, Marionette, $, _) {
      var DELETE_CONFIRM_MESSAGE, NAME_SYMBOL;
      NAME_SYMBOL = "$NAME";
      DELETE_CONFIRM_MESSAGE = "Are you sure you want to remove the tag \"" + NAME_SYMBOL + "\?";
      Index.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          this.triggerHideHover = __bind(this.triggerHideHover, this);

          this.triggerHover = __bind(this.triggerHover, this);
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('tags/index/layout');

        Layout.prototype.ui = {
          tagCount: '.tag-count a',
          tags: '.tags>.row'
        };

        Layout.prototype.regions = {
          tagHover: '.tag-hover-region'
        };

        Layout.prototype.events = {
          'mouseenter @ui.tagCount': 'setHoverTimeout',
          'mouseleave @ui.tags': 'clearHoverTimeout',
          'mouseleave @ui.tagCount': 'clearHoverTimeout',
          'mouseleave @ui.tags': 'setHideHoverTimeout',
          'mouseenter @ui.tags': 'clearHideHoverTimeout',
          'mouseleave': 'setHideHoverTimeout'
        };

        Layout.prototype.setHoverTimeout = function() {
          var _ref, _ref1;
          if (!(!(((_ref = this.model) != null ? _ref.tagUrl : void 0) != null) && parseInt((_ref1 = this.model) != null ? _ref1.get('tag_count') : void 0) === 0)) {
            return this.hoverTimeout = setTimeout(this.triggerHover, 100);
          }
        };

        Layout.prototype.clearHoverTimeout = function() {
          return clearTimeout(this.hoverTimeout);
        };

        Layout.prototype.setHideHoverTimeout = function() {
          return this.hideHoverTimeout = setTimeout(this.triggerHideHover, 200);
        };

        Layout.prototype.clearHideHoverTimeout = function() {
          return clearTimeout(this.hideHoverTimeout);
        };

        Layout.prototype.triggerHover = function() {
          return this.trigger('show:tag:hover');
        };

        Layout.prototype.triggerHideHover = function() {
          return this.trigger('hide:tag:hover');
        };

        Layout.prototype.increment = function(increment) {
          var count;
          if (increment == null) {
            increment = 1;
          }
          count = parseInt(this.ui.tagCount.html()) + increment;
          return this.ui.tagCount.html(_.escape("" + count + " tags"));
        };

        Layout.prototype.decrement = function(decrement) {
          var count;
          if (decrement == null) {
            decrement = 1;
          }
          count = parseInt(this.ui.tagCount.html()) - decrement;
          return this.ui.tagCount.html(_.escape("" + count + " tags"));
        };

        return Layout;

      })(App.Views.Layout);
      return Index.TagCompositeView = (function(_super) {

        __extends(TagCompositeView, _super);

        function TagCompositeView() {
          this.deleteTagClicked = __bind(this.deleteTagClicked, this);
          return TagCompositeView.__super__.constructor.apply(this, arguments);
        }

        TagCompositeView.prototype.template = TagCompositeView.prototype.templatePath('tags/index/tag_composite');

        TagCompositeView.prototype.className = 'tags';

        TagCompositeView.prototype.events = {
          'click a.tag-close': 'deleteTagClicked',
          'click a.green-add': 'addTagClicked'
        };

        TagCompositeView.prototype.modelEvents = {
          'change': 'render'
        };

        TagCompositeView.prototype.ui = {
          tag: '.tag-count'
        };

        TagCompositeView.prototype.initialize = function(opts) {
          this.serverAPI = opts.serverAPI;
          this.model = opts.model;
          return TagCompositeView.__super__.initialize.call(this, opts);
        };

        TagCompositeView.prototype.serializeData = function() {
          var tags;
          tags = this.model.get('tags') || [];
          return {
            model: this.model,
            lastTags: tags,
            tagCount: tags.length,
            workspace_id: this.model.get('workspace_id')
          };
        };

        TagCompositeView.prototype.addTagClicked = function(e) {
          var collection, controller, id, ids, models, query, url,
            _this = this;
          e.preventDefault();
          id = this.model.get('id');
          if (!id || id < 1) {
            return;
          }
          ids = [id];
          models = _.map(ids, function(id) {
            return new Backbone.Model({
              id: id
            });
          });
          collection = new Backbone.Collection(models);
          query = "";
          url = this.model.tagUrl != null ? url = this.model.tagUrl() : url = this.model.get('tagUrl');
          controller = App.request('tags:new:component', collection, {
            q: query,
            url: url,
            content: this.model.get('taggingModalHelpContent'),
            serverAPI: this.serverAPI,
            tagSingle: true
          });
          return App.execute("showModal", controller, {
            modal: {
              title: 'Tags',
              description: '',
              height: 170,
              width: 400,
              hideBorder: true
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
              _this.trigger("tag:increment", controller.tagCount);
              return App.vent.trigger('core:tag:added', _this.model.collection);
            }
          });
        };

        TagCompositeView.prototype.deleteTagClicked = function(e) {
          var $wrap, confirmMsg, id, tagName,
            _this = this;
          e.preventDefault();
          id = parseInt($(e.currentTarget).attr('data-id'));
          if (!id || id < 1) {
            return;
          }
          tagName = _.string.trim($(e.currentTarget).prev('a.tag').text());
          confirmMsg = DELETE_CONFIRM_MESSAGE.replace(NAME_SYMBOL, tagName);
          if (!confirm(confirmMsg)) {
            return;
          }
          $wrap = $(e.currentTarget).closest('div');
          $(e.currentTarget).prev('a.tag').first().remove();
          $(e.currentTarget).remove();
          $wrap.remove();
          return this.model.removeTag({
            tagId: id,
            success: function() {
              _this.trigger("tag:decrement");
              _this.render();
              return App.vent.trigger('core:tag:removed', _this.model.collection);
            }
          });
        };

        TagCompositeView.prototype.showTags = function() {
          var _this = this;
          return this.model.fetchTags(function(model) {
            return _this.$el.css('display', 'block');
          });
        };

        TagCompositeView.prototype.hideTags = function() {
          return this.$el.css('display', 'none');
        };

        TagCompositeView.prototype.clearTagHovers = function() {
          return $('.tag-hover-region>.tags').css('display', 'none');
        };

        return TagCompositeView;

      })(App.Views.CompositeView);
    });
  });

}).call(this);
