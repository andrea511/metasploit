(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.MaliciousFileView = (function(_super) {

      __extends(MaliciousFileView, _super);

      function MaliciousFileView() {
        return MaliciousFileView.__super__.constructor.apply(this, arguments);
      }

      MaliciousFileView.prototype.initialize = function() {
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Submitting... ',
          autoOpen: false,
          closeOnEscape: false
        });
        return MaliciousFileView.__super__.initialize.apply(this, arguments);
      };

      MaliciousFileView.prototype.onLoad = function() {
        MaliciousFileView.__super__.onLoad.apply(this, arguments);
        $("input[name='social_engineering_user_submitted_file[name]']", this.el).focus();
        return $('form', this.el).submit(function(e) {
          return e.preventDefault();
        });
      };

      MaliciousFileView.prototype.renderHeader = function() {
        MaliciousFileView.__super__.renderHeader.apply(this, arguments);
        $('.header .page-circles', this.el).hide();
        return $('.header', this.el).addClass('no-box-shadow');
      };

      MaliciousFileView.prototype.actionButtons = function() {
        return [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]];
      };

      MaliciousFileView.prototype.save = function() {
        var $form,
          _this = this;
        $form = $('form', this.el);
        this.loadingModal.dialog('open');
        $.ajax({
          url: $form.attr('action'),
          type: 'POST',
          files: $(':file', $form),
          data: $('input,select,textarea', $form).not(':file').serializeArray(),
          iframe: true,
          processData: false,
          success: function(data, status) {
            var jsonData, saveStatus;
            $('.content', _this.el).html(data);
            _this.loadingModal.dialog('close');
            saveStatus = $('meta[name=save-status]', _this.el).attr('content');
            if (saveStatus === 'false' || !saveStatus) {
              return _this.onLoad();
            } else {
              jsonData = $.parseJSON(saveStatus);
              return _this.close();
            }
          },
          error: function() {
            return _this.loadingModal.dialog('close');
          }
        });
        return MaliciousFileView.__super__.save.apply(this, arguments);
      };

      return MaliciousFileView;

    })(FormView);
  });

}).call(this);
