(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/tag_layout-9f16b59e57d3626d74d6b12495bc89b686f240770d0e3c790755b08f2f939648.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', '/assets/tags/backbone/views/form-4edd96c21159cc29c9f39b363f76d66f660b3b1bdfef459734d3d342085114d4.js'], function($, Template, Modal, TagForm) {
    var DELETE_CONFIRM_MESSAGE, DISPLAY_TAG_COUNT, NAME_SYMBOL, TagLayout;
    NAME_SYMBOL = "$NAME";
    DELETE_CONFIRM_MESSAGE = "Are you sure you want to remove the tag \"" + NAME_SYMBOL + "\" from this host?";
    DISPLAY_TAG_COUNT = 3;
    return TagLayout = (function(_super) {

      __extends(TagLayout, _super);

      function TagLayout() {
        this.render = __bind(this.render, this);

        this.addTagClicked = __bind(this.addTagClicked, this);

        this.deleteTagClicked = __bind(this.deleteTagClicked, this);

        this.onShow = __bind(this.onShow, this);
        return TagLayout.__super__.constructor.apply(this, arguments);
      }

      TagLayout.DELETE_CONFIRM_MESSAGE = "Are you sure you want to remove the tag \"" + NAME_SYMBOL + "\" from this host?";

      TagLayout.prototype.initialize = function(_arg) {
        this.host = _arg.host;
        return this.host.on('change', this.render);
      };

      TagLayout.prototype.template = HandlebarsTemplates['hosts/layouts/tag_layout'];

      TagLayout.prototype.serializeData = function() {
        var tags;
        tags = this.host.get('tags') || [];
        return {
          host: this.host,
          lastTags: tags.slice(-DISPLAY_TAG_COUNT).reverse(),
          tagCount: tags.length,
          moreTagCount: tags.length - DISPLAY_TAG_COUNT,
          workspace_id: this.host.get('workspace_id'),
          otherTags: tags.slice(0, -DISPLAY_TAG_COUNT).reverse()
        };
      };

      TagLayout.prototype.events = {
        'click a.tag-close': 'deleteTagClicked',
        'click a.green-add': 'addTagClicked'
      };

      TagLayout.prototype.onShow = function() {
        return $(this.el).tooltip();
      };

      TagLayout.prototype.deleteTagClicked = function(e) {
        var $more, $wrap, confirmMsg, id, m, tagName, x,
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
        $wrap = $(e.currentTarget).parents('div.wrap');
        $(e.currentTarget).prev('a.tag').first().remove();
        $(e.currentTarget).remove();
        $wrap.remove();
        $more = $('a.more', this.el);
        if ((m = $more.text().match(/(\d+) more/))) {
          x = parseInt(m[1]) - 1;
          if (x <= 0) {
            $more.remove();
          } else {
            $more.text("" + x + " more…");
          }
        }
        return this.host.removeTags({
          tagIds: [id],
          success: function() {
            return _this.render();
          }
        });
      };

      TagLayout.prototype.addTagClicked = function(e) {
        var form;
        e.preventDefault();
        if (this.modal) {
          this.modal.destroy();
        }
        this.modal = new Modal({
          "class": 'flat',
          title: 'Add Tags',
          width: 400
        });
        this.modal.open();
        form = new TagForm({
          hosts: [this.host],
          modal: this.modal
        });
        this.modal.content.show(form);
        this.modal._center();
        return form.focus();
      };

      TagLayout.prototype.render = function() {
        var $newDropdowns, data;
        data = _.map($('.under,.menu', this.el), function(el) {
          return [el, $(el).is(':visible')];
        });
        TagLayout.__super__.render.apply(this, arguments);
        $newDropdowns = $('.under,.menu', this.el);
        _.each($newDropdowns, function(newDropdown, i) {
          if ((data[i] != null) && data[i][1]) {
            return $(newDropdown).addClass('hover');
          }
        });
        return _.defer(function() {
          return $newDropdowns.removeClass('hover');
        });
      };

      return TagLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
