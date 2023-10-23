(function() {

  jQuery(function($) {
    return window.renderCodeMirror = function(topOffset) {
      var $file_type, $form, $prefix, $vhostField, cellHeight, cmHeight, mirror, selectedText, textarea, vhostName;
      if (topOffset == null) {
        topOffset = 180;
      }
      $form = $('.ui-tabs-wrap:visible form,form.social_engineering_email_template,form.social_engineering_web_template');
      textarea = $('textarea.to-code-mirror', $form)[0];
      cellHeight = $(textarea).parents('.content').first().height();
      cmHeight = cellHeight - topOffset || 600;
      mirror = CodeMirror.fromTextArea(textarea, {
        lineNumbers: true,
        matchBrackets: true,
        mode: "htmlmixed",
        tabSize: 2,
        indentUnit: 2,
        indentWithTabs: true,
        enterMode: "keep",
        tabMode: "shift",
        lineWrapping: true,
        height: cmHeight + 'px'
      });
      $('.CodeMirror-scroll').css({
        height: "" + cmHeight + "px"
      });
      $(textarea).bind('loadFromEditor', function() {
        return mirror.save();
      });
      selectedText = '';
      $vhostField = $('input[name="social_engineering_web_page[path]"]', $form);
      $file_type = $('input[name="social_engineering_web_page[file_generation_type]"]', $form);
      $file_type.click(function(e) {
        if ($(e.currentTarget).val() === "exe_agent" && $vhostField.val().indexOf('.exe') === -1) {
          return $vhostField.val($vhostField.val() + '.exe');
        } else if ($(e.currentTarget).val() !== "exe_agent" && $vhostField.val().indexOf('.exe') !== -1) {
          return $vhostField.val($('input[name="social_engineering_web_page[path]"]').val().slice(0, $vhostField.val().indexOf('.exe')));
        }
      });
      if ($vhostField.size()) {
        $vhostField.val($vhostField.val().replace(/^\//, ''));
        vhostName = $vhostField.attr('data-content');
        $prefix = $('<div class="vhost-prefix"></div>').text('http://' + vhostName + '/');
        $vhostField.before($prefix);
      }
      $form.bind('updateMirror', function(e, str) {
        mirror.setValue(str);
        return mirror.autoFormatRange({
          ch: 0,
          line: 0
        }, {
          ch: 0,
          line: mirror.lineCount()
        });
      });
      $form.bind('replaceMirrorSelection', function(e, str) {
        if ($('.CodeMirror', $form).is(':visible')) {
          return mirror.replaceSelection(str);
        }
      });
      $form.bind('getMirrorSelection', function(e) {
        if ($('.CodeMirror', $form).is(':visible')) {
          return mirror.getSelection();
        } else {
          return null;
        }
      });
      $form.bind('getMirrorContent', function(e) {
        return mirror.getValue();
      });
      $form.bind('setMirrorContent', function(e, opts) {
        mirror.setValue(opts['content']);
        if (opts['autoformat']) {
          return mirror.autoFormatRange({
            ch: 0,
            line: 0
          }, {
            ch: 0,
            line: mirror.lineCount()
          });
        }
      });
      $form.bind('getMirrorSelectionRange', function(e, opts) {
        var first, selEnd, selStart;
        if ($('.CodeMirror', $form).is(':visible')) {
          first = {
            line: 0,
            ch: 0
          };
          selStart = mirror.getCursor(true);
          selEnd = mirror.getCursor(false);
          return {
            start: mirror.getRange(first, selStart).length,
            end: mirror.getRange(first, selEnd).length
          };
        } else {
          return null;
        }
      });
      return $form.bind('getMirrorCursorPosition', function(e) {
        var end, start;
        start = {
          line: 0,
          ch: 0
        };
        end = mirror.getCursor(false);
        return mirror.getRange(start, end).length;
      });
    };
  });

}).call(this);
