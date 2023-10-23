(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/tasks/new_nexpose_exception_push/backbone/views/layouts/new_nexpose_exception_push_layout-f6236df113255fdc9c567bb6003bd6bd8dd322bbe3cad476634ceea207849d6e.js'], function($, NewNexposeExceptionPushLayout, TabsLayout) {
    var ExceptionPushController;
    return ExceptionPushController = (function() {

      function ExceptionPushController() {
        this.start = __bind(this.start, this);

      }

      ExceptionPushController.prototype.start = function() {
        var consoles;
        this.region = new Backbone.Marionette.Region({
          el: "#exception-push"
        });
        this.exception_reasons = $('meta[name="exception_reasons"]').attr('content');
        consoles = _.map(this.NEXPOSE_CONSOLES, function(val, key) {
          return {
            value: val.id,
            text: val.name
          };
        });
        this.model = new Backbone.Model({
          console: {
            consoles: consoles,
            console: consoles[0].value
          },
          date: ""
        });
        return this.region.show(new NewNexposeExceptionPushLayout({
          model: this.model,
          controller: this
        }));
      };

      ExceptionPushController.prototype.EXCEPTION_REASONS = $.parseJSON($('meta[name="exception_reasons"]').attr('content'));

      ExceptionPushController.prototype.VULN_IDS = $.parseJSON($('meta[name="vuln_ids"]').attr('content'));

      ExceptionPushController.prototype.NEXPOSE_CONSOLES = $.parseJSON($('meta[name="consoles"]').attr('content'));

      ExceptionPushController.prototype.MATCH_SET_ID = $.parseJSON($('meta[name="match_set_id"]').attr('content'));

      return ExceptionPushController;

    })();
  });

}).call(this);
