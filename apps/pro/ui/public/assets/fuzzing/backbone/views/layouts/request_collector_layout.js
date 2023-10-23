(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/templates/fuzzing/layouts/request_collector_layout-ddbdda3f22a3021f8d4bc62e217ce2e6d0aa8af7d402d854dfcc61be6c89d4d1.js', '/assets/fuzzing/backbone/views/item_views/request_item_view-c819cf48afe2485388bfd20e680065c93b51ebd8256a9c65c882a08ec3723ba2.js', '/assets/fuzzing/backbone/views/item_views/request_input_item_view-9bf460297b44ab1d75c3612dd81721695e8c4ea53b39f76bed47267c1048db81.js', '/assets/fuzzing/backbone/views/collection_views/request_collection_view-29a69f7df62aa738707c43631970e8406bea0490b3c471f499af737d8d209bb8.js', '/assets/fuzzing/backbone/collections/request_group_collection-7df3379aa2c130ad18acc8e313e4591c091ea57698e8a2092d61e46700bebb39.js'], function(Template, RequestItemView, RequestInputItemView, RequestCollectionView, RequestGroupCollection) {
    var RequestCollectorLayout;
    return RequestCollectorLayout = (function(_super) {

      __extends(RequestCollectorLayout, _super);

      function RequestCollectorLayout() {
        return RequestCollectorLayout.__super__.constructor.apply(this, arguments);
      }

      RequestCollectorLayout.prototype.template = HandlebarsTemplates['fuzzing/layouts/request_collector_layout'];

      RequestCollectorLayout.prototype.regions = {
        requests: '.requests',
        request_input: '.request-input'
      };

      RequestCollectorLayout.prototype.onRender = function() {
        this._initData();
        return this._showRequestInput();
      };

      RequestCollectorLayout.prototype._showRequestInput = function() {
        this.request_input_item_view = new RequestInputItemView;
        this.requests.show(this.request_collection_view);
        return this.request_input.show(this.request_input_item_view);
      };

      RequestCollectorLayout.prototype._initData = function() {
        this.request_collection = RequestGroupCollection;
        this.request_collection.workspace_id = 1;
        this.request_collection.fuzzing_id = 3;
        this.request_collection.fetch;
        return this.request_collection_view = new RequestCollectionView({
          itemView: RequestItemView,
          collection: this.request_collection
        });
      };

      return RequestCollectorLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
