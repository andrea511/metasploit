(function() {
  var __hasProp = {}.hasOwnProperty;

  jQueryInWindow(function($) {
    var Template, addLine, isBlank, removeLine, updateNames;
    Template = (function() {

      function Template(tplSel) {
        this.tpl = $(tplSel).html();
      }

      Template.prototype.render = function(opts) {
        var key, val;
        for (key in opts) {
          if (!__hasProp.call(opts, key)) continue;
          val = opts[key];
          this.tpl = this.tpl.replace("{" + key + "}", val);
        }
        this.tpl = this.tpl.replace(/\{.*?\}/g, "");
        return this.tpl;
      };

      return Template;

    })();
    updateNames = function() {
      return $('.multi-add-human-target li').each(function(idx) {
        $('input:eq(0)', this).attr('name', "social_engineering_target_list[quick_add_targets][" + idx + "][email_address]");
        $('input:eq(1)', this).attr('name', "social_engineering_target_list[quick_add_targets][" + idx + "][first_name]");
        return $('input:eq(2)', this).attr('name', "social_engineering_target_list[quick_add_targets][" + idx + "][last_name]");
      });
    };
    removeLine = function(btn) {
      $(btn).parents('li').remove();
      updateNames();
      return $('.multi-add-human-target li:last-child div:last-child').show();
    };
    addLine = function(opts) {
      var $li, tpl;
      $('.multi-add-human-target li div:last-child').hide();
      tpl = new Template('#multi-add-human-target-template');
      $('.multi-add-human-target').append(tpl.render(opts));
      updateNames();
      $li = $('.multi-add-human-target li:last-child');
      $('input', $li).inputHint();
      $('a.plus', $li).click(function() {
        addLine();
        return false;
      });
      return $('a.minus', $li).click(function() {
        removeLine(this);
        return false;
      });
    };
    isBlank = function(obj) {
      var key, val;
      for (key in obj) {
        if (!__hasProp.call(obj, key)) continue;
        val = obj[key];
        if (val && val.length > 0) {
          return false;
        }
      }
      return true;
    };
    return window.renderTargets = function() {
      var count, idx, val;
      window.prevTargets = jQuery.parseJSON(jQuery('#prevTargets').attr('content')) || null;
      jQuery('#prevTargets').remove();
      count = 0;
      if (prevTargets) {
        for (idx in prevTargets) {
          if (!__hasProp.call(prevTargets, idx)) continue;
          val = prevTargets[idx];
          if (!isBlank(val)) {
            addLine(val);
            count++;
          }
        }
      }
      if (!count) {
        return addLine();
      }
    };
  });

}).call(this);
