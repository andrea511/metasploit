(function() {

  jQuery(function($) {
    var VALIDATE_URL;
    VALIDATE_URL = /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i;
    return window.renderAttributeDropdown = function() {
      var $cachedATags, $dialog, $form, $modDialog, $opt, findCodeMirrorATags, findWysiwygATags, getSelectedElements, optInitText, optInitValue, rangeIntersectsNode, showModifyLinkDialog, showOptionDialog, showStaticPageDialog;
      $form = $('.ui-tabs-wrap:visible form,form.social_engineering_email_template,form.social_engineering_web_template');
      $dialog = null;
      $modDialog = null;
      optInitValue = null;
      optInitText = null;
      $cachedATags = null;
      rangeIntersectsNode = function(range, node) {
        var nodeRange;
        if (range.intersectsNode) {
          return range.intersectsNode(node);
        } else {
          nodeRange = node.ownerDocument.createRange();
          try {
            nodeRange.selectNode(node);
          } catch (e) {
            nodeRange.selectNodeContents(node);
          }
          return range.compareBoundaryPoints(Range.END_TO_START, nodeRange) === -1 && range.compareBoundaryPoints(Range.START_TO_END, nodeRange) === 1;
        }
      };
      getSelectedElements = function(range) {
        var containerElement, d, elmlist, treeWalker;
        if (range) {
          containerElement = range.commonAncestorContainer;
          if (containerElement.nodeType !== 1) {
            containerElement = containerElement.parentNode;
          }
          d = containerElement.ownerDocument;
          treeWalker = d.createTreeWalker(containerElement, NodeFilter.SHOW_ELEMENT, (function(node) {
            if (rangeIntersectsNode(range, node)) {
              return NodeFilter.FILTER_ACCEPT;
            } else {
              return NodeFilter.FILTER_REJECT;
            }
          }), false);
          elmlist = [treeWalker.currentNode];
          while (treeWalker.nextNode()) {
            elmlist.push(treeWalker.currentNode);
          }
          return elmlist;
        } else {
          return null;
        }
      };
      findWysiwygATags = function() {
        var $aTags, wysiwygRange;
        if ($('.wysiwyg', $form).is(':visible')) {
          wysiwygRange = $form.triggerHandler('getWysiwygRange');
          $aTags = [];
          if (wysiwygRange) {
            $aTags = $(getSelectedElements(wysiwygRange)).filter('a');
          }
          return $aTags;
        } else {
          return null;
        }
      };
      findCodeMirrorATags = function() {
        var html, lm, range;
        if ($('.CodeMirror', $form).is(':visible')) {
          html = $form.triggerHandler('getMirrorContent');
          range = $form.triggerHandler('getMirrorSelectionRange');
          lm = new LinkManipulator(html);
          return lm.matchTagsInSelection('a', range.start, range.end);
        } else {
          return null;
        }
      };
      showOptionDialog = function(opts) {
        var mirrorSelection;
        if ($('.CodeMirror-scroll', $form).is(':visible')) {
          mirrorSelection = $form.triggerHandler('getMirrorSelection');
        } else {
          mirrorSelection = $form.triggerHandler('getWysiwygSelection');
        }
        mirrorSelection || (mirrorSelection = '');
        $dialog || ($dialog = $('div.dialog.link-popup', $form).dialog({
          title: 'Insert Campaign Link',
          width: 400,
          height: 230,
          modal: true,
          autoOpen: false,
          closeOnEscape: false,
          buttons: {
            "Cancel": function() {
              return $(this).dialog("close");
            },
            "Insert": function() {
              var cmd, opt, txt;
              txt = $('input[name=campaign-link-name]', $dialog).val();
              opt = $('select[name=webpage] option:selected', $dialog).val().replace('/', '');
              cmd = '<a href="{% campaign_href \'' + opt + '\' %}">' + txt + '</a>';
              $form.triggerHandler('replaceMirrorSelection', cmd);
              $form.triggerHandler('replaceWysiwygSelection', cmd);
              return $(this).dialog("close");
            }
          },
          close: function(ev, ui) {
            return $dialog.find(':input').val('');
          }
        }));
        $dialog.dialog('open');
        return $('input[name=campaign-link-name]', $dialog).val(mirrorSelection);
      };
      showStaticPageDialog = function(pageName) {
        var mirrorSelection;
        if ($('.CodeMirror-scroll', $form).is(':visible')) {
          mirrorSelection = $form.triggerHandler('getMirrorSelection');
        } else {
          mirrorSelection = $form.triggerHandler('getWysiwygSelection');
        }
        mirrorSelection || (mirrorSelection = '');
        $dialog || ($dialog = $('div.dialog.landing-popup', $form).dialog({
          title: 'Insert Link to Landing Page',
          width: 390,
          height: 250,
          modal: true,
          autoOpen: false,
          closeOnEscape: false,
          buttons: {
            "Cancel": function() {
              return $(this).dialog("close");
            },
            "Insert": function() {
              var cmd, spoofChecked, title, txt;
              txt = $('input[name=campaign-link-name]', $dialog).val();
              title = $('input[name=hover-text]', $dialog).val() || '';
              spoofChecked = $('input[name=spoof-hover]', $dialog).is(':checked');
              if (spoofChecked) {
                cmd = '<a href="{% campaign_href \'' + pageName + '\' %}" title="' + title + '">' + txt + '</a>';
              } else {
                cmd = '<a href="{% campaign_href \'' + pageName + '\' %}">' + txt + '</a>';
              }
              $form.triggerHandler('replaceMirrorSelection', cmd);
              $form.triggerHandler('replaceWysiwygSelection', cmd);
              return $(this).dialog("close");
            }
          },
          close: function(ev, ui) {
            $dialog.find(':input').val('');
            return $dialog.find('[type=checkbox]').removeAttr('checked');
          }
        }));
        $dialog.dialog('open');
        return $('input[name=campaign-link-name]', $dialog).val(mirrorSelection);
      };
      showModifyLinkDialog = function(linkType) {
        var $aTags, title, validHref, validTitleURL;
        $aTags = findWysiwygATags() || findCodeMirrorATags();
        if ($aTags.length === 0) {
          $aTags = $cachedATags;
        }
        title = 'Redirect Link to Campaign Web Page';
        if ($aTags.length > 1) {
          title = "Redirect " + $aTags.length + " Links to Campaign Web Page";
        }
        $modDialog || ($modDialog = $('div.dialog.modify-link-popup', $form).dialog({
          title: title,
          width: 390,
          height: 250,
          modal: true,
          autoOpen: false,
          closeOnEscape: false,
          buttons: {
            "Cancel": function() {
              return $(this).dialog("close");
            },
            "Update": function() {
              var $opt, href, html, lm, lm2, newHTML, range, shouldSpoofLinkTitle, spoofLinkTitle;
              $aTags = findWysiwygATags() || findCodeMirrorATags();
              if ($aTags.length === 0) {
                $aTags = $cachedATags;
              }
              $cachedATags = null;
              $opt = $('select option:selected', $modDialog);
              spoofLinkTitle = $('.spoof input[type=text]', $modDialog).val();
              shouldSpoofLinkTitle = $('.spoof input[type=checkbox]', $modDialog).is(':checked');
              shouldSpoofLinkTitle &= spoofLinkTitle && spoofLinkTitle.length > 0;
              if (optInitValue === 'campaign_link') {
                href = "{% campaign_href '" + ($opt.val()) + "' %}";
              } else {
                href = "{% campaign_href '" + ($opt.text()) + "' %}";
              }
              if ($('.CodeMirror-scroll', $form).is(':visible')) {
                html = $form.triggerHandler('getMirrorContent');
                range = $form.triggerHandler('getMirrorSelectionRange');
                lm = new LinkManipulator(html);
                newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', href, range.start, range.end);
                if (shouldSpoofLinkTitle) {
                  lm2 = new LinkManipulator(newHTML);
                  newHTML = lm2.replacePropertyOfTagsInSelection('title', 'a', spoofLinkTitle, range.start, range.end);
                }
                $form.triggerHandler('setMirrorContent', {
                  content: newHTML
                });
              } else {
                $($aTags).attr('href', href);
                if (shouldSpoofLinkTitle) {
                  $($aTags).attr('title', spoofLinkTitle);
                }
              }
              return $(this).dialog("close");
            }
          },
          close: function(ev, ui) {
            return $modDialog.find(':input').val('');
          }
        }));
        $modDialog.dialog('open');
        $modDialog.dialog({
          title: title
        });
        validHref = _.find($aTags, function(a) {
          var href;
          href = a.getAttribute("href");
          return href && href.length > 0 && !href.match(/^\{\%/) && href.match(VALIDATE_URL);
        });
        validHref = validHref ? validHref.getAttribute('href') : validHref;
        validTitleURL = _.find($aTags, function(a) {
          return a.title && a.title.length > 0 && a.title.match(VALIDATE_URL);
        });
        validTitleURL = validTitleURL ? validTitleURL.title : validTitleURL;
        $('[name=spoof-hover]', $modDialog).attr('checked', 'checked');
        if (validTitleURL) {
          $('input[name=hover-text]', $modDialog).val(validTitleURL);
        } else if (validHref) {
          $('input[name=hover-text]', $modDialog).val(validHref);
        } else {
          $('[name=spoof-hover]', $modDialog).removeAttr('checked');
        }
        return true;
      };
      $opt = $("select.dropdown-menu option", $form).filter(function() {
        return $.inArray($(this).val(), ["campaign_link", "campaign_landing_link", "modify_link"]) > -1;
      });
      optInitValue = $opt.val();
      optInitText = $opt.text();
      $("select.dropdown-menu", $form).bind('open', function(e) {
        var $aTags;
        $aTags = findWysiwygATags() || findCodeMirrorATags();
        $cachedATags = $aTags;
        $opt = $("select.dropdown-menu option", $form).filter(function() {
          return $.inArray($(this).val(), ["campaign_link", "campaign_landing_link", "modify_link"]) > -1;
        });
        if ($aTags.length > 1) {
          $opt.text("Redirect " + $aTags.length + " links to a Campaign Web Page");
          return $opt.val('modify_link');
        } else if ($aTags.length === 1) {
          $opt.text('Redirect link to a Campaign Web Page');
          return $opt.val('modify_link');
        } else {
          $opt.val(optInitValue);
          return $opt.text(optInitText);
        }
      });
      return $("select.dropdown-menu", $form).change(function(e) {
        var selVal;
        selVal = $('option:selected', this).val();
        $(e.target).select2('val', '');
        if (selVal === 'campaign_link') {
          return showOptionDialog();
        } else if (selVal === 'campaign_landing_link') {
          return showStaticPageDialog('Landing Page');
        } else if (selVal === 'modify_link') {
          return showModifyLinkDialog();
        } else if (selVal !== '') {
          $form.triggerHandler('replaceMirrorSelection', selVal);
          return $form.triggerHandler('replaceWysiwygSelection', selVal);
        }
      });
    };
  });

}).call(this);
