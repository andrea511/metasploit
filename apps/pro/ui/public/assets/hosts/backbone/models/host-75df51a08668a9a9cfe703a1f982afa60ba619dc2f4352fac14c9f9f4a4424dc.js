(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery'], function($) {
    var Host;
    return Host = (function(_super) {

      __extends(Host, _super);

      function Host() {
        this.update = __bind(this.update, this);

        this.removeTags = __bind(this.removeTags, this);
        return Host.__super__.constructor.apply(this, arguments);
      }

      Host.prototype.defaults = {
        id: 0,
        workspace_id: 0
      };

      Host.prototype.removeTags = function(_arg) {
        var id, success, tagIds,
          _this = this;
        tagIds = _arg.tagIds, success = _arg.success;
        id = this.get('id');
        return $.ajax({
          method: "POST",
          url: "/hosts/" + id + ".json",
          data: {
            '_method': "delete",
            workspace_id: this.attributes.workspace_id,
            remove_tag: {
              host_id: id
            },
            tag_ids: tagIds
          },
          success: function() {
            _this.attributes.tags = _.reject(_this.attributes.tags, function(tag) {
              return _.contains(tagIds, tag.id);
            });
            if (success != null) {
              return success();
            }
          }
        });
      };

      Host.prototype.update = function(_arg) {
        var error, id, params, success,
          _this = this;
        params = _arg.params, success = _arg.success, error = _arg.error;
        id = this.get('id');
        return $.ajax({
          method: "POST",
          url: "/hosts/" + id + ".json",
          data: _.extend(params, {
            '_method': "PATCH"
          }),
          success: function(data) {
            if ((data != null ? data.host : void 0) != null) {
              _this.set(data.host);
            }
            if (success != null) {
              return success(data);
            }
          },
          error: function(xhr) {
            var data;
            try {
              data = $.parseJSON(xhr.responseText);
              if (error != null) {
                return error(data);
              }
            } catch (e) {
              return console.error('Invalid 500 response from server.');
            }
          }
        });
      };

      return Host;

    })(Backbone.Model);
  });

}).call(this);
