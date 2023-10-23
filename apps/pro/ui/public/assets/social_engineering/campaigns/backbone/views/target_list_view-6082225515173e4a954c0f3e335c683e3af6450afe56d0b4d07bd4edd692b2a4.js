(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.TargetListView = (function(_super) {

      __extends(TargetListView, _super);

      function TargetListView() {
        return TargetListView.__super__.constructor.apply(this, arguments);
      }

      TargetListView.prototype.initialize = function(opts) {
        this.options = opts;
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Submitting...',
          autoOpen: false,
          closeOnEscape: false
        });
        _.bindAll(this, 'deleteClicked');
        return TargetListView.__super__.initialize.apply(this, arguments);
      };

      TargetListView.prototype.onLoad = function() {
        var $table,
          _this = this;
        TargetListView.__super__.onLoad.apply(this, arguments);
        window.renderTargets();
        $table = $('table.list.sortable', this.el);
        $table.dataTable({
          sDom: 't<"list-table-footer clearfix"ip <"sel" l>>r',
          sPaginationType: 'r7Style',
          oLanguage: {
            sEmptyTable: "No data has been recorded."
          },
          aoColumns: [
            {
              bSortable: false
            }, {}, {}, {}
          ],
          fnDrawCallback: function() {
            var resetDeleteBtn;
            resetDeleteBtn = function() {
              var $boxes, anyChecked;
              $boxes = $(".table input[type=checkbox]", _this.el).not('[name^=all_]');
              anyChecked = _.find($boxes, function(box) {
                return $(box).is(':checked');
              });
              return $('.target-list-show .delete-span', _this.el).show().toggleClass('ui-disabled', !!!anyChecked);
            };
            $(".table input[name^=all_][type=checkbox]", _this.el).change(function(e) {
              var checked;
              checked = $(e.target).is(':checked');
              if (checked) {
                $('.table input[type=checkbox]', _this.el).attr('checked', 'checked');
              } else {
                $('.table input[type=checkbox]', _this.el).removeAttr('checked');
              }
              return resetDeleteBtn();
            });
            return $(".table input[type=checkbox]", _this.el).not('[name^=all_]').change(function(e) {
              var checked;
              checked = $(e.target).is(':checked');
              if (!checked) {
                $(".table input[name^=all_][type=checkbox]", _this.el).removeAttr('checked');
              }
              return resetDeleteBtn();
            });
          }
        });
        $('a.save-targets', this.el).click(function(e) {
          var $form;
          $form = $(e.target).parents('form').first();
          return _this.submitForm($form);
        });
        return $('.target-list-show .delete-span', this.el).click(this.deleteClicked);
      };

      TargetListView.prototype.submitForm = function($form, url) {
        var render,
          _this = this;
        if (url == null) {
          url = null;
        }
        this.loadingModal.dialog('open');
        render = function(data) {
          _this.loadingModal.dialog('close');
          $('.content-frame>.content', _this.el).html('');
          $('.content-frame>.content', _this.el).html(data);
          return _this.onLoad();
        };
        return $.ajax({
          url: url || $form.attr('action'),
          type: 'POST',
          data: $form.serialize(),
          success: function(data) {
            return render(data);
          },
          error: function(e) {
            return render(e.responseText);
          }
        });
      };

      TargetListView.prototype.deleteClicked = function(e) {
        var $form, url;
        if ($('.target-list-show  .delete-span').hasClass('ui-disabled')) {
          return;
        }
        if (!confirm("Are you sure you want to delete the selected Human Targets?")) {
          return;
        }
        $form = $('form', this.el).first();
        url = $form.attr('action') + '/remove_targets';
        return this.submitForm($form, url);
      };

      TargetListView.prototype.actionButtons = function() {
        if (this.options['buttons'] === false) {
          return [[['cancel primary', 'Done']]];
        } else {
          return [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]];
        }
      };

      TargetListView.prototype.save = function() {
        var $form,
          _this = this;
        $form = $('.target-list-new form', this.el);
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
        return TargetListView.__super__.save.apply(this, arguments);
      };

      return TargetListView;

    })(FormView);
  });

}).call(this);
