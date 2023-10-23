(function() {

  define(['jquery', 'apps/imports/file/file_controller'], function($) {
    return describe('ImportsApp.Nexpose.Controller', function() {
      set('regionEl', function() {
        return $("<div />").appendTo($('body'))[0];
      });
      set('region', function() {
        return new Backbone.Marionette.Region({
          el: regionEl
        });
      });
      afterEach(function() {
        return region.reset();
      });
      return describe('when it initially loads the page', function() {
        beforeEach(function() {
          this.controller = new Pro.ImportsApp.File.Controller();
          return region.show(this.controller._mainView);
        });
        it('renders the view', function() {
          return expect($(regionEl).children().length).toBeGreaterThan(0);
        });
        it('renders the file input', function() {
          return expect($('#file_input').length).toEqual(1);
        });
        return it('renders the excluded addresses field', function() {
          return expect($('#nexpose_scan_task_blacklist_string').length).toEqual(1);
        });
      });
    });
  });

}).call(this);
