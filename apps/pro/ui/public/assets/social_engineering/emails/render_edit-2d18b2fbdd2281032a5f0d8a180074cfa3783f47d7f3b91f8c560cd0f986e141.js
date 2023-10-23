(function() {

  jQuery(function($) {
    return window.renderEmailEdit = function() {
      var $config, $fileInputs, $form, $inputs, $textareaCodeMirror, $textareaWysiwyg, cellHeight, fileFormatSearch, moduleInitialConfig, modulePath, moduleTitle, sel, workspace, wysiwyg;
      $form = $('.ui-tabs-wrap:visible form');
      $inputs = $('select[name="social_engineering_email[attack_type]"]', $form);
      workspace = WORKSPACE_ID;
      fileFormatSearch = null;
      modulePath = $('meta[name=module-path]', $form).attr('content');
      moduleTitle = $('meta[name=module-title]', $form).attr('content');
      moduleInitialConfig = $.parseJSON($('meta[name=module-data]', $form).attr('content') || "null");
      $config = $('.exploit-module-config', $form);
      $inputs.change(function(e) {
        var newVal;
        newVal = $('option', $inputs).filter(':selected').val();
        $('.attack-box-options>div', $form).hide();
        if (newVal === 'none') {
          $('.shadow-arrow', $form).hide();
          return $('.attack-box-options', $form).hide();
        } else {
          $('.attack-box-options', $form).show();
          $('.shadow-arrow', $form).show().css({
            left: '49%',
            top: '-1px'
          });
          return $('.attack-box-options .' + newVal, $form).show();
        }
      });
      $inputs.first().change();
      $fileInputs = $('.file li.choice input', $form);
      $fileInputs.change(function(e) {
        var className;
        if (!$(this).filter(':checked')) {
          return;
        }
        className = $('input', $(this).parents('fieldset')).filter(':checked').val();
        $(".file>div", $form).hide();
        if (className) {
          $(".file ." + className, $form).css('display', 'block');
        }
        if (className === 'file_format') {
          if (!$(".file ." + className, $form).is(':visible')) {
            return;
          }
          fileFormatSearch || (fileFormatSearch = new ModuleSearch($('.file .file_format .load-modules', $form), {
            workspace: workspace,
            hiddenInputContainer: $config,
            fileFormat: true,
            extraQuery: '',
            modulePath: modulePath,
            moduleTitle: moduleTitle,
            moduleConfig: moduleInitialConfig,
            paramWrapName: 'social_engineering_email'
          }));
          fileFormatSearch.activate();
          return modulePath = moduleTitle = moduleInitialConfig = null;
        }
      });
      $fileInputs.change();
      $('.origin-box input[type=radio]', $form).click(function(e) {
        $('.origin-box .config>div', $form).hide();
        return $('.origin-box .config>div.' + $(this).val(), $form).show();
      });
      sel = $('.white-box.origin-box li.radio input:checked', $form).val();
      $('.white-box.origin-box .config>div.' + sel, $form).show();
      $textareaCodeMirror = $('.to-code-mirror', $form);
      $textareaWysiwyg = $textareaCodeMirror.clone().attr('id', 'social_engineering_email_content_wysiwyg').attr('name', 'ignore');
      $textareaWysiwyg.addClass('to-wysiwyg').removeClass('to-code-mirror');
      $textareaCodeMirror.after($textareaWysiwyg);
      wysiwyg = $textareaWysiwyg.wysiwyg({
        controls: {
          insertImage: {
            visible: false
          },
          code: {
            visible: false
          },
          table: {
            visible: false
          },
          insertTable: {
            visible: false
          },
          createLink: {
            visible: false
          },
          unLink: {
            visible: false
          }
        },
        iFrameClass: "wysiwyg-input"
      });
      cellHeight = $('.wysiwyg', $form).parents('.content').first().height();
      $('.wysiwyg iframe', $form).height(cellHeight - 200);
      $('.wysiwyg', $form).hide();
      $('.editor-box input[type=radio]', $form).change(function(e) {
        var $iframe, $preview, content, tmpl, url, val;
        if (!$(e.target).filter(':checked').size()) {
          return;
        }
        val = $(e.target).val();
        if (val === 'rich_text') {
          $('.CodeMirror', $form).hide();
          $('.preview', $form).hide();
          $('.wysiwyg', $form).show();
          $('.custom-attribute', $form).show();
          $textareaWysiwyg.attr('name', 'social_engineering_email[content]');
          $textareaCodeMirror.attr('name', 'ignore');
          $(wysiwyg).wysiwyg('setContent', $form.triggerHandler('getMirrorContent'));
          return $(wysiwyg).data('wysiwyg').editorDoc.body.focus();
        } else if (val === 'preview') {
          content = $form.triggerHandler('getEditorContent');
          $('.CodeMirror', $form).hide();
          $('.wysiwyg', $form).hide();
          $('.custom-attribute', $form).hide();
          $(wysiwyg).wysiwyg('setContent', content);
          $form.triggerHandler('setMirrorContent', {
            content: content
          });
          $preview = $('.preview', $form);
          $iframe = $preview.find('iframe');
          $iframe.contents().find('html').html('');
          $iframe.css({
            width: '100%',
            border: '0'
          });
          tmpl = $('li#social_engineering_email_template_input select option:selected', $form).val();
          url = $('meta[name=preview-url]', $form).attr('content');
          $preview.addClass('ui-loading').height(cellHeight - 200).show().css({
            overflow: 'scroll',
            border: '1px solid #ddd'
          });
          return $.ajax({
            url: url,
            type: 'post',
            data: {
              content: content,
              template_id: tmpl
            },
            success: function(data) {
              var h;
              $preview.show().removeClass('ui-loading');
              $iframe.contents().find('html').html(data);
              h = $('html', $iframe.contents()).height();
              $iframe.height(h);
              return $('.blocker', $form).height(h);
            }
          });
        } else {
          $('.CodeMirror', $form).show();
          $('.wysiwyg', $form).hide();
          $('.preview', $form).hide();
          $('.custom-attribute', $form).show();
          $textareaWysiwyg.attr('name', 'ignore');
          $textareaCodeMirror.attr('name', 'social_engineering_email[content]');
          content = $(wysiwyg).wysiwyg('getContent');
          return $form.triggerHandler('setMirrorContent', {
            content: content,
            autoformat: true
          });
        }
      });
      $('li#social_engineering_email_template_input select').change(function() {
        if ($('.preview', $form).is(':visible')) {
          return $('.editor-box input[type=radio]', $form).change();
        }
      });
      $form.bind('replaceWysiwygSelection', function(e, str) {
        return $(wysiwyg).data('wysiwyg').insertHtml(str);
      });
      $form.bind('getWysiwygSelection', function(e, str) {
        sel = $(wysiwyg).data('wysiwyg').getRangeText();
        if ($('.wysiwyg').is(':visible')) {
          return sel || '';
        }
        return null;
      });
      $form.bind('getWysiwygHTMLSelection', function(e, str) {
        var div, docFrag, html, range;
        range = $(wysiwyg).data('wysiwyg').getInternalRange();
        docFrag = range.cloneContents();
        div = document.createElement('div');
        div.appendChild(docFrag);
        html = $(div).html();
        if ($('.wysiwyg').is(':visible')) {
          return html || '';
        }
        return null;
      });
      $form.bind('getWysiwygRange', function(e, str) {
        var range;
        if ($('.wysiwyg:visible', $form).length > 0) {
          return range = $(wysiwyg).data('wysiwyg').getInternalRange();
        } else {
          return null;
        }
      });
      $form.bind('syncWysiwyg', function() {
        return $(wysiwyg).data('wysiwyg').saveContent();
      });
      $form.bind('getEditorSelection', function() {
        if ($('.wysiwyg:visible', $form).length > 0) {
          return $form.triggerHandler('getWysiwygHTMLSelection');
        } else {
          return $form.triggerHandler('getMirrorSelection');
        }
      });
      $form.bind('getEditorContent', function() {
        if ($('.wysiwyg', $form).is(':visible')) {
          return $(wysiwyg).wysiwyg('getContent');
        } else {
          return $form.triggerHandler('getMirrorContent');
        }
      });
      $form.bind('setEditorContent', function(e, content) {
        if ($('.wysiwyg:visible', $form).length > 0) {
          return $(wysiwyg).setContent(content);
        } else {
          return $form.triggerHandler('setMirrorContent', {
            content: content
          });
        }
      });
      $form.bind('setWysiwygContent', function(e, content) {
        return $(wysiwyg).data('wysiwyg').setContent(content);
      });
      $form.bind('setWysiwygSelectionRange', function(e, selRange) {
        return $(wysiwyg).data('wysiwyg').setInternalSelection(selRange.start, selRange.end);
      });
      $form.bind('getWysiwygSelectionRange', function(e, selRange) {
        return $(wysiwyg).data('wysiwyg').getInternalRange(selRange.start, selRange.end);
      });
      $form.bind('getEditorCursorPosition', function(e, content) {
        if ($('.wysiwyg:visible', $form).length > 0) {
          return $(wysiwyg).data('wysiwyg').getInternalRange().startOffset;
        } else {
          return $form.triggerHandler('getMirrorCursorPosition');
        }
      });
      $form.bind('getWysiwygCursorContainer', function(e, content) {
        return $(wysiwyg).data('wysiwyg').getInternalRange();
      });
      return $form.bind('getEditorSelectionRange', function(e, content) {
        if ($('.wysiwyg:visible', $form).length > 0) {
          return $form.triggerHandler('getWysiwygSelectionRange');
        } else {
          return $form.triggerHandler('getMirrorSelectionRange');
        }
      });
    };
  });

}).call(this);
