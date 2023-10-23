(function() {

  define(['/assets/fuzzing/backbone/views/regions/app_region-873d0557e676774e593c36272b8999599abb38c8c630e2791063763a54e71d19.js', '/assets/fuzzing/backbone/views/layouts/fuzzing_frame_layout-22fcc37f9fb43ba97bcd330d8833c1f4907ec2a1657d19f3bb8c6e200dc38379.js', '/assets/fuzzing/backbone/views/layouts/request_collector_layout-0b3e2a1a850bb4c1d29ccdd3bb8d256b53aa70780c5d8df895b5b844c1249d49.js', '/assets/fuzzing/backbone/views/item_views/result_page_header_item_view-fa427b5fa9dd816ebd6f7bbe3cf5db4ab43bf1a453eab70126523591bfe84b57.js', '/assets/fuzzing/backbone/views/item_views/fuzzing_iframe_item_view-60751b9afdec1074052d53859882a707f8b994b0a5479553cb26d7c2ba07b1c0.js', '/assets/fuzzing/backbone/views/layouts/fuzzing_xss_attack_layout-546d56c4107392dae2181fb61d775560577b0537d17add70f7906e0ec43bfbe9.js', '/assets/fuzzing/backbone/views/item_views/fuzzing_attack_header_item_view-f14c0e168ccf53ff57860c512fa10ed831e685b8a6f669ce955b486ecd30c6c4.js'], function(AppRegion, FuzzingFrameLayout, RequestCollectorLayout, ResultPageHeaderItemView, FuzzingIframeItemView, FuzzingXSSAttackLayout, FuzzingAttackHeaderItemView) {
    var FuzzingFrameController;
    return FuzzingFrameController = (function() {

      function FuzzingFrameController() {
        this.app_region = new AppRegion;
        this.fuzzing_frame_layout = new FuzzingFrameLayout;
        this.app_region.show(this.fuzzing_frame_layout);
      }

      FuzzingFrameController.prototype._layout_region_reset = function() {
        this.fuzzing_frame_layout.top_row.reset();
        this.fuzzing_frame_layout.middle_row.reset();
        return this.fuzzing_frame_layout.bottom_row.reset();
      };

      FuzzingFrameController.prototype._initFuzzzingFrame = function() {
        this.fuzzing_xss_attack_layout = new FuzzingXSSAttackLayout;
        this.fuzzing_iframe_item_view = new FuzzingIframeItemView;
        return this.fuzzing_attack_header_item_view = new FuzzingAttackHeaderItemView;
      };

      FuzzingFrameController.prototype._initRequestCollector = function() {
        this.request_collector_layout = new RequestCollectorLayout;
        this.result_page_header_item_view = new ResultPageHeaderItemView;
        return this.fuzzing_iframe_item_view = new FuzzingIframeItemView;
      };

      FuzzingFrameController.prototype.showFuzzingFrame = function() {
        this._initFuzzzingFrame();
        this._layout_region_reset();
        this.fuzzing_frame_layout.top_row.show(this.fuzzing_xss_attack_layout);
        this.fuzzing_frame_layout.middle_row.show(this.fuzzing_attack_header_item_view);
        return this.fuzzing_frame_layout.bottom_row.show(this.fuzzing_iframe_item_view);
      };

      FuzzingFrameController.prototype.showRequestCollector = function() {
        this._initRequestCollector();
        this._layout_region_reset();
        this.fuzzing_frame_layout.top_row.show(this.request_collector_layout);
        this.fuzzing_frame_layout.middle_row.show(this.result_page_header_item_view);
        return this.fuzzing_frame_layout.bottom_row.show(this.fuzzing_iframe_item_view);
      };

      return FuzzingFrameController;

    })();
  });

}).call(this);
