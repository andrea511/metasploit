(function() {

  jQuery(function($) {
    return window.renderWebPageEdit = function() {
      var $config, $f1, $f2, $fileInputs, $form, $inputs, $label, $li, $r1, $r2, bapSearch, exploitSearch, fileFormatSearch, javaSearch, moduleInitialConfig, modulePath, moduleTitle, sel, workspace;
      $form = $('.ui-tabs-wrap:visible form').first();
      sel = $('.white-box li.radio input:checked', $form).val();
      $('.white-box .config>div.' + sel, $form).show();
      $r1 = $('input[name=\'social_engineering_web_page[phishing_redirect_origin]\']', $form).eq(0);
      $li = $r1.parents('li');
      $r2 = $('input[name=\'social_engineering_web_page[phishing_redirect_origin]\']', $form).eq(1);
      $r1.css({
        width: 'auto',
        'margin-right': '10px'
      });
      $r2.css({
        width: 'auto',
        'margin-right': '10px'
      });
      $f1 = $('input[name=\'social_engineering_web_page[phishing_redirect_specified_url]\']', $form);
      $f1.css('width', '90%').before($r1);
      $f2 = $('select[name=\'social_engineering_web_page[phishing_redirect_web_page_id]\']', $form);
      $f2.css('width', '200px').before($r2);
      $label = $('<span>').text('Choose another attack page to redirect to');
      $label.css({
        'position': 'relative',
        'top': '4px',
        'padding-right': '10px'
      });
      $f2.before($label);
      $li.remove();
      $f1.focus(function() {
        return $r1.prop('checked', true) && $r2.prop('checked', false);
      });
      $f2.focus(function() {
        return $r2.prop('checked', true) && $r1.prop('checked', false);
      });
      $r1.click(function() {
        return $f1.focus();
      });
      $r2.click(function() {
        return $f2.focus();
      });
      $label.click(function() {
        return $f2.focus();
      });
      $('select[name=\'social_engineering_web_page[phishing_redirect_web_page_id]\']', $form).change(function() {
        return $('input[name=\'social_engineering_web_page[phishing_redirect]\']', $form).val('');
      });
      $inputs = $('select[name="social_engineering_web_page[attack_type]"]', $form);
      workspace = WORKSPACE_ID;
      exploitSearch = null;
      bapSearch = null;
      javaSearch = null;
      fileFormatSearch = null;
      modulePath = $('meta[name=module-path]', $form).attr('content');
      moduleTitle = $('meta[name=module-title]', $form).attr('content');
      moduleInitialConfig = $.parseJSON($('meta[name=module-data]', $form).attr('content') || 'null');
      $config = $('.exploit-module-config', $form);
      $form.on('click', '.white-box input[type=radio]', function() {
        $('.white-box .config>div', $form).hide();
        return $('.white-box .config>div.' + $(this).val(), $form).show();
      });
      $inputs.change(function(e) {
        var $a, msg, newVal, removeIfNotSaved;
        newVal = $('option', $inputs).filter(':selected').val();
        if (newVal === '') {
          newVal = 'none';
        }
        $('.attack-box-options', $form).show();
        $('.attack-box-options>div', $form).hide();
        $('.shadow-arrow,.shadow-arrow-row', $form).show();
        $('.attack-box-options .' + newVal, $form).show();
        $('div.content-box', $form).not('.attack-box').css({
          opacity: 1,
          'pointer-events': 'auto'
        });
        $('.content-disabled-box', $form).hide();
        removeIfNotSaved = function(success) {
          if (this.oldHTML || success) {
            return;
          }
          $('option', $inputs).removeAttr('selected');
          $('option', $inputs).first().attr('selected', 'true');
          return $inputs.first().change();
        };
        if (!(newVal === 'none' || newVal === 'phishing')) {
          $('div.content-box', $form).not('.attack-box').css({
            opacity: .6,
            'pointer-events': 'none'
          });
          $('.content-disabled-box', $form).fadeIn();
          msg = 'Content is disabled when serving ';
          if (newVal === 'file') {
            $('.content-disabled-box', $form).text(msg + 'files.');
          } else {
            $('.content-disabled-box', $form).text(msg + 'exploits.');
          }
        }
        if (newVal === 'exploit') {
          $a = $(".attack-box-options .selected>a", $form).filter(':visible');
          modulePath || (modulePath = $a.data('modulePath'));
          moduleTitle || (moduleTitle = $a.data('moduleTitle'));
          exploitSearch || (exploitSearch = new ModuleSearch($('.exploit', $form), {
            workspace: workspace,
            hiddenInputContainer: $config,
            modulePath: modulePath,
            moduleTitle: moduleTitle,
            moduleConfig: moduleInitialConfig
          }));
          exploitSearch.activate();
          return modulePath = moduleTitle = moduleInitialConfig = null;
        } else if (newVal === 'bap') {
          modulePath = 'auxiliary/server/browser_autopwn';
          moduleTitle = 'HTTP Client Automatic Exploiter';
          bapSearch || (bapSearch = new ModuleSearch($('.bap', $form), {
            workspace: workspace,
            hiddenInputContainer: $config,
            hideSearch: true,
            configSavedCallback: removeIfNotSaved,
            modulePath: modulePath,
            moduleTitle: moduleTitle,
            moduleConfig: moduleInitialConfig
          }));
          bapSearch.activate();
          if (!bapSearch.currentlyLoaded()) {
            bapSearch.loadModuleModalConfig();
          }
          return modulePath = moduleTitle = moduleInitialConfig = null;
        } else if (newVal === 'java_signed_applet') {
          modulePath = 'exploit/multi/browser/java_signed_applet';
          moduleTitle = 'Java Signed Applet Social Engineering Code Execution';
          javaSearch || (javaSearch = new ModuleSearch($('.java_signed_applet', $form), {
            workspace: workspace,
            hiddenInputContainer: $config,
            hideSearch: true,
            configSavedCallback: removeIfNotSaved,
            modulePath: modulePath,
            moduleTitle: moduleTitle,
            moduleConfig: moduleInitialConfig
          }));
          javaSearch.activate();
          if (!javaSearch.currentlyLoaded()) {
            javaSearch.loadModuleModalConfig();
          }
          return modulePath = moduleTitle = moduleInitialConfig = null;
        } else if (newVal === 'file') {
          $('div.content-box', $form).not('.attack-box').css({
            opacity: .6,
            'pointer-events': 'none'
          });
          $('.content-disabled-box', $form).fadeIn();
          if ($fileInputs) {
            return $fileInputs.change();
          }
        } else if (newVal === 'none') {
          $('.attack-box-options', $form).hide();
          return $('.shadow-arrow,.shadow-arrow-row', $form).hide();
        }
      });
      $inputs.first().change();
      $fileInputs = $('.file li.choice input', $form);
      $fileInputs.change(function(e) {
        var className;
        if (!$(this).filter(':checked')) {
          return;
        }
        className = $('input', $(this).parents('fieldset')).filter(':checked').last().val();
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
            moduleConfig: moduleInitialConfig
          }));
          fileFormatSearch.activate();
          return modulePath = moduleTitle = moduleInitialConfig = null;
        }
      });
      return $fileInputs.change();
    };
  });

}).call(this);
