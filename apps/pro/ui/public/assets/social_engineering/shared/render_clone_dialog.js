(function() {

  jQuery(function($) {
    var cloneDialog;
    cloneDialog = null;
    return window.renderCloneDialog = function() {
      var d;
      d = $('#cloneWebsite .config .clone-web-options', this.el).clone();
      $('.check-with-text', d).on('change', function() {
        var textbox;
        textbox = $($(this).data('enabled-text'), $(this).closest('.checkbox-and-text'));
        if ($(this).is(':checked')) {
          textbox.prop('disabled', false);
          return textbox.focus();
        } else {
          return textbox.prop('disabled', true);
        }
      });
      return d.show().dialog({
        title: 'Clone Website',
        modal: true,
        width: 320,
        closeOnEscape: false,
        autoResize: true,
        close: function() {
          return $(this).dialog('destroy').remove();
        },
        open: function() {
          var _this = this;
          $('.ui-dialog-buttonpane', $(this).parent()).show();
          return _.defer((function() {
            return $('input', _this).first().blur().delay(1).focus();
          }));
        },
        buttons: {
          "Cancel": function() {
            return $(this).dialog("close");
          },
          "Clone": function() {
            var $form, action, cloner, dataHash, origin,
              _this = this;
            $('.ui-dialog-buttonpane', $(this).parent()).hide();
            $('>.clone-content', this).hide();
            $('>.loading', this).show();
            dataHash = $('.clone-content input', this).serializeArray();
            $form = $('.ui-tabs-wrap:visible form').first();
            if (!$form.size()) {
              $form = $('form').last();
            }
            action = $form.attr('action').replace(/\?.*$/, '').replace(/\/\d+$/, '');
            origin = "" + action + "/clone_proxy.json";
            cloner = new HTMLCloner({
              origin: origin,
              success: function(data, status) {
                var err;
                $('.ui-dialog-buttonpane', $(_this).parent()).show();
                $('>.clone-content', _this).show();
                $('>.loading', _this).hide();
                if (data['error']) {
                  err = data['error'];
                  return $('.clone-content .error', _this).show().text(err);
                } else {
                  $('.clone-content .error', _this).hide();
                  $form.trigger('updateMirror', data.body);
                  return $(_this).dialog('close');
                }
              }
            });
            return cloner.cloneURL(dataHash);
          }
        }
      });
    };
  });

}).call(this);
