(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/tags/form-f6df3ebb69ee6dedd65cd5242d812c4c970e60da05ff82650963505a3e25ed3f.js', '/assets/jquery.tokeninput-967a3a6cea335c7437dfcd702c96692ceca5ce17cb0c075fb10578f754fcb141.js', '/assets/shared/backbone/views/modal_form-a8fcc1003908ec851dabba8dcccd809004d4ff400643d83bac7fe2661ec929df.js'], function($, Template, TokenInput, ModalForm) {
    var TagForm;
    return TagForm = (function(_super) {

      __extends(TagForm, _super);

      function TagForm() {
        this._showError = __bind(this._showError, this);

        this._removeError = __bind(this._removeError, this);

        this._tagRoute = __bind(this._tagRoute, this);

        this._nameField = __bind(this._nameField, this);

        this.formSubmitted = __bind(this.formSubmitted, this);

        this.onShow = __bind(this.onShow, this);

        this.focus = __bind(this.focus, this);

        this.serialize = __bind(this.serialize, this);
        return TagForm.__super__.constructor.apply(this, arguments);
      }

      TagForm.prototype.template = HandlebarsTemplates['tags/form'];

      TagForm.prototype.events = {
        'submit form': 'formSubmitted'
      };

      TagForm.prototype.initialize = function(opts) {
        if (opts == null) {
          opts = {};
        }
        $.extend(this, opts);
        return TagForm.__super__.initialize.apply(this, arguments);
      };

      TagForm.prototype.serialize = function() {
        return this;
      };

      TagForm.prototype.focus = function() {
        return this.$el.find('input:visible').focus();
      };

      TagForm.prototype.onShow = function() {
        var nameField, route, wid;
        nameField = this._nameField();
        if (nameField.data('tokenInputObject') == null) {
          wid = this.workspace_id || window.WORKSPACE_ID;
          route = Routes.search_workspace_tags_path(wid, {
            format: 'json'
          });
          return nameField.tokenInput(route, {
            theme: "metasploit",
            hintText: "Type in a tag name...",
            searchingText: "Searching tags...",
            allowCustomEntry: true,
            preventDuplicates: true,
            allowFreeTagging: true,
            resultsLimit: 3
          });
        }
      };

      TagForm.prototype.formSubmitted = function(e) {
        var data, tokens,
          _this = this;
        this._removeError();
        this.setLoading(true);
        e.preventDefault();
        tokens = _.map(this._nameField().data('tokenInputObject').getTokens(), function(tok) {
          return tok.name;
        });
        data = {
          host_ids: _.map(this.hosts, function(h) {
            return h.id;
          }),
          new_host_tags: tokens.join(','),
          preserve_existing: true
        };
        return $.ajax({
          url: this._tagRoute(),
          method: 'POST',
          data: data,
          success: function(x) {
            _this.hosts[0].set(x.host);
            if (_this.modal != null) {
              return _this.modal.destroy();
            }
          },
          error: function(x) {
            var json;
            json = $.parseJSON(x.responseText);
            _this._showError(json.error);
            return _this.setLoading(false);
          }
        });
      };

      TagForm.prototype._nameField = function() {
        return $('[name=name]', this.el);
      };

      TagForm.prototype._tagRoute = function() {
        return "/workspaces/" + window.WORKSPACE_ID + "/hosts/quick_multi_tag.json";
      };

      TagForm.prototype._removeError = function() {
        return $('form .error', this.el).remove();
      };

      TagForm.prototype._showError = function(err) {
        var $errDiv;
        this._removeError();
        $errDiv = $('<li />', {
          "class": 'error'
        });
        $errDiv.text(err);
        return $('form', this.el).prepend($errDiv);
      };

      return TagForm;

    })(ModalForm);
  });

}).call(this);
