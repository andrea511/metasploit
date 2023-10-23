// This [jQuery](http://jquery.com/) plugin implements an `<iframe>`
// [transport](http://api.jquery.com/extending-ajax/#Transports) so that
// `$.ajax()` calls support the uploading of files using standard HTML file
// input fields. This is done by switching the exchange from `XMLHttpRequest`
// to a hidden `iframe` element containing a form that is submitted.

// The [source for the plugin](http://github.com/cmlenz/jquery-iframe-transport)
// is available on [Github](http://github.com/) and dual licensed under the MIT
// or GPL Version 2 licenses.

// ## Usage

// To use this plugin, you simply add an `iframe` option with the value `true`
// to the Ajax settings an `$.ajax()` call, and specify the file fields to
// include in the submssion using the `files` option, which can be a selector,
// jQuery object, or a list of DOM elements containing one or more
// `<input type="file">` elements:

//     $("#myform").submit(function() {
//         $.ajax(this.action, {
//             files: $(":file", this),
//             iframe: true
//         }).complete(function(data) {
//             console.log(data);
//         });
//     });

// The plugin will construct hidden `<iframe>` and `<form>` elements, add the
// file field(s) to that form, submit the form, and process the response.

// If you want to include other form fields in the form submission, include
// them in the `data` option, and set the `processData` option to `false`:

//     $("#myform").submit(function() {
//         $.ajax(this.action, {
//             data: $(":text", this).serializeArray(),
//             files: $(":file", this),
//             iframe: true,
//             processData: false
//         }).complete(function(data) {
//             console.log(data);
//         });
//     });

// ### Response Data Types

// As the transport does not have access to the HTTP headers of the server
// response, it is not as simple to make use of the automatic content type
// detection provided by jQuery as with regular XHR. If you can't set the
// expected response data type (for example because it may vary depending on
// the outcome of processing by the server), you will need to employ a
// workaround on the server side: Send back an HTML document containing just a
// `<textarea>` element with a `data-type` attribute that specifies the MIME
// type, and put the actual payload in the textarea:

//     <textarea data-type="application/json">
//       {"ok": true, "message": "Thanks so much"}
//     </textarea>

// The iframe transport plugin will detect this and pass the value of the
// `data-type` attribute on to jQuery as if it was the "Content-Type" response
// header, thereby enabling the same kind of conversions that jQuery applies
// to regular responses. For the example above you should get a Javascript
// object as the `data` parameter of the `complete` callback, with the
// properties `ok: true` and `message: "Thanks so much"`.

// ### Handling Server Errors

// Another problem with using an `iframe` for file uploads is that it is
// impossible for the javascript code to determine the HTTP status code of the
// servers response. Effectively, all of the calls you make will look like they
// are getting successful responses, and thus invoke the `done()` or
// `complete()` callbacks. You can only determine communicate problems using
// the content of the response payload. For example, consider using a JSON
// response such as the following to indicate a problem with an uploaded file:

//     <textarea data-type="application/json">
//       {"ok": false, "message": "Please only upload reasonably sized files."}
//     </textarea>

// ### Compatibility

// This plugin has primarily been tested on Safari 5 (or later), Firefox 4 (or
// later), and Internet Explorer (all the way back to version 6). While I
// haven't found any issues with it so far, I'm fairly sure it still doesn't
// work around all the quirks in all different browsers. But the code is still
// pretty simple overall, so you should be able to fix it and contribute a
// patch :)

// ## Annotated Source

(function ($, undefined) {
  "use strict";

  // Register a prefilter that checks whether the `iframe` option is set, and
  // switches to the "iframe" data type if it is `true`.
  $.ajaxPrefilter(function (options, origOptions, jqXHR) {
    if (options.iframe) {
      return "iframe";
    }
  });

  // Register a transport for the "iframe" data type. It will only activate
  // when the "files" option has been set to a non-empty list of enabled file
  // inputs.
  $.ajaxTransport("iframe", function (options, origOptions, jqXHR) {
    var form = null,
        iframe = null,
        name = "iframe-" + $.now(),
        files = $(options.files).filter(":file:enabled"),
        markers = null;

    // This function gets called after a successful submission or an abortion
    // and should revert all changes made to the page to enable the
    // submission via this transport.
    function cleanUp() {
      markers.replaceWith(function (idx) {
        return files.get(idx);
      });
      form.remove();
      iframe.attr("src", "about:blank").remove();
    }

    // Remove "iframe" from the data types list so that further processing is
    // based on the content type returned by the server, without attempting an
    // (unsupported) conversion from "iframe" to the actual type.
    options.dataTypes.shift();

    form = $("<form enctype='multipart/form-data' method='post'></form>")
      .hide().attr({action: options.url, target: name});

    // If there is any additional data specified via the `data` option,
    // we add it as hidden fields to the form. This (currently) requires
    // the `processData` option to be set to false so that the data doesn't
    // get serialized to a string.
    if (typeof(options.data) === "string" && options.data.length > 0) {
      $.error("data must not be serialized");
    } else {
      $.each($.param(options.data || {}).split('&'), function (index, el) {
        el = el.split('=');
        $("<input type='hidden' />").attr({
          name: decodeURIComponent(el[0])
        , value: decodeURIComponent(el[1].replace(/\+/g, '%20'))
        }).appendTo(form);
      });
    }


    // Add a hidden `X-Requested-With` field with the value `IFrame` to the
    // field, to help server-side code to determine that the upload happened
    // through this transport.
    $("<input type='hidden' value='IFrame' name='X-Requested-With' />")
      .appendTo(form);

    // Move the file fields into the hidden form, but first remember their
    // original locations in the document by replacing them with disabled
    // clones. This should also avoid introducing unwanted changes to the
    // page layout during submission.
    markers = files.after(function (idx) {
      return $(this).clone().attr("disabled", true);
    }).next();
    files.appendTo(form);

    return {

      // The `send` function is called by jQuery when the request should be
      // sent.
      send: function (headers, completeCallback) {
        iframe = $("<iframe src='about:blank' name='" + name +
          "' id='" + name + "' style='display:none'></iframe>");

        // The first load event gets fired after the iframe has been injected
        // into the DOM, and is used to prepare the actual submission.
        iframe.bind("load", function () {

          // The second load event gets fired when the response to the form
          // submission is received. The implementation detects whether the
          // actual payload is embedded in a `<textarea>` element, and
          // prepares the required conversions to be made in that case.
          iframe.unbind("load").bind("load", function () {
            var doc = this.contentWindow ? this.contentWindow.document :
              (this.contentDocument ? this.contentDocument : this.document),
              root = doc.body,
              textarea = root.getElementsByTagName("textarea")[0],
              type = textarea ? textarea.getAttribute("data-type") : null,
              status = textarea ? textarea.getAttribute("data-status") : 200,
              statusText = textarea ? textarea.getAttribute("data-statusText") : "OK",
              content = {
                html: root.innerHTML,
                text: type ?
                  textarea.value :
                  $('<div/>').html(root.innerHTML).html()
              };

            cleanUp();
            completeCallback(status, statusText, content, type ?
              ("Content-Type: " + type) :
              null);
          });

          // Now that the load handler has been set up, submit the form.
          form[0].submit();
        });

        // After everything has been set up correctly, the form and iframe
        // get injected into the DOM so that the submission can be
        // initiated.
        $("body").append(form, iframe);
      },

      // The `abort` function is called by jQuery when the request should be
      // aborted.
      abort: function () {
        if (iframe !== null) {
          iframe.unbind("load").attr("src", "about:blank");
          cleanUp();
        }
      }
    };
  });

}(jQuery));
(function() {
  var FF_ELEMENTS_TO_REMOVE, INPUTS_TO_HIDE,
    __hasProp = {}.hasOwnProperty;

  INPUTS_TO_HIDE = ['module_run_task[options][SRVHOST]', 'module_run_task[options][URIPATH]', 'module_run_task[options][SRVPORT]', 'module_run_task[options][FILENAME]'];

  FF_ELEMENTS_TO_REMOVE = ['h3:contains(Target Systems)+table', 'h3:contains(Target Systems)'];

  jQuery(function($) {
    return $(function() {
      var ModuleSearch;
      window.moduleLinksInit = function(moduleRunPathFragment) {
        var onclick;
        onclick = function(event) {
          if ($(this).attr('href') !== "#") {
            return true;
          }
        };
        $('a.module-name').unbind('click.moduleLinksInit');
        return $('a.module-name').bind('click.moduleLinksInit', onclick);
      };
      $.fn.dataTableExt.oSort['star-asc'] = function(a, b) {
        return (a.match(/img/g) || []).length - (b.match(/img/g) || []).length;
      };
      $.fn.dataTableExt.oSort['star-desc'] = function(a, b) {
        return $.fn.dataTableExt.oSort['star-asc'](b, a);
      };
      return window.ModuleSearch = ModuleSearch = (function() {

        function ModuleSearch(ele, opts) {
          var k, newName, v, _ref;
          this.ele = $(ele);
          this.workspace = opts['workspace'] || 1;
          this.modulePath = opts['modulePath'] || '';
          this.moduleTitle = opts['moduleTitle'] || '';
          this.extraQuery = opts['extraQuery'];
          if (this.extraQuery === void 0) {
            this.extraQuery = 'app:client';
          }
          this.fileFormat = opts['fileFormat'] || false;
          this.hiddenInputContainer = opts['hiddenInputContainer'];
          this.paramWrapName = opts['paramWrapName'] || 'social_engineering_web_page';
          this.hideSearch = opts['hideSearch'] || false;
          if (!this.hiddenInputContainer) {
            this.hiddenInputContainer = this.ele.parent().append('<div class="hiddenInputContainer"></div>').children().last().hide();
          }
          this.moduleConfig = opts['moduleConfig'] || false;
          this.modal = null;
          this.configSavedCallback = opts['configSavedCallback'] || (function() {});
          this.ele.html('<div class="selected"></div><div class="load">' + '<div style="position:relative;top: 5px;text-align:center;">Initializing module cache</div>' + '<div class="tab-loading"></div></div>');
          if (this.moduleConfig) {
            _ref = this.convertToQueryFormat(this.moduleConfig);
            for (k in _ref) {
              if (!__hasProp.call(_ref, k)) continue;
              v = _ref[k];
              newName = "" + this.paramWrapName + "[exploit_module_config" + k + "]";
              this.hiddenInputContainer.append($('<input type="hidden">').attr({
                name: newName,
                value: v
              }));
            }
            this.hiddenInputContainer.append($('<input type="hidden">').attr({
              name: "" + this.paramWrapName + "[exploit_module_path]",
              value: this.modulePath
            }));
            this.hiddenInputContainer.append($('<input type="hidden">').attr({
              name: 'modulePath',
              value: this.modulePath
            }));
            this.oldHTML = this.hiddenInputContainer.html();
          }
          if (this.hideSearch) {
            $(">.load", this.ele).hide();
          } else {
            this.loadModuleSearch('');
          }
          this.refreshTitleBar();
        }

        ModuleSearch.prototype.formatName = function(name) {
          name = name.replace('module_run_task', 'exploit_module_config');
          switch (name) {
            case "modulePath":
              name = 'exploit_module_path';
          }
          return "" + this.paramWrapName + "[" + name + "]";
        };

        ModuleSearch.prototype.loadModuleSearch = function(query, cb) {
          var args, path,
            _this = this;
          path = "/workspaces/" + this.workspace + "/modules";
          args = {
            _nl: "1",
            q: query,
            extra_query: this.extraQuery,
            file_format: this.fileFormat || '',
            straight: 'true'
          };
          return $.ajax(path, {
            type: "POST",
            data: args,
            success: function(data, status) {
              var that;
              $(">.load", _this.ele).html(data);
              $(".searchform~*", _this.ele).remove();
              $(".searchform", _this.ele).parent().contents().last().remove();
              $(".searchform", _this.ele).submit(function() {
                var $box;
                $box = $(".searchform input[type=text]#q", _this.ele);
                $box.blur().attr('disabled', 'disabled').addClass('loading');
                _this.loadModuleSearch($('input[name=q]', _this.ele).val(), function() {
                  return $box.removeAttr('disabled').removeClass('loading');
                });
                return false;
              });
              that = _this;
              $('input#q').change(function(e) {
                return that.loadModuleSearch($(this).val());
              });
              $('a.module-name', _this.ele).click(function(e) {
                var mp, mt;
                mp = $(this).attr('module_fullname');
                mt = $(this).text();
                that.loadModuleModalConfig(mp, mt);
                return false;
              });
              $("table.module_list th a", _this.ele).each(function() {
                $(this).before($(this).html());
                return $(this).remove();
              });
              $("table.module_list", _this.ele).addClass('sortable').dataTable({
                oLanguage: {
                  sEmptyTable: "No matching Modules found."
                },
                sDom: 'ft<"list-table-footer clearfix"ip <"sel" l>>r',
                sPaginationType: 'r7Style',
                bFilter: false,
                aaSorting: [[4, 'desc']],
                aoColumns: [
                  {}, {}, {}, {}, {
                    sType: 'star'
                  }, {}, {}, {}, {}
                ]
              });
              if (cb) {
                return cb();
              }
            }
          });
        };

        ModuleSearch.prototype.saveFromModal = function() {
          var $input, SKIP_NAMES,
            _this = this;
          SKIP_NAMES = ["utf8", "authenticity_token", "_method", "moduleName", "selected_action"];
          this.hiddenInputContainer.html('');
          this.modulePath = this.modulePath_ || this.modulePath;
          this.moduleTitle = this.moduleTitle_ || this.moduleTitle;
          this.modulePath_ = this.moduleTitle_ = null;
          this.modal.find('input, textarea, select').each(function(index, element) {
            var $input, currentName, skip, val, _i, _len;
            for (_i = 0, _len = SKIP_NAMES.length; _i < _len; _i++) {
              skip = SKIP_NAMES[_i];
              if (skip === $(element).attr('name')) {
                return;
              }
            }
            currentName = _this.formatName($(element).attr('name'));
            val = $(element).val();
            if ($(element).attr('type') === 'checkbox') {
              val = 'checked';
              if (!$(element).attr('checked')) {
                return;
              }
            }
            if ($(element).attr('type') === 'radio' & !$(element).prop('checked')) {
              return;
            }
            $input = $('<input type="hidden">').attr({
              name: currentName,
              value: $(element).val()
            });
            return _this.hiddenInputContainer.append($input);
          });
          $input = $('<input type="hidden">').attr({
            name: 'modulePath',
            value: this.modulePath
          });
          this.hiddenInputContainer.append($input);
          return this.oldHTML = this.hiddenInputContainer.html();
        };

        ModuleSearch.prototype.moduleModalOptions = function() {
          var _this = this;
          return {
            width: 980,
            height: 600,
            autoOpen: false,
            modal: true,
            draggable: false,
            resizable: false,
            title: "Configure Module",
            buttons: [
              {
                text: "Cancel",
                click: function() {
                  _this.modal.data('save', 'false');
                  _this.modal.dialog('close');
                  return _this.configSavedCallback.call(_this, false);
                }
              }, {
                text: "OK",
                click: function() {
                  _this.saveFromModal();
                  _this.refreshTitleBar();
                  _this.modal.data('save', 'true');
                  return _this.modal.dialog('close');
                }
              }
            ],
            close: function() {
              _this.modal.remove();
              return _this.configSavedCallback(_this.modal.data('save') === 'true');
            }
          };
        };

        ModuleSearch.prototype.convertToQueryFormat = function(hash) {
          var decode, left, match, match2, out, p, pl, search;
          out = {};
          p = $.param(hash);
          pl = /\+/g;
          search = /([^&=]+)=?([^&]*)/g;
          decode = function(s) {
            return decodeURIComponent(s.replace(pl, ' '));
          };
          while (match = search.exec(p)) {
            left = decode(match[1]);
            if (match2 = left.match(/(.*)?\[.*\]/)) {
              left = left.replace(/^[^\[]*/, "[" + match2[1] + "]");
            } else {
              left = "[" + left + "]";
            }
            out[left] = decode(match[2]);
          }
          return out;
        };

        ModuleSearch.prototype.refreshTitleBar = function() {
          var $a, html,
            _this = this;
          if (this.moduleTitle && this.moduleTitle.length > 0) {
            html = "<div class='module-path'><span class='gt'>&gt;</span><span class='rest'>" + this.moduleTitle + "</div> <a href='#'>Edit Config</a></span>";
          } else {
            html = "<div class='module-path'><div>No exploit module chosen. Choose a module from the form below.</div></div>";
          }
          $(".selected", this.ele).filter(':visible').html(html);
          $a = $(".selected>a", this.ele).filter(':visible');
          return $a.click(function(e) {
            return _this.loadModuleModalConfig();
          });
        };

        ModuleSearch.prototype.loadModuleModalConfig = function(mp, mt) {
          var args, path,
            _this = this;
          mp || (mp = this.modulePath);
          mt || (mt = this.moduleTitle);
          this.modal = $("<div class='module-config'></div>");
          path = "/workspaces/" + this.workspace + "/tasks/new_module_run/" + mp;
          args = {
            _nl: "1",
            allow_ff: (this.fileFormat ? "true" : "false")
          };
          return $.get(path, args, function(data) {
            var $data, alteredData, formPath, n, sel, subString, that, _i, _j, _len, _len1;
            $data = $(data);
            formPath = $data.find('form').attr('action');
            subString = "/workspaces/" + _this.workspace + "/tasks/start_module_run/";
            mp = formPath.replace(subString, "");
            alteredData = $data.attr('id', '');
            alteredData.find('form').append("<input type='hidden' name='modulePath' value=\"" + mp + "\" />");
            alteredData.find('form').append("<input type='hidden' name='moduleName' value=\"" + mt + "\" />");
            for (_i = 0, _len = INPUTS_TO_HIDE.length; _i < _len; _i++) {
              n = INPUTS_TO_HIDE[_i];
              alteredData.find("input[name='" + n + "']").parents('tr').remove();
            }
            for (_j = 0, _len1 = FF_ELEMENTS_TO_REMOVE.length; _j < _len1; _j++) {
              sel = FF_ELEMENTS_TO_REMOVE[_j];
              alteredData.find(sel).remove();
            }
            alteredData.find('input[type=checkbox]').removeAttr('checked');
            that = _this;
            if (_this.hiddenInputContainer.find('[name=modulePath]').val() === mp) {
              alteredData.find('input, textarea').each(function() {
                var $node, name, v;
                name = that.formatName($(this).attr('name'));
                $node = $("input[name='" + name + "']", this.hiddenInputContainer);
                v = $node.val();
                if ($(this).attr("type") === "radio") {
                  if ($(this).val() === $node.val()) {
                    $(this).prop("checked", true);
                  } else {
                    return;
                  }
                }
                if (v) {
                  $(this).val(v);
                }
                if ($(this).attr('type') === 'checkbox') {
                  if (v) {
                    return $(this).attr('checked', 'true');
                  } else {
                    return $(this).removeAttr('checked');
                  }
                }
              });
              alteredData.find('select').each(function() {
                var name, v;
                name = that.formatName($(this).attr('name'));
                v = $("input[name='" + name + "']", this.hiddenInputContainer).val();
                $('option', $(this)).removeAttr('selected');
                return $('option', $(this)).each(function() {
                  if ($(this).val() === v) {
                    return $(this).attr('selected', true);
                  }
                });
              });
            }
            _this.modal.html($(alteredData));
            _this.modulePath_ = mp;
            _this.moduleTitle_ = mt;
            _this.modal.dialog(_this.moduleModalOptions());
            return _this.modal.dialog('open');
          });
        };

        ModuleSearch.prototype.activate = function() {
          if (this.oldHTML) {
            return this.hiddenInputContainer.html(this.oldHTML);
          }
        };

        ModuleSearch.prototype.currentlyLoaded = function() {
          return $("[name=\'" + this.paramWrapName + "[exploit_module_path]\']", this.hiddenInputContainer).val() === this.modulePath;
        };

        return ModuleSearch;

      })();
    });
  });

}).call(this);
// CodeMirror version 2.35
//
// All functions that need access to the editor's state live inside
// the CodeMirror function. Below that, at the bottom of the file,
// some utilities are defined.

// CodeMirror is the only global var we claim
window.CodeMirror = (function() {
  "use strict";
  // This is the function that produces an editor instance. Its
  // closure is used to store the editor state.
  function CodeMirror(place, givenOptions) {
    // Determine effective options based on given values and defaults.
    var options = {}, defaults = CodeMirror.defaults;
    for (var opt in defaults)
      if (defaults.hasOwnProperty(opt))
        options[opt] = (givenOptions && givenOptions.hasOwnProperty(opt) ? givenOptions : defaults)[opt];

    var input = elt("textarea", null, null, "position: absolute; padding: 0; width: 1px; height: 1em");
    input.setAttribute("wrap", "off"); input.setAttribute("autocorrect", "off"); input.setAttribute("autocapitalize", "off");
    // Wraps and hides input textarea
    var inputDiv = elt("div", [input], null, "overflow: hidden; position: relative; width: 3px; height: 0px;");
    // The empty scrollbar content, used solely for managing the scrollbar thumb.
    var scrollbarInner = elt("div", null, "CodeMirror-scrollbar-inner");
    // The vertical scrollbar. Horizontal scrolling is handled by the scroller itself.
    var scrollbar = elt("div", [scrollbarInner], "CodeMirror-scrollbar");
    // DIVs containing the selection and the actual code
    var lineDiv = elt("div"), selectionDiv = elt("div", null, null, "position: relative; z-index: -1");
    // Blinky cursor, and element used to ensure cursor fits at the end of a line
    var cursor = elt("pre", "\u00a0", "CodeMirror-cursor"), widthForcer = elt("pre", "\u00a0", "CodeMirror-cursor", "visibility: hidden");
    // Used to measure text size
    var measure = elt("div", null, null, "position: absolute; width: 100%; height: 0px; overflow: hidden; visibility: hidden;");
    var lineSpace = elt("div", [measure, cursor, widthForcer, selectionDiv, lineDiv], null, "position: relative; z-index: 0");
    var gutterText = elt("div", null, "CodeMirror-gutter-text"), gutter = elt("div", [gutterText], "CodeMirror-gutter");
    // Moved around its parent to cover visible view
    var mover = elt("div", [gutter, elt("div", [lineSpace], "CodeMirror-lines")], null, "position: relative");
    // Set to the height of the text, causes scrolling
    var sizer = elt("div", [mover], null, "position: relative");
    // Provides scrolling
    var scroller = elt("div", [sizer], "CodeMirror-scroll");
    scroller.setAttribute("tabIndex", "-1");
    // The element in which the editor lives.
    var wrapper = elt("div", [inputDiv, scrollbar, scroller], "CodeMirror" + (options.lineWrapping ? " CodeMirror-wrap" : ""));
    if (place.appendChild) place.appendChild(wrapper); else place(wrapper);

    themeChanged(); keyMapChanged();
    // Needed to hide big blue blinking cursor on Mobile Safari
    if (ios) input.style.width = "0px";
    if (!webkit) scroller.draggable = true;
    lineSpace.style.outline = "none";
    if (options.tabindex != null) input.tabIndex = options.tabindex;
    if (options.autofocus) focusInput();
    if (!options.gutter && !options.lineNumbers) gutter.style.display = "none";
    // Needed to handle Tab key in KHTML
    if (khtml) inputDiv.style.height = "1px", inputDiv.style.position = "absolute";

    // Check for OS X >= 10.7. This has transparent scrollbars, so the
    // overlaying of one scrollbar with another won't work. This is a
    // temporary hack to simply turn off the overlay scrollbar. See
    // issue #727.
    if (mac_geLion) { scrollbar.style.zIndex = -2; scrollbar.style.visibility = "hidden"; }
    // Need to set a minimum width to see the scrollbar on IE7 (but must not set it on IE8).
    else if (ie_lt8) scrollbar.style.minWidth = "18px";

    // Delayed object wrap timeouts, making sure only one is active. blinker holds an interval.
    var poll = new Delayed(), highlight = new Delayed(), blinker;

    // mode holds a mode API object. doc is the tree of Line objects,
    // frontier is the point up to which the content has been parsed,
    // and history the undo history (instance of History constructor).
    var mode, doc = new BranchChunk([new LeafChunk([new Line("")])]), frontier = 0, focused;
    loadMode();
    // The selection. These are always maintained to point at valid
    // positions. Inverted is used to remember that the user is
    // selecting bottom-to-top.
    var sel = {from: {line: 0, ch: 0}, to: {line: 0, ch: 0}, inverted: false};
    // Selection-related flags. shiftSelecting obviously tracks
    // whether the user is holding shift.
    var shiftSelecting, lastClick, lastDoubleClick, lastScrollTop = 0, draggingText,
        overwrite = false, suppressEdits = false, pasteIncoming = false;
    // Variables used by startOperation/endOperation to track what
    // happened during the operation.
    var updateInput, userSelChange, changes, textChanged, selectionChanged,
        gutterDirty, callbacks;
    // Current visible range (may be bigger than the view window).
    var displayOffset = 0, showingFrom = 0, showingTo = 0, lastSizeC = 0;
    // bracketHighlighted is used to remember that a bracket has been
    // marked.
    var bracketHighlighted;
    // Tracks the maximum line length so that the horizontal scrollbar
    // can be kept static when scrolling.
    var maxLine = getLine(0), updateMaxLine = false, maxLineChanged = true;
    var pollingFast = false; // Ensures slowPoll doesn't cancel fastPoll
    var goalColumn = null;

    // Initialize the content.
    operation(function(){setValue(options.value || ""); updateInput = false;})();
    var history = new History();

    // Register our event handlers.
    connect(scroller, "mousedown", operation(onMouseDown));
    connect(scroller, "dblclick", operation(onDoubleClick));
    connect(lineSpace, "selectstart", e_preventDefault);
    // Gecko browsers fire contextmenu *after* opening the menu, at
    // which point we can't mess with it anymore. Context menu is
    // handled in onMouseDown for Gecko.
    if (!gecko) connect(scroller, "contextmenu", onContextMenu);
    connect(scroller, "scroll", onScrollMain);
    connect(scrollbar, "scroll", onScrollBar);
    connect(scrollbar, "mousedown", function() {if (focused) setTimeout(focusInput, 0);});
    var resizeHandler = connect(window, "resize", function() {
      if (wrapper.parentNode) updateDisplay(true);
      else resizeHandler();
    }, true);
    connect(input, "keyup", operation(onKeyUp));
    connect(input, "input", fastPoll);
    connect(input, "keydown", operation(onKeyDown));
    connect(input, "keypress", operation(onKeyPress));
    connect(input, "focus", onFocus);
    connect(input, "blur", onBlur);

    function drag_(e) {
      if (options.onDragEvent && options.onDragEvent(instance, addStop(e))) return;
      e_stop(e);
    }
    if (options.dragDrop) {
      connect(scroller, "dragstart", onDragStart);
      connect(scroller, "dragenter", drag_);
      connect(scroller, "dragover", drag_);
      connect(scroller, "drop", operation(onDrop));
    }
    connect(scroller, "paste", function(){focusInput(); fastPoll();});
    connect(input, "paste", function(){pasteIncoming = true; fastPoll();});
    connect(input, "cut", operation(function(){
      if (!options.readOnly) replaceSelection("");
    }));

    // Needed to handle Tab key in KHTML
    if (khtml) connect(sizer, "mouseup", function() {
        if (document.activeElement == input) input.blur();
        focusInput();
    });

    // IE throws unspecified error in certain cases, when
    // trying to access activeElement before onload
    var hasFocus; try { hasFocus = (document.activeElement == input); } catch(e) { }
    if (hasFocus || options.autofocus) setTimeout(onFocus, 20);
    else onBlur();

    function isLine(l) {return l >= 0 && l < doc.size;}
    // The instance object that we'll return. Mostly calls out to
    // local functions in the CodeMirror function. Some do some extra
    // range checking and/or clipping. operation is used to wrap the
    // call so that changes it makes are tracked, and the display is
    // updated afterwards.
    var instance = wrapper.CodeMirror = {
      getValue: getValue,
      setValue: operation(setValue),
      getSelection: getSelection,
      replaceSelection: operation(replaceSelection),
      focus: function(){window.focus(); focusInput(); onFocus(); fastPoll();},
      setOption: function(option, value) {
        var oldVal = options[option];
        options[option] = value;
        if (option == "mode" || option == "indentUnit") loadMode();
        else if (option == "readOnly" && value == "nocursor") {onBlur(); input.blur();}
        else if (option == "readOnly" && !value) {resetInput(true);}
        else if (option == "theme") themeChanged();
        else if (option == "lineWrapping" && oldVal != value) operation(wrappingChanged)();
        else if (option == "tabSize") updateDisplay(true);
        else if (option == "keyMap") keyMapChanged();
        else if (option == "tabindex") input.tabIndex = value;
        if (option == "lineNumbers" || option == "gutter" || option == "firstLineNumber" ||
            option == "theme" || option == "lineNumberFormatter") {
          gutterChanged();
          updateDisplay(true);
        }
      },
      getOption: function(option) {return options[option];},
      getMode: function() {return mode;},
      undo: operation(undo),
      redo: operation(redo),
      indentLine: operation(function(n, dir) {
        if (typeof dir != "string") {
          if (dir == null) dir = options.smartIndent ? "smart" : "prev";
          else dir = dir ? "add" : "subtract";
        }
        if (isLine(n)) indentLine(n, dir);
      }),
      indentSelection: operation(indentSelected),
      historySize: function() {return {undo: history.done.length, redo: history.undone.length};},
      clearHistory: function() {history = new History();},
      setHistory: function(histData) {
        history = new History();
        history.done = histData.done;
        history.undone = histData.undone;
      },
      getHistory: function() {
        function cp(arr) {
          for (var i = 0, nw = [], nwelt; i < arr.length; ++i) {
            nw.push(nwelt = []);
            for (var j = 0, elt = arr[i]; j < elt.length; ++j) {
              var old = [], cur = elt[j];
              nwelt.push({start: cur.start, added: cur.added, old: old});
              for (var k = 0; k < cur.old.length; ++k) old.push(hlText(cur.old[k]));
            }
          }
          return nw;
        }
        return {done: cp(history.done), undone: cp(history.undone)};
      },
      matchBrackets: operation(function(){matchBrackets(true);}),
      getTokenAt: operation(function(pos) {
        pos = clipPos(pos);
        return getLine(pos.line).getTokenAt(mode, getStateBefore(pos.line), options.tabSize, pos.ch);
      }),
      getStateAfter: function(line) {
        line = clipLine(line == null ? doc.size - 1: line);
        return getStateBefore(line + 1);
      },
      cursorCoords: function(start, mode) {
        if (start == null) start = sel.inverted;
        return this.charCoords(start ? sel.from : sel.to, mode);
      },
      charCoords: function(pos, mode) {
        pos = clipPos(pos);
        if (mode == "local") return localCoords(pos, false);
        if (mode == "div") return localCoords(pos, true);
        return pageCoords(pos);
      },
      coordsChar: function(coords) {
        var off = eltOffset(lineSpace);
        return coordsChar(coords.x - off.left, coords.y - off.top);
      },
      markText: operation(markText),
      setBookmark: setBookmark,
      findMarksAt: findMarksAt,
      setMarker: operation(addGutterMarker),
      clearMarker: operation(removeGutterMarker),
      setLineClass: operation(setLineClass),
      hideLine: operation(function(h) {return setLineHidden(h, true);}),
      showLine: operation(function(h) {return setLineHidden(h, false);}),
      onDeleteLine: function(line, f) {
        if (typeof line == "number") {
          if (!isLine(line)) return null;
          line = getLine(line);
        }
        (line.handlers || (line.handlers = [])).push(f);
        return line;
      },
      lineInfo: lineInfo,
      getViewport: function() { return {from: showingFrom, to: showingTo};},
      addWidget: function(pos, node, scroll, vert, horiz) {
        pos = localCoords(clipPos(pos));
        var top = pos.yBot, left = pos.x;
        node.style.position = "absolute";
        sizer.appendChild(node);
        if (vert == "over") top = pos.y;
        else if (vert == "near") {
          var vspace = Math.max(scroller.offsetHeight, doc.height * textHeight()),
              hspace = Math.max(sizer.clientWidth, lineSpace.clientWidth) - paddingLeft();
          if (pos.yBot + node.offsetHeight > vspace && pos.y > node.offsetHeight)
            top = pos.y - node.offsetHeight;
          if (left + node.offsetWidth > hspace)
            left = hspace - node.offsetWidth;
        }
        node.style.top = (top + paddingTop()) + "px";
        node.style.left = node.style.right = "";
        if (horiz == "right") {
          left = sizer.clientWidth - node.offsetWidth;
          node.style.right = "0px";
        } else {
          if (horiz == "left") left = 0;
          else if (horiz == "middle") left = (sizer.clientWidth - node.offsetWidth) / 2;
          node.style.left = (left + paddingLeft()) + "px";
        }
        if (scroll)
          scrollIntoView(left, top, left + node.offsetWidth, top + node.offsetHeight);
      },

      lineCount: function() {return doc.size;},
      clipPos: clipPos,
      getCursor: function(start) {
        if (start == null) start = sel.inverted;
        return copyPos(start ? sel.from : sel.to);
      },
      somethingSelected: function() {return !posEq(sel.from, sel.to);},
      setCursor: operation(function(line, ch, user) {
        if (ch == null && typeof line.line == "number") setCursor(line.line, line.ch, user);
        else setCursor(line, ch, user);
      }),
      setSelection: operation(function(from, to, user) {
        (user ? setSelectionUser : setSelection)(clipPos(from), clipPos(to || from));
      }),
      getLine: function(line) {if (isLine(line)) return getLine(line).text;},
      getLineHandle: function(line) {if (isLine(line)) return getLine(line);},
      setLine: operation(function(line, text) {
        if (isLine(line)) replaceRange(text, {line: line, ch: 0}, {line: line, ch: getLine(line).text.length});
      }),
      removeLine: operation(function(line) {
        if (isLine(line)) replaceRange("", {line: line, ch: 0}, clipPos({line: line+1, ch: 0}));
      }),
      replaceRange: operation(replaceRange),
      getRange: function(from, to, lineSep) {return getRange(clipPos(from), clipPos(to), lineSep);},

      triggerOnKeyDown: operation(onKeyDown),
      execCommand: function(cmd) {return commands[cmd](instance);},
      // Stuff used by commands, probably not much use to outside code.
      moveH: operation(moveH),
      deleteH: operation(deleteH),
      moveV: operation(moveV),
      toggleOverwrite: function() {
        if(overwrite){
          overwrite = false;
          cursor.className = cursor.className.replace(" CodeMirror-overwrite", "");
        } else {
          overwrite = true;
          cursor.className += " CodeMirror-overwrite";
        }
      },

      posFromIndex: function(off) {
        var lineNo = 0, ch;
        doc.iter(0, doc.size, function(line) {
          var sz = line.text.length + 1;
          if (sz > off) { ch = off; return true; }
          off -= sz;
          ++lineNo;
        });
        return clipPos({line: lineNo, ch: ch});
      },
      indexFromPos: function (coords) {
        if (coords.line < 0 || coords.ch < 0) return 0;
        var index = coords.ch;
        doc.iter(0, coords.line, function (line) {
          index += line.text.length + 1;
        });
        return index;
      },
      scrollTo: function(x, y) {
        if (x != null) scroller.scrollLeft = x;
        if (y != null) scrollbar.scrollTop = scroller.scrollTop = y;
        updateDisplay([]);
      },
      getScrollInfo: function() {
        return {x: scroller.scrollLeft, y: scrollbar.scrollTop,
                height: scrollbar.scrollHeight, width: scroller.scrollWidth};
      },
      setSize: function(width, height) {
        function interpret(val) {
          val = String(val);
          return /^\d+$/.test(val) ? val + "px" : val;
        }
        if (width != null) wrapper.style.width = interpret(width);
        if (height != null) scroller.style.height = interpret(height);
        instance.refresh();
      },

      operation: function(f){return operation(f)();},
      compoundChange: function(f){return compoundChange(f);},
      refresh: function(){
        updateDisplay(true, null, lastScrollTop);
        if (scrollbar.scrollHeight > lastScrollTop)
          scrollbar.scrollTop = lastScrollTop;
      },
      getInputField: function(){return input;},
      getWrapperElement: function(){return wrapper;},
      getScrollerElement: function(){return scroller;},
      getGutterElement: function(){return gutter;}
    };

    function getLine(n) { return getLineAt(doc, n); }
    function updateLineHeight(line, height) {
      gutterDirty = true;
      var diff = height - line.height;
      for (var n = line; n; n = n.parent) n.height += diff;
    }

    function lineContent(line, wrapAt) {
      if (!line.styles)
        line.highlight(mode, line.stateAfter = getStateBefore(lineNo(line)), options.tabSize);
      return line.getContent(options.tabSize, wrapAt, options.lineWrapping);
    }

    function setValue(code) {
      var top = {line: 0, ch: 0};
      updateLines(top, {line: doc.size - 1, ch: getLine(doc.size-1).text.length},
                  splitLines(code), top, top);
      updateInput = true;
    }
    function getValue(lineSep) {
      var text = [];
      doc.iter(0, doc.size, function(line) { text.push(line.text); });
      return text.join(lineSep || "\n");
    }

    function onScrollBar(e) {
      if (scrollbar.scrollTop != lastScrollTop) {
        lastScrollTop = scroller.scrollTop = scrollbar.scrollTop;
        updateDisplay([]);
      }
    }

    function onScrollMain(e) {
      if (options.fixedGutter && gutter.style.left != scroller.scrollLeft + "px")
        gutter.style.left = scroller.scrollLeft + "px";
      if (scroller.scrollTop != lastScrollTop) {
        lastScrollTop = scroller.scrollTop;
        if (scrollbar.scrollTop != lastScrollTop)
          scrollbar.scrollTop = lastScrollTop;
        updateDisplay([]);
      }
      if (options.onScroll) options.onScroll(instance);
    }

    function onMouseDown(e) {
      setShift(e_prop(e, "shiftKey"));
      // Check whether this is a click in a widget
      for (var n = e_target(e); n != wrapper; n = n.parentNode)
        if (n.parentNode == sizer && n != mover) return;

      // See if this is a click in the gutter
      for (var n = e_target(e); n != wrapper; n = n.parentNode)
        if (n.parentNode == gutterText) {
          if (options.onGutterClick)
            options.onGutterClick(instance, indexOf(gutterText.childNodes, n) + showingFrom, e);
          return e_preventDefault(e);
        }

      var start = posFromMouse(e);

      switch (e_button(e)) {
      case 3:
        if (gecko) onContextMenu(e);
        return;
      case 2:
        if (start) setCursor(start.line, start.ch, true);
        setTimeout(focusInput, 20);
        e_preventDefault(e);
        return;
      }
      // For button 1, if it was clicked inside the editor
      // (posFromMouse returning non-null), we have to adjust the
      // selection.
      if (!start) {if (e_target(e) == scroller) e_preventDefault(e); return;}

      if (!focused) onFocus();

      var now = +new Date, type = "single";
      if (lastDoubleClick && lastDoubleClick.time > now - 400 && posEq(lastDoubleClick.pos, start)) {
        type = "triple";
        e_preventDefault(e);
        setTimeout(focusInput, 20);
        selectLine(start.line);
      } else if (lastClick && lastClick.time > now - 400 && posEq(lastClick.pos, start)) {
        type = "double";
        lastDoubleClick = {time: now, pos: start};
        e_preventDefault(e);
        var word = findWordAt(start);
        setSelectionUser(word.from, word.to);
      } else { lastClick = {time: now, pos: start}; }

      function dragEnd(e2) {
        if (webkit) scroller.draggable = false;
        draggingText = false;
        up(); drop();
        if (Math.abs(e.clientX - e2.clientX) + Math.abs(e.clientY - e2.clientY) < 10) {
          e_preventDefault(e2);
          setCursor(start.line, start.ch, true);
          focusInput();
        }
      }
      var last = start, going;
      if (options.dragDrop && dragAndDrop && !options.readOnly && !posEq(sel.from, sel.to) &&
          !posLess(start, sel.from) && !posLess(sel.to, start) && type == "single") {
        // Let the drag handler handle this.
        if (webkit) scroller.draggable = true;
        var up = connect(document, "mouseup", operation(dragEnd), true);
        var drop = connect(scroller, "drop", operation(dragEnd), true);
        draggingText = true;
        // IE's approach to draggable
        if (scroller.dragDrop) scroller.dragDrop();
        return;
      }
      e_preventDefault(e);
      if (type == "single") setCursor(start.line, start.ch, true);

      var startstart = sel.from, startend = sel.to;

      function doSelect(cur) {
        if (type == "single") {
          setSelectionUser(start, cur);
        } else if (type == "double") {
          var word = findWordAt(cur);
          if (posLess(cur, startstart)) setSelectionUser(word.from, startend);
          else setSelectionUser(startstart, word.to);
        } else if (type == "triple") {
          if (posLess(cur, startstart)) setSelectionUser(startend, clipPos({line: cur.line, ch: 0}));
          else setSelectionUser(startstart, clipPos({line: cur.line + 1, ch: 0}));
        }
      }

      function extend(e) {
        var cur = posFromMouse(e, true);
        if (cur && !posEq(cur, last)) {
          if (!focused) onFocus();
          last = cur;
          doSelect(cur);
          updateInput = false;
          var visible = visibleLines();
          if (cur.line >= visible.to || cur.line < visible.from)
            going = setTimeout(operation(function(){extend(e);}), 150);
        }
      }

      function done(e) {
        clearTimeout(going);
        var cur = posFromMouse(e);
        if (cur) doSelect(cur);
        e_preventDefault(e);
        focusInput();
        updateInput = true;
        move(); up();
      }
      var move = connect(document, "mousemove", operation(function(e) {
        clearTimeout(going);
        e_preventDefault(e);
        if (!ie && !e_button(e)) done(e);
        else extend(e);
      }), true);
      var up = connect(document, "mouseup", operation(done), true);
    }
    function onDoubleClick(e) {
      for (var n = e_target(e); n != wrapper; n = n.parentNode)
        if (n.parentNode == gutterText) return e_preventDefault(e);
      e_preventDefault(e);
    }
    function onDrop(e) {
      if (options.onDragEvent && options.onDragEvent(instance, addStop(e))) return;
      e_preventDefault(e);
      var pos = posFromMouse(e, true), files = e.dataTransfer.files;
      if (!pos || options.readOnly) return;
      if (files && files.length && window.FileReader && window.File) {
        var n = files.length, text = Array(n), read = 0;
        var loadFile = function(file, i) {
          var reader = new FileReader;
          reader.onload = function() {
            text[i] = reader.result;
            if (++read == n) {
              pos = clipPos(pos);
              operation(function() {
                var end = replaceRange(text.join(""), pos, pos);
                setSelectionUser(pos, end);
              })();
            }
          };
          reader.readAsText(file);
        };
        for (var i = 0; i < n; ++i) loadFile(files[i], i);
      } else {
        // Don't do a replace if the drop happened inside of the selected text.
        if (draggingText && !(posLess(pos, sel.from) || posLess(sel.to, pos))) return;
        try {
          var text = e.dataTransfer.getData("Text");
          if (text) {
            compoundChange(function() {
              var curFrom = sel.from, curTo = sel.to;
              setSelectionUser(pos, pos);
              if (draggingText) replaceRange("", curFrom, curTo);
              replaceSelection(text);
              focusInput();
            });
          }
        }
        catch(e){}
      }
    }
    function onDragStart(e) {
      var txt = getSelection();
      e.dataTransfer.setData("Text", txt);

      // Use dummy image instead of default browsers image.
      if (e.dataTransfer.setDragImage)
        e.dataTransfer.setDragImage(elt('img'), 0, 0);
    }

    function doHandleBinding(bound, dropShift) {
      if (typeof bound == "string") {
        bound = commands[bound];
        if (!bound) return false;
      }
      var prevShift = shiftSelecting;
      try {
        if (options.readOnly) suppressEdits = true;
        if (dropShift) shiftSelecting = null;
        bound(instance);
      } catch(e) {
        if (e != Pass) throw e;
        return false;
      } finally {
        shiftSelecting = prevShift;
        suppressEdits = false;
      }
      return true;
    }
    var maybeTransition;
    function handleKeyBinding(e) {
      // Handle auto keymap transitions
      var startMap = getKeyMap(options.keyMap), next = startMap.auto;
      clearTimeout(maybeTransition);
      if (next && !isModifierKey(e)) maybeTransition = setTimeout(function() {
        if (getKeyMap(options.keyMap) == startMap) {
          options.keyMap = (next.call ? next.call(null, instance) : next);
        }
      }, 50);

      var name = keyNames[e_prop(e, "keyCode")], handled = false;
      var flipCtrlCmd = opera && mac;
      if (name == null || e.altGraphKey) return false;
      if (e_prop(e, "altKey")) name = "Alt-" + name;
      if (e_prop(e, flipCtrlCmd ? "metaKey" : "ctrlKey")) name = "Ctrl-" + name;
      if (e_prop(e, flipCtrlCmd ? "ctrlKey" : "metaKey")) name = "Cmd-" + name;

      var stopped = false;
      function stop() { stopped = true; }

      if (e_prop(e, "shiftKey")) {
        handled = lookupKey("Shift-" + name, options.extraKeys, options.keyMap,
                            function(b) {return doHandleBinding(b, true);}, stop)
               || lookupKey(name, options.extraKeys, options.keyMap, function(b) {
                 if (typeof b == "string" && /^go[A-Z]/.test(b)) return doHandleBinding(b);
               }, stop);
      } else {
        handled = lookupKey(name, options.extraKeys, options.keyMap, doHandleBinding, stop);
      }
      if (stopped) handled = false;
      if (handled) {
        e_preventDefault(e);
        restartBlink();
        if (ie) { e.oldKeyCode = e.keyCode; e.keyCode = 0; }
      }
      return handled;
    }
    function handleCharBinding(e, ch) {
      var handled = lookupKey("'" + ch + "'", options.extraKeys,
                              options.keyMap, function(b) { return doHandleBinding(b, true); });
      if (handled) {
        e_preventDefault(e);
        restartBlink();
      }
      return handled;
    }

    var lastStoppedKey = null;
    function onKeyDown(e) {
      if (!focused) onFocus();
      if (ie && e.keyCode == 27) { e.returnValue = false; }
      if (pollingFast) { if (readInput()) pollingFast = false; }
      if (options.onKeyEvent && options.onKeyEvent(instance, addStop(e))) return;
      var code = e_prop(e, "keyCode");
      // IE does strange things with escape.
      setShift(code == 16 || e_prop(e, "shiftKey"));
      // First give onKeyEvent option a chance to handle this.
      var handled = handleKeyBinding(e);
      if (opera) {
        lastStoppedKey = handled ? code : null;
        // Opera has no cut event... we try to at least catch the key combo
        if (!handled && code == 88 && e_prop(e, mac ? "metaKey" : "ctrlKey"))
          replaceSelection("");
      }
    }
    function onKeyPress(e) {
      if (pollingFast) readInput();
      if (options.onKeyEvent && options.onKeyEvent(instance, addStop(e))) return;
      var keyCode = e_prop(e, "keyCode"), charCode = e_prop(e, "charCode");
      if (opera && keyCode == lastStoppedKey) {lastStoppedKey = null; e_preventDefault(e); return;}
      if (((opera && (!e.which || e.which < 10)) || khtml) && handleKeyBinding(e)) return;
      var ch = String.fromCharCode(charCode == null ? keyCode : charCode);
      if (options.electricChars && mode.electricChars && options.smartIndent && !options.readOnly) {
        if (mode.electricChars.indexOf(ch) > -1)
          setTimeout(operation(function() {indentLine(sel.to.line, "smart");}), 75);
      }
      if (handleCharBinding(e, ch)) return;
      fastPoll();
    }
    function onKeyUp(e) {
      if (options.onKeyEvent && options.onKeyEvent(instance, addStop(e))) return;
      if (e_prop(e, "keyCode") == 16) shiftSelecting = null;
    }

    function onFocus() {
      if (options.readOnly == "nocursor") return;
      if (!focused) {
        if (options.onFocus) options.onFocus(instance);
        focused = true;
        if (scroller.className.search(/\bCodeMirror-focused\b/) == -1)
          scroller.className += " CodeMirror-focused";
      }
      slowPoll();
      restartBlink();
    }
    function onBlur() {
      if (focused) {
        if (options.onBlur) options.onBlur(instance);
        focused = false;
        if (bracketHighlighted)
          operation(function(){
            if (bracketHighlighted) { bracketHighlighted(); bracketHighlighted = null; }
          })();
        scroller.className = scroller.className.replace(" CodeMirror-focused", "");
      }
      clearInterval(blinker);
      setTimeout(function() {if (!focused) shiftSelecting = null;}, 150);
    }

    // Replace the range from from to to by the strings in newText.
    // Afterwards, set the selection to selFrom, selTo.
    function updateLines(from, to, newText, selFrom, selTo) {
      if (suppressEdits) return;
      var old = [];
      doc.iter(from.line, to.line + 1, function(line) {
        old.push(newHL(line.text, line.markedSpans));
      });
      if (history) {
        history.addChange(from.line, newText.length, old);
        while (history.done.length > options.undoDepth) history.done.shift();
      }
      var lines = updateMarkedSpans(hlSpans(old[0]), hlSpans(lst(old)), from.ch, to.ch, newText);
      updateLinesNoUndo(from, to, lines, selFrom, selTo);
    }
    function unredoHelper(from, to) {
      if (!from.length) return;
      var set = from.pop(), out = [];
      for (var i = set.length - 1; i >= 0; i -= 1) {
        var change = set[i];
        var replaced = [], end = change.start + change.added;
        doc.iter(change.start, end, function(line) { replaced.push(newHL(line.text, line.markedSpans)); });
        out.push({start: change.start, added: change.old.length, old: replaced});
        var pos = {line: change.start + change.old.length - 1,
                   ch: editEnd(hlText(lst(replaced)), hlText(lst(change.old)))};
        updateLinesNoUndo({line: change.start, ch: 0}, {line: end - 1, ch: getLine(end-1).text.length},
                          change.old, pos, pos);
      }
      updateInput = true;
      to.push(out);
    }
    function undo() {unredoHelper(history.done, history.undone);}
    function redo() {unredoHelper(history.undone, history.done);}

    function updateLinesNoUndo(from, to, lines, selFrom, selTo) {
      if (suppressEdits) return;
      var recomputeMaxLength = false, maxLineLength = maxLine.text.length;
      if (!options.lineWrapping)
        doc.iter(from.line, to.line + 1, function(line) {
          if (!line.hidden && line.text.length == maxLineLength) {recomputeMaxLength = true; return true;}
        });
      if (from.line != to.line || lines.length > 1) gutterDirty = true;

      var nlines = to.line - from.line, firstLine = getLine(from.line), lastLine = getLine(to.line);
      var lastHL = lst(lines);

      // First adjust the line structure
      if (from.ch == 0 && to.ch == 0 && hlText(lastHL) == "") {
        // This is a whole-line replace. Treated specially to make
        // sure line objects move the way they are supposed to.
        var added = [], prevLine = null;
        for (var i = 0, e = lines.length - 1; i < e; ++i)
          added.push(new Line(hlText(lines[i]), hlSpans(lines[i])));
        lastLine.update(lastLine.text, hlSpans(lastHL));
        if (nlines) doc.remove(from.line, nlines, callbacks);
        if (added.length) doc.insert(from.line, added);
      } else if (firstLine == lastLine) {
        if (lines.length == 1) {
          firstLine.update(firstLine.text.slice(0, from.ch) + hlText(lines[0]) + firstLine.text.slice(to.ch), hlSpans(lines[0]));
        } else {
          for (var added = [], i = 1, e = lines.length - 1; i < e; ++i)
            added.push(new Line(hlText(lines[i]), hlSpans(lines[i])));
          added.push(new Line(hlText(lastHL) + firstLine.text.slice(to.ch), hlSpans(lastHL)));
          firstLine.update(firstLine.text.slice(0, from.ch) + hlText(lines[0]), hlSpans(lines[0]));
          doc.insert(from.line + 1, added);
        }
      } else if (lines.length == 1) {
        firstLine.update(firstLine.text.slice(0, from.ch) + hlText(lines[0]) + lastLine.text.slice(to.ch), hlSpans(lines[0]));
        doc.remove(from.line + 1, nlines, callbacks);
      } else {
        var added = [];
        firstLine.update(firstLine.text.slice(0, from.ch) + hlText(lines[0]), hlSpans(lines[0]));
        lastLine.update(hlText(lastHL) + lastLine.text.slice(to.ch), hlSpans(lastHL));
        for (var i = 1, e = lines.length - 1; i < e; ++i)
          added.push(new Line(hlText(lines[i]), hlSpans(lines[i])));
        if (nlines > 1) doc.remove(from.line + 1, nlines - 1, callbacks);
        doc.insert(from.line + 1, added);
      }
      if (options.lineWrapping) {
        var perLine = Math.max(5, scroller.clientWidth / charWidth() - 3);
        doc.iter(from.line, from.line + lines.length, function(line) {
          if (line.hidden) return;
          var guess = Math.ceil(line.text.length / perLine) || 1;
          if (guess != line.height) updateLineHeight(line, guess);
        });
      } else {
        doc.iter(from.line, from.line + lines.length, function(line) {
          var l = line.text;
          if (!line.hidden && l.length > maxLineLength) {
            maxLine = line; maxLineLength = l.length; maxLineChanged = true;
            recomputeMaxLength = false;
          }
        });
        if (recomputeMaxLength) updateMaxLine = true;
      }

      // Adjust frontier, schedule worker
      frontier = Math.min(frontier, from.line);
      startWorker(400);

      var lendiff = lines.length - nlines - 1;
      // Remember that these lines changed, for updating the display
      changes.push({from: from.line, to: to.line + 1, diff: lendiff});
      if (options.onChange) {
        // Normalize lines to contain only strings, since that's what
        // the change event handler expects
        for (var i = 0; i < lines.length; ++i)
          if (typeof lines[i] != "string") lines[i] = lines[i].text;
        var changeObj = {from: from, to: to, text: lines};
        if (textChanged) {
          for (var cur = textChanged; cur.next; cur = cur.next) {}
          cur.next = changeObj;
        } else textChanged = changeObj;
      }

      // Update the selection
      function updateLine(n) {return n <= Math.min(to.line, to.line + lendiff) ? n : n + lendiff;}
      setSelection(clipPos(selFrom), clipPos(selTo),
                   updateLine(sel.from.line), updateLine(sel.to.line));
    }

    function needsScrollbar() {
      var realHeight = doc.height * textHeight() + 2 * paddingTop();
      return realHeight * .99 > scroller.offsetHeight ? realHeight : false;
    }

    function updateVerticalScroll(scrollTop) {
      var scrollHeight = needsScrollbar();
      scrollbar.style.display = scrollHeight ? "block" : "none";
      if (scrollHeight) {
        scrollbarInner.style.height = sizer.style.minHeight = scrollHeight + "px";
        scrollbar.style.height = scroller.clientHeight + "px";
        if (scrollTop != null) {
          scrollbar.scrollTop = scroller.scrollTop = scrollTop;
          // 'Nudge' the scrollbar to work around a Webkit bug where,
          // in some situations, we'd end up with a scrollbar that
          // reported its scrollTop (and looked) as expected, but
          // *behaved* as if it was still in a previous state (i.e.
          // couldn't scroll up, even though it appeared to be at the
          // bottom).
          if (webkit) setTimeout(function() {
            if (scrollbar.scrollTop != scrollTop) return;
            scrollbar.scrollTop = scrollTop + (scrollTop ? -1 : 1);
            scrollbar.scrollTop = scrollTop;
          }, 0);
        }
      } else {
        sizer.style.minHeight = "";
      }
      // Position the mover div to align with the current virtual scroll position
      mover.style.top = displayOffset * textHeight() + "px";
    }

    function computeMaxLength() {
      maxLine = getLine(0); maxLineChanged = true;
      var maxLineLength = maxLine.text.length;
      doc.iter(1, doc.size, function(line) {
        var l = line.text;
        if (!line.hidden && l.length > maxLineLength) {
          maxLineLength = l.length; maxLine = line;
        }
      });
      updateMaxLine = false;
    }

    function replaceRange(code, from, to) {
      from = clipPos(from);
      if (!to) to = from; else to = clipPos(to);
      code = splitLines(code);
      function adjustPos(pos) {
        if (posLess(pos, from)) return pos;
        if (!posLess(to, pos)) return end;
        var line = pos.line + code.length - (to.line - from.line) - 1;
        var ch = pos.ch;
        if (pos.line == to.line)
          ch += lst(code).length - (to.ch - (to.line == from.line ? from.ch : 0));
        return {line: line, ch: ch};
      }
      var end;
      replaceRange1(code, from, to, function(end1) {
        end = end1;
        return {from: adjustPos(sel.from), to: adjustPos(sel.to)};
      });
      return end;
    }
    function replaceSelection(code, collapse) {
      replaceRange1(splitLines(code), sel.from, sel.to, function(end) {
        if (collapse == "end") return {from: end, to: end};
        else if (collapse == "start") return {from: sel.from, to: sel.from};
        else return {from: sel.from, to: end};
      });
    }
    function replaceRange1(code, from, to, computeSel) {
      var endch = code.length == 1 ? code[0].length + from.ch : lst(code).length;
      var newSel = computeSel({line: from.line + code.length - 1, ch: endch});
      updateLines(from, to, code, newSel.from, newSel.to);
    }

    function getRange(from, to, lineSep) {
      var l1 = from.line, l2 = to.line;
      if (l1 == l2) return getLine(l1).text.slice(from.ch, to.ch);
      var code = [getLine(l1).text.slice(from.ch)];
      doc.iter(l1 + 1, l2, function(line) { code.push(line.text); });
      code.push(getLine(l2).text.slice(0, to.ch));
      return code.join(lineSep || "\n");
    }
    function getSelection(lineSep) {
      return getRange(sel.from, sel.to, lineSep);
    }

    function slowPoll() {
      if (pollingFast) return;
      poll.set(options.pollInterval, function() {
        readInput();
        if (focused) slowPoll();
      });
    }
    function fastPoll() {
      var missed = false;
      pollingFast = true;
      function p() {
        var changed = readInput();
        if (!changed && !missed) {missed = true; poll.set(60, p);}
        else {pollingFast = false; slowPoll();}
      }
      poll.set(20, p);
    }

    // Previnput is a hack to work with IME. If we reset the textarea
    // on every change, that breaks IME. So we look for changes
    // compared to the previous content instead. (Modern browsers have
    // events that indicate IME taking place, but these are not widely
    // supported or compatible enough yet to rely on.)
    var prevInput = "";
    function readInput() {
      if (!focused || hasSelection(input) || options.readOnly) return false;
      var text = input.value;
      if (text == prevInput) return false;
      if (!nestedOperation) startOperation();
      shiftSelecting = null;
      var same = 0, l = Math.min(prevInput.length, text.length);
      while (same < l && prevInput[same] == text[same]) ++same;
      if (same < prevInput.length)
        sel.from = {line: sel.from.line, ch: sel.from.ch - (prevInput.length - same)};
      else if (overwrite && posEq(sel.from, sel.to) && !pasteIncoming)
        sel.to = {line: sel.to.line, ch: Math.min(getLine(sel.to.line).text.length, sel.to.ch + (text.length - same))};
      replaceSelection(text.slice(same), "end");
      if (text.length > 1000) { input.value = prevInput = ""; }
      else prevInput = text;
      if (!nestedOperation) endOperation();
      pasteIncoming = false;
      return true;
    }
    function resetInput(user) {
      if (!posEq(sel.from, sel.to)) {
        prevInput = "";
        input.value = getSelection();
        if (focused) selectInput(input);
      } else if (user) prevInput = input.value = "";
    }

    function focusInput() {
      if (options.readOnly != "nocursor") input.focus();
    }

    function scrollCursorIntoView() {
      var coords = calculateCursorCoords();
      scrollIntoView(coords.x, coords.y, coords.x, coords.yBot);
      if (!focused) return;
      var box = sizer.getBoundingClientRect(), doScroll = null;
      if (coords.y + box.top < 0) doScroll = true;
      else if (coords.y + box.top + textHeight() > (window.innerHeight || document.documentElement.clientHeight)) doScroll = false;
      if (doScroll != null) {
        var hidden = cursor.style.display == "none";
        if (hidden) {
          cursor.style.display = "";
          cursor.style.left = coords.x + "px";
          cursor.style.top = (coords.y - displayOffset) + "px";
        }
        cursor.scrollIntoView(doScroll);
        if (hidden) cursor.style.display = "none";
      }
    }
    function calculateCursorCoords() {
      var cursor = localCoords(sel.inverted ? sel.from : sel.to);
      var x = options.lineWrapping ? Math.min(cursor.x, lineSpace.offsetWidth) : cursor.x;
      return {x: x, y: cursor.y, yBot: cursor.yBot};
    }
    function scrollIntoView(x1, y1, x2, y2) {
      var scrollPos = calculateScrollPos(x1, y1, x2, y2);
      if (scrollPos.scrollLeft != null) {scroller.scrollLeft = scrollPos.scrollLeft;}
      if (scrollPos.scrollTop != null) {scrollbar.scrollTop = scroller.scrollTop = scrollPos.scrollTop;}
    }
    function calculateScrollPos(x1, y1, x2, y2) {
      var pl = paddingLeft(), pt = paddingTop();
      y1 += pt; y2 += pt; x1 += pl; x2 += pl;
      var screen = scroller.clientHeight, screentop = scrollbar.scrollTop, result = {};
      var docBottom = needsScrollbar() || Infinity;
      var atTop = y1 < pt + 10, atBottom = y2 + pt > docBottom - 10;
      if (y1 < screentop) result.scrollTop = atTop ? 0 : Math.max(0, y1);
      else if (y2 > screentop + screen) result.scrollTop = (atBottom ? docBottom : y2) - screen;

      var screenw = scroller.clientWidth, screenleft = scroller.scrollLeft;
      var gutterw = options.fixedGutter ? gutter.clientWidth : 0;
      var atLeft = x1 < gutterw + pl + 10;
      if (x1 < screenleft + gutterw || atLeft) {
        if (atLeft) x1 = 0;
        result.scrollLeft = Math.max(0, x1 - 10 - gutterw);
      } else if (x2 > screenw + screenleft - 3) {
        result.scrollLeft = x2 + 10 - screenw;
      }
      return result;
    }

    function visibleLines(scrollTop) {
      var lh = textHeight(), top = (scrollTop != null ? scrollTop : scrollbar.scrollTop) - paddingTop();
      var fromHeight = Math.max(0, Math.floor(top / lh));
      var toHeight = Math.ceil((top + scroller.clientHeight) / lh);
      return {from: lineAtHeight(doc, fromHeight),
              to: lineAtHeight(doc, toHeight)};
    }
    // Uses a set of changes plus the current scroll position to
    // determine which DOM updates have to be made, and makes the
    // updates.
    function updateDisplay(changes, suppressCallback, scrollTop) {
      if (!scroller.clientWidth) {
        showingFrom = showingTo = displayOffset = 0;
        return;
      }
      // Compute the new visible window
      // If scrollTop is specified, use that to determine which lines
      // to render instead of the current scrollbar position.
      var visible = visibleLines(scrollTop);
      // Bail out if the visible area is already rendered and nothing changed.
      if (changes !== true && changes.length == 0 && visible.from > showingFrom && visible.to < showingTo) {
        updateVerticalScroll(scrollTop);
        return;
      }
      var from = Math.max(visible.from - 100, 0), to = Math.min(doc.size, visible.to + 100);
      if (showingFrom < from && from - showingFrom < 20) from = showingFrom;
      if (showingTo > to && showingTo - to < 20) to = Math.min(doc.size, showingTo);

      // Create a range of theoretically intact lines, and punch holes
      // in that using the change info.
      var intact = changes === true ? [] :
        computeIntact([{from: showingFrom, to: showingTo, domStart: 0}], changes);
      // Clip off the parts that won't be visible
      var intactLines = 0;
      for (var i = 0; i < intact.length; ++i) {
        var range = intact[i];
        if (range.from < from) {range.domStart += (from - range.from); range.from = from;}
        if (range.to > to) range.to = to;
        if (range.from >= range.to) intact.splice(i--, 1);
        else intactLines += range.to - range.from;
      }
      if (intactLines == to - from && from == showingFrom && to == showingTo) {
        updateVerticalScroll(scrollTop);
        return;
      }
      intact.sort(function(a, b) {return a.domStart - b.domStart;});

      var th = textHeight(), gutterDisplay = gutter.style.display;
      lineDiv.style.display = "none";
      patchDisplay(from, to, intact);
      lineDiv.style.display = gutter.style.display = "";

      var different = from != showingFrom || to != showingTo || lastSizeC != scroller.clientHeight + th;
      // This is just a bogus formula that detects when the editor is
      // resized or the font size changes.
      if (different) lastSizeC = scroller.clientHeight + th;
      if (from != showingFrom || to != showingTo && options.onViewportChange)
        setTimeout(function(){
          if (options.onViewportChange) options.onViewportChange(instance, from, to);
        });
      showingFrom = from; showingTo = to;
      displayOffset = heightAtLine(doc, from);
      startWorker(100);

      // Since this is all rather error prone, it is honoured with the
      // only assertion in the whole file.
      if (lineDiv.childNodes.length != showingTo - showingFrom)
        throw new Error("BAD PATCH! " + JSON.stringify(intact) + " size=" + (showingTo - showingFrom) +
                        " nodes=" + lineDiv.childNodes.length);

      function checkHeights() {
        var curNode = lineDiv.firstChild, heightChanged = false;
        doc.iter(showingFrom, showingTo, function(line) {
          // Work around bizarro IE7 bug where, sometimes, our curNode
          // is magically replaced with a new node in the DOM, leaving
          // us with a reference to an orphan (nextSibling-less) node.
          if (!curNode) return;
          if (!line.hidden) {
            var height = Math.round(curNode.offsetHeight / th) || 1;
            if (line.height != height) {
              updateLineHeight(line, height);
              gutterDirty = heightChanged = true;
            }
          }
          curNode = curNode.nextSibling;
        });
        return heightChanged;
      }

      if (options.lineWrapping) checkHeights();

      gutter.style.display = gutterDisplay;
      if (different || gutterDirty) {
        // If the gutter grew in size, re-check heights. If those changed, re-draw gutter.
        updateGutter() && options.lineWrapping && checkHeights() && updateGutter();
      }
      updateVerticalScroll(scrollTop);
      updateSelection();
      if (!suppressCallback && options.onUpdate) options.onUpdate(instance);
      return true;
    }

    function computeIntact(intact, changes) {
      for (var i = 0, l = changes.length || 0; i < l; ++i) {
        var change = changes[i], intact2 = [], diff = change.diff || 0;
        for (var j = 0, l2 = intact.length; j < l2; ++j) {
          var range = intact[j];
          if (change.to <= range.from && change.diff)
            intact2.push({from: range.from + diff, to: range.to + diff,
                          domStart: range.domStart});
          else if (change.to <= range.from || change.from >= range.to)
            intact2.push(range);
          else {
            if (change.from > range.from)
              intact2.push({from: range.from, to: change.from, domStart: range.domStart});
            if (change.to < range.to)
              intact2.push({from: change.to + diff, to: range.to + diff,
                            domStart: range.domStart + (change.to - range.from)});
          }
        }
        intact = intact2;
      }
      return intact;
    }

    function patchDisplay(from, to, intact) {
      function killNode(node) {
        var tmp = node.nextSibling;
        node.parentNode.removeChild(node);
        return tmp;
      }
      // The first pass removes the DOM nodes that aren't intact.
      if (!intact.length) removeChildren(lineDiv);
      else {
        var domPos = 0, curNode = lineDiv.firstChild, n;
        for (var i = 0; i < intact.length; ++i) {
          var cur = intact[i];
          while (cur.domStart > domPos) {curNode = killNode(curNode); domPos++;}
          for (var j = 0, e = cur.to - cur.from; j < e; ++j) {curNode = curNode.nextSibling; domPos++;}
        }
        while (curNode) curNode = killNode(curNode);
      }
      // This pass fills in the lines that actually changed.
      var nextIntact = intact.shift(), curNode = lineDiv.firstChild, j = from;
      doc.iter(from, to, function(line) {
        if (nextIntact && nextIntact.to == j) nextIntact = intact.shift();
        if (!nextIntact || nextIntact.from > j) {
          if (line.hidden) var lineElement = elt("pre");
          else {
            var lineElement = lineContent(line);
            if (line.className) lineElement.className = line.className;
            // Kludge to make sure the styled element lies behind the selection (by z-index)
            if (line.bgClassName) {
              var pre = elt("pre", "\u00a0", line.bgClassName, "position: absolute; left: 0; right: 0; top: 0; bottom: 0; z-index: -2");
              lineElement = elt("div", [pre, lineElement], null, "position: relative");
            }
          }
          lineDiv.insertBefore(lineElement, curNode);
        } else {
          curNode = curNode.nextSibling;
        }
        ++j;
      });
    }

    function updateGutter() {
      if (!options.gutter && !options.lineNumbers) return;
      var hText = mover.offsetHeight, hEditor = scroller.clientHeight;
      gutter.style.height = (hText - hEditor < 2 ? hEditor : hText) + "px";
      var fragment = document.createDocumentFragment(), i = showingFrom, normalNode;
      doc.iter(showingFrom, Math.max(showingTo, showingFrom + 1), function(line) {
        if (line.hidden) {
          fragment.appendChild(elt("pre"));
        } else {
          var marker = line.gutterMarker;
          var text = options.lineNumbers ? options.lineNumberFormatter(i + options.firstLineNumber) : null;
          if (marker && marker.text)
            text = marker.text.replace("%N%", text != null ? text : "");
          else if (text == null)
            text = "\u00a0";
          var markerElement = fragment.appendChild(elt("pre", null, marker && marker.style));
          markerElement.innerHTML = text;
          for (var j = 1; j < line.height; ++j) {
            markerElement.appendChild(elt("br"));
            markerElement.appendChild(document.createTextNode("\u00a0"));
          }
          if (!marker) normalNode = i;
        }
        ++i;
      });
      gutter.style.display = "none";
      removeChildrenAndAdd(gutterText, fragment);
      // Make sure scrolling doesn't cause number gutter size to pop
      if (normalNode != null && options.lineNumbers) {
        var node = gutterText.childNodes[normalNode - showingFrom];
        var minwidth = String(doc.size).length, val = eltText(node.firstChild), pad = "";
        while (val.length + pad.length < minwidth) pad += "\u00a0";
        if (pad) node.insertBefore(document.createTextNode(pad), node.firstChild);
      }
      gutter.style.display = "";
      var resized = Math.abs((parseInt(lineSpace.style.marginLeft) || 0) - gutter.offsetWidth) > 2;
      lineSpace.style.marginLeft = gutter.offsetWidth + "px";
      gutterDirty = false;
      return resized;
    }
    function updateSelection() {
      var collapsed = posEq(sel.from, sel.to);
      var fromPos = localCoords(sel.from, true);
      var toPos = collapsed ? fromPos : localCoords(sel.to, true);
      var headPos = sel.inverted ? fromPos : toPos, th = textHeight();
      var wrapOff = eltOffset(wrapper), lineOff = eltOffset(lineDiv);
      inputDiv.style.top = Math.max(0, Math.min(scroller.offsetHeight, headPos.y + lineOff.top - wrapOff.top)) + "px";
      inputDiv.style.left = Math.max(0, Math.min(scroller.offsetWidth, headPos.x + lineOff.left - wrapOff.left)) + "px";
      if (collapsed) {
        cursor.style.top = headPos.y + "px";
        cursor.style.left = (options.lineWrapping ? Math.min(headPos.x, lineSpace.offsetWidth) : headPos.x) + "px";
        cursor.style.display = "";
        selectionDiv.style.display = "none";
      } else {
        var sameLine = fromPos.y == toPos.y, fragment = document.createDocumentFragment();
        var clientWidth = lineSpace.clientWidth || lineSpace.offsetWidth;
        var clientHeight = lineSpace.clientHeight || lineSpace.offsetHeight;
        var add = function(left, top, right, height) {
          var rstyle = quirksMode ? "width: " + (!right ? clientWidth : clientWidth - right - left) + "px"
                                  : "right: " + right + "px";
          fragment.appendChild(elt("div", null, "CodeMirror-selected", "position: absolute; left: " + left +
                                   "px; top: " + top + "px; " + rstyle + "; height: " + height + "px"));
        };
        if (sel.from.ch && fromPos.y >= 0) {
          var right = sameLine ? clientWidth - toPos.x : 0;
          add(fromPos.x, fromPos.y, right, th);
        }
        var middleStart = Math.max(0, fromPos.y + (sel.from.ch ? th : 0));
        var middleHeight = Math.min(toPos.y, clientHeight) - middleStart;
        if (middleHeight > 0.2 * th)
          add(0, middleStart, 0, middleHeight);
        if ((!sameLine || !sel.from.ch) && toPos.y < clientHeight - .5 * th)
          add(0, toPos.y, clientWidth - toPos.x, th);
        removeChildrenAndAdd(selectionDiv, fragment);
        cursor.style.display = "none";
        selectionDiv.style.display = "";
      }
    }

    function setShift(val) {
      if (val) shiftSelecting = shiftSelecting || (sel.inverted ? sel.to : sel.from);
      else shiftSelecting = null;
    }
    function setSelectionUser(from, to) {
      var sh = shiftSelecting && clipPos(shiftSelecting);
      if (sh) {
        if (posLess(sh, from)) from = sh;
        else if (posLess(to, sh)) to = sh;
      }
      setSelection(from, to);
      userSelChange = true;
    }
    // Update the selection. Last two args are only used by
    // updateLines, since they have to be expressed in the line
    // numbers before the update.
    function setSelection(from, to, oldFrom, oldTo) {
      goalColumn = null;
      if (oldFrom == null) {oldFrom = sel.from.line; oldTo = sel.to.line;}
      if (posEq(sel.from, from) && posEq(sel.to, to)) return;
      if (posLess(to, from)) {var tmp = to; to = from; from = tmp;}

      // Skip over hidden lines.
      if (from.line != oldFrom) {
        var from1 = skipHidden(from, oldFrom, sel.from.ch);
        // If there is no non-hidden line left, force visibility on current line
        if (!from1) setLineHidden(from.line, false);
        else from = from1;
      }
      if (to.line != oldTo) to = skipHidden(to, oldTo, sel.to.ch);

      if (posEq(from, to)) sel.inverted = false;
      else if (posEq(from, sel.to)) sel.inverted = false;
      else if (posEq(to, sel.from)) sel.inverted = true;

      if (options.autoClearEmptyLines && posEq(sel.from, sel.to)) {
        var head = sel.inverted ? from : to;
        if (head.line != sel.from.line && sel.from.line < doc.size) {
          var oldLine = getLine(sel.from.line);
          if (/^\s+$/.test(oldLine.text))
            setTimeout(operation(function() {
              if (oldLine.parent && /^\s+$/.test(oldLine.text)) {
                var no = lineNo(oldLine);
                replaceRange("", {line: no, ch: 0}, {line: no, ch: oldLine.text.length});
              }
            }, 10));
        }
      }

      sel.from = from; sel.to = to;
      selectionChanged = true;
    }
    function skipHidden(pos, oldLine, oldCh) {
      function getNonHidden(dir) {
        var lNo = pos.line + dir, end = dir == 1 ? doc.size : -1;
        while (lNo != end) {
          var line = getLine(lNo);
          if (!line.hidden) {
            var ch = pos.ch;
            if (toEnd || ch > oldCh || ch > line.text.length) ch = line.text.length;
            return {line: lNo, ch: ch};
          }
          lNo += dir;
        }
      }
      var line = getLine(pos.line);
      var toEnd = pos.ch == line.text.length && pos.ch != oldCh;
      if (!line.hidden) return pos;
      if (pos.line >= oldLine) return getNonHidden(1) || getNonHidden(-1);
      else return getNonHidden(-1) || getNonHidden(1);
    }
    function setCursor(line, ch, user) {
      var pos = clipPos({line: line, ch: ch || 0});
      (user ? setSelectionUser : setSelection)(pos, pos);
    }

    function clipLine(n) {return Math.max(0, Math.min(n, doc.size-1));}
    function clipPos(pos) {
      if (pos.line < 0) return {line: 0, ch: 0};
      if (pos.line >= doc.size) return {line: doc.size-1, ch: getLine(doc.size-1).text.length};
      var ch = pos.ch, linelen = getLine(pos.line).text.length;
      if (ch == null || ch > linelen) return {line: pos.line, ch: linelen};
      else if (ch < 0) return {line: pos.line, ch: 0};
      else return pos;
    }

    function findPosH(dir, unit) {
      var end = sel.inverted ? sel.from : sel.to, line = end.line, ch = end.ch;
      var lineObj = getLine(line);
      function findNextLine() {
        for (var l = line + dir, e = dir < 0 ? -1 : doc.size; l != e; l += dir) {
          var lo = getLine(l);
          if (!lo.hidden) { line = l; lineObj = lo; return true; }
        }
      }
      function moveOnce(boundToLine) {
        if (ch == (dir < 0 ? 0 : lineObj.text.length)) {
          if (!boundToLine && findNextLine()) ch = dir < 0 ? lineObj.text.length : 0;
          else return false;
        } else ch += dir;
        return true;
      }
      if (unit == "char") moveOnce();
      else if (unit == "column") moveOnce(true);
      else if (unit == "word") {
        var sawWord = false;
        for (;;) {
          if (dir < 0) if (!moveOnce()) break;
          if (isWordChar(lineObj.text.charAt(ch))) sawWord = true;
          else if (sawWord) {if (dir < 0) {dir = 1; moveOnce();} break;}
          if (dir > 0) if (!moveOnce()) break;
        }
      }
      return {line: line, ch: ch};
    }
    function moveH(dir, unit) {
      var pos = dir < 0 ? sel.from : sel.to;
      if (shiftSelecting || posEq(sel.from, sel.to)) pos = findPosH(dir, unit);
      setCursor(pos.line, pos.ch, true);
    }
    function deleteH(dir, unit) {
      if (!posEq(sel.from, sel.to)) replaceRange("", sel.from, sel.to);
      else if (dir < 0) replaceRange("", findPosH(dir, unit), sel.to);
      else replaceRange("", sel.from, findPosH(dir, unit));
      userSelChange = true;
    }
    function moveV(dir, unit) {
      var dist = 0, pos = localCoords(sel.inverted ? sel.from : sel.to, true);
      if (goalColumn != null) pos.x = goalColumn;
      if (unit == "page") {
        var screen = Math.min(scroller.clientHeight, window.innerHeight || document.documentElement.clientHeight);
        var target = coordsChar(pos.x, pos.y + screen * dir);
      } else if (unit == "line") {
        var th = textHeight();
        var target = coordsChar(pos.x, pos.y + .5 * th + dir * th);
      }
      if (unit == "page") scrollbar.scrollTop += localCoords(target, true).y - pos.y;
      setCursor(target.line, target.ch, true);
      goalColumn = pos.x;
    }

    function findWordAt(pos) {
      var line = getLine(pos.line).text;
      var start = pos.ch, end = pos.ch;
      if (line) {
        if (pos.after === false || end == line.length) --start; else ++end;
        var startChar = line.charAt(start);
        var check = isWordChar(startChar) ? isWordChar :
                    /\s/.test(startChar) ? function(ch) {return /\s/.test(ch);} :
                    function(ch) {return !/\s/.test(ch) && isWordChar(ch);};
        while (start > 0 && check(line.charAt(start - 1))) --start;
        while (end < line.length && check(line.charAt(end))) ++end;
      }
      return {from: {line: pos.line, ch: start}, to: {line: pos.line, ch: end}};
    }
    function selectLine(line) {
      setSelectionUser({line: line, ch: 0}, clipPos({line: line + 1, ch: 0}));
    }
    function indentSelected(mode) {
      if (posEq(sel.from, sel.to)) return indentLine(sel.from.line, mode);
      var e = sel.to.line - (sel.to.ch ? 0 : 1);
      for (var i = sel.from.line; i <= e; ++i) indentLine(i, mode);
    }

    function indentLine(n, how) {
      if (!how) how = "add";
      if (how == "smart") {
        if (!mode.indent) how = "prev";
        else var state = getStateBefore(n);
      }

      var line = getLine(n), curSpace = line.indentation(options.tabSize),
          curSpaceString = line.text.match(/^\s*/)[0], indentation;
      if (how == "smart") {
        indentation = mode.indent(state, line.text.slice(curSpaceString.length), line.text);
        if (indentation == Pass) how = "prev";
      }
      if (how == "prev") {
        if (n) indentation = getLine(n-1).indentation(options.tabSize);
        else indentation = 0;
      }
      else if (how == "add") indentation = curSpace + options.indentUnit;
      else if (how == "subtract") indentation = curSpace - options.indentUnit;
      indentation = Math.max(0, indentation);
      var diff = indentation - curSpace;

      var indentString = "", pos = 0;
      if (options.indentWithTabs)
        for (var i = Math.floor(indentation / options.tabSize); i; --i) {pos += options.tabSize; indentString += "\t";}
      if (pos < indentation) indentString += spaceStr(indentation - pos);

      if (indentString != curSpaceString)
        replaceRange(indentString, {line: n, ch: 0}, {line: n, ch: curSpaceString.length});
      line.stateAfter = null;
    }

    function loadMode() {
      mode = CodeMirror.getMode(options, options.mode);
      doc.iter(0, doc.size, function(line) { line.stateAfter = null; });
      frontier = 0;
      startWorker(100);
    }
    function gutterChanged() {
      var visible = options.gutter || options.lineNumbers;
      gutter.style.display = visible ? "" : "none";
      if (visible) gutterDirty = true;
      else lineDiv.parentNode.style.marginLeft = 0;
    }
    function wrappingChanged(from, to) {
      if (options.lineWrapping) {
        wrapper.className += " CodeMirror-wrap";
        var perLine = scroller.clientWidth / charWidth() - 3;
        doc.iter(0, doc.size, function(line) {
          if (line.hidden) return;
          var guess = Math.ceil(line.text.length / perLine) || 1;
          if (guess != 1) updateLineHeight(line, guess);
        });
        lineSpace.style.minWidth = widthForcer.style.left = "";
      } else {
        wrapper.className = wrapper.className.replace(" CodeMirror-wrap", "");
        computeMaxLength();
        doc.iter(0, doc.size, function(line) {
          if (line.height != 1 && !line.hidden) updateLineHeight(line, 1);
        });
      }
      changes.push({from: 0, to: doc.size});
    }
    function themeChanged() {
      scroller.className = scroller.className.replace(/\s*cm-s-\S+/g, "") +
        options.theme.replace(/(^|\s)\s*/g, " cm-s-");
    }
    function keyMapChanged() {
      var style = keyMap[options.keyMap].style;
      wrapper.className = wrapper.className.replace(/\s*cm-keymap-\S+/g, "") +
        (style ? " cm-keymap-" + style : "");
    }

    function TextMarker(type, style) { this.lines = []; this.type = type; if (style) this.style = style; }
    TextMarker.prototype.clear = operation(function() {
      var min, max;
      for (var i = 0; i < this.lines.length; ++i) {
        var line = this.lines[i];
        var span = getMarkedSpanFor(line.markedSpans, this);
        if (span.from != null) min = lineNo(line);
        if (span.to != null) max = lineNo(line);
        line.markedSpans = removeMarkedSpan(line.markedSpans, span);
      }
      if (min != null) changes.push({from: min, to: max + 1});
      this.lines.length = 0;
      this.explicitlyCleared = true;
    });
    TextMarker.prototype.find = function() {
      var from, to;
      for (var i = 0; i < this.lines.length; ++i) {
        var line = this.lines[i];
        var span = getMarkedSpanFor(line.markedSpans, this);
        if (span.from != null || span.to != null) {
          var found = lineNo(line);
          if (span.from != null) from = {line: found, ch: span.from};
          if (span.to != null) to = {line: found, ch: span.to};
        }
      }
      if (this.type == "bookmark") return from;
      return from && {from: from, to: to};
    };

    function markText(from, to, className, options) {
      from = clipPos(from); to = clipPos(to);
      var marker = new TextMarker("range", className);
      if (options) for (var opt in options) if (options.hasOwnProperty(opt))
        marker[opt] = options[opt];
      var curLine = from.line;
      doc.iter(curLine, to.line + 1, function(line) {
        var span = {from: curLine == from.line ? from.ch : null,
                    to: curLine == to.line ? to.ch : null,
                    marker: marker};
        line.markedSpans = (line.markedSpans || []).concat([span]);
        marker.lines.push(line);
        ++curLine;
      });
      changes.push({from: from.line, to: to.line + 1});
      return marker;
    }

    function setBookmark(pos) {
      pos = clipPos(pos);
      var marker = new TextMarker("bookmark"), line = getLine(pos.line);
      history.addChange(pos.line, 1, [newHL(line.text, line.markedSpans)], true);
      var span = {from: pos.ch, to: pos.ch, marker: marker};
      line.markedSpans = (line.markedSpans || []).concat([span]);
      marker.lines.push(line);
      return marker;
    }

    function findMarksAt(pos) {
      pos = clipPos(pos);
      var markers = [], spans = getLine(pos.line).markedSpans;
      if (spans) for (var i = 0; i < spans.length; ++i) {
        var span = spans[i];
        if ((span.from == null || span.from <= pos.ch) &&
            (span.to == null || span.to >= pos.ch))
          markers.push(span.marker);
      }
      return markers;
    }

    function addGutterMarker(line, text, className) {
      if (typeof line == "number") line = getLine(clipLine(line));
      line.gutterMarker = {text: text, style: className};
      gutterDirty = true;
      return line;
    }
    function removeGutterMarker(line) {
      if (typeof line == "number") line = getLine(clipLine(line));
      line.gutterMarker = null;
      gutterDirty = true;
    }

    function changeLine(handle, op) {
      var no = handle, line = handle;
      if (typeof handle == "number") line = getLine(clipLine(handle));
      else no = lineNo(handle);
      if (no == null) return null;
      if (op(line, no)) changes.push({from: no, to: no + 1});
      else return null;
      return line;
    }
    function setLineClass(handle, className, bgClassName) {
      return changeLine(handle, function(line) {
        if (line.className != className || line.bgClassName != bgClassName) {
          line.className = className;
          line.bgClassName = bgClassName;
          return true;
        }
      });
    }
    function setLineHidden(handle, hidden) {
      return changeLine(handle, function(line, no) {
        if (line.hidden != hidden) {
          line.hidden = hidden;
          if (!options.lineWrapping) {
            if (hidden && line.text.length == maxLine.text.length) {
              updateMaxLine = true;
            } else if (!hidden && line.text.length > maxLine.text.length) {
              maxLine = line; updateMaxLine = false;
            }
          }
          updateLineHeight(line, hidden ? 0 : 1);
          var fline = sel.from.line, tline = sel.to.line;
          if (hidden && (fline == no || tline == no)) {
            var from = fline == no ? skipHidden({line: fline, ch: 0}, fline, 0) : sel.from;
            var to = tline == no ? skipHidden({line: tline, ch: 0}, tline, 0) : sel.to;
            // Can't hide the last visible line, we'd have no place to put the cursor
            if (!to) return;
            setSelection(from, to);
          }
          return (gutterDirty = true);
        }
      });
    }

    function lineInfo(line) {
      if (typeof line == "number") {
        if (!isLine(line)) return null;
        var n = line;
        line = getLine(line);
        if (!line) return null;
      } else {
        var n = lineNo(line);
        if (n == null) return null;
      }
      var marker = line.gutterMarker;
      return {line: n, handle: line, text: line.text, markerText: marker && marker.text,
              markerClass: marker && marker.style, lineClass: line.className, bgClass: line.bgClassName};
    }

    function measureLine(line, ch) {
      if (ch == 0) return {top: 0, left: 0};
      var pre = lineContent(line, ch);
      removeChildrenAndAdd(measure, pre);
      var anchor = pre.anchor;
      var top = anchor.offsetTop, left = anchor.offsetLeft;
      // Older IEs report zero offsets for spans directly after a wrap
      if (ie && top == 0 && left == 0) {
        var backup = elt("span", "x");
        anchor.parentNode.insertBefore(backup, anchor.nextSibling);
        top = backup.offsetTop;
      }
      return {top: top, left: left};
    }
    function localCoords(pos, inLineWrap) {
      var x, lh = textHeight(), y = lh * (heightAtLine(doc, pos.line) - (inLineWrap ? displayOffset : 0));
      if (pos.ch == 0) x = 0;
      else {
        var sp = measureLine(getLine(pos.line), pos.ch);
        x = sp.left;
        if (options.lineWrapping) y += Math.max(0, sp.top);
      }
      return {x: x, y: y, yBot: y + lh};
    }
    // Coords must be lineSpace-local
    function coordsChar(x, y) {
      var th = textHeight(), cw = charWidth(), heightPos = displayOffset + Math.floor(y / th);
      if (heightPos < 0) return {line: 0, ch: 0};
      var lineNo = lineAtHeight(doc, heightPos);
      if (lineNo >= doc.size) return {line: doc.size - 1, ch: getLine(doc.size - 1).text.length};
      var lineObj = getLine(lineNo), text = lineObj.text;
      var tw = options.lineWrapping, innerOff = tw ? heightPos - heightAtLine(doc, lineNo) : 0;
      if (x <= 0 && innerOff == 0) return {line: lineNo, ch: 0};
      var wrongLine = false;
      function getX(len) {
        var sp = measureLine(lineObj, len);
        if (tw) {
          var off = Math.round(sp.top / th);
          wrongLine = off != innerOff;
          return Math.max(0, sp.left + (off - innerOff) * scroller.clientWidth);
        }
        return sp.left;
      }
      var from = 0, fromX = 0, to = text.length, toX;
      // Guess a suitable upper bound for our search.
      var estimated = Math.min(to, Math.ceil((x + innerOff * scroller.clientWidth * .9) / cw));
      for (;;) {
        var estX = getX(estimated);
        if (estX <= x && estimated < to) estimated = Math.min(to, Math.ceil(estimated * 1.2));
        else {toX = estX; to = estimated; break;}
      }
      if (x > toX) return {line: lineNo, ch: to};
      // Try to guess a suitable lower bound as well.
      estimated = Math.floor(to * 0.8); estX = getX(estimated);
      if (estX < x) {from = estimated; fromX = estX;}
      // Do a binary search between these bounds.
      for (;;) {
        if (to - from <= 1) {
          var after = x - fromX < toX - x;
          return {line: lineNo, ch: after ? from : to, after: after};
        }
        var middle = Math.ceil((from + to) / 2), middleX = getX(middle);
        if (middleX > x) {to = middle; toX = middleX; if (wrongLine) toX += 1000; }
        else {from = middle; fromX = middleX;}
      }
    }
    function pageCoords(pos) {
      var local = localCoords(pos, true), off = eltOffset(lineSpace);
      return {x: off.left + local.x, y: off.top + local.y, yBot: off.top + local.yBot};
    }

    var cachedHeight, cachedHeightFor, measurePre;
    function textHeight() {
      if (measurePre == null) {
        measurePre = elt("pre");
        for (var i = 0; i < 49; ++i) {
          measurePre.appendChild(document.createTextNode("x"));
          measurePre.appendChild(elt("br"));
        }
        measurePre.appendChild(document.createTextNode("x"));
      }
      var offsetHeight = lineDiv.clientHeight;
      if (offsetHeight == cachedHeightFor) return cachedHeight;
      cachedHeightFor = offsetHeight;
      removeChildrenAndAdd(measure, measurePre.cloneNode(true));
      cachedHeight = measure.firstChild.offsetHeight / 50 || 1;
      removeChildren(measure);
      return cachedHeight;
    }
    var cachedWidth, cachedWidthFor = 0;
    function charWidth() {
      if (scroller.clientWidth == cachedWidthFor) return cachedWidth;
      cachedWidthFor = scroller.clientWidth;
      var anchor = elt("span", "x");
      var pre = elt("pre", [anchor]);
      removeChildrenAndAdd(measure, pre);
      return (cachedWidth = anchor.offsetWidth || 10);
    }
    function paddingTop() {return lineSpace.offsetTop;}
    function paddingLeft() {return lineSpace.offsetLeft;}

    function posFromMouse(e, liberal) {
      var offW = eltOffset(scroller, true), x, y;
      // Fails unpredictably on IE[67] when mouse is dragged around quickly.
      try { x = e.clientX; y = e.clientY; } catch (e) { return null; }
      // This is a mess of a heuristic to try and determine whether a
      // scroll-bar was clicked or not, and to return null if one was
      // (and !liberal).
      if (!liberal && (x - offW.left > scroller.clientWidth || y - offW.top > scroller.clientHeight))
        return null;
      var offL = eltOffset(lineSpace, true);
      return coordsChar(x - offL.left, y - offL.top);
    }
    var detectingSelectAll;
    function onContextMenu(e) {
      var pos = posFromMouse(e), scrollPos = scrollbar.scrollTop;
      if (!pos || opera) return; // Opera is difficult.
      if (posEq(sel.from, sel.to) || posLess(pos, sel.from) || !posLess(pos, sel.to))
        operation(setCursor)(pos.line, pos.ch);

      var oldCSS = input.style.cssText;
      inputDiv.style.position = "absolute";
      input.style.cssText = "position: fixed; width: 30px; height: 30px; top: " + (e.clientY - 5) +
        "px; left: " + (e.clientX - 5) + "px; z-index: 1000; background: white; " +
        "border-width: 0; outline: none; overflow: hidden; opacity: .05; filter: alpha(opacity=5);";
      focusInput();
      resetInput(true);
      // Adds "Select all" to context menu in FF
      if (posEq(sel.from, sel.to)) input.value = prevInput = " ";

      function rehide() {
        inputDiv.style.position = "relative";
        input.style.cssText = oldCSS;
        if (ie_lt9) scrollbar.scrollTop = scrollPos;
        slowPoll();

        // Try to detect the user choosing select-all 
        if (input.selectionStart != null) {
          clearTimeout(detectingSelectAll);
          var extval = input.value = " " + (posEq(sel.from, sel.to) ? "" : input.value), i = 0;
          prevInput = " ";
          input.selectionStart = 1; input.selectionEnd = extval.length;
          detectingSelectAll = setTimeout(function poll(){
            if (prevInput == " " && input.selectionStart == 0)
              operation(commands.selectAll)(instance);
            else if (i++ < 10) detectingSelectAll = setTimeout(poll, 500);
            else resetInput();
          }, 200);
        }
      }

      if (gecko) {
        e_stop(e);
        var mouseup = connect(window, "mouseup", function() {
          mouseup();
          setTimeout(rehide, 20);
        }, true);
      } else {
        setTimeout(rehide, 50);
      }
    }

    // Cursor-blinking
    function restartBlink() {
      clearInterval(blinker);
      var on = true;
      cursor.style.visibility = "";
      blinker = setInterval(function() {
        cursor.style.visibility = (on = !on) ? "" : "hidden";
      }, options.cursorBlinkRate);
    }

    var matching = {"(": ")>", ")": "(<", "[": "]>", "]": "[<", "{": "}>", "}": "{<"};
    function matchBrackets(autoclear) {
      var head = sel.inverted ? sel.from : sel.to, line = getLine(head.line), pos = head.ch - 1;
      var match = (pos >= 0 && matching[line.text.charAt(pos)]) || matching[line.text.charAt(++pos)];
      if (!match) return;
      var ch = match.charAt(0), forward = match.charAt(1) == ">", d = forward ? 1 : -1, st = line.styles;
      for (var off = pos + 1, i = 0, e = st.length; i < e; i+=2)
        if ((off -= st[i].length) <= 0) {var style = st[i+1]; break;}

      var stack = [line.text.charAt(pos)], re = /[(){}[\]]/;
      function scan(line, from, to) {
        if (!line.text) return;
        var st = line.styles, pos = forward ? 0 : line.text.length - 1, cur;
        for (var i = forward ? 0 : st.length - 2, e = forward ? st.length : -2; i != e; i += 2*d) {
          var text = st[i];
          if (st[i+1] != style) {pos += d * text.length; continue;}
          for (var j = forward ? 0 : text.length - 1, te = forward ? text.length : -1; j != te; j += d, pos+=d) {
            if (pos >= from && pos < to && re.test(cur = text.charAt(j))) {
              var match = matching[cur];
              if (match.charAt(1) == ">" == forward) stack.push(cur);
              else if (stack.pop() != match.charAt(0)) return {pos: pos, match: false};
              else if (!stack.length) return {pos: pos, match: true};
            }
          }
        }
      }
      for (var i = head.line, e = forward ? Math.min(i + 100, doc.size) : Math.max(-1, i - 100); i != e; i+=d) {
        var line = getLine(i), first = i == head.line;
        var found = scan(line, first && forward ? pos + 1 : 0, first && !forward ? pos : line.text.length);
        if (found) break;
      }
      if (!found) found = {pos: null, match: false};
      var style = found.match ? "CodeMirror-matchingbracket" : "CodeMirror-nonmatchingbracket";
      var one = markText({line: head.line, ch: pos}, {line: head.line, ch: pos+1}, style),
          two = found.pos != null && markText({line: i, ch: found.pos}, {line: i, ch: found.pos + 1}, style);
      var clear = operation(function(){one.clear(); two && two.clear();});
      if (autoclear) setTimeout(clear, 800);
      else bracketHighlighted = clear;
    }

    // Finds the line to start with when starting a parse. Tries to
    // find a line with a stateAfter, so that it can start with a
    // valid state. If that fails, it returns the line with the
    // smallest indentation, which tends to need the least context to
    // parse correctly.
    function findStartLine(n) {
      var minindent, minline;
      for (var search = n, lim = n - 40; search > lim; --search) {
        if (search == 0) return 0;
        var line = getLine(search-1);
        if (line.stateAfter) return search;
        var indented = line.indentation(options.tabSize);
        if (minline == null || minindent > indented) {
          minline = search - 1;
          minindent = indented;
        }
      }
      return minline;
    }
    function getStateBefore(n) {
      var pos = findStartLine(n), state = pos && getLine(pos-1).stateAfter;
      if (!state) state = startState(mode);
      else state = copyState(mode, state);
      doc.iter(pos, n, function(line) {
        line.process(mode, state, options.tabSize);
        line.stateAfter = (pos == n - 1 || pos % 5 == 0) ? copyState(mode, state) : null;
      });
      return state;
    }
    function highlightWorker() {
      if (frontier >= showingTo) return;
      var end = +new Date + options.workTime, state = copyState(mode, getStateBefore(frontier));
      var startFrontier = frontier;
      doc.iter(frontier, showingTo, function(line) {
        if (frontier >= showingFrom) { // Visible
          line.highlight(mode, state, options.tabSize);
          line.stateAfter = copyState(mode, state);
        } else {
          line.process(mode, state, options.tabSize);
          line.stateAfter = frontier % 5 == 0 ? copyState(mode, state) : null;
        }
        ++frontier;
        if (+new Date > end) {
          startWorker(options.workDelay);
          return true;
        }
      });
      if (showingTo > startFrontier && frontier >= showingFrom)
        operation(function() {changes.push({from: startFrontier, to: frontier});})();
    }
    function startWorker(time) {
      if (frontier < showingTo)
        highlight.set(time, highlightWorker);
    }

    // Operations are used to wrap changes in such a way that each
    // change won't have to update the cursor and display (which would
    // be awkward, slow, and error-prone), but instead updates are
    // batched and then all combined and executed at once.
    function startOperation() {
      updateInput = userSelChange = textChanged = null;
      changes = []; selectionChanged = false; callbacks = [];
    }
    function endOperation() {
      if (updateMaxLine) computeMaxLength();
      if (maxLineChanged && !options.lineWrapping) {
        var cursorWidth = widthForcer.offsetWidth, left = measureLine(maxLine, maxLine.text.length).left;
        if (!ie_lt8) {
          widthForcer.style.left = left + "px";
          lineSpace.style.minWidth = (left + cursorWidth) + "px";
        }
        maxLineChanged = false;
      }
      var newScrollPos, updated;
      if (selectionChanged) {
        var coords = calculateCursorCoords();
        newScrollPos = calculateScrollPos(coords.x, coords.y, coords.x, coords.yBot);
      }
      if (changes.length || newScrollPos && newScrollPos.scrollTop != null)
        updated = updateDisplay(changes, true, newScrollPos && newScrollPos.scrollTop);
      if (!updated) {
        if (selectionChanged) updateSelection();
        if (gutterDirty) updateGutter();
      }
      if (newScrollPos) scrollCursorIntoView();
      if (selectionChanged) restartBlink();

      if (focused && (updateInput === true || (updateInput !== false && selectionChanged)))
        resetInput(userSelChange);

      if (selectionChanged && options.matchBrackets)
        setTimeout(operation(function() {
          if (bracketHighlighted) {bracketHighlighted(); bracketHighlighted = null;}
          if (posEq(sel.from, sel.to)) matchBrackets(false);
        }), 20);
      var sc = selectionChanged, cbs = callbacks; // these can be reset by callbacks
      if (textChanged && options.onChange && instance)
        options.onChange(instance, textChanged);
      if (sc && options.onCursorActivity)
        options.onCursorActivity(instance);
      for (var i = 0; i < cbs.length; ++i) cbs[i](instance);
      if (updated && options.onUpdate) options.onUpdate(instance);
    }
    var nestedOperation = 0;
    function operation(f) {
      return function() {
        if (!nestedOperation++) startOperation();
        try {var result = f.apply(this, arguments);}
        finally {if (!--nestedOperation) endOperation();}
        return result;
      };
    }

    function compoundChange(f) {
      history.startCompound();
      try { return f(); } finally { history.endCompound(); }
    }

    for (var ext in extensions)
      if (extensions.propertyIsEnumerable(ext) &&
          !instance.propertyIsEnumerable(ext))
        instance[ext] = extensions[ext];
    for (var i = 0; i < initHooks.length; ++i) initHooks[i](instance);
    return instance;
  } // (end of function CodeMirror)

  // The default configuration options.
  CodeMirror.defaults = {
    value: "",
    mode: null,
    theme: "default",
    indentUnit: 2,
    indentWithTabs: false,
    smartIndent: true,
    tabSize: 4,
    keyMap: "default",
    extraKeys: null,
    electricChars: true,
    autoClearEmptyLines: false,
    onKeyEvent: null,
    onDragEvent: null,
    lineWrapping: false,
    lineNumbers: false,
    gutter: false,
    fixedGutter: false,
    firstLineNumber: 1,
    readOnly: false,
    dragDrop: true,
    onChange: null,
    onCursorActivity: null,
    onViewportChange: null,
    onGutterClick: null,
    onUpdate: null,
    onFocus: null, onBlur: null, onScroll: null,
    matchBrackets: false,
    cursorBlinkRate: 530,
    workTime: 100,
    workDelay: 200,
    pollInterval: 100,
    undoDepth: 40,
    tabindex: null,
    autofocus: null,
    lineNumberFormatter: function(integer) { return integer; }
  };

  var ios = /AppleWebKit/.test(navigator.userAgent) && /Mobile\/\w+/.test(navigator.userAgent);
  var mac = ios || /Mac/.test(navigator.platform);
  var win = /Win/.test(navigator.platform);

  // Known modes, by name and by MIME
  var modes = CodeMirror.modes = {}, mimeModes = CodeMirror.mimeModes = {};
  CodeMirror.defineMode = function(name, mode) {
    if (!CodeMirror.defaults.mode && name != "null") CodeMirror.defaults.mode = name;
    if (arguments.length > 2) {
      mode.dependencies = [];
      for (var i = 2; i < arguments.length; ++i) mode.dependencies.push(arguments[i]);
    }
    modes[name] = mode;
  };
  CodeMirror.defineMIME = function(mime, spec) {
    mimeModes[mime] = spec;
  };
  CodeMirror.resolveMode = function(spec) {
    if (typeof spec == "string" && mimeModes.hasOwnProperty(spec))
      spec = mimeModes[spec];
    else if (typeof spec == "string" && /^[\w\-]+\/[\w\-]+\+xml$/.test(spec))
      return CodeMirror.resolveMode("application/xml");
    if (typeof spec == "string") return {name: spec};
    else return spec || {name: "null"};
  };
  CodeMirror.getMode = function(options, spec) {
    var spec = CodeMirror.resolveMode(spec);
    var mfactory = modes[spec.name];
    if (!mfactory) return CodeMirror.getMode(options, "text/plain");
    var modeObj = mfactory(options, spec);
    if (modeExtensions.hasOwnProperty(spec.name)) {
      var exts = modeExtensions[spec.name];
      for (var prop in exts) if (exts.hasOwnProperty(prop)) modeObj[prop] = exts[prop];
    }
    modeObj.name = spec.name;
    return modeObj;
  };
  CodeMirror.listModes = function() {
    var list = [];
    for (var m in modes)
      if (modes.propertyIsEnumerable(m)) list.push(m);
    return list;
  };
  CodeMirror.listMIMEs = function() {
    var list = [];
    for (var m in mimeModes)
      if (mimeModes.propertyIsEnumerable(m)) list.push({mime: m, mode: mimeModes[m]});
    return list;
  };

  var extensions = CodeMirror.extensions = {};
  CodeMirror.defineExtension = function(name, func) {
    extensions[name] = func;
  };

  var initHooks = [];
  CodeMirror.defineInitHook = function(f) {initHooks.push(f);};

  var modeExtensions = CodeMirror.modeExtensions = {};
  CodeMirror.extendMode = function(mode, properties) {
    var exts = modeExtensions.hasOwnProperty(mode) ? modeExtensions[mode] : (modeExtensions[mode] = {});
    for (var prop in properties) if (properties.hasOwnProperty(prop))
      exts[prop] = properties[prop];
  };

  var commands = CodeMirror.commands = {
    selectAll: function(cm) {cm.setSelection({line: 0, ch: 0}, {line: cm.lineCount() - 1});},
    killLine: function(cm) {
      var from = cm.getCursor(true), to = cm.getCursor(false), sel = !posEq(from, to);
      if (!sel && cm.getLine(from.line).length == from.ch) cm.replaceRange("", from, {line: from.line + 1, ch: 0});
      else cm.replaceRange("", from, sel ? to : {line: from.line});
    },
    deleteLine: function(cm) {var l = cm.getCursor().line; cm.replaceRange("", {line: l, ch: 0}, {line: l});},
    undo: function(cm) {cm.undo();},
    redo: function(cm) {cm.redo();},
    goDocStart: function(cm) {cm.setCursor(0, 0, true);},
    goDocEnd: function(cm) {cm.setSelection({line: cm.lineCount() - 1}, null, true);},
    goLineStart: function(cm) {cm.setCursor(cm.getCursor().line, 0, true);},
    goLineStartSmart: function(cm) {
      var cur = cm.getCursor();
      var text = cm.getLine(cur.line), firstNonWS = Math.max(0, text.search(/\S/));
      cm.setCursor(cur.line, cur.ch <= firstNonWS && cur.ch ? 0 : firstNonWS, true);
    },
    goLineEnd: function(cm) {cm.setSelection({line: cm.getCursor().line}, null, true);},
    goLineUp: function(cm) {cm.moveV(-1, "line");},
    goLineDown: function(cm) {cm.moveV(1, "line");},
    goPageUp: function(cm) {cm.moveV(-1, "page");},
    goPageDown: function(cm) {cm.moveV(1, "page");},
    goCharLeft: function(cm) {cm.moveH(-1, "char");},
    goCharRight: function(cm) {cm.moveH(1, "char");},
    goColumnLeft: function(cm) {cm.moveH(-1, "column");},
    goColumnRight: function(cm) {cm.moveH(1, "column");},
    goWordLeft: function(cm) {cm.moveH(-1, "word");},
    goWordRight: function(cm) {cm.moveH(1, "word");},
    delCharLeft: function(cm) {cm.deleteH(-1, "char");},
    delCharRight: function(cm) {cm.deleteH(1, "char");},
    delWordLeft: function(cm) {cm.deleteH(-1, "word");},
    delWordRight: function(cm) {cm.deleteH(1, "word");},
    indentAuto: function(cm) {cm.indentSelection("smart");},
    indentMore: function(cm) {cm.indentSelection("add");},
    indentLess: function(cm) {cm.indentSelection("subtract");},
    insertTab: function(cm) {cm.replaceSelection("\t", "end");},
    defaultTab: function(cm) {
      if (cm.somethingSelected()) cm.indentSelection("add");
      else cm.replaceSelection("\t", "end");
    },
    transposeChars: function(cm) {
      var cur = cm.getCursor(), line = cm.getLine(cur.line);
      if (cur.ch > 0 && cur.ch < line.length - 1)
        cm.replaceRange(line.charAt(cur.ch) + line.charAt(cur.ch - 1),
                        {line: cur.line, ch: cur.ch - 1}, {line: cur.line, ch: cur.ch + 1});
    },
    newlineAndIndent: function(cm) {
      cm.replaceSelection("\n", "end");
      cm.indentLine(cm.getCursor().line);
    },
    toggleOverwrite: function(cm) {cm.toggleOverwrite();}
  };

  var keyMap = CodeMirror.keyMap = {};
  keyMap.basic = {
    "Left": "goCharLeft", "Right": "goCharRight", "Up": "goLineUp", "Down": "goLineDown",
    "End": "goLineEnd", "Home": "goLineStartSmart", "PageUp": "goPageUp", "PageDown": "goPageDown",
    "Delete": "delCharRight", "Backspace": "delCharLeft", "Tab": "defaultTab", "Shift-Tab": "indentAuto",
    "Enter": "newlineAndIndent", "Insert": "toggleOverwrite"
  };
  // Note that the save and find-related commands aren't defined by
  // default. Unknown commands are simply ignored.
  keyMap.pcDefault = {
    "Ctrl-A": "selectAll", "Ctrl-D": "deleteLine", "Ctrl-Z": "undo", "Shift-Ctrl-Z": "redo", "Ctrl-Y": "redo",
    "Ctrl-Home": "goDocStart", "Alt-Up": "goDocStart", "Ctrl-End": "goDocEnd", "Ctrl-Down": "goDocEnd",
    "Ctrl-Left": "goWordLeft", "Ctrl-Right": "goWordRight", "Alt-Left": "goLineStart", "Alt-Right": "goLineEnd",
    "Ctrl-Backspace": "delWordLeft", "Ctrl-Delete": "delWordRight", "Ctrl-S": "save", "Ctrl-F": "find",
    "Ctrl-G": "findNext", "Shift-Ctrl-G": "findPrev", "Shift-Ctrl-F": "replace", "Shift-Ctrl-R": "replaceAll",
    "Ctrl-[": "indentLess", "Ctrl-]": "indentMore",
    fallthrough: "basic"
  };
  keyMap.macDefault = {
    "Cmd-A": "selectAll", "Cmd-D": "deleteLine", "Cmd-Z": "undo", "Shift-Cmd-Z": "redo", "Cmd-Y": "redo",
    "Cmd-Up": "goDocStart", "Cmd-End": "goDocEnd", "Cmd-Down": "goDocEnd", "Alt-Left": "goWordLeft",
    "Alt-Right": "goWordRight", "Cmd-Left": "goLineStart", "Cmd-Right": "goLineEnd", "Alt-Backspace": "delWordLeft",
    "Ctrl-Alt-Backspace": "delWordRight", "Alt-Delete": "delWordRight", "Cmd-S": "save", "Cmd-F": "find",
    "Cmd-G": "findNext", "Shift-Cmd-G": "findPrev", "Cmd-Alt-F": "replace", "Shift-Cmd-Alt-F": "replaceAll",
    "Cmd-[": "indentLess", "Cmd-]": "indentMore",
    fallthrough: ["basic", "emacsy"]
  };
  keyMap["default"] = mac ? keyMap.macDefault : keyMap.pcDefault;
  keyMap.emacsy = {
    "Ctrl-F": "goCharRight", "Ctrl-B": "goCharLeft", "Ctrl-P": "goLineUp", "Ctrl-N": "goLineDown",
    "Alt-F": "goWordRight", "Alt-B": "goWordLeft", "Ctrl-A": "goLineStart", "Ctrl-E": "goLineEnd",
    "Ctrl-V": "goPageUp", "Shift-Ctrl-V": "goPageDown", "Ctrl-D": "delCharRight", "Ctrl-H": "delCharLeft",
    "Alt-D": "delWordRight", "Alt-Backspace": "delWordLeft", "Ctrl-K": "killLine", "Ctrl-T": "transposeChars"
  };

  function getKeyMap(val) {
    if (typeof val == "string") return keyMap[val];
    else return val;
  }
  function lookupKey(name, extraMap, map, handle, stop) {
    function lookup(map) {
      map = getKeyMap(map);
      var found = map[name];
      if (found === false) {
        if (stop) stop();
        return true;
      }
      if (found != null && handle(found)) return true;
      if (map.nofallthrough) {
        if (stop) stop();
        return true;
      }
      var fallthrough = map.fallthrough;
      if (fallthrough == null) return false;
      if (Object.prototype.toString.call(fallthrough) != "[object Array]")
        return lookup(fallthrough);
      for (var i = 0, e = fallthrough.length; i < e; ++i) {
        if (lookup(fallthrough[i])) return true;
      }
      return false;
    }
    if (extraMap && lookup(extraMap)) return true;
    return lookup(map);
  }
  function isModifierKey(event) {
    var name = keyNames[e_prop(event, "keyCode")];
    return name == "Ctrl" || name == "Alt" || name == "Shift" || name == "Mod";
  }
  CodeMirror.isModifierKey = isModifierKey;

  CodeMirror.fromTextArea = function(textarea, options) {
    if (!options) options = {};
    options.value = textarea.value;
    if (!options.tabindex && textarea.tabindex)
      options.tabindex = textarea.tabindex;
    // Set autofocus to true if this textarea is focused, or if it has
    // autofocus and no other element is focused.
    if (options.autofocus == null) {
      var hasFocus = document.body;
      // doc.activeElement occasionally throws on IE
      try { hasFocus = document.activeElement; } catch(e) {}
      options.autofocus = hasFocus == textarea ||
        textarea.getAttribute("autofocus") != null && hasFocus == document.body;
    }

    function save() {textarea.value = instance.getValue();}
    if (textarea.form) {
      // Deplorable hack to make the submit method do the right thing.
      var rmSubmit = connect(textarea.form, "submit", save, true);
      if (typeof textarea.form.submit == "function") {
        var realSubmit = textarea.form.submit;
        textarea.form.submit = function wrappedSubmit() {
          save();
          textarea.form.submit = realSubmit;
          textarea.form.submit();
          textarea.form.submit = wrappedSubmit;
        };
      }
    }

    textarea.style.display = "none";
    var instance = CodeMirror(function(node) {
      textarea.parentNode.insertBefore(node, textarea.nextSibling);
    }, options);
    instance.save = save;
    instance.getTextArea = function() { return textarea; };
    instance.toTextArea = function() {
      save();
      textarea.parentNode.removeChild(instance.getWrapperElement());
      textarea.style.display = "";
      if (textarea.form) {
        rmSubmit();
        if (typeof textarea.form.submit == "function")
          textarea.form.submit = realSubmit;
      }
    };
    return instance;
  };

  var gecko = /gecko\/\d{7}/i.test(navigator.userAgent);
  var ie = /MSIE \d/.test(navigator.userAgent);
  var ie_lt8 = /MSIE [1-7]\b/.test(navigator.userAgent);
  var ie_lt9 = /MSIE [1-8]\b/.test(navigator.userAgent);
  var quirksMode = ie && document.documentMode == 5;
  var webkit = /WebKit\//.test(navigator.userAgent);
  var chrome = /Chrome\//.test(navigator.userAgent);
  var opera = /Opera\//.test(navigator.userAgent);
  var safari = /Apple Computer/.test(navigator.vendor);
  var khtml = /KHTML\//.test(navigator.userAgent);
  var mac_geLion = /Mac OS X 10\D([7-9]|\d\d)\D/.test(navigator.userAgent);

  // Utility functions for working with state. Exported because modes
  // sometimes need to do this.
  function copyState(mode, state) {
    if (state === true) return state;
    if (mode.copyState) return mode.copyState(state);
    var nstate = {};
    for (var n in state) {
      var val = state[n];
      if (val instanceof Array) val = val.concat([]);
      nstate[n] = val;
    }
    return nstate;
  }
  CodeMirror.copyState = copyState;
  function startState(mode, a1, a2) {
    return mode.startState ? mode.startState(a1, a2) : true;
  }
  CodeMirror.startState = startState;
  CodeMirror.innerMode = function(mode, state) {
    while (mode.innerMode) {
      var info = mode.innerMode(state);
      state = info.state;
      mode = info.mode;
    }
    return info || {mode: mode, state: state};
  };

  // The character stream used by a mode's parser.
  function StringStream(string, tabSize) {
    this.pos = this.start = 0;
    this.string = string;
    this.tabSize = tabSize || 8;
  }
  StringStream.prototype = {
    eol: function() {return this.pos >= this.string.length;},
    sol: function() {return this.pos == 0;},
    peek: function() {return this.string.charAt(this.pos) || undefined;},
    next: function() {
      if (this.pos < this.string.length)
        return this.string.charAt(this.pos++);
    },
    eat: function(match) {
      var ch = this.string.charAt(this.pos);
      if (typeof match == "string") var ok = ch == match;
      else var ok = ch && (match.test ? match.test(ch) : match(ch));
      if (ok) {++this.pos; return ch;}
    },
    eatWhile: function(match) {
      var start = this.pos;
      while (this.eat(match)){}
      return this.pos > start;
    },
    eatSpace: function() {
      var start = this.pos;
      while (/[\s\u00a0]/.test(this.string.charAt(this.pos))) ++this.pos;
      return this.pos > start;
    },
    skipToEnd: function() {this.pos = this.string.length;},
    skipTo: function(ch) {
      var found = this.string.indexOf(ch, this.pos);
      if (found > -1) {this.pos = found; return true;}
    },
    backUp: function(n) {this.pos -= n;},
    column: function() {return countColumn(this.string, this.start, this.tabSize);},
    indentation: function() {return countColumn(this.string, null, this.tabSize);},
    match: function(pattern, consume, caseInsensitive) {
      if (typeof pattern == "string") {
        var cased = function(str) {return caseInsensitive ? str.toLowerCase() : str;};
        if (cased(this.string).indexOf(cased(pattern), this.pos) == this.pos) {
          if (consume !== false) this.pos += pattern.length;
          return true;
        }
      } else {
        var match = this.string.slice(this.pos).match(pattern);
        if (match && match.index > 0) return null;
        if (match && consume !== false) this.pos += match[0].length;
        return match;
      }
    },
    current: function(){return this.string.slice(this.start, this.pos);}
  };
  CodeMirror.StringStream = StringStream;

  function MarkedSpan(from, to, marker) {
    this.from = from; this.to = to; this.marker = marker;
  }

  function getMarkedSpanFor(spans, marker) {
    if (spans) for (var i = 0; i < spans.length; ++i) {
      var span = spans[i];
      if (span.marker == marker) return span;
    }
  }

  function removeMarkedSpan(spans, span) {
    var r;
    for (var i = 0; i < spans.length; ++i)
      if (spans[i] != span) (r || (r = [])).push(spans[i]);
    return r;
  }

  function markedSpansBefore(old, startCh, endCh) {
    if (old) for (var i = 0, nw; i < old.length; ++i) {
      var span = old[i], marker = span.marker;
      var startsBefore = span.from == null || (marker.inclusiveLeft ? span.from <= startCh : span.from < startCh);
      if (startsBefore || marker.type == "bookmark" && span.from == startCh && span.from != endCh) {
        var endsAfter = span.to == null || (marker.inclusiveRight ? span.to >= startCh : span.to > startCh);
        (nw || (nw = [])).push({from: span.from,
                                to: endsAfter ? null : span.to,
                                marker: marker});
      }
    }
    return nw;
  }

  function markedSpansAfter(old, endCh) {
    if (old) for (var i = 0, nw; i < old.length; ++i) {
      var span = old[i], marker = span.marker;
      var endsAfter = span.to == null || (marker.inclusiveRight ? span.to >= endCh : span.to > endCh);
      if (endsAfter || marker.type == "bookmark" && span.from == endCh) {
        var startsBefore = span.from == null || (marker.inclusiveLeft ? span.from <= endCh : span.from < endCh);
        (nw || (nw = [])).push({from: startsBefore ? null : span.from - endCh,
                                to: span.to == null ? null : span.to - endCh,
                                marker: marker});
      }
    }
    return nw;
  }

  function updateMarkedSpans(oldFirst, oldLast, startCh, endCh, newText) {
    if (!oldFirst && !oldLast) return newText;
    // Get the spans that 'stick out' on both sides
    var first = markedSpansBefore(oldFirst, startCh);
    var last = markedSpansAfter(oldLast, endCh);

    // Next, merge those two ends
    var sameLine = newText.length == 1, offset = lst(newText).length + (sameLine ? startCh : 0);
    if (first) {
      // Fix up .to properties of first
      for (var i = 0; i < first.length; ++i) {
        var span = first[i];
        if (span.to == null) {
          var found = getMarkedSpanFor(last, span.marker);
          if (!found) span.to = startCh;
          else if (sameLine) span.to = found.to == null ? null : found.to + offset;
        }
      }
    }
    if (last) {
      // Fix up .from in last (or move them into first in case of sameLine)
      for (var i = 0; i < last.length; ++i) {
        var span = last[i];
        if (span.to != null) span.to += offset;
        if (span.from == null) {
          var found = getMarkedSpanFor(first, span.marker);
          if (!found) {
            span.from = offset;
            if (sameLine) (first || (first = [])).push(span);
          }
        } else {
          span.from += offset;
          if (sameLine) (first || (first = [])).push(span);
        }
      }
    }

    var newMarkers = [newHL(newText[0], first)];
    if (!sameLine) {
      // Fill gap with whole-line-spans
      var gap = newText.length - 2, gapMarkers;
      if (gap > 0 && first)
        for (var i = 0; i < first.length; ++i)
          if (first[i].to == null)
            (gapMarkers || (gapMarkers = [])).push({from: null, to: null, marker: first[i].marker});
      for (var i = 0; i < gap; ++i)
        newMarkers.push(newHL(newText[i+1], gapMarkers));
      newMarkers.push(newHL(lst(newText), last));
    }
    return newMarkers;
  }

  // hl stands for history-line, a data structure that can be either a
  // string (line without markers) or a {text, markedSpans} object.
  function hlText(val) { return typeof val == "string" ? val : val.text; }
  function hlSpans(val) {
    if (typeof val == "string") return null;
    var spans = val.markedSpans, out = null;
    for (var i = 0; i < spans.length; ++i) {
      if (spans[i].marker.explicitlyCleared) { if (!out) out = spans.slice(0, i); }
      else if (out) out.push(spans[i]);
    }
    return !out ? spans : out.length ? out : null;
  }
  function newHL(text, spans) { return spans ? {text: text, markedSpans: spans} : text; }

  function detachMarkedSpans(line) {
    var spans = line.markedSpans;
    if (!spans) return;
    for (var i = 0; i < spans.length; ++i) {
      var lines = spans[i].marker.lines;
      var ix = indexOf(lines, line);
      lines.splice(ix, 1);
    }
    line.markedSpans = null;
  }

  function attachMarkedSpans(line, spans) {
    if (!spans) return;
    for (var i = 0; i < spans.length; ++i)
      var marker = spans[i].marker.lines.push(line);
    line.markedSpans = spans;
  }

  // When measuring the position of the end of a line, different
  // browsers require different approaches. If an empty span is added,
  // many browsers report bogus offsets. Of those, some (Webkit,
  // recent IE) will accept a space without moving the whole span to
  // the next line when wrapping it, others work with a zero-width
  // space.
  var eolSpanContent = " ";
  if (gecko || (ie && !ie_lt8)) eolSpanContent = "\u200b";
  else if (opera) eolSpanContent = "";

  // Line objects. These hold state related to a line, including
  // highlighting info (the styles array).
  function Line(text, markedSpans) {
    this.text = text;
    this.height = 1;
    attachMarkedSpans(this, markedSpans);
  }
  Line.prototype = {
    update: function(text, markedSpans) {
      this.text = text;
      this.stateAfter = this.styles = null;
      detachMarkedSpans(this);
      attachMarkedSpans(this, markedSpans);
    },
    // Run the given mode's parser over a line, update the styles
    // array, which contains alternating fragments of text and CSS
    // classes.
    highlight: function(mode, state, tabSize) {
      var stream = new StringStream(this.text, tabSize), st = this.styles || (this.styles = []);
      var pos = st.length = 0;
      if (this.text == "" && mode.blankLine) mode.blankLine(state);
      while (!stream.eol()) {
        var style = mode.token(stream, state), substr = stream.current();
        stream.start = stream.pos;
        if (pos && st[pos-1] == style) {
          st[pos-2] += substr;
        } else if (substr) {
          st[pos++] = substr; st[pos++] = style;
        }
        // Give up when line is ridiculously long
        if (stream.pos > 5000) {
          st[pos++] = this.text.slice(stream.pos); st[pos++] = null;
          break;
        }
      }
    },
    process: function(mode, state, tabSize) {
      var stream = new StringStream(this.text, tabSize);
      if (this.text == "" && mode.blankLine) mode.blankLine(state);
      while (!stream.eol() && stream.pos <= 5000) {
        mode.token(stream, state);
        stream.start = stream.pos;
      }
    },
    // Fetch the parser token for a given character. Useful for hacks
    // that want to inspect the mode state (say, for completion).
    getTokenAt: function(mode, state, tabSize, ch) {
      var txt = this.text, stream = new StringStream(txt, tabSize);
      while (stream.pos < ch && !stream.eol()) {
        stream.start = stream.pos;
        var style = mode.token(stream, state);
      }
      return {start: stream.start,
              end: stream.pos,
              string: stream.current(),
              className: style || null,
              state: state};
    },
    indentation: function(tabSize) {return countColumn(this.text, null, tabSize);},
    // Produces an HTML fragment for the line, taking selection,
    // marking, and highlighting into account.
    getContent: function(tabSize, wrapAt, compensateForWrapping) {
      var first = true, col = 0, specials = /[\t\u0000-\u0019\u200b\u2028\u2029\uFEFF]/g;
      var pre = elt("pre");
      function span_(html, text, style) {
        if (!text) return;
        // Work around a bug where, in some compat modes, IE ignores leading spaces
        if (first && ie && text.charAt(0) == " ") text = "\u00a0" + text.slice(1);
        first = false;
        if (!specials.test(text)) {
          col += text.length;
          var content = document.createTextNode(text);
        } else {
          var content = document.createDocumentFragment(), pos = 0;
          while (true) {
            specials.lastIndex = pos;
            var m = specials.exec(text);
            var skipped = m ? m.index - pos : text.length - pos;
            if (skipped) {
              content.appendChild(document.createTextNode(text.slice(pos, pos + skipped)));
              col += skipped;
            }
            if (!m) break;
            pos += skipped + 1;
            if (m[0] == "\t") {
              var tabWidth = tabSize - col % tabSize;
              content.appendChild(elt("span", spaceStr(tabWidth), "cm-tab"));
              col += tabWidth;
            } else {
              var token = elt("span", "\u2022", "cm-invalidchar");
              token.title = "\\u" + m[0].charCodeAt(0).toString(16);
              content.appendChild(token);
              col += 1;
            }
          }
        }
        if (style) html.appendChild(elt("span", [content], style));
        else html.appendChild(content);
      }
      var span = span_;
      if (wrapAt != null) {
        var outPos = 0, anchor = pre.anchor = elt("span");
        span = function(html, text, style) {
          var l = text.length;
          if (wrapAt >= outPos && wrapAt < outPos + l) {
            var cut = wrapAt - outPos;
            if (cut) {
              span_(html, text.slice(0, cut), style);
              // See comment at the definition of spanAffectsWrapping
              if (compensateForWrapping) {
                var view = text.slice(cut - 1, cut + 1);
                if (spanAffectsWrapping.test(view)) html.appendChild(elt("wbr"));
                else if (!ie_lt8 && /\w\w/.test(view)) html.appendChild(document.createTextNode("\u200d"));
              }
            }
            html.appendChild(anchor);
            span_(anchor, opera ? text.slice(cut, cut + 1) : text.slice(cut), style);
            if (opera) span_(html, text.slice(cut + 1), style);
            wrapAt--;
            outPos += l;
          } else {
            outPos += l;
            span_(html, text, style);
            if (outPos == wrapAt && outPos == len) {
              setTextContent(anchor, eolSpanContent);
              html.appendChild(anchor);
            }
            // Stop outputting HTML when gone sufficiently far beyond measure
            else if (outPos > wrapAt + 10 && /\s/.test(text)) span = function(){};
          }
        };
      }

      var st = this.styles, allText = this.text, marked = this.markedSpans;
      var len = allText.length;
      function styleToClass(style) {
        if (!style) return null;
        return "cm-" + style.replace(/ +/g, " cm-");
      }
      if (!allText && wrapAt == null) {
        span(pre, " ");
      } else if (!marked || !marked.length) {
        for (var i = 0, ch = 0; ch < len; i+=2) {
          var str = st[i], style = st[i+1], l = str.length;
          if (ch + l > len) str = str.slice(0, len - ch);
          ch += l;
          span(pre, str, styleToClass(style));
        }
      } else {
        marked.sort(function(a, b) { return a.from - b.from; });
        var pos = 0, i = 0, text = "", style, sg = 0;
        var nextChange = marked[0].from || 0, marks = [], markpos = 0;
        var advanceMarks = function() {
          var m;
          while (markpos < marked.length &&
                 ((m = marked[markpos]).from == pos || m.from == null)) {
            if (m.marker.type == "range") marks.push(m);
            ++markpos;
          }
          nextChange = markpos < marked.length ? marked[markpos].from : Infinity;
          for (var i = 0; i < marks.length; ++i) {
            var to = marks[i].to;
            if (to == null) to = Infinity;
            if (to == pos) marks.splice(i--, 1);
            else nextChange = Math.min(to, nextChange);
          }
        };
        var m = 0;
        while (pos < len) {
          if (nextChange == pos) advanceMarks();
          var upto = Math.min(len, nextChange);
          while (true) {
            if (text) {
              var end = pos + text.length;
              var appliedStyle = style;
              for (var j = 0; j < marks.length; ++j) {
                var mark = marks[j];
                appliedStyle = (appliedStyle ? appliedStyle + " " : "") + mark.marker.style;
                if (mark.marker.endStyle && mark.to === Math.min(end, upto)) appliedStyle += " " + mark.marker.endStyle;
                if (mark.marker.startStyle && mark.from === pos) appliedStyle += " " + mark.marker.startStyle;
              }
              span(pre, end > upto ? text.slice(0, upto - pos) : text, appliedStyle);
              if (end >= upto) {text = text.slice(upto - pos); pos = upto; break;}
              pos = end;
            }
            text = st[i++]; style = styleToClass(st[i++]);
          }
        }
      }
      return pre;
    },
    cleanUp: function() {
      this.parent = null;
      detachMarkedSpans(this);
    }
  };

  // Data structure that holds the sequence of lines.
  function LeafChunk(lines) {
    this.lines = lines;
    this.parent = null;
    for (var i = 0, e = lines.length, height = 0; i < e; ++i) {
      lines[i].parent = this;
      height += lines[i].height;
    }
    this.height = height;
  }
  LeafChunk.prototype = {
    chunkSize: function() { return this.lines.length; },
    remove: function(at, n, callbacks) {
      for (var i = at, e = at + n; i < e; ++i) {
        var line = this.lines[i];
        this.height -= line.height;
        line.cleanUp();
        if (line.handlers)
          for (var j = 0; j < line.handlers.length; ++j) callbacks.push(line.handlers[j]);
      }
      this.lines.splice(at, n);
    },
    collapse: function(lines) {
      lines.splice.apply(lines, [lines.length, 0].concat(this.lines));
    },
    insertHeight: function(at, lines, height) {
      this.height += height;
      this.lines = this.lines.slice(0, at).concat(lines).concat(this.lines.slice(at));
      for (var i = 0, e = lines.length; i < e; ++i) lines[i].parent = this;
    },
    iterN: function(at, n, op) {
      for (var e = at + n; at < e; ++at)
        if (op(this.lines[at])) return true;
    }
  };
  function BranchChunk(children) {
    this.children = children;
    var size = 0, height = 0;
    for (var i = 0, e = children.length; i < e; ++i) {
      var ch = children[i];
      size += ch.chunkSize(); height += ch.height;
      ch.parent = this;
    }
    this.size = size;
    this.height = height;
    this.parent = null;
  }
  BranchChunk.prototype = {
    chunkSize: function() { return this.size; },
    remove: function(at, n, callbacks) {
      this.size -= n;
      for (var i = 0; i < this.children.length; ++i) {
        var child = this.children[i], sz = child.chunkSize();
        if (at < sz) {
          var rm = Math.min(n, sz - at), oldHeight = child.height;
          child.remove(at, rm, callbacks);
          this.height -= oldHeight - child.height;
          if (sz == rm) { this.children.splice(i--, 1); child.parent = null; }
          if ((n -= rm) == 0) break;
          at = 0;
        } else at -= sz;
      }
      if (this.size - n < 25) {
        var lines = [];
        this.collapse(lines);
        this.children = [new LeafChunk(lines)];
        this.children[0].parent = this;
      }
    },
    collapse: function(lines) {
      for (var i = 0, e = this.children.length; i < e; ++i) this.children[i].collapse(lines);
    },
    insert: function(at, lines) {
      var height = 0;
      for (var i = 0, e = lines.length; i < e; ++i) height += lines[i].height;
      this.insertHeight(at, lines, height);
    },
    insertHeight: function(at, lines, height) {
      this.size += lines.length;
      this.height += height;
      for (var i = 0, e = this.children.length; i < e; ++i) {
        var child = this.children[i], sz = child.chunkSize();
        if (at <= sz) {
          child.insertHeight(at, lines, height);
          if (child.lines && child.lines.length > 50) {
            while (child.lines.length > 50) {
              var spilled = child.lines.splice(child.lines.length - 25, 25);
              var newleaf = new LeafChunk(spilled);
              child.height -= newleaf.height;
              this.children.splice(i + 1, 0, newleaf);
              newleaf.parent = this;
            }
            this.maybeSpill();
          }
          break;
        }
        at -= sz;
      }
    },
    maybeSpill: function() {
      if (this.children.length <= 10) return;
      var me = this;
      do {
        var spilled = me.children.splice(me.children.length - 5, 5);
        var sibling = new BranchChunk(spilled);
        if (!me.parent) { // Become the parent node
          var copy = new BranchChunk(me.children);
          copy.parent = me;
          me.children = [copy, sibling];
          me = copy;
        } else {
          me.size -= sibling.size;
          me.height -= sibling.height;
          var myIndex = indexOf(me.parent.children, me);
          me.parent.children.splice(myIndex + 1, 0, sibling);
        }
        sibling.parent = me.parent;
      } while (me.children.length > 10);
      me.parent.maybeSpill();
    },
    iter: function(from, to, op) { this.iterN(from, to - from, op); },
    iterN: function(at, n, op) {
      for (var i = 0, e = this.children.length; i < e; ++i) {
        var child = this.children[i], sz = child.chunkSize();
        if (at < sz) {
          var used = Math.min(n, sz - at);
          if (child.iterN(at, used, op)) return true;
          if ((n -= used) == 0) break;
          at = 0;
        } else at -= sz;
      }
    }
  };

  function getLineAt(chunk, n) {
    while (!chunk.lines) {
      for (var i = 0;; ++i) {
        var child = chunk.children[i], sz = child.chunkSize();
        if (n < sz) { chunk = child; break; }
        n -= sz;
      }
    }
    return chunk.lines[n];
  }
  function lineNo(line) {
    if (line.parent == null) return null;
    var cur = line.parent, no = indexOf(cur.lines, line);
    for (var chunk = cur.parent; chunk; cur = chunk, chunk = chunk.parent) {
      for (var i = 0, e = chunk.children.length; ; ++i) {
        if (chunk.children[i] == cur) break;
        no += chunk.children[i].chunkSize();
      }
    }
    return no;
  }
  function lineAtHeight(chunk, h) {
    var n = 0;
    outer: do {
      for (var i = 0, e = chunk.children.length; i < e; ++i) {
        var child = chunk.children[i], ch = child.height;
        if (h < ch) { chunk = child; continue outer; }
        h -= ch;
        n += child.chunkSize();
      }
      return n;
    } while (!chunk.lines);
    for (var i = 0, e = chunk.lines.length; i < e; ++i) {
      var line = chunk.lines[i], lh = line.height;
      if (h < lh) break;
      h -= lh;
    }
    return n + i;
  }
  function heightAtLine(chunk, n) {
    var h = 0;
    outer: do {
      for (var i = 0, e = chunk.children.length; i < e; ++i) {
        var child = chunk.children[i], sz = child.chunkSize();
        if (n < sz) { chunk = child; continue outer; }
        n -= sz;
        h += child.height;
      }
      return h;
    } while (!chunk.lines);
    for (var i = 0; i < n; ++i) h += chunk.lines[i].height;
    return h;
  }

  // The history object 'chunks' changes that are made close together
  // and at almost the same time into bigger undoable units.
  function History() {
    this.time = 0;
    this.done = []; this.undone = [];
    this.compound = 0;
    this.closed = false;
  }
  History.prototype = {
    addChange: function(start, added, old) {
      this.undone.length = 0;
      var time = +new Date, cur = lst(this.done), last = cur && lst(cur);
      var dtime = time - this.time;

      if (cur && !this.closed && this.compound) {
        cur.push({start: start, added: added, old: old});
      } else if (dtime > 400 || !last || this.closed ||
                 last.start > start + old.length || last.start + last.added < start) {
        this.done.push([{start: start, added: added, old: old}]);
        this.closed = false;
      } else {
        var startBefore = Math.max(0, last.start - start),
            endAfter = Math.max(0, (start + old.length) - (last.start + last.added));
        for (var i = startBefore; i > 0; --i) last.old.unshift(old[i - 1]);
        for (var i = endAfter; i > 0; --i) last.old.push(old[old.length - i]);
        if (startBefore) last.start = start;
        last.added += added - (old.length - startBefore - endAfter);
      }
      this.time = time;
    },
    startCompound: function() {
      if (!this.compound++) this.closed = true;
    },
    endCompound: function() {
      if (!--this.compound) this.closed = true;
    }
  };

  function stopMethod() {e_stop(this);}
  // Ensure an event has a stop method.
  function addStop(event) {
    if (!event.stop) event.stop = stopMethod;
    return event;
  }

  function e_preventDefault(e) {
    if (e.preventDefault) e.preventDefault();
    else e.returnValue = false;
  }
  function e_stopPropagation(e) {
    if (e.stopPropagation) e.stopPropagation();
    else e.cancelBubble = true;
  }
  function e_stop(e) {e_preventDefault(e); e_stopPropagation(e);}
  CodeMirror.e_stop = e_stop;
  CodeMirror.e_preventDefault = e_preventDefault;
  CodeMirror.e_stopPropagation = e_stopPropagation;

  function e_target(e) {return e.target || e.srcElement;}
  function e_button(e) {
    var b = e.which;
    if (b == null) {
      if (e.button & 1) b = 1;
      else if (e.button & 2) b = 3;
      else if (e.button & 4) b = 2;
    }
    if (mac && e.ctrlKey && b == 1) b = 3;
    return b;
  }

  // Allow 3rd-party code to override event properties by adding an override
  // object to an event object.
  function e_prop(e, prop) {
    var overridden = e.override && e.override.hasOwnProperty(prop);
    return overridden ? e.override[prop] : e[prop];
  }

  // Event handler registration. If disconnect is true, it'll return a
  // function that unregisters the handler.
  function connect(node, type, handler, disconnect) {
    if (typeof node.addEventListener == "function") {
      node.addEventListener(type, handler, false);
      if (disconnect) return function() {node.removeEventListener(type, handler, false);};
    } else {
      var wrapHandler = function(event) {handler(event || window.event);};
      node.attachEvent("on" + type, wrapHandler);
      if (disconnect) return function() {node.detachEvent("on" + type, wrapHandler);};
    }
  }
  CodeMirror.connect = connect;

  function Delayed() {this.id = null;}
  Delayed.prototype = {set: function(ms, f) {clearTimeout(this.id); this.id = setTimeout(f, ms);}};

  var Pass = CodeMirror.Pass = {toString: function(){return "CodeMirror.Pass";}};

  // Detect drag-and-drop
  var dragAndDrop = function() {
    // There is *some* kind of drag-and-drop support in IE6-8, but I
    // couldn't get it to work yet.
    if (ie_lt9) return false;
    var div = elt('div');
    return "draggable" in div || "dragDrop" in div;
  }();

  // Feature-detect whether newlines in textareas are converted to \r\n
  var lineSep = function () {
    var te = elt("textarea");
    te.value = "foo\nbar";
    if (te.value.indexOf("\r") > -1) return "\r\n";
    return "\n";
  }();

  // For a reason I have yet to figure out, some browsers disallow
  // word wrapping between certain characters *only* if a new inline
  // element is started between them. This makes it hard to reliably
  // measure the position of things, since that requires inserting an
  // extra span. This terribly fragile set of regexps matches the
  // character combinations that suffer from this phenomenon on the
  // various browsers.
  var spanAffectsWrapping = /^$/; // Won't match any two-character string
  if (gecko) spanAffectsWrapping = /$'/;
  else if (safari) spanAffectsWrapping = /\-[^ \-?]|\?[^ !'\"\),.\-\/:;\?\]\}]/;
  else if (chrome) spanAffectsWrapping = /\-[^ \-\.?]|\?[^ \-\.?\]\}:;!'\"\),\/]|[\.!\"#&%\)*+,:;=>\]|\}~][\(\{\[<]|\$'/;

  // Counts the column offset in a string, taking tabs into account.
  // Used mostly to find indentation.
  function countColumn(string, end, tabSize) {
    if (end == null) {
      end = string.search(/[^\s\u00a0]/);
      if (end == -1) end = string.length;
    }
    for (var i = 0, n = 0; i < end; ++i) {
      if (string.charAt(i) == "\t") n += tabSize - (n % tabSize);
      else ++n;
    }
    return n;
  }

  function eltOffset(node, screen) {
    // Take the parts of bounding client rect that we are interested in so we are able to edit if need be,
    // since the returned value cannot be changed externally (they are kept in sync as the element moves within the page)
    try { var box = node.getBoundingClientRect(); box = { top: box.top, left: box.left }; }
    catch(e) { box = {top: 0, left: 0}; }
    if (!screen) {
      // Get the toplevel scroll, working around browser differences.
      if (window.pageYOffset == null) {
        var t = document.documentElement || document.body.parentNode;
        if (t.scrollTop == null) t = document.body;
        box.top += t.scrollTop; box.left += t.scrollLeft;
      } else {
        box.top += window.pageYOffset; box.left += window.pageXOffset;
      }
    }
    return box;
  }

  function eltText(node) {
    return node.textContent || node.innerText || node.nodeValue || "";
  }

  var spaceStrs = [""];
  function spaceStr(n) {
    while (spaceStrs.length <= n)
      spaceStrs.push(lst(spaceStrs) + " ");
    return spaceStrs[n];
  }

  function lst(arr) { return arr[arr.length-1]; }

  function selectInput(node) {
    if (ios) { // Mobile Safari apparently has a bug where select() is broken.
      node.selectionStart = 0;
      node.selectionEnd = node.value.length;
    } else node.select();
  }

  // Operations on {line, ch} objects.
  function posEq(a, b) {return a.line == b.line && a.ch == b.ch;}
  function posLess(a, b) {return a.line < b.line || (a.line == b.line && a.ch < b.ch);}
  function copyPos(x) {return {line: x.line, ch: x.ch};}

  function elt(tag, content, className, style) {
    var e = document.createElement(tag);
    if (className) e.className = className;
    if (style) e.style.cssText = style;
    if (typeof content == "string") setTextContent(e, content);
    else if (content) for (var i = 0; i < content.length; ++i) e.appendChild(content[i]);
    return e;
  }
  function removeChildren(e) {
    e.innerHTML = "";
    return e;
  }
  function removeChildrenAndAdd(parent, e) {
    removeChildren(parent).appendChild(e);
  }
  function setTextContent(e, str) {
    if (ie_lt9) {
      e.innerHTML = "";
      e.appendChild(document.createTextNode(str));
    } else e.textContent = str;
  }

  // Used to position the cursor after an undo/redo by finding the
  // last edited character.
  function editEnd(from, to) {
    if (!to) return 0;
    if (!from) return to.length;
    for (var i = from.length, j = to.length; i >= 0 && j >= 0; --i, --j)
      if (from.charAt(i) != to.charAt(j)) break;
    return j + 1;
  }

  function indexOf(collection, elt) {
    if (collection.indexOf) return collection.indexOf(elt);
    for (var i = 0, e = collection.length; i < e; ++i)
      if (collection[i] == elt) return i;
    return -1;
  }
  function isWordChar(ch) {
    return /\w/.test(ch) || ch.toUpperCase() != ch.toLowerCase() || /[\u4E00-\u9FA5]/.test(ch);
  }

  // See if "".split is the broken IE version, if so, provide an
  // alternative way to split lines.
  var splitLines = "\n\nb".split(/\n/).length != 3 ? function(string) {
    var pos = 0, result = [], l = string.length;
    while (pos <= l) {
      var nl = string.indexOf("\n", pos);
      if (nl == -1) nl = string.length;
      var line = string.slice(pos, string.charAt(nl - 1) == "\r" ? nl - 1 : nl);
      var rt = line.indexOf("\r");
      if (rt != -1) {
        result.push(line.slice(0, rt));
        pos += rt + 1;
      } else {
        result.push(line);
        pos = nl + 1;
      }
    }
    return result;
  } : function(string){return string.split(/\r\n?|\n/);};
  CodeMirror.splitLines = splitLines;

  var hasSelection = window.getSelection ? function(te) {
    try { return te.selectionStart != te.selectionEnd; }
    catch(e) { return false; }
  } : function(te) {
    try {var range = te.ownerDocument.selection.createRange();}
    catch(e) {}
    if (!range || range.parentElement() != te) return false;
    return range.compareEndPoints("StartToEnd", range) != 0;
  };

  CodeMirror.defineMode("null", function() {
    return {token: function(stream) {stream.skipToEnd();}};
  });
  CodeMirror.defineMIME("text/plain", "null");

  var keyNames = {3: "Enter", 8: "Backspace", 9: "Tab", 13: "Enter", 16: "Shift", 17: "Ctrl", 18: "Alt",
                  19: "Pause", 20: "CapsLock", 27: "Esc", 32: "Space", 33: "PageUp", 34: "PageDown", 35: "End",
                  36: "Home", 37: "Left", 38: "Up", 39: "Right", 40: "Down", 44: "PrintScrn", 45: "Insert",
                  46: "Delete", 59: ";", 91: "Mod", 92: "Mod", 93: "Mod", 109: "-", 107: "=", 127: "Delete",
                  186: ";", 187: "=", 188: ",", 189: "-", 190: ".", 191: "/", 192: "`", 219: "[", 220: "\\",
                  221: "]", 222: "'", 63276: "PageUp", 63277: "PageDown", 63275: "End", 63273: "Home",
                  63234: "Left", 63232: "Up", 63235: "Right", 63233: "Down", 63302: "Insert", 63272: "Delete"};
  CodeMirror.keyNames = keyNames;
  (function() {
    // Number keys
    for (var i = 0; i < 10; i++) keyNames[i + 48] = String(i);
    // Alphabetic keys
    for (var i = 65; i <= 90; i++) keyNames[i] = String.fromCharCode(i);
    // Function keys
    for (var i = 1; i <= 12; i++) keyNames[i + 111] = keyNames[i + 63235] = "F" + i;
  })();

  CodeMirror.version = "2.35";

  return CodeMirror;
})();
// ============== Formatting extensions ============================
// A common storage for all mode-specific formatting features
if (!CodeMirror.modeExtensions) CodeMirror.modeExtensions = {};

// Returns the extension of the editor's current mode
CodeMirror.defineExtension("getModeExt", function () {
  var mname = CodeMirror.resolveMode(this.getOption("mode")).name;
  var ext = CodeMirror.modeExtensions[mname];
  if (!ext) throw new Error("No extensions found for mode " + mname);
  return ext;
});

// If the current mode is 'htmlmixed', returns the extension of a mode located at
// the specified position (can be htmlmixed, css or javascript). Otherwise, simply
// returns the extension of the editor's current mode.
CodeMirror.defineExtension("getModeExtAtPos", function (pos) {
  var token = this.getTokenAt(pos);
  if (token && token.state && token.state.mode)
    return CodeMirror.modeExtensions[token.state.mode == "html" ? "htmlmixed" : token.state.mode];
  else
    return this.getModeExt();
});

// Comment/uncomment the specified range
CodeMirror.defineExtension("commentRange", function (isComment, from, to) {
  var curMode = this.getModeExtAtPos(this.getCursor());
  if (isComment) { // Comment range
    var commentedText = this.getRange(from, to);
    this.replaceRange(curMode.commentStart + this.getRange(from, to) + curMode.commentEnd
      , from, to);
    if (from.line == to.line && from.ch == to.ch) { // An empty comment inserted - put cursor inside
      this.setCursor(from.line, from.ch + curMode.commentStart.length);
    }
  }
  else { // Uncomment range
    var selText = this.getRange(from, to);
    var startIndex = selText.indexOf(curMode.commentStart);
    var endIndex = selText.lastIndexOf(curMode.commentEnd);
    if (startIndex > -1 && endIndex > -1 && endIndex > startIndex) {
      // Take string till comment start
      selText = selText.substr(0, startIndex)
      // From comment start till comment end
        + selText.substring(startIndex + curMode.commentStart.length, endIndex)
      // From comment end till string end
        + selText.substr(endIndex + curMode.commentEnd.length);
    }
    this.replaceRange(selText, from, to);
  }
});

// Applies automatic mode-aware indentation to the specified range
CodeMirror.defineExtension("autoIndentRange", function (from, to) {
  var cmInstance = this;
  this.operation(function () {
    for (var i = from.line; i <= to.line; i++) {
      cmInstance.indentLine(i, "smart");
    }
  });
});

// Applies automatic formatting to the specified range
CodeMirror.defineExtension("autoFormatRange", function (from, to) {
  var absStart = this.indexFromPos(from);
  var absEnd = this.indexFromPos(to);
  // Insert additional line breaks where necessary according to the
  // mode's syntax
  var res = this.getModeExt().autoFormatLineBreaks(this.getValue(), absStart, absEnd);
  var cmInstance = this;

  // Replace and auto-indent the range
  this.operation(function () {
    cmInstance.replaceRange(res, from, to);
    var startLine = cmInstance.posFromIndex(absStart).line;
    var endLine = cmInstance.posFromIndex(absStart + res.length).line;
    for (var i = startLine; i <= endLine; i++) {
      cmInstance.indentLine(i, "smart");
    }
  });
});

// Define extensions for a few modes

CodeMirror.modeExtensions["css"] = {
  commentStart: "/*",
  commentEnd: "*/",
  wordWrapChars: [";", "\\{", "\\}"],
  autoFormatLineBreaks: function (text, startPos, endPos) {
    text = text.substring(startPos, endPos);
    return text.replace(new RegExp("(;|\\{|\\})([^\r\n])", "g"), "$1\n$2");
  }
};

CodeMirror.modeExtensions["javascript"] = {
  commentStart: "/*",
  commentEnd: "*/",
  wordWrapChars: [";", "\\{", "\\}"],

  getNonBreakableBlocks: function (text) {
    var nonBreakableRegexes = [
        new RegExp("for\\s*?\\(([\\s\\S]*?)\\)"),
        new RegExp("'([\\s\\S]*?)('|$)"),
        new RegExp("\"([\\s\\S]*?)(\"|$)"),
        new RegExp("//.*([\r\n]|$)")
      ];
    var nonBreakableBlocks = new Array();
    for (var i = 0; i < nonBreakableRegexes.length; i++) {
      var curPos = 0;
      while (curPos < text.length) {
        var m = text.substr(curPos).match(nonBreakableRegexes[i]);
        if (m != null) {
          nonBreakableBlocks.push({
            start: curPos + m.index,
            end: curPos + m.index + m[0].length
          });
          curPos += m.index + Math.max(1, m[0].length);
        }
        else { // No more matches
          break;
        }
      }
    }
    nonBreakableBlocks.sort(function (a, b) {
      return a.start - b.start;
    });

    return nonBreakableBlocks;
  },

  autoFormatLineBreaks: function (text, startPos, endPos) {
    text = text.substring(startPos, endPos);
    var curPos = 0;
    var reLinesSplitter = new RegExp("(;|\\{|\\})([^\r\n])", "g");
    var nonBreakableBlocks = this.getNonBreakableBlocks(text);
    if (nonBreakableBlocks != null) {
      var res = "";
      for (var i = 0; i < nonBreakableBlocks.length; i++) {
        if (nonBreakableBlocks[i].start > curPos) { // Break lines till the block
          res += text.substring(curPos, nonBreakableBlocks[i].start).replace(reLinesSplitter, "$1\n$2");
          curPos = nonBreakableBlocks[i].start;
        }
        if (nonBreakableBlocks[i].start <= curPos
          && nonBreakableBlocks[i].end >= curPos) { // Skip non-breakable block
          res += text.substring(curPos, nonBreakableBlocks[i].end);
          curPos = nonBreakableBlocks[i].end;
        }
      }
      if (curPos < text.length - 1) {
        res += text.substr(curPos).replace(reLinesSplitter, "$1\n$2");
      }
      return res;
    }
    else {
      return text.replace(reLinesSplitter, "$1\n$2");
    }
  }
};

CodeMirror.modeExtensions["xml"] = {
  commentStart: "<!--",
  commentEnd: "-->",
  wordWrapChars: [">"],

  autoFormatLineBreaks: function (text, startPos, endPos) {
    text = text.substring(startPos, endPos);
    var lines = text.split("\n");
    var reProcessedPortion = new RegExp("(^\\s*?<|^[^<]*?)(.+)(>\\s*?$|[^>]*?$)");
    var reOpenBrackets = new RegExp("<", "g");
    var reCloseBrackets = new RegExp("(>)([^\r\n])", "g");
    for (var i = 0; i < lines.length; i++) {
      var mToProcess = lines[i].match(reProcessedPortion);
      if (mToProcess != null && mToProcess.length > 3) { // The line starts with whitespaces and ends with whitespaces
        lines[i] = mToProcess[1]
            + mToProcess[2].replace(reOpenBrackets, "\n$&").replace(reCloseBrackets, "$1\n$2")
            + mToProcess[3];
        continue;
      }
    }

    return lines.join("\n");
  }
};

CodeMirror.modeExtensions["htmlmixed"] = {
  commentStart: "<!--",
  commentEnd: "-->",
  wordWrapChars: [">", ";", "\\{", "\\}"],

  getModeInfos: function (text, absPos) {
    var modeInfos = new Array();
    modeInfos[0] =
      {
        pos: 0,
        modeExt: CodeMirror.modeExtensions["xml"],
        modeName: "xml"
      };

    var modeMatchers = new Array();
    modeMatchers[0] =
      {
        regex: new RegExp("<style[^>]*>([\\s\\S]*?)(</style[^>]*>|$)", "i"),
        modeExt: CodeMirror.modeExtensions["css"],
        modeName: "css"
      };
    modeMatchers[1] =
      {
        regex: new RegExp("<script[^>]*>([\\s\\S]*?)(</script[^>]*>|$)", "i"),
        modeExt: CodeMirror.modeExtensions["javascript"],
        modeName: "javascript"
      };

    var lastCharPos = (typeof (absPos) !== "undefined" ? absPos : text.length - 1);
    // Detect modes for the entire text
    for (var i = 0; i < modeMatchers.length; i++) {
      var curPos = 0;
      while (curPos <= lastCharPos) {
        var m = text.substr(curPos).match(modeMatchers[i].regex);
        if (m != null) {
          if (m.length > 1 && m[1].length > 0) {
            // Push block begin pos
            var blockBegin = curPos + m.index + m[0].indexOf(m[1]);
            modeInfos.push(
              {
                pos: blockBegin,
                modeExt: modeMatchers[i].modeExt,
                modeName: modeMatchers[i].modeName
              });
            // Push block end pos
            modeInfos.push(
              {
                pos: blockBegin + m[1].length,
                modeExt: modeInfos[0].modeExt,
                modeName: modeInfos[0].modeName
              });
            curPos += m.index + m[0].length;
            continue;
          }
          else {
            curPos += m.index + Math.max(m[0].length, 1);
          }
        }
        else { // No more matches
          break;
        }
      }
    }
    // Sort mode infos
    modeInfos.sort(function sortModeInfo(a, b) {
      return a.pos - b.pos;
    });

    return modeInfos;
  },

  autoFormatLineBreaks: function (text, startPos, endPos) {
    var modeInfos = this.getModeInfos(text);
    var reBlockStartsWithNewline = new RegExp("^\\s*?\n");
    var reBlockEndsWithNewline = new RegExp("\n\\s*?$");
    var res = "";
    // Use modes info to break lines correspondingly
    if (modeInfos.length > 1) { // Deal with multi-mode text
      for (var i = 1; i <= modeInfos.length; i++) {
        var selStart = modeInfos[i - 1].pos;
        var selEnd = (i < modeInfos.length ? modeInfos[i].pos : endPos);

        if (selStart >= endPos) { // The block starts later than the needed fragment
          break;
        }
        if (selStart < startPos) {
          if (selEnd <= startPos) { // The block starts earlier than the needed fragment
            continue;
          }
          selStart = startPos;
        }
        if (selEnd > endPos) {
          selEnd = endPos;
        }
        var textPortion = text.substring(selStart, selEnd);
        if (modeInfos[i - 1].modeName != "xml") { // Starting a CSS or JavaScript block
          if (!reBlockStartsWithNewline.test(textPortion)
              && selStart > 0) { // The block does not start with a line break
            textPortion = "\n" + textPortion;
          }
          if (!reBlockEndsWithNewline.test(textPortion)
              && selEnd < text.length - 1) { // The block does not end with a line break
            textPortion += "\n";
          }
        }
        res += modeInfos[i - 1].modeExt.autoFormatLineBreaks(textPortion);
      }
    }
    else { // Single-mode text
      res = modeInfos[0].modeExt.autoFormatLineBreaks(text.substring(startPos, endPos));
    }

    return res;
  }
};
CodeMirror.defineMode("css", function(config) {
  var indentUnit = config.indentUnit, type;
  function ret(style, tp) {type = tp; return style;}

  function tokenBase(stream, state) {
    var ch = stream.next();
    if (ch == "@") {stream.eatWhile(/[\w\\\-]/); return ret("meta", stream.current());}
    else if (ch == "/" && stream.eat("*")) {
      state.tokenize = tokenCComment;
      return tokenCComment(stream, state);
    }
    else if (ch == "<" && stream.eat("!")) {
      state.tokenize = tokenSGMLComment;
      return tokenSGMLComment(stream, state);
    }
    else if (ch == "=") ret(null, "compare");
    else if ((ch == "~" || ch == "|") && stream.eat("=")) return ret(null, "compare");
    else if (ch == "\"" || ch == "'") {
      state.tokenize = tokenString(ch);
      return state.tokenize(stream, state);
    }
    else if (ch == "#") {
      stream.eatWhile(/[\w\\\-]/);
      return ret("atom", "hash");
    }
    else if (ch == "!") {
      stream.match(/^\s*\w*/);
      return ret("keyword", "important");
    }
    else if (/\d/.test(ch)) {
      stream.eatWhile(/[\w.%]/);
      return ret("number", "unit");
    }
    else if (/[,.+>*\/]/.test(ch)) {
      return ret(null, "select-op");
    }
    else if (/[;{}:\[\]]/.test(ch)) {
      return ret(null, ch);
    }
    else {
      stream.eatWhile(/[\w\\\-]/);
      return ret("variable", "variable");
    }
  }

  function tokenCComment(stream, state) {
    var maybeEnd = false, ch;
    while ((ch = stream.next()) != null) {
      if (maybeEnd && ch == "/") {
        state.tokenize = tokenBase;
        break;
      }
      maybeEnd = (ch == "*");
    }
    return ret("comment", "comment");
  }

  function tokenSGMLComment(stream, state) {
    var dashes = 0, ch;
    while ((ch = stream.next()) != null) {
      if (dashes >= 2 && ch == ">") {
        state.tokenize = tokenBase;
        break;
      }
      dashes = (ch == "-") ? dashes + 1 : 0;
    }
    return ret("comment", "comment");
  }

  function tokenString(quote) {
    return function(stream, state) {
      var escaped = false, ch;
      while ((ch = stream.next()) != null) {
        if (ch == quote && !escaped)
          break;
        escaped = !escaped && ch == "\\";
      }
      if (!escaped) state.tokenize = tokenBase;
      return ret("string", "string");
    };
  }

  return {
    startState: function(base) {
      return {tokenize: tokenBase,
              baseIndent: base || 0,
              stack: []};
    },

    token: function(stream, state) {
      if (stream.eatSpace()) return null;
      var style = state.tokenize(stream, state);

      var context = state.stack[state.stack.length-1];
      if (type == "hash" && context != "rule") style = "string-2";
      else if (style == "variable") {
        if (context == "rule") style = "number";
        else if (!context || context == "@media{") style = "tag";
      }

      if (context == "rule" && /^[\{\};]$/.test(type))
        state.stack.pop();
      if (type == "{") {
        if (context == "@media") state.stack[state.stack.length-1] = "@media{";
        else state.stack.push("{");
      }
      else if (type == "}") state.stack.pop();
      else if (type == "@media") state.stack.push("@media");
      else if (context == "{" && type != "comment") state.stack.push("rule");
      return style;
    },

    indent: function(state, textAfter) {
      var n = state.stack.length;
      if (/^\}/.test(textAfter))
        n -= state.stack[state.stack.length-1] == "rule" ? 2 : 1;
      return state.baseIndent + n * indentUnit;
    },

    electricChars: "}"
  };
});

CodeMirror.defineMIME("text/css", "css");
CodeMirror.defineMode("xml", function(config, parserConfig) {
  var indentUnit = config.indentUnit;
  var Kludges = parserConfig.htmlMode ? {
    autoSelfClosers: {'area': true, 'base': true, 'br': true, 'col': true, 'command': true,
                      'embed': true, 'frame': true, 'hr': true, 'img': true, 'input': true,
                      'keygen': true, 'link': true, 'meta': true, 'param': true, 'source': true,
                      'track': true, 'wbr': true},
    implicitlyClosed: {'dd': true, 'li': true, 'optgroup': true, 'option': true, 'p': true,
                       'rp': true, 'rt': true, 'tbody': true, 'td': true, 'tfoot': true,
                       'th': true, 'tr': true},
    contextGrabbers: {
      'dd': {'dd': true, 'dt': true},
      'dt': {'dd': true, 'dt': true},
      'li': {'li': true},
      'option': {'option': true, 'optgroup': true},
      'optgroup': {'optgroup': true},
      'p': {'address': true, 'article': true, 'aside': true, 'blockquote': true, 'dir': true,
            'div': true, 'dl': true, 'fieldset': true, 'footer': true, 'form': true,
            'h1': true, 'h2': true, 'h3': true, 'h4': true, 'h5': true, 'h6': true,
            'header': true, 'hgroup': true, 'hr': true, 'menu': true, 'nav': true, 'ol': true,
            'p': true, 'pre': true, 'section': true, 'table': true, 'ul': true},
      'rp': {'rp': true, 'rt': true},
      'rt': {'rp': true, 'rt': true},
      'tbody': {'tbody': true, 'tfoot': true},
      'td': {'td': true, 'th': true},
      'tfoot': {'tbody': true},
      'th': {'td': true, 'th': true},
      'thead': {'tbody': true, 'tfoot': true},
      'tr': {'tr': true}
    },
    doNotIndent: {"pre": true},
    allowUnquoted: true,
    allowMissing: false
  } : {
    autoSelfClosers: {},
    implicitlyClosed: {},
    contextGrabbers: {},
    doNotIndent: {},
    allowUnquoted: false,
    allowMissing: false
  };
  var alignCDATA = parserConfig.alignCDATA;

  // Return variables for tokenizers
  var tagName, type;

  function inText(stream, state) {
    function chain(parser) {
      state.tokenize = parser;
      return parser(stream, state);
    }

    var ch = stream.next();
    if (ch == "<") {
      if (stream.eat("!")) {
        if (stream.eat("[")) {
          if (stream.match("CDATA[")) return chain(inBlock("atom", "]]>"));
          else return null;
        }
        else if (stream.match("--")) return chain(inBlock("comment", "-->"));
        else if (stream.match("DOCTYPE", true, true)) {
          stream.eatWhile(/[\w\._\-]/);
          return chain(doctype(1));
        }
        else return null;
      }
      else if (stream.eat("?")) {
        stream.eatWhile(/[\w\._\-]/);
        state.tokenize = inBlock("meta", "?>");
        return "meta";
      }
      else {
        type = stream.eat("/") ? "closeTag" : "openTag";
        stream.eatSpace();
        tagName = "";
        var c;
        while ((c = stream.eat(/[^\s\u00a0=<>\"\'\/?]/))) tagName += c;
        state.tokenize = inTag;
        return "tag";
      }
    }
    else if (ch == "&") {
      var ok;
      if (stream.eat("#")) {
        if (stream.eat("x")) {
          ok = stream.eatWhile(/[a-fA-F\d]/) && stream.eat(";");          
        } else {
          ok = stream.eatWhile(/[\d]/) && stream.eat(";");
        }
      } else {
        ok = stream.eatWhile(/[\w\.\-:]/) && stream.eat(";");
      }
      return ok ? "atom" : "error";
    }
    else {
      stream.eatWhile(/[^&<]/);
      return null;
    }
  }

  function inTag(stream, state) {
    var ch = stream.next();
    if (ch == ">" || (ch == "/" && stream.eat(">"))) {
      state.tokenize = inText;
      type = ch == ">" ? "endTag" : "selfcloseTag";
      return "tag";
    }
    else if (ch == "=") {
      type = "equals";
      return null;
    }
    else if (/[\'\"]/.test(ch)) {
      state.tokenize = inAttribute(ch);
      return state.tokenize(stream, state);
    }
    else {
      stream.eatWhile(/[^\s\u00a0=<>\"\'\/?]/);
      return "word";
    }
  }

  function inAttribute(quote) {
    return function(stream, state) {
      while (!stream.eol()) {
        if (stream.next() == quote) {
          state.tokenize = inTag;
          break;
        }
      }
      return "string";
    };
  }

  function inBlock(style, terminator) {
    return function(stream, state) {
      while (!stream.eol()) {
        if (stream.match(terminator)) {
          state.tokenize = inText;
          break;
        }
        stream.next();
      }
      return style;
    };
  }
  function doctype(depth) {
    return function(stream, state) {
      var ch;
      while ((ch = stream.next()) != null) {
        if (ch == "<") {
          state.tokenize = doctype(depth + 1);
          return state.tokenize(stream, state);
        } else if (ch == ">") {
          if (depth == 1) {
            state.tokenize = inText;
            break;
          } else {
            state.tokenize = doctype(depth - 1);
            return state.tokenize(stream, state);
          }
        }
      }
      return "meta";
    };
  }

  var curState, setStyle;
  function pass() {
    for (var i = arguments.length - 1; i >= 0; i--) curState.cc.push(arguments[i]);
  }
  function cont() {
    pass.apply(null, arguments);
    return true;
  }

  function pushContext(tagName, startOfLine) {
    var noIndent = Kludges.doNotIndent.hasOwnProperty(tagName) || (curState.context && curState.context.noIndent);
    curState.context = {
      prev: curState.context,
      tagName: tagName,
      indent: curState.indented,
      startOfLine: startOfLine,
      noIndent: noIndent
    };
  }
  function popContext() {
    if (curState.context) curState.context = curState.context.prev;
  }

  function element(type) {
    if (type == "openTag") {
      curState.tagName = tagName;
      return cont(attributes, endtag(curState.startOfLine));
    } else if (type == "closeTag") {
      var err = false;
      if (curState.context) {
        if (curState.context.tagName != tagName) {
          if (Kludges.implicitlyClosed.hasOwnProperty(curState.context.tagName.toLowerCase())) {
            popContext();
          }
          err = !curState.context || curState.context.tagName != tagName;
        }
      } else {
        err = true;
      }
      if (err) setStyle = "error";
      return cont(endclosetag(err));
    }
    return cont();
  }
  function endtag(startOfLine) {
    return function(type) {
      if (type == "selfcloseTag" ||
          (type == "endTag" && Kludges.autoSelfClosers.hasOwnProperty(curState.tagName.toLowerCase()))) {
        maybePopContext(curState.tagName.toLowerCase());
        return cont();
      }
      if (type == "endTag") {
        maybePopContext(curState.tagName.toLowerCase());
        pushContext(curState.tagName, startOfLine);
        return cont();
      }
      return cont();
    };
  }
  function endclosetag(err) {
    return function(type) {
      if (err) setStyle = "error";
      if (type == "endTag") { popContext(); return cont(); }
      setStyle = "error";
      return cont(arguments.callee);
    }
  }
  function maybePopContext(nextTagName) {
    var parentTagName;
    while (true) {
      if (!curState.context) {
        return;
      }
      parentTagName = curState.context.tagName.toLowerCase();
      if (!Kludges.contextGrabbers.hasOwnProperty(parentTagName) ||
          !Kludges.contextGrabbers[parentTagName].hasOwnProperty(nextTagName)) {
        return;
      }
      popContext();
    }
  }

  function attributes(type) {
    if (type == "word") {setStyle = "attribute"; return cont(attribute, attributes);}
    if (type == "endTag" || type == "selfcloseTag") return pass();
    setStyle = "error";
    return cont(attributes);
  }
  function attribute(type) {
    if (type == "equals") return cont(attvalue, attributes);
    if (!Kludges.allowMissing) setStyle = "error";
    return (type == "endTag" || type == "selfcloseTag") ? pass() : cont();
  }
  function attvalue(type) {
    if (type == "string") return cont(attvaluemaybe);
    if (type == "word" && Kludges.allowUnquoted) {setStyle = "string"; return cont();}
    setStyle = "error";
    return (type == "endTag" || type == "selfCloseTag") ? pass() : cont();
  }
  function attvaluemaybe(type) {
    if (type == "string") return cont(attvaluemaybe);
    else return pass();
  }

  return {
    startState: function() {
      return {tokenize: inText, cc: [], indented: 0, startOfLine: true, tagName: null, context: null};
    },

    token: function(stream, state) {
      if (stream.sol()) {
        state.startOfLine = true;
        state.indented = stream.indentation();
      }
      if (stream.eatSpace()) return null;

      setStyle = type = tagName = null;
      var style = state.tokenize(stream, state);
      state.type = type;
      if ((style || type) && style != "comment") {
        curState = state;
        while (true) {
          var comb = state.cc.pop() || element;
          if (comb(type || style)) break;
        }
      }
      state.startOfLine = false;
      return setStyle || style;
    },

    indent: function(state, textAfter, fullLine) {
      var context = state.context;
      if ((state.tokenize != inTag && state.tokenize != inText) ||
          context && context.noIndent)
        return fullLine ? fullLine.match(/^(\s*)/)[0].length : 0;
      if (alignCDATA && /<!\[CDATA\[/.test(textAfter)) return 0;
      if (context && /^<\//.test(textAfter))
        context = context.prev;
      while (context && !context.startOfLine)
        context = context.prev;
      if (context) return context.indent + indentUnit;
      else return 0;
    },

    compareStates: function(a, b) {
      if (a.indented != b.indented || a.tokenize != b.tokenize) return false;
      for (var ca = a.context, cb = b.context; ; ca = ca.prev, cb = cb.prev) {
        if (!ca || !cb) return ca == cb;
        if (ca.tagName != cb.tagName) return false;
      }
    },

    electricChars: "/"
  };
});

CodeMirror.defineMIME("application/xml", "xml");
if (!CodeMirror.mimeModes.hasOwnProperty("text/html"))
  CodeMirror.defineMIME("text/html", {name: "xml", htmlMode: true});
CodeMirror.defineMode("javascript", function(config, parserConfig) {
  var indentUnit = config.indentUnit;
  var jsonMode = parserConfig.json;

  // Tokenizer

  var keywords = function(){
    function kw(type) {return {type: type, style: "keyword"};}
    var A = kw("keyword a"), B = kw("keyword b"), C = kw("keyword c");
    var operator = kw("operator"), atom = {type: "atom", style: "atom"};
    return {
      "if": A, "while": A, "with": A, "else": B, "do": B, "try": B, "finally": B,
      "return": C, "break": C, "continue": C, "new": C, "delete": C, "throw": C,
      "var": kw("var"), "const": kw("var"), "let": kw("var"),
      "function": kw("function"), "catch": kw("catch"),
      "for": kw("for"), "switch": kw("switch"), "case": kw("case"), "default": kw("default"),
      "in": operator, "typeof": operator, "instanceof": operator,
      "true": atom, "false": atom, "null": atom, "undefined": atom, "NaN": atom, "Infinity": atom
    };
  }();

  var isOperatorChar = /[+\-*&%=<>!?|]/;

  function chain(stream, state, f) {
    state.tokenize = f;
    return f(stream, state);
  }

  function nextUntilUnescaped(stream, end) {
    var escaped = false, next;
    while ((next = stream.next()) != null) {
      if (next == end && !escaped)
        return false;
      escaped = !escaped && next == "\\";
    }
    return escaped;
  }

  // Used as scratch variables to communicate multiple values without
  // consing up tons of objects.
  var type, content;
  function ret(tp, style, cont) {
    type = tp; content = cont;
    return style;
  }

  function jsTokenBase(stream, state) {
    var ch = stream.next();
    if (ch == '"' || ch == "'")
      return chain(stream, state, jsTokenString(ch));
    else if (/[\[\]{}\(\),;\:\.]/.test(ch))
      return ret(ch);
    else if (ch == "0" && stream.eat(/x/i)) {
      stream.eatWhile(/[\da-f]/i);
      return ret("number", "number");
    }      
    else if (/\d/.test(ch) || ch == "-" && stream.eat(/\d/)) {
      stream.match(/^\d*(?:\.\d*)?(?:[eE][+\-]?\d+)?/);
      return ret("number", "number");
    }
    else if (ch == "/") {
      if (stream.eat("*")) {
        return chain(stream, state, jsTokenComment);
      }
      else if (stream.eat("/")) {
        stream.skipToEnd();
        return ret("comment", "comment");
      }
      else if (state.reAllowed) {
        nextUntilUnescaped(stream, "/");
        stream.eatWhile(/[gimy]/); // 'y' is "sticky" option in Mozilla
        return ret("regexp", "string-2");
      }
      else {
        stream.eatWhile(isOperatorChar);
        return ret("operator", null, stream.current());
      }
    }
    else if (ch == "#") {
        stream.skipToEnd();
        return ret("error", "error");
    }
    else if (isOperatorChar.test(ch)) {
      stream.eatWhile(isOperatorChar);
      return ret("operator", null, stream.current());
    }
    else {
      stream.eatWhile(/[\w\$_]/);
      var word = stream.current(), known = keywords.propertyIsEnumerable(word) && keywords[word];
      return (known && state.kwAllowed) ? ret(known.type, known.style, word) :
                     ret("variable", "variable", word);
    }
  }

  function jsTokenString(quote) {
    return function(stream, state) {
      if (!nextUntilUnescaped(stream, quote))
        state.tokenize = jsTokenBase;
      return ret("string", "string");
    };
  }

  function jsTokenComment(stream, state) {
    var maybeEnd = false, ch;
    while (ch = stream.next()) {
      if (ch == "/" && maybeEnd) {
        state.tokenize = jsTokenBase;
        break;
      }
      maybeEnd = (ch == "*");
    }
    return ret("comment", "comment");
  }

  // Parser

  var atomicTypes = {"atom": true, "number": true, "variable": true, "string": true, "regexp": true};

  function JSLexical(indented, column, type, align, prev, info) {
    this.indented = indented;
    this.column = column;
    this.type = type;
    this.prev = prev;
    this.info = info;
    if (align != null) this.align = align;
  }

  function inScope(state, varname) {
    for (var v = state.localVars; v; v = v.next)
      if (v.name == varname) return true;
  }

  function parseJS(state, style, type, content, stream) {
    var cc = state.cc;
    // Communicate our context to the combinators.
    // (Less wasteful than consing up a hundred closures on every call.)
    cx.state = state; cx.stream = stream; cx.marked = null, cx.cc = cc;
  
    if (!state.lexical.hasOwnProperty("align"))
      state.lexical.align = true;

    while(true) {
      var combinator = cc.length ? cc.pop() : jsonMode ? expression : statement;
      if (combinator(type, content)) {
        while(cc.length && cc[cc.length - 1].lex)
          cc.pop()();
        if (cx.marked) return cx.marked;
        if (type == "variable" && inScope(state, content)) return "variable-2";
        return style;
      }
    }
  }

  // Combinator utils

  var cx = {state: null, column: null, marked: null, cc: null};
  function pass() {
    for (var i = arguments.length - 1; i >= 0; i--) cx.cc.push(arguments[i]);
  }
  function cont() {
    pass.apply(null, arguments);
    return true;
  }
  function register(varname) {
    var state = cx.state;
    if (state.context) {
      cx.marked = "def";
      for (var v = state.localVars; v; v = v.next)
        if (v.name == varname) return;
      state.localVars = {name: varname, next: state.localVars};
    }
  }

  // Combinators

  var defaultVars = {name: "this", next: {name: "arguments"}};
  function pushcontext() {
    if (!cx.state.context) cx.state.localVars = defaultVars;
    cx.state.context = {prev: cx.state.context, vars: cx.state.localVars};
  }
  function popcontext() {
    cx.state.localVars = cx.state.context.vars;
    cx.state.context = cx.state.context.prev;
  }
  function pushlex(type, info) {
    var result = function() {
      var state = cx.state;
      state.lexical = new JSLexical(state.indented, cx.stream.column(), type, null, state.lexical, info)
    };
    result.lex = true;
    return result;
  }
  function poplex() {
    var state = cx.state;
    if (state.lexical.prev) {
      if (state.lexical.type == ")")
        state.indented = state.lexical.indented;
      state.lexical = state.lexical.prev;
    }
  }
  poplex.lex = true;

  function expect(wanted) {
    return function expecting(type) {
      if (type == wanted) return cont();
      else if (wanted == ";") return pass();
      else return cont(arguments.callee);
    };
  }

  function statement(type) {
    if (type == "var") return cont(pushlex("vardef"), vardef1, expect(";"), poplex);
    if (type == "keyword a") return cont(pushlex("form"), expression, statement, poplex);
    if (type == "keyword b") return cont(pushlex("form"), statement, poplex);
    if (type == "{") return cont(pushlex("}"), block, poplex);
    if (type == ";") return cont();
    if (type == "function") return cont(functiondef);
    if (type == "for") return cont(pushlex("form"), expect("("), pushlex(")"), forspec1, expect(")"),
                                      poplex, statement, poplex);
    if (type == "variable") return cont(pushlex("stat"), maybelabel);
    if (type == "switch") return cont(pushlex("form"), expression, pushlex("}", "switch"), expect("{"),
                                         block, poplex, poplex);
    if (type == "case") return cont(expression, expect(":"));
    if (type == "default") return cont(expect(":"));
    if (type == "catch") return cont(pushlex("form"), pushcontext, expect("("), funarg, expect(")"),
                                        statement, poplex, popcontext);
    return pass(pushlex("stat"), expression, expect(";"), poplex);
  }
  function expression(type) {
    if (atomicTypes.hasOwnProperty(type)) return cont(maybeoperator);
    if (type == "function") return cont(functiondef);
    if (type == "keyword c") return cont(maybeexpression);
    if (type == "(") return cont(pushlex(")"), maybeexpression, expect(")"), poplex, maybeoperator);
    if (type == "operator") return cont(expression);
    if (type == "[") return cont(pushlex("]"), commasep(expression, "]"), poplex, maybeoperator);
    if (type == "{") return cont(pushlex("}"), commasep(objprop, "}"), poplex, maybeoperator);
    return cont();
  }
  function maybeexpression(type) {
    if (type.match(/[;\}\)\],]/)) return pass();
    return pass(expression);
  }
    
  function maybeoperator(type, value) {
    if (type == "operator" && /\+\+|--/.test(value)) return cont(maybeoperator);
    if (type == "operator" || type == ":") return cont(expression);
    if (type == ";") return;
    if (type == "(") return cont(pushlex(")"), commasep(expression, ")"), poplex, maybeoperator);
    if (type == ".") return cont(property, maybeoperator);
    if (type == "[") return cont(pushlex("]"), expression, expect("]"), poplex, maybeoperator);
  }
  function maybelabel(type) {
    if (type == ":") return cont(poplex, statement);
    return pass(maybeoperator, expect(";"), poplex);
  }
  function property(type) {
    if (type == "variable") {cx.marked = "property"; return cont();}
  }
  function objprop(type) {
    if (type == "variable") cx.marked = "property";
    if (atomicTypes.hasOwnProperty(type)) return cont(expect(":"), expression);
  }
  function commasep(what, end) {
    function proceed(type) {
      if (type == ",") return cont(what, proceed);
      if (type == end) return cont();
      return cont(expect(end));
    }
    return function commaSeparated(type) {
      if (type == end) return cont();
      else return pass(what, proceed);
    };
  }
  function block(type) {
    if (type == "}") return cont();
    return pass(statement, block);
  }
  function vardef1(type, value) {
    if (type == "variable"){register(value); return cont(vardef2);}
    return cont();
  }
  function vardef2(type, value) {
    if (value == "=") return cont(expression, vardef2);
    if (type == ",") return cont(vardef1);
  }
  function forspec1(type) {
    if (type == "var") return cont(vardef1, forspec2);
    if (type == ";") return pass(forspec2);
    if (type == "variable") return cont(formaybein);
    return pass(forspec2);
  }
  function formaybein(type, value) {
    if (value == "in") return cont(expression);
    return cont(maybeoperator, forspec2);
  }
  function forspec2(type, value) {
    if (type == ";") return cont(forspec3);
    if (value == "in") return cont(expression);
    return cont(expression, expect(";"), forspec3);
  }
  function forspec3(type) {
    if (type != ")") cont(expression);
  }
  function functiondef(type, value) {
    if (type == "variable") {register(value); return cont(functiondef);}
    if (type == "(") return cont(pushlex(")"), pushcontext, commasep(funarg, ")"), poplex, statement, popcontext);
  }
  function funarg(type, value) {
    if (type == "variable") {register(value); return cont();}
  }

  // Interface

  return {
    startState: function(basecolumn) {
      return {
        tokenize: jsTokenBase,
        reAllowed: true,
        kwAllowed: true,
        cc: [],
        lexical: new JSLexical((basecolumn || 0) - indentUnit, 0, "block", false),
        localVars: parserConfig.localVars,
        context: parserConfig.localVars && {vars: parserConfig.localVars},
        indented: 0
      };
    },

    token: function(stream, state) {
      if (stream.sol()) {
        if (!state.lexical.hasOwnProperty("align"))
          state.lexical.align = false;
        state.indented = stream.indentation();
      }
      if (stream.eatSpace()) return null;
      var style = state.tokenize(stream, state);
      if (type == "comment") return style;
      state.reAllowed = !!(type == "operator" || type == "keyword c" || type.match(/^[\[{}\(,;:]$/));
      state.kwAllowed = type != '.';
      return parseJS(state, style, type, content, stream);
    },

    indent: function(state, textAfter) {
      if (state.tokenize != jsTokenBase) return 0;
      var firstChar = textAfter && textAfter.charAt(0), lexical = state.lexical;
      if (lexical.type == "stat" && firstChar == "}") lexical = lexical.prev;
      var type = lexical.type, closing = firstChar == type;
      if (type == "vardef") return lexical.indented + 4;
      else if (type == "form" && firstChar == "{") return lexical.indented;
      else if (type == "stat" || type == "form") return lexical.indented + indentUnit;
      else if (lexical.info == "switch" && !closing)
        return lexical.indented + (/^(?:case|default)\b/.test(textAfter) ? indentUnit : 2 * indentUnit);
      else if (lexical.align) return lexical.column + (closing ? 0 : 1);
      else return lexical.indented + (closing ? 0 : indentUnit);
    },

    electricChars: ":{}"
  };
});

CodeMirror.defineMIME("text/javascript", "javascript");
CodeMirror.defineMIME("application/json", {name: "javascript", json: true});
CodeMirror.defineMode("htmlmixed", function(config, parserConfig) {
  var htmlMode = CodeMirror.getMode(config, {name: "xml", htmlMode: true});
  var jsMode = CodeMirror.getMode(config, "javascript");
  var cssMode = CodeMirror.getMode(config, "css");

  function html(stream, state) {
    var style = htmlMode.token(stream, state.htmlState);
    if (style == "tag" && stream.current() == ">" && state.htmlState.context) {
      if (/^script$/i.test(state.htmlState.context.tagName)) {
        state.token = javascript;
        state.localState = jsMode.startState(htmlMode.indent(state.htmlState, ""));
        state.mode = "javascript";
      }
      else if (/^style$/i.test(state.htmlState.context.tagName)) {
        state.token = css;
        state.localState = cssMode.startState(htmlMode.indent(state.htmlState, ""));
        state.mode = "css";
      }
    }
    return style;
  }
  function maybeBackup(stream, pat, style) {
    var cur = stream.current();
    var close = cur.search(pat);
    if (close > -1) stream.backUp(cur.length - close);
    return style;
  }
  function javascript(stream, state) {
    if (stream.match(/^<\/\s*script\s*>/i, false)) {
      state.token = html;
      state.localState = null;
      state.mode = "html";
      return html(stream, state);
    }
    return maybeBackup(stream, /<\/\s*script\s*>/,
                       jsMode.token(stream, state.localState));
  }
  function css(stream, state) {
    if (stream.match(/^<\/\s*style\s*>/i, false)) {
      state.token = html;
      state.localState = null;
      state.mode = "html";
      return html(stream, state);
    }
    return maybeBackup(stream, /<\/\s*style\s*>/,
                       cssMode.token(stream, state.localState));
  }

  return {
    startState: function() {
      var state = htmlMode.startState();
      return {token: html, localState: null, mode: "html", htmlState: state};
    },

    copyState: function(state) {
      if (state.localState)
        var local = CodeMirror.copyState(state.token == css ? cssMode : jsMode, state.localState);
      return {token: state.token, localState: local, mode: state.mode,
              htmlState: CodeMirror.copyState(htmlMode, state.htmlState)};
    },

    token: function(stream, state) {
      return state.token(stream, state);
    },

    indent: function(state, textAfter) {
      if (state.token == html || /^\s*<\//.test(textAfter))
        return htmlMode.indent(state.htmlState, textAfter);
      else if (state.token == javascript)
        return jsMode.indent(state.localState, textAfter);
      else
        return cssMode.indent(state.localState, textAfter);
    },

    compareStates: function(a, b) {
      if (a.mode != b.mode) return false;
      if (a.localState) return CodeMirror.Pass;
      return htmlMode.compareStates(a.htmlState, b.htmlState);
    },

    electricChars: "/{}:"
  }
}, "xml", "javascript", "css");

CodeMirror.defineMIME("text/html", "htmlmixed");
/**
 * WYSIWYG - jQuery plugin 0.97
 * (0.97.2 - From infinity)
 *
 * Copyright (c) 2008-2009 Juan M Martinez, 2010-2011 Akzhan Abdulin and all contributors
 * https://github.com/akzhan/jwysiwyg
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 */

/*jslint browser: true, forin: true */


(function ($) {
  "use strict";
  /* Wysiwyg namespace: private properties and methods */

  var console = window.console ? window.console : {
    log: $.noop,
    error: function (msg) {
      $.error(msg);
    }
  };
  var supportsProp = (('prop' in $.fn) && ('removeProp' in $.fn));

  function Wysiwyg() {
    // - the item is added by this.ui.appendControls and then appendItem
    // - click triggers this.triggerControl
    // cmd or[key] - designMode exec function name
    // tags - activates control for these tags (@see checkTargets)
    // css - activates control if one of css is applied
    this.controls = {
      bold: {
        groupIndex: 0,
        visible: true,
        tags: ["b", "strong"],
        css: {
          fontWeight: "bold"
        },
        tooltip: "Bold",
        hotkey: {"ctrl": 1, "key": 66}
      },

      copy: {
        groupIndex: 8,
        visible: false,
        tooltip: "Copy"
      },

      createLink: {
        groupIndex: 6,
        visible: true,
        exec: function () {
          var self = this;
          if ($.wysiwyg.controls && $.wysiwyg.controls.link) {
            $.wysiwyg.controls.link.init(this);
          } else if ($.wysiwyg.autoload) {
            $.wysiwyg.autoload.control("wysiwyg.link.js", function () {
              self.controls.createLink.exec.apply(self);
            });
          } else {
            console.error("$.wysiwyg.controls.link not defined. You need to include wysiwyg.link.js file");
          }
        },
        tags: ["a"],
        tooltip: "Create link"
      },
      
      unLink : {
        groupIndex: 6,
        visible: true,
        exec : function() {
          this.editorDoc.execCommand("unlink", false, null);
        },
        tooltip: "Remove link"
      },

      cut: {
        groupIndex: 8,
        visible: false,
        tooltip: "Cut"
      },

      decreaseFontSize: {
        groupIndex: 9,
        visible: false,
        tags: ["small"],
        tooltip: "Decrease font size",
        exec: function () {
          this.decreaseFontSize();
        }
      },

      h1: {
        groupIndex: 7,
        visible: true,
        className: "h1",
        command: ($.browser.msie || $.browser.safari) ? "FormatBlock" : "heading",
        "arguments": ($.browser.msie || $.browser.safari) ? "<h1>" : "h1",
        tags: ["h1"],
        tooltip: "Header 1"
      },

      h2: {
        groupIndex: 7,
        visible: true,
        className: "h2",
        command: ($.browser.msie || $.browser.safari) ? "FormatBlock" : "heading",
        "arguments": ($.browser.msie || $.browser.safari) ? "<h2>" : "h2",
        tags: ["h2"],
        tooltip: "Header 2"
      },

      h3: {
        groupIndex: 7,
        visible: true,
        className: "h3",
        command: ($.browser.msie || $.browser.safari) ? "FormatBlock" : "heading",
        "arguments": ($.browser.msie || $.browser.safari) ? "<h3>" : "h3",
        tags: ["h3"],
        tooltip: "Header 3"
      },

      highlight: {
        tooltip:     "Highlight",
        className:   "highlight",
        groupIndex:  1,
        visible:     false,
        css: {
          backgroundColor: "rgb(255, 255, 102)"
        },
        exec: function () {
          var command, node, selection, args;

          if ($.browser.msie || $.browser.safari) {
            command = "backcolor";
          } else {
            command = "hilitecolor";
          }

          if ($.browser.msie) {
            node = this.getInternalRange().parentElement();
          } else {
            selection = this.getInternalSelection();
            node = selection.extentNode || selection.focusNode;

            while (node.style === undefined) {
              node = node.parentNode;
              if (node.tagName && node.tagName.toLowerCase() === "body") {
                return;
              }
            }
          }

          if (node.style.backgroundColor === "rgb(255, 255, 102)" ||
              node.style.backgroundColor === "#ffff66") {
            args = "#ffffff";
          } else {
            args = "#ffff66";
          }

          this.editorDoc.execCommand(command, false, args);
        }
      },

      html: {
        groupIndex: 10,
        visible: false,
        exec: function () {
          var elementHeight;

          if (this.options.resizeOptions && $.fn.resizable) {
            elementHeight = this.element.height();
          }

          if (this.viewHTML) { //textarea is shown
            this.setContent(this.original.value);

            $(this.original).hide();
            this.editor.show();

            if (this.options.resizeOptions && $.fn.resizable) {
              // if element.height still the same after frame was shown
              if (elementHeight === this.element.height()) {
                this.element.height(elementHeight + this.editor.height());
              }

              this.element.resizable($.extend(true, {
                alsoResize: this.editor
              }, this.options.resizeOptions));
            }
            
            this.ui.toolbar.find("li").each(function () {
              var li = $(this);

              if (li.hasClass("html")) {
                li.removeClass("active");
              } else {
                li.removeClass('disabled');
              }
            });
          } else { //wysiwyg is shown
            this.saveContent();

            $(this.original).css({
              width:  this.element.outerWidth() - 6,
              height: this.element.height() - this.ui.toolbar.height() - 6,
              resize: "none"
            }).show();
            this.editor.hide();
            
            if (this.options.resizeOptions && $.fn.resizable) {
              // if element.height still the same after frame was hidden
              if (elementHeight === this.element.height()) {
                this.element.height(this.ui.toolbar.height());
              }

              this.element.resizable("destroy");
            }

            this.ui.toolbar.find("li").each(function () {
              var li = $(this);

              if (li.hasClass("html")) {
                li.addClass("active");
              } else {
                if (false === li.hasClass("fullscreen")) {
                  li.removeClass("active").addClass('disabled');
                }
              }
            });
          }

          this.viewHTML = !(this.viewHTML);
        },
        tooltip: "View source code"
      },

      increaseFontSize: {
        groupIndex: 9,
        visible: false,
        tags: ["big"],
        tooltip: "Increase font size",
        exec: function () {
          this.increaseFontSize();
        }
      },

      indent: {
        groupIndex: 2,
        visible: true,
        tooltip: "Indent"
      },

      insertHorizontalRule: {
        groupIndex: 6,
        visible: true,
        tags: ["hr"],
        tooltip: "Insert Horizontal Rule"
      },

      insertImage: {
        groupIndex: 6,
        visible: true,
        exec: function () {
          var self = this;

          if ($.wysiwyg.controls && $.wysiwyg.controls.image) {
            $.wysiwyg.controls.image.init(this);
          } else if ($.wysiwyg.autoload) {
            $.wysiwyg.autoload.control("wysiwyg.image.js", function () {
              self.controls.insertImage.exec.apply(self);
            });
          } else {
            console.error("$.wysiwyg.controls.image not defined. You need to include wysiwyg.image.js file");
          }
        },
        tags: ["img"],
        tooltip: "Insert image"
      },

      insertOrderedList: {
        groupIndex: 5,
        visible: true,
        tags: ["ol"],
        tooltip: "Insert Ordered List"
      },

      insertTable: {
        groupIndex: 6,
        visible: true,
        exec: function () {
          var self = this;

          if ($.wysiwyg.controls && $.wysiwyg.controls.table) {
            $.wysiwyg.controls.table(this);
          } else if ($.wysiwyg.autoload) {
            $.wysiwyg.autoload.control("wysiwyg.table.js", function () {
              self.controls.insertTable.exec.apply(self);
            });
          } else {
            console.error("$.wysiwyg.controls.table not defined. You need to include wysiwyg.table.js file");
          }
        },
        tags: ["table"],
        tooltip: "Insert table"
      },

      insertUnorderedList: {
        groupIndex: 5,
        visible: true,
        tags: ["ul"],
        tooltip: "Insert Unordered List"
      },

      italic: {
        groupIndex: 0,
        visible: true,
        tags: ["i", "em"],
        css: {
          fontStyle: "italic"
        },
        tooltip: "Italic",
        hotkey: {"ctrl": 1, "key": 73}
      },

      justifyCenter: {
        groupIndex: 1,
        visible: true,
        tags: ["center"],
        css: {
          textAlign: "center"
        },
        tooltip: "Justify Center"
      },

      justifyFull: {
        groupIndex: 1,
        visible: true,
        css: {
          textAlign: "justify"
        },
        tooltip: "Justify Full"
      },

      justifyLeft: {
        visible: true,
        groupIndex: 1,
        css: {
          textAlign: "left"
        },
        tooltip: "Justify Left"
      },

      justifyRight: {
        groupIndex: 1,
        visible: true,
        css: {
          textAlign: "right"
        },
        tooltip: "Justify Right"
      },

      ltr: {
        groupIndex: 10,
        visible: false,
        exec: function () {
          var p = this.dom.getElement("p");

          if (!p) {
            return false;
          }

          $(p).attr("dir", "ltr");
          return true;
        },
        tooltip : "Left to Right"
      },

      outdent: {
        groupIndex: 2,
        visible: true,
        tooltip: "Outdent"
      },

      paragraph: {
        groupIndex: 7,
        visible: false,
        className: "paragraph",
        command: "FormatBlock",
        "arguments": ($.browser.msie || $.browser.safari) ? "<p>" : "p",
        tags: ["p"],
        tooltip: "Paragraph"
      },

      paste: {
        groupIndex: 8,
        visible: false,
        tooltip: "Paste"
      },

      redo: {
        groupIndex: 4,
        visible: true,
        tooltip: "Redo"
      },

      removeFormat: {
        groupIndex: 10,
        visible: true,
        exec: function () {
          this.removeFormat();
        },
        tooltip: "Remove formatting"
      },

      rtl: {
        groupIndex: 10,
        visible: false,
        exec: function () {
          var p = this.dom.getElement("p");

          if (!p) {
            return false;
          }

          $(p).attr("dir", "rtl");
          return true;
        },
        tooltip : "Right to Left"
      },

      strikeThrough: {
        groupIndex: 0,
        visible: true,
        tags: ["s", "strike"],
        css: {
          textDecoration: "line-through"
        },
        tooltip: "Strike-through"
      },

      subscript: {
        groupIndex: 3,
        visible: true,
        tags: ["sub"],
        tooltip: "Subscript"
      },

      superscript: {
        groupIndex: 3,
        visible: true,
        tags: ["sup"],
        tooltip: "Superscript"
      },

      underline: {
        groupIndex: 0,
        visible: true,
        tags: ["u"],
        css: {
          textDecoration: "underline"
        },
        tooltip: "Underline",
        hotkey: {"ctrl": 1, "key": 85}
      },

      undo: {
        groupIndex: 4,
        visible: true,
        tooltip: "Undo"
      },

      code: {
        visible : true,
        groupIndex: 6,
        tooltip: "Code snippet",
        exec: function () {
          var range = this.getInternalRange(),
            common  = $(range.commonAncestorContainer),
            $nodeName = range.commonAncestorContainer.nodeName.toLowerCase();
          if (common.parent("code").length) {
            common.unwrap();
          } else {
            if ($nodeName !== "body") {
              common.wrap("<code/>");
            }
          }
        }
      },
      
      cssWrap: {
        visible : false,
        groupIndex: 6,
        tooltip: "CSS Wrapper",
        exec: function () { 
          $.wysiwyg.controls.cssWrap.init(this);
        }
      }
      
    };

    this.defaults = {
html: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" style="margin:0"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head><body style="margin:0;">INITIAL_CONTENT</body></html>',
      debug: false,
      controls: {},
      css: {},
      events: {},
      autoGrow: false,
      autoSave: true,
      brIE: true,         // http://code.google.com/p/jwysiwyg/issues/detail?id=15
      formHeight: 270,
      formWidth: 440,
      iFrameClass: null,
      initialContent: "<p>Initial content</p>",
      maxHeight: 10000,     // see autoGrow
      maxLength: 0,
      messages: {
        nonSelection: "Select the text you wish to link"
      },
      toolbarHtml: '<ul role="menu" class="toolbar"></ul>',
      removeHeadings: false,
      replaceDivWithP: false,
      resizeOptions: false,
      rmUnusedControls: false,  // https://github.com/akzhan/jwysiwyg/issues/52
      rmUnwantedBr: true,     // http://code.google.com/p/jwysiwyg/issues/detail?id=11
      tableFiller: "Lorem ipsum",
      initialMinHeight: null,

      controlImage: {
        forceRelativeUrls: false
      },

      controlLink: {
        forceRelativeUrls: false
      },

      plugins: { // placeholder for plugins settings
        autoload: false,
        i18n: false,
        rmFormat: {
          rmMsWordMarkup: false
        }
      },
      
      dialog : "default"
    };

    //these properties are set from control hashes
    this.availableControlProperties = [
      "arguments",
      "callback",
      "className",
      "command",
      "css",
      "custom",
      "exec",
      "groupIndex",
      "hotkey",
      "icon",
      "tags",
      "tooltip",
      "visible"
    ];

    this.editor     = null;  //jquery iframe holder
    this.editorDoc    = null;
    this.element    = null;
    this.options    = {};
    this.original   = null;
    this.savedRange   = null;
    this.timers     = [];
    this.validKeyCodes  = [8, 9, 13, 16, 17, 18, 19, 20, 27, 33, 34, 35, 36, 37, 38, 39, 40, 45, 46];

    this.isDestroyed  = false;

    this.dom    = { // DOM related properties and methods
      ie:   {
        parent: null // link to dom
      },
      w3c:  {
        parent: null // link to dom
      }
    };
    this.dom.parent   = this;
    this.dom.ie.parent  = this.dom;
    this.dom.w3c.parent = this.dom;

    this.ui     = {}; // UI related properties and methods
    this.ui.self  = this;
    this.ui.toolbar = null;
    this.ui.initialHeight = null; // ui.grow

    this.dom.getAncestor = function (element, filterTagName) {
      filterTagName = filterTagName.toLowerCase();
      
      while (element && typeof element.tagName != "undefined" && "body" !== element.tagName.toLowerCase()) {
        if (filterTagName === element.tagName.toLowerCase()) {
          return element;
        }

        element = element.parentNode;
      }
      if(!element.tagName && (element.previousSibling || element.nextSibling)) {
        if(element.previousSibling) {
          if(element.previousSibling.tagName.toLowerCase() == filterTagName) {
            return element.previousSibling;
          }
        } 
        if(element.nextSibling) {
          if(element.nextSibling.tagName.toLowerCase() == filterTagName) {
            return element.nextSibling;
          }
        } 
      }

      return null;
    };

    this.dom.getElement = function (filterTagName) {
      var dom = this;
      
      filterTagName = filterTagName.toLowerCase();      

      if (window.getSelection) {
        return dom.w3c.getElement(filterTagName);
      } else {
        return dom.ie.getElement(filterTagName);
      }
    };

    this.dom.ie.getElement = function (filterTagName) {
      var dom     = this.parent,
        selection = dom.parent.getInternalSelection(),
        range   = selection.createRange(),
        element;

      if ("Control" === selection.type) {
        // control selection
        if (1 === range.length) {
          element = range.item(0);
        } else {
          // multiple control selection
          return null;
        }
      } else {
        element = range.parentElement();
      }

      return dom.getAncestor(element, filterTagName);
    };

    this.dom.w3c.getElement = function (filterTagName) {
      var dom   = this.parent,
        range = dom.parent.getInternalRange(),
        element;
        
      if (!range) {
        return null;
      }

      element = range.commonAncestorContainer;

      if (3 === element.nodeType) {
        element = element.parentNode;
      }

      // if startContainer not Text, Comment, or CDATASection element then
      // startOffset is the number of child nodes between the start of the
      // startContainer and the boundary point of the Range
      if (element === range.startContainer) {
        element = element.childNodes[range.startOffset];
      }
      
      if(!element.tagName && (element.previousSibling || element.nextSibling)) {
        if(element.previousSibling) {
          if(element.previousSibling.tagName.toLowerCase() == filterTagName) {
            return element.previousSibling;
          }
        } 
        if(element.nextSibling) {
          if(element.nextSibling.tagName.toLowerCase() == filterTagName) {
            return element.nextSibling;
          }
        } 
      }

      return dom.getAncestor(element, filterTagName);
    };

    this.ui.addHoverClass = function () {
      $(this).addClass("wysiwyg-button-hover");
    };

    this.ui.appendControls = function () {
      var ui = this,
        self = this.self,
        controls = self.parseControls(),
        hasVisibleControls  = true, // to prevent separator before first item
        groups = [],
        controlsByGroup = {},
        i,
        currentGroupIndex, // jslint wants all vars at top of function
        iterateGroup = function (controlName, control) { //called for every group when adding
          if (control.groupIndex && currentGroupIndex !== control.groupIndex) {
            currentGroupIndex = control.groupIndex;
            hasVisibleControls = false;
          }

          if (!control.visible) {
            return;
          }

          if (!hasVisibleControls) {
            ui.appendItemSeparator();
            hasVisibleControls = true;
          }

          if (control.custom) {
            ui.appendItemCustom(controlName, control);
          } else {
            ui.appendItem(controlName, control);
          }
        };

      $.each(controls, function (name, c) { //sort by groupIndex
        var index = "empty";

        if (undefined !== c.groupIndex) {
          if ("" === c.groupIndex) {
            index = "empty";
          } else {
            index = c.groupIndex;
          }
        }

        if (undefined === controlsByGroup[index]) {
          groups.push(index);
          controlsByGroup[index] = {};
        }
        controlsByGroup[index][name] = c;
      });

      groups.sort(function (a, b) { //just sort group indexes by
        if ("number" === typeof (a) && typeof (a) === typeof (b)) {
          return (a - b);
        } else {
          a = a.toString();
          b = b.toString();

          if (a > b) {
            return 1;
          }

          if (a === b) {
            return 0;
          }

          return -1;
        }
      });

      if (0 < groups.length) {
        // set to first index in groups to proper placement of separator
        currentGroupIndex = groups[0];
      }

      for (i = 0; i < groups.length; i += 1) {
        $.each(controlsByGroup[groups[i]], iterateGroup);
      }
    };

    this.ui.appendItem = function (name, control) {
      var self = this.self,
        className = control.className || control.command || name || "empty",
        tooltip = control.tooltip || control.command || name || "";

      return $('<li role="menuitem" unselectable="on">' + (className) + "</li>")
        .addClass(className)
        .attr("title", tooltip)
        .hover(this.addHoverClass, this.removeHoverClass)
        .click(function (event) {
          if ($(this).hasClass("disabled")) {
            return false;
          }

          self.triggerControl.apply(self, [name, control]);

          /**
          * @link https://github.com/akzhan/jwysiwyg/issues/219
          */
          var $target = $(event.target);
          for (var controlName in self.controls) {
            if ($target.hasClass(controlName)) {
              self.ui.toolbar.find("." + controlName).toggleClass("active");
              self.editorDoc.rememberCommand = true;
              break;
            }
          }
                    
          this.blur();
          self.ui.returnRange();
          self.ui.focus();
          return true;
        })
        .appendTo(self.ui.toolbar);
    };

    this.ui.appendItemCustom = function (name, control) {
      var self = this.self,
        tooltip = control.tooltip || control.command || name || "";

      if (control.callback) {
        $(window).bind("trigger-" + name + ".wysiwyg", control.callback);
      }

      return $('<li role="menuitem" unselectable="on" style="background: url(\'' + control.icon + '\') no-repeat;"></li>')
        .addClass("custom-command-" + name)
        .addClass("wysiwyg-custom-command")
        .addClass(name)
        .attr("title", tooltip)
        .hover(this.addHoverClass, this.removeHoverClass)
        .click(function () {
          if ($(this).hasClass("disabled")) {
            return false;
          }

          self.triggerControl.apply(self, [name, control]);

          this.blur();
          self.ui.returnRange();
          self.ui.focus();

          self.triggerControlCallback(name);
          return true;
        })
        .appendTo(self.ui.toolbar);
    };

    this.ui.appendItemSeparator = function () {
      var self = this.self;
      return $('<li role="separator" class="separator"></li>').appendTo(self.ui.toolbar);
    };

    this.autoSaveFunction = function () {
      this.saveContent();
    };

    //called after click in wysiwyg "textarea"
    this.ui.checkTargets = function (element) {
      var self = this.self;

      //activate controls
      $.each(self.options.controls, function (name, control) {
        var className = control.className || control.command || name || "empty",
          tags,
          elm,
          css,
          el,
          checkActiveStatus = function (cssProperty, cssValue) {
            var handler;

            if ("function" === typeof (cssValue)) {
              handler = cssValue;
              if (handler(el.css(cssProperty).toString().toLowerCase(), self)) {
                self.ui.toolbar.find("." + className).addClass("active");
              }
            } else {
              if (el.css(cssProperty).toString().toLowerCase() === cssValue) {
                self.ui.toolbar.find("." + className).addClass("active");
              }
            }
          };

        if ("fullscreen" !== className) {
          self.ui.toolbar.find("." + className).removeClass("active");
        }

        //activate by allowed tags
        if (control.tags || (control.options && control.options.tags)) {
          tags = control.tags || (control.options && control.options.tags);

          elm = element;
          while (elm) {
            if (elm.nodeType !== 1) {
              break;
            }

            if ($.inArray(elm.tagName.toLowerCase(), tags) !== -1) {
              self.ui.toolbar.find("." + className).addClass("active");
            }

            elm = elm.parentNode;
          }
        }

        //activate by supposed css
        if (control.css || (control.options && control.options.css)) {
          css = control.css || (control.options && control.options.css);
          el = $(element);

          while (el) {
            if (el[0].nodeType !== 1) {
              break;
            }
            $.each(css, checkActiveStatus);

            el = el.parent();
          }
        }
      });
    };

    this.ui.designMode = function () {
      var attempts = 3,
        self = this.self,
        runner;
        runner = function (attempts) {
          if ("on" === self.editorDoc.designMode) {
            if (self.timers.designMode) {
              window.clearTimeout(self.timers.designMode);
            }

            // IE needs to reget the document element (this.editorDoc) after designMode was set
            if (self.innerDocument() !== self.editorDoc) {
              self.ui.initFrame();
            }

            return;
          }

          try {
            self.editorDoc.designMode = "on";
          } catch (e) {
          }

          attempts -= 1;
          if (attempts > 0) {
            self.timers.designMode = window.setTimeout(function () { runner(attempts); }, 100);
          }
        };

      runner(attempts);
    };

    this.destroy = function () {
      this.isDestroyed = true;

      var i, $form = this.element.closest("form");

      for (i = 0; i < this.timers.length; i += 1) {
        window.clearTimeout(this.timers[i]);
      }

      // Remove bindings
      $form.unbind(".wysiwyg");
      this.element.remove();
      $.removeData(this.original, "wysiwyg");
      $(this.original).show();
      return this;
    };

    this.getRangeText = function () {
      var r = this.getInternalRange();

      if (r.toString) {
        r = r.toString();
      } else if (r.text) {  // IE
        r = r.text;
      }

      return r;
    };
    //not used?
    this.execute = function (command, arg) {
      if (typeof (arg) === "undefined") {
        arg = null;
      }
      this.editorDoc.execCommand(command, false, arg);
    };

    this.extendOptions = function (options) {
      var controls = {};

      /**
       * If the user set custom controls, we catch it, and merge with the
       * defaults controls later.
       */
      if ("object" === typeof options.controls) {
        controls = options.controls;
        delete options.controls;
      }

      options = $.extend(true, {}, this.defaults, options);
      options.controls = $.extend(true, {}, controls, this.controls, controls);

      if (options.rmUnusedControls) {
        $.each(options.controls, function (controlName) {
          if (!controls[controlName]) {
            delete options.controls[controlName];
          }
        });
      }

      return options;
    };

    this.ui.focus = function () {
      var self = this.self;

      self.editor.get(0).contentWindow.focus();
      return self;
    };

    this.ui.returnRange = function () {
      var self = this.self, sel;

      if (self.savedRange !== null) {
        if (window.getSelection) { //non IE and there is already a selection
          sel = window.getSelection();
          if (sel.rangeCount > 0) {
            sel.removeAllRanges();
          }
          try {
            sel.addRange(self.savedRange);
          } catch (e) {
            console.error(e);
          }
        } else if (window.document.createRange) { // non IE and no selection
          window.getSelection().addRange(self.savedRange);
        } else if (window.document.selection) { //IE
          self.savedRange.select();
        }

        self.savedRange = null;
      }
    };

    this.increaseFontSize = function () {
      if ($.browser.mozilla || $.browser.opera) {
        this.editorDoc.execCommand("increaseFontSize", false, null);
      } else if ($.browser.safari) {        
        var Range = this.getInternalRange(),
          Selection = this.getInternalSelection(),
          newNode = this.editorDoc.createElement("big");

        // If cursor placed on text node
        if (true === Range.collapsed && 3 === Range.commonAncestorContainer.nodeType) {
          var text = Range.commonAncestorContainer.nodeValue.toString(),
            start = text.lastIndexOf(" ", Range.startOffset) + 1,
            end = (-1 === text.indexOf(" ", Range.startOffset)) ? text : text.indexOf(" ", Range.startOffset);

          Range.setStart(Range.commonAncestorContainer, start);
          Range.setEnd(Range.commonAncestorContainer, end);

          Range.surroundContents(newNode);
          Selection.addRange(Range);
        } else {
          Range.surroundContents(newNode);
          Selection.removeAllRanges();
          Selection.addRange(Range);
        }
      } else {
        console.error("Internet Explorer?");
      }
    };

    this.decreaseFontSize = function () {
      if ($.browser.mozilla || $.browser.opera) {
        this.editorDoc.execCommand("decreaseFontSize", false, null);
      } else if ($.browser.safari) {
        var Range = this.getInternalRange(),
          Selection = this.getInternalSelection(),
          newNode = this.editorDoc.createElement("small");

        // If cursor placed on text node
        if (true === Range.collapsed && 3 === Range.commonAncestorContainer.nodeType) {
          var text = Range.commonAncestorContainer.nodeValue.toString(),
            start = text.lastIndexOf(" ", Range.startOffset) + 1,
            end = (-1 === text.indexOf(" ", Range.startOffset)) ? text : text.indexOf(" ", Range.startOffset);
  
          Range.setStart(Range.commonAncestorContainer, start);
          Range.setEnd(Range.commonAncestorContainer, end);
  
          Range.surroundContents(newNode);
          Selection.addRange(Range);
        } else {
          Range.surroundContents(newNode);
          Selection.removeAllRanges();
          Selection.addRange(Range);
        }
      } else {
        console.error("Internet Explorer?");
      }
    };

    this.getContent = function () {
      if (this.viewHTML) {
        this.setContent(this.original.value);
      }
      return this.events.filter('getContent', this.editorDoc.body.innerHTML);
    };
    
    /**
     * A jWysiwyg specific event system.
     *
     * Example:
     * 
     * $("#editor").getWysiwyg().events.bind("getContent", function (orig) {
     *     return "<div id='content'>"+orgi+"</div>";
     * });
     * 
     * This makes it so that when ever getContent is called, it is wrapped in a div#content.
     */
    this.events = {
      _events : {},
      
      /**
       * Similar to jQuery's bind, but for jWysiwyg only.
       */
      bind : function (eventName, callback) {
        if (typeof (this._events.eventName) !== "object") {
          this._events[eventName] = [];
        }
        this._events[eventName].push(callback);
      },
      
      /**
       * Similar to jQuery's trigger, but for jWysiwyg only.
       */
      trigger : function (eventName, args) {
        if (typeof (this._events.eventName) === "object") {
          var editor = this.editor;
          $.each(this._events[eventName], function (k, v) {
            if (typeof (v) === "function") {
              v.apply(editor, args);
            }
          });
        }
      },
      
      /**
       * This "filters" `originalText` by passing it as the first argument to every callback
       * with the name `eventName` and taking the return value and passing it to the next function.
       *
       * This function returns the result after all the callbacks have been applied to `originalText`.
       */
      filter : function (eventName, originalText) {
        if (typeof (this._events[eventName]) === "object") {
          var editor = this.editor,
            args = Array.prototype.slice.call(arguments, 1);

          $.each(this._events[eventName], function (k, v) {
            if (typeof (v) === "function") {
              originalText = v.apply(editor, args);
            }
          });
        }
        return originalText;
      }
    };

    this.getElementByAttributeValue = function (tagName, attributeName, attributeValue) {
      var i, value, elements = this.editorDoc.getElementsByTagName(tagName);

      for (i = 0; i < elements.length; i += 1) {
        value = elements[i].getAttribute(attributeName);

        if ($.browser.msie) {
          /** IE add full path, so I check by the last chars. */
          value = value.substr(value.length - attributeValue.length);
        }

        if (value === attributeValue) {
          return elements[i];
        }
      }

      return false;
    };

    this.getInternalRange = function () {
      var selection = this.getInternalSelection();

      if (!selection) {
        return null;
      }

      if (selection.rangeCount && selection.rangeCount > 0) { // w3c
        return selection.getRangeAt(0);
      } else if (selection.createRange) { // ie
        return selection.createRange();
      }

      return null;
    };

    this.getInternalSelection = function () {
      // firefox: document.getSelection is deprecated
      if (this.editor.get(0).contentWindow) {
        if (this.editor.get(0).contentWindow.getSelection) {
          return this.editor.get(0).contentWindow.getSelection();
        }
        if (this.editor.get(0).contentWindow.selection) {
          return this.editor.get(0).contentWindow.selection;
        }
      }
      if (this.editorDoc.getSelection) {
        return this.editorDoc.getSelection();
      }
      if (this.editorDoc.selection) {
        return this.editorDoc.selection;
      }

      return null;
    };

    this.getRange = function () {
      var selection = this.getSelection();

      if (!selection) {
        return null;
      }

      if (selection.rangeCount && selection.rangeCount > 0) { // w3c
        selection.getRangeAt(0);
      } else if (selection.createRange) { // ie
        return selection.createRange();
      }

      return null;
    };

    this.getSelection = function () {
      return (window.getSelection) ? window.getSelection() : window.document.selection;
    };

    // :TODO: you can type long string and letters will be hidden because of overflow
    this.ui.grow = function () {
      var self = this.self,
        innerBody = $(self.editorDoc.body),
        innerHeight = $.browser.msie ? innerBody[0].scrollHeight : innerBody.height() + 2 + 20, // 2 - borders, 20 - to prevent content jumping on grow
        minHeight = self.ui.initialHeight,
        height = Math.max(innerHeight, minHeight);

      height = Math.min(height, self.options.maxHeight);

      self.editor.attr("scrolling", height < self.options.maxHeight ? "no" : "auto"); // hide scrollbar firefox
      innerBody.css("overflow", height < self.options.maxHeight ? "hidden" : ""); // hide scrollbar chrome

      self.editor.get(0).height = height;

      return self;
    };

    this.init = function (element, options) {
      var self = this,
        $form = $(element).closest("form"),
        newX = (element.width || element.clientWidth || 0),
        newY = (element.height || element.clientHeight || 0)
        ;

      this.options  = this.extendOptions(options);
      this.original = element;
      this.ui.toolbar = $(this.options.toolbarHtml);

      if ($.browser.msie && parseInt($.browser.version, 10) < 8) {
        this.options.autoGrow = false;
      }

      if (newX === 0 && element.cols) {
        newX = (element.cols * 8) + 21;
      }
      if (newY === 0 && element.rows) {
        newY = (element.rows * 16) + 16;
      }

      this.editor = $(window.location.protocol === "https:" ? '<iframe src="about:blank"></iframe>' : "<iframe></iframe>").attr("frameborder", "0");

      if (this.options.iFrameClass) {
        this.editor.addClass(this.options.iFrameClass);
      } else {
        this.editor.css({
          minHeight: (newY - 6).toString() + "px",
          // fix for issue 12 ( http://github.com/akzhan/jwysiwyg/issues/issue/12 )
          width: (newX > 50) ? newX.toString() + "px" : ""
        });
        if ($.browser.msie && parseInt($.browser.version, 10) < 7) {
          this.editor.css("height", newY.toString() + "px");
        }
      }
      /** 
       * Automagically add id to iframe if textarea has its own when possible 
       * ( http://github.com/akzhan/jwysiwyg/issues/245 )
       */
      if (element.id) {
        var proposedId = element.id + '-wysiwyg-iframe';
        if (! document.getElementById(proposedId)) {
          this.editor.attr('id', proposedId);
        }
      }

      /**
       * http://code.google.com/p/jwysiwyg/issues/detail?id=96
       */
      this.editor.attr("tabindex", $(element).attr("tabindex"));

      this.element = $("<div/>").addClass("wysiwyg");

      if (!this.options.iFrameClass) {
        this.element.css({
          width: (newX > 0) ? newX.toString() + "px" : "100%"
        });
      }

      $(element).hide().before(this.element);

      this.viewHTML = false;

      /**
       * @link http://code.google.com/p/jwysiwyg/issues/detail?id=52
       */
      this.initialContent = $(element).val();
      this.ui.initFrame();

      if (this.options.resizeOptions && $.fn.resizable) {
        this.element.resizable($.extend(true, {
          alsoResize: this.editor
        }, this.options.resizeOptions));
      }

      if (this.options.autoSave) {
        $form.bind("submit.wysiwyg", function () { self.autoSaveFunction(); });
      }

      $form.bind("reset.wysiwyg", function () { self.resetFunction(); });
    };

    this.ui.initFrame = function () {
      var self = this.self,
        stylesheet,
        growHandler,
        saveHandler;

      self.ui.appendControls();
      self.element.append(self.ui.toolbar)
        .append($("<div><!-- --></div>")
          .css({
            clear: "both"
          }))
        .append(self.editor);

      self.editorDoc = self.innerDocument();

      if (self.isDestroyed) {
        return null;
      }

      self.ui.designMode();
      self.editorDoc.open();
      self.editorDoc.write(
        self.options.html
          /**
           * @link http://code.google.com/p/jwysiwyg/issues/detail?id=144
           */
          .replace(/INITIAL_CONTENT/, function () { return self.wrapInitialContent(); })
      );
      self.editorDoc.close();

      $.wysiwyg.plugin.bind(self);

      $(self.editorDoc).trigger("initFrame.wysiwyg");

      $(self.editorDoc).bind("click.wysiwyg", function (event) {
        self.ui.checkTargets(event.target ? event.target : event.srcElement);
      });

            /**
             * @link https://github.com/akzhan/jwysiwyg/issues/251
             */
            setInterval(function () {
                var offset = null;

                try {
                    var range = self.getInternalRange();
                    if (range) {
                        offset = {
                            range: range,
                            parent: "endContainer" in range ? range.endContainer.parentNode : range.parentElement(),
                            width: ("startOffset" in range ? (range.startOffset - range.endOffset) : range.boundingWidth) || 0
                        };
                    }
                }
                catch (e) { console.error(e); }

                if (offset && offset.width == 0 && !self.editorDoc.rememberCommand) {
                    self.ui.checkTargets(offset.parent);
                }
            }, 400);
            
      /**
       * @link http://code.google.com/p/jwysiwyg/issues/detail?id=20
       * @link https://github.com/akzhan/jwysiwyg/issues/330
       */
      $(self.original).focus(function () {
        if ($(this).filter(":visible").length === 0 || $.browser.opera) {
          return;
        }
        self.ui.focus();
      });

      $(self.editorDoc).keydown(function (event) {
        var emptyContentRegex;
        if (event.keyCode === 8) { // backspace
          emptyContentRegex = /^<([\w]+)[^>]*>(<br\/?>)?<\/\1>$/;
          if (emptyContentRegex.test(self.getContent())) { // if content is empty
            event.stopPropagation(); // prevent remove single empty tag
            return false;
          }
        }
                
                self.editorDoc.rememberCommand = false;
        return true;
      });
      
      if (!$.browser.msie) {
        $(self.editorDoc).keydown(function (event) {
          var controlName;
                          var control;

          /* Meta for Macs. tom@punkave.com */
          if (event.ctrlKey || event.metaKey) {
            for (controlName in self.options.controls) {
                                    control = self.options.controls[controlName];
              if (control.hotkey && control.hotkey.ctrl) {
                if (event.keyCode === control.hotkey.key) {
                  self.triggerControl.apply(self, [controlName, control]);

                  return false;
                }
              }
            }
          }
          return true;
        });
      } 
      
      if (self.options.brIE) {
        $(self.editorDoc).keydown(function (event) {
          if (event.keyCode === 13) {
            
            if ($.browser.msie || $.browser.opera) {
              var rng = self.getRange();
              if (rng) {
                rng.pasteHTML("<br/>");
                rng.collapse(false);
                rng.select();
              } else {
                self.insertHtml('<br/>');
              }           
            } else {
              var sel = self.editorDoc.getSelection();
              if (sel && sel.getRangeAt && sel.rangeCount) {
                var range = sel.getRangeAt(0);
                if (!range)
                  return true;
                range.deleteContents();

                var el = document.createElement("div");
                el.innerHTML = "<br/>";
                var frag = document.createDocumentFragment(), node, lastNode;
                while ( (node = el.firstChild) ) {
                  lastNode = frag.appendChild(node);
                }
                range.insertNode(frag);

                // Preserve the selection
                if (lastNode) {
                  range = range.cloneRange();
                  range.setStartAfter(lastNode);
                  range.collapse(true);
                  sel.removeAllRanges();
                  sel.addRange(range);
                }
              } else
                return true;

            }
            return false;
          }

          return true;
        });
      }

      if (self.options.plugins.rmFormat.rmMsWordMarkup) {
        $(self.editorDoc).bind("keyup.wysiwyg", function (event) {
          if (event.ctrlKey || event.metaKey) {
            // CTRL + V (paste)
            if (86 === event.keyCode) {
              if ($.wysiwyg.rmFormat) {
                if ("object" === typeof (self.options.plugins.rmFormat.rmMsWordMarkup)) {
                  $.wysiwyg.rmFormat.run(self, {rules: { msWordMarkup: self.options.plugins.rmFormat.rmMsWordMarkup }});
                } else {
                  $.wysiwyg.rmFormat.run(self, {rules: { msWordMarkup: { enabled: true }}});
                }
              }
            }
          }
        });
      }

      if (self.options.autoSave) {
        $(self.editorDoc).keydown(function () { self.autoSaveFunction(); })
          .keyup(function () { self.autoSaveFunction(); })
          .mousedown(function () { self.autoSaveFunction(); })
          .bind($.support.noCloneEvent ? "input.wysiwyg" : "paste.wysiwyg", function () { self.autoSaveFunction(); });
      }

      if (self.options.autoGrow) {
        if (self.options.initialMinHeight !== null) {
          self.ui.initialHeight = self.options.initialMinHeight;
        } else {
          self.ui.initialHeight = $(self.editorDoc).height();
        }
        $(self.editorDoc.body).css("border", "1px solid white"); // cancel margin collapsing

        growHandler = function () {
          self.ui.grow();
        };

        $(self.editorDoc).keyup(growHandler);
        $(self.editorDoc).bind("editorRefresh.wysiwyg", growHandler);

        // fix when content height > textarea height
        self.ui.grow();
      }

      if (self.options.css) {
        if (String === self.options.css.constructor) {
          if ($.browser.msie) {
            stylesheet = self.editorDoc.createStyleSheet(self.options.css);
            $(stylesheet).attr({
              "media":  "all"
            });
          } else {
            stylesheet = $("<link/>").attr({
              "href":   self.options.css,
              "media":  "all",
              "rel":    "stylesheet",
              "type":   "text/css"
            });

            $(self.editorDoc).find("head").append(stylesheet);
          }
        } else {
          self.timers.initFrame_Css = window.setTimeout(function () {
            $(self.editorDoc.body).css(self.options.css);
          }, 0);
        }
      }

      if (self.initialContent.length === 0) {
        if ("function" === typeof (self.options.initialContent)) {
          self.setContent(self.options.initialContent());
        } else {
          self.setContent(self.options.initialContent);
        }
      }

      if (self.options.maxLength > 0) {
        $(self.editorDoc).keydown(function (event) {
          if ($(self.editorDoc).text().length >= self.options.maxLength && $.inArray(event.which, self.validKeyCodes) === -1) {
            event.preventDefault();
          }
        });
      }
      
      // Support event callbacks
      $.each(self.options.events, function (key, handler) {
        $(self.editorDoc).bind(key + ".wysiwyg", function (event) {
          // Trigger event handler, providing the event and api to 
          // support additional functionality.
          handler.apply(self.editorDoc, [event, self]);
        });
      });

      // restores selection properly on focus
      if ($.browser.msie) {
        // Event chain: beforedeactivate => focusout => blur.
        // Focusout & blur fired too late to handle internalRange() in dialogs.
        // When clicked on input boxes both got range = null
        $(self.editorDoc).bind("beforedeactivate.wysiwyg", function () {
          self.savedRange = self.getInternalRange();
        });
      } else {
        $(self.editorDoc).bind("blur.wysiwyg", function () {
          self.savedRange = self.getInternalRange();
        });
      }

      $(self.editorDoc.body).addClass("wysiwyg");
      if (self.options.events && self.options.events.save) {
        saveHandler = self.options.events.save;

        $(self.editorDoc).bind("keyup.wysiwyg", saveHandler);
        $(self.editorDoc).bind("change.wysiwyg", saveHandler);

        if ($.support.noCloneEvent) {
          $(self.editorDoc).bind("input.wysiwyg", saveHandler);
        } else {
          $(self.editorDoc).bind("paste.wysiwyg", saveHandler);
          $(self.editorDoc).bind("cut.wysiwyg", saveHandler);
        }
      }
      
      /**
       * XHTML5 {@link https://github.com/akzhan/jwysiwyg/issues/152}
       */
      if (self.options.xhtml5 && self.options.unicode) {
        var replacements = {ne:8800,le:8804,para:182,xi:958,darr:8595,nu:957,oacute:243,Uacute:218,omega:969,prime:8242,pound:163,igrave:236,thorn:254,forall:8704,emsp:8195,lowast:8727,brvbar:166,alefsym:8501,nbsp:160,delta:948,clubs:9827,lArr:8656,Omega:937,Auml:196,cedil:184,and:8743,plusmn:177,ge:8805,raquo:187,uml:168,equiv:8801,laquo:171,rdquo:8221,Epsilon:917,divide:247,fnof:402,chi:967,Dagger:8225,iacute:237,rceil:8969,sigma:963,Oslash:216,acute:180,frac34:190,lrm:8206,upsih:978,Scaron:352,part:8706,exist:8707,nabla:8711,image:8465,prop:8733,zwj:8205,omicron:959,aacute:225,Yuml:376,Yacute:221,weierp:8472,rsquo:8217,otimes:8855,kappa:954,thetasym:977,harr:8596,Ouml:214,Iota:921,ograve:242,sdot:8901,copy:169,oplus:8853,acirc:226,sup:8835,zeta:950,Iacute:205,Oacute:211,crarr:8629,Nu:925,bdquo:8222,lsquo:8216,apos:39,Beta:914,eacute:233,egrave:232,lceil:8968,Kappa:922,piv:982,Ccedil:199,ldquo:8220,Xi:926,cent:162,uarr:8593,hellip:8230,Aacute:193,ensp:8194,sect:167,Ugrave:217,aelig:230,ordf:170,curren:164,sbquo:8218,macr:175,Phi:934,Eta:919,rho:961,Omicron:927,sup2:178,euro:8364,aring:229,Theta:920,mdash:8212,uuml:252,otilde:245,eta:951,uacute:250,rArr:8658,nsub:8836,agrave:224,notin:8713,ndash:8211,Psi:936,Ocirc:212,sube:8838,szlig:223,micro:181,not:172,sup1:185,middot:183,iota:953,ecirc:234,lsaquo:8249,thinsp:8201,sum:8721,ntilde:241,scaron:353,cap:8745,atilde:227,lang:10216,__replacement:65533,isin:8712,gamma:947,Euml:203,ang:8736,upsilon:965,Ntilde:209,hearts:9829,Alpha:913,Tau:932,spades:9824,dagger:8224,THORN:222,"int":8747,lambda:955,Eacute:201,Uuml:220,infin:8734,rlm:8207,Aring:197,ugrave:249,Egrave:200,Acirc:194,rsaquo:8250,ETH:208,oslash:248,alpha:945,Ograve:210,Prime:8243,mu:956,ni:8715,real:8476,bull:8226,beta:946,icirc:238,eth:240,prod:8719,larr:8592,ordm:186,perp:8869,Gamma:915,reg:174,ucirc:251,Pi:928,psi:968,tilde:732,asymp:8776,zwnj:8204,Agrave:192,deg:176,AElig:198,times:215,Delta:916,sim:8764,Otilde:213,Mu:924,uArr:8657,circ:710,theta:952,Rho:929,sup3:179,diams:9830,tau:964,Chi:935,frac14:188,oelig:339,shy:173,or:8744,dArr:8659,phi:966,iuml:239,Lambda:923,rfloor:8971,iexcl:161,cong:8773,ccedil:231,Icirc:206,frac12:189,loz:9674,rarr:8594,cup:8746,radic:8730,frasl:8260,euml:235,OElig:338,hArr:8660,Atilde:195,Upsilon:933,there4:8756,ouml:246,oline:8254,Ecirc:202,yacute:253,auml:228,permil:8240,sigmaf:962,iquest:191,empty:8709,pi:960,Ucirc:219,supe:8839,Igrave:204,yen:165,rang:10217,trade:8482,lfloor:8970,minus:8722,Zeta:918,sub:8834,epsilon:949,yuml:255,Sigma:931,Iuml:207,ocirc:244};
        self.events.bind("getContent", function (text) {
          return text.replace(/&(?:amp;)?(?!amp|lt|gt|quot)([a-z][a-z0-9]*);/gi, function (str, p1) {
            if (!replacements[p1]) {
              p1 = p1.toLowerCase();
              if (!replacements[p1]) {
                p1 = "__replacement";
              }
            }
            
            var num = replacements[p1];
            /* Numeric return if ever wanted: return replacements[p1] ? "&#"+num+";" : ""; */
            return String.fromCharCode(num);
          });
        });
      }
      $(self.original).trigger('ready.jwysiwyg', [self.editorDoc, self]);
    };

    this.innerDocument = function () {
      var element = this.editor.get(0);

      if (element.nodeName.toLowerCase() === "iframe") {
        if (element.contentDocument) {        // Gecko
          return element.contentDocument;
        } else if (element.contentWindow) {     // IE
          return element.contentWindow.document;
        }

        if (this.isDestroyed) {
          return null;
        }

        console.error("Unexpected error in innerDocument");

        /*
         return ( $.browser.msie )
         ? document.frames[element.id].document
         : element.contentWindow.document // contentDocument;
         */
      }

      return element;
    };

    this.insertHtml = function (szHTML) {
      var img, range;

      if (!szHTML || szHTML.length === 0) {
        return this;
      }

      if ($.browser.msie) {
        this.ui.focus();
        this.editorDoc.execCommand("insertImage", false, "#jwysiwyg#");
        img = this.getElementByAttributeValue("img", "src", "#jwysiwyg#");
        if (img) {
          $(img).replaceWith(szHTML);
        }
      } else {
        if ($.browser.mozilla) { // @link https://github.com/akzhan/jwysiwyg/issues/50
          if (1 === szHTML.length) {
            range = this.getInternalRange();
            range.deleteContents();
            range.insertNode($(szHTML).get(0));
          } else {
            this.editorDoc.execCommand("insertHTML", false, szHTML);
          }
        } else {
          if (!this.editorDoc.execCommand("insertHTML", false, szHTML)) {
            this.editor.focus();
            /* :TODO: place caret at the end
            if (window.getSelection) {
            } else {
            }
            this.editor.focus();
            */
            this.editorDoc.execCommand("insertHTML", false, szHTML);
          }
        }
      }

      this.saveContent();
      
      return this;
    };

    //check allowed properties
    this.parseControls = function () {
      var self = this;

      $.each(this.options.controls, function (controlName, control) {
        $.each(control, function (propertyName) {
          if (-1 === $.inArray(propertyName, self.availableControlProperties)) {
            throw controlName + '["' + propertyName + '"]: property "' + propertyName + '" not exists in Wysiwyg.availableControlProperties';
          }
        });
      });

      if (this.options.parseControls) { //user callback
        return this.options.parseControls.call(this);
      }

      return this.options.controls;
    };

    this.removeFormat = function () {
      if ($.browser.msie) {
        this.ui.focus();
      }

      if (this.options.removeHeadings) {
        this.editorDoc.execCommand("formatBlock", false, "<p>"); // remove headings
      }

      this.editorDoc.execCommand("removeFormat", false, null);
      this.editorDoc.execCommand("unlink", false, null);

      if ($.wysiwyg.rmFormat && $.wysiwyg.rmFormat.enabled) {
        if ("object" === typeof (this.options.plugins.rmFormat.rmMsWordMarkup)) {
          $.wysiwyg.rmFormat.run(this, {rules: { msWordMarkup: this.options.plugins.rmFormat.rmMsWordMarkup }});
        } else {
          $.wysiwyg.rmFormat.run(this, {rules: { msWordMarkup: { enabled: true }}});
        }
      }

      return this;
    };

    this.ui.removeHoverClass = function () {
      $(this).removeClass("wysiwyg-button-hover");
    };

    this.resetFunction = function () {
      this.setContent(this.initialContent);
    };

    this.saveContent = function () {
      if (this.viewHTML)
      {
        return; // no need
      }
      if (this.original) {
        var content, newContent;

        content = this.getContent();

        if (this.options.rmUnwantedBr) {
          content = content.replace(/<br\/?>$/, "");
        }

        if (this.options.replaceDivWithP) {
          newContent = $("<div/>").addClass("temp").append(content);

          newContent.children("div").each(function () {
            var element = $(this), p = element.find("p"), i;

            if (0 === p.length) {
              p = $("<p></p>");

              if (this.attributes.length > 0) {
                for (i = 0; i < this.attributes.length; i += 1) {
                  p.attr(this.attributes[i].name, element.attr(this.attributes[i].name));
                }
              }

              p.append(element.html());

              element.replaceWith(p);
            }
          });
          
          content = newContent.html();
        }

        $(this.original).val(content).change();

        if (this.options.events && this.options.events.save) {
          this.options.events.save.call(this);
        }
      }

      return this;
    };

    this.setContent = function (newContent) {
      this.editorDoc.body.innerHTML = newContent;
      this.saveContent();

      return this;
    };

    this.triggerControl = function (name, control) {
      var cmd = control.command || name,              //command directly for designMode=on iframe (this.editorDoc)
        args = control["arguments"] || [];

      if (control.exec) {
        control.exec.apply(this);  //custom exec function in control, allows DOM changing
      } else {
        this.ui.focus();
        this.ui.withoutCss(); //disable style="" attr inserting in mozzila's designMode
        // when click <Cut>, <Copy> or <Paste> got "Access to XPConnect service denied" code: "1011"
        // in Firefox untrusted JavaScript is not allowed to access the clipboard
        try {
          this.editorDoc.execCommand(cmd, false, args);
        } catch (e) {
          console.error(e);
        }
      }

      if (this.options.autoSave) {
        this.autoSaveFunction();
      }
    };

    this.triggerControlCallback = function (name) {
      $(window).trigger("trigger-" + name + ".wysiwyg", [this]);
    };

    this.ui.withoutCss = function () {
      var self = this.self;

      if ($.browser.mozilla) {
        try {
          self.editorDoc.execCommand("styleWithCSS", false, false);
        } catch (e) {
          try {
            self.editorDoc.execCommand("useCSS", false, true);
          } catch (e2) {
          }
        }
      }

      return self;
    };

    this.wrapInitialContent = function () {
      var content = this.initialContent;
      return content;
    };
  }

  /*
   * Wysiwyg namespace: public properties and methods
   */
  $.wysiwyg = {
    messages: {
      noObject: "Something goes wrong, check object"
    },

    /**
     * Custom control support by Alec Gorge ( http://github.com/alecgorge )
     */
    addControl: function (object, name, settings) {
      return object.each(function () {
        var oWysiwyg = $(this).data("wysiwyg"),
          customControl = {},
          toolbar;

        if (!oWysiwyg) {
          return this;
        }

        customControl[name] = $.extend(true, {visible: true, custom: true}, settings);
        $.extend(true, oWysiwyg.options.controls, customControl);

        // render new toolbar
        toolbar = $(oWysiwyg.options.toolbarHtml);
        oWysiwyg.ui.toolbar.replaceWith(toolbar);
        oWysiwyg.ui.toolbar = toolbar;
        oWysiwyg.ui.appendControls();
      });
    },

    clear: function (object) {
      return object.each(function () {
        var oWysiwyg = $(this).data("wysiwyg");

        if (!oWysiwyg) {
          return this;
        }

        oWysiwyg.setContent("");
      });
    },

    console: console, // let our console be available for extensions

    destroy: function (object) {
      return object.each(function () {
        var oWysiwyg = $(this).data("wysiwyg");

        if (!oWysiwyg) {
          return this;
        }

        oWysiwyg.destroy();
      });
    },

    "document": function (object) {
      // no chains because of return
      var oWysiwyg = object.data("wysiwyg");

      if (!oWysiwyg) {
        return undefined;
      }

      return $(oWysiwyg.editorDoc);
    },

    getContent: function (object) {
      // no chains because of return
      var oWysiwyg = object.data("wysiwyg");

      if (!oWysiwyg) {
        return undefined;
      }

      return oWysiwyg.getContent();
    },
    
        getSelection: function (object) {
        // no chains because of return
      var oWysiwyg = object.data("wysiwyg");

      if (!oWysiwyg) {
        return undefined;
      }

      return oWysiwyg.getRangeText();
    },

    init: function (object, options) {
      return object.each(function () {
        var opts = $.extend(true, {}, options),
          obj;

        // :4fun:
        // remove this textarea validation and change line in this.saveContent function
        // $(this.original).val(content); to $(this.original).html(content);
        // now you can make WYSIWYG editor on h1, p, and many more tags
        if (("textarea" !== this.nodeName.toLowerCase()) || $(this).data("wysiwyg")) {
          return;
        }

        obj = new Wysiwyg();
        obj.init(this, opts);
        $.data(this, "wysiwyg", obj);

        $(obj.editorDoc).trigger("afterInit.wysiwyg");
      });
    },

    insertHtml: function (object, szHTML) {
      return object.each(function () {
        var oWysiwyg = $(this).data("wysiwyg");

        if (!oWysiwyg) {
          return this;
        }

        oWysiwyg.insertHtml(szHTML);
      });
    },

    plugin: {
      listeners: {},

      bind: function (Wysiwyg) {
        var self = this;

        $.each(this.listeners, function (action, handlers) {
          var i, plugin;

          for (i = 0; i < handlers.length; i += 1) {
            plugin = self.parseName(handlers[i]);

            $(Wysiwyg.editorDoc).bind(action + ".wysiwyg", {plugin: plugin}, function (event) {
              $.wysiwyg[event.data.plugin.name][event.data.plugin.method].apply($.wysiwyg[event.data.plugin.name], [Wysiwyg]);
            });
          }
        });
      },

      exists: function (name) {
        var plugin;

        if ("string" !== typeof (name)) {
          return false;
        }

        plugin = this.parseName(name);

        if (!$.wysiwyg[plugin.name] || !$.wysiwyg[plugin.name][plugin.method]) {
          return false;
        }

        return true;
      },

      listen: function (action, handler) {
        var plugin;

        plugin = this.parseName(handler);

        if (!$.wysiwyg[plugin.name] || !$.wysiwyg[plugin.name][plugin.method]) {
          return false;
        }

        if (!this.listeners[action]) {
          this.listeners[action] = [];
        }

        this.listeners[action].push(handler);

        return true;
      },

      parseName: function (name) {
        var elements;

        if ("string" !== typeof (name)) {
          return false;
        }

        elements = name.split(".");

        if (2 > elements.length) {
          return false;
        }

        return {name: elements[0], method: elements[1]};
      },

      register: function (data) {
        if (!data.name) {
          console.error("Plugin name missing");
        }

        $.each($.wysiwyg, function (pluginName) {
          if (pluginName === data.name) {
            console.error("Plugin with name '" + data.name + "' was already registered");
          }
        });

        $.wysiwyg[data.name] = data;

        return true;
      }
    },

    removeFormat: function (object) {
      return object.each(function () {
        var oWysiwyg = $(this).data("wysiwyg");

        if (!oWysiwyg) {
          return this;
        }

        oWysiwyg.removeFormat();
      });
    },

    save: function (object) {
      return object.each(function () {
        var oWysiwyg = $(this).data("wysiwyg");

        if (!oWysiwyg) {
          return this;
        }

        oWysiwyg.saveContent();
      });
    },

    selectAll: function (object) {
      var oWysiwyg = object.data("wysiwyg"), oBody, oRange, selection;

      if (!oWysiwyg) {
        return this;
      }

      oBody = oWysiwyg.editorDoc.body;
      if (window.getSelection) {
        selection = oWysiwyg.getInternalSelection();
        selection.selectAllChildren(oBody);
      } else {
        oRange = oBody.createTextRange();
        oRange.moveToElementText(oBody);
        oRange.select();
      }
    },

    setContent: function (object, newContent) {
      return object.each(function () {
        var oWysiwyg = $(this).data("wysiwyg");

        if (!oWysiwyg) {
          return this;
        }

        oWysiwyg.setContent(newContent);
      });
    },

    triggerControl: function (object, controlName) {
      return object.each(function () {
        var oWysiwyg = $(this).data("wysiwyg");

        if (!oWysiwyg) {
          return this;
        }

        if (!oWysiwyg.controls[controlName]) {
          console.error("Control '" + controlName + "' not exists");
        }

        oWysiwyg.triggerControl.apply(oWysiwyg, [controlName, oWysiwyg.controls[controlName]]);
      });
    },

    support: {
      prop: supportsProp
    },

    utils: {
      extraSafeEntities: [["<", ">", "'", '"', " "], [32]],

      encodeEntities: function (str) {
        var self = this, aStr, aRet = [];

        if (this.extraSafeEntities[1].length === 0) {
          $.each(this.extraSafeEntities[0], function (i, ch) {
            self.extraSafeEntities[1].push(ch.charCodeAt(0));
          });
        }
        aStr = str.split("");
        $.each(aStr, function (i) {
          var iC = aStr[i].charCodeAt(0);
          if ($.inArray(iC, self.extraSafeEntities[1]) && (iC < 65 || iC > 127 || (iC > 90 && iC < 97))) {
            aRet.push('&#' + iC + ';');
          } else {
            aRet.push(aStr[i]);
          }
        });

        return aRet.join('');
      }
    }
  };

  /**
   * Unifies dialog methods to allow custom implementations
   * 
   * Events:
   *     * afterOpen
   *     * beforeShow
   *     * afterShow
   *     * beforeHide
   *     * afterHide
   *     * beforeClose
   *     * afterClose
   * 
   * Example:
   * var dialog = new ($.wysiwyg.dialog)($('#idToTextArea').data('wysiwyg'), {"title": "Test", "content": "form data, etc."});
   * 
   * dialog.bind("afterOpen", function () { alert('you should see a dialog behind this one!'); });
   * 
   * dialog.open();
   * 
   * 
   */
  $.wysiwyg.dialog = function (jWysiwyg, opts) {
    
    var theme = (jWysiwyg && jWysiwyg.options && jWysiwyg.options.dialog) ? jWysiwyg.options.dialog : (opts.theme ? opts.theme : "default"),
      obj   = new $.wysiwyg.dialog.createDialog(theme),
      that  = this,
      $that = $(that);
        
    this.options = {
      "modal": true,
      "draggable": true,
      "title": "Title",
      "content": "Content",
      "width":  "auto",
      "height": "auto",
      "zIndex": 2000,
      "open": false,
      "close": false
    };

    this.isOpen = false;

    $.extend(this.options, opts);

    this.object = obj;

    // Opens a dialog with the specified content
    this.open = function () {
      this.isOpen = true;

      obj.init.apply(that, []);
      var $dialog = obj.show.apply(that, []);

      $that.trigger("afterOpen", [$dialog]);
      
    };

    this.show = function () {
      this.isOpen = true;
      
      $that.trigger("beforeShow");
      
      var $dialog = obj.show.apply(that, []);
      
      $that.trigger("afterShow");
    };

    this.hide = function () {
      this.isOpen = false;
      
      $that.trigger("beforeHide");
      
      var $dialog = obj.hide.apply(that, []);
      
      $that.trigger("afterHide", [$dialog]);
    };

    // Closes the dialog window.
    this.close = function () {
      this.isOpen = false;
            
      var $dialog = obj.hide.apply(that, []);
      
      $that.trigger("beforeClose", [$dialog]);
      
      obj.destroy.apply(that, []);
      
      $that.trigger("afterClose", [$dialog]);

      jWysiwyg.ui.focus();
    };

    if (this.options.open) {
      $that.bind("afterOpen", this.options.open);
    }
    if (this.options.close) {
      $that.bind("afterClose", this.options.close);
    }

    return this;
  };

  // "Static" Dialog methods.
  $.extend(true, $.wysiwyg.dialog, {
    _themes : {}, // sample {"Theme Name": object}
    _theme : "", // the current theme

    register : function(name, obj) {
      $.wysiwyg.dialog._themes[name] = obj;
    },

    deregister : function (name) {
      delete $.wysiwyg.dialog._themes[name];
    },

    createDialog : function (name) {
      return new ($.wysiwyg.dialog._themes[name]);
    },
    
    getDimensions : function () {
      var width  = document.body.scrollWidth,
        height = document.body.scrollHeight;

      if ($.browser.opera) {
        height = Math.max(
          $(document).height(),
          $(window).height(),
          document.documentElement.clientHeight);
      }

      return [width, height];
    }
  });

  $(function () { // need access to jQuery UI stuff.
    if (jQuery.ui) {
      $.wysiwyg.dialog.register("jqueryui", function () {
        var that = this;

        this._$dialog = null;

        this.init = function() {
          var abstractDialog  = this,
            content     = this.options.content;

          if (typeof content === 'object') {
            if (typeof content.html === 'function') {
              content = content.html();
            } else if(typeof content.toString === 'function') {
              content = content.toString();
            }
          }

          that._$dialog = $('<div></div>').attr('title', this.options.title).html(content);

          var dialogHeight = this.options.height == 'auto' ? 300 : this.options.height,
            dialogWidth = this.options.width == 'auto' ? 450 : this.options.width;

          // console.log(that._$dialog);
          
          that._$dialog.dialog({
            modal: this.options.modal,
            draggable: this.options.draggable,
            height: dialogHeight,
            width: dialogWidth
          });

          return that._$dialog;
        };

        this.show = function () {
          that._$dialog.dialog("open");
          return that._$dialog;
        };

        this.hide = function () {
          that._$dialog.dialog("close");
          return that._$dialog;
        };

        this.destroy = function() {
          that._$dialog.dialog("destroy");
          return that._$dialog;
        };
      });
    }

    $.wysiwyg.dialog.register("default", function () {
      var that = this;

      this._$dialog = null;

      this.init = function() {
        var abstractDialog  = this,
          content     = this.options.content;

        if (typeof content === 'object') {
          if(typeof content.html === 'function') {
            content = content.html();
          }
          else if(typeof content.toString === 'function') {
            content = content.toString();
          }
        }

        that._$dialog = $('<div class="wysiwyg-dialog"></div>').css({"z-index": this.options.zIndex});

        var $topbar = $('<div class="wysiwyg-dialog-topbar"><div class="wysiwyg-dialog-close-wrapper"></div><div class="wysiwyg-dialog-title">'+this.options.title+'</div></div>');
        var $link = $('<a href="#" class="wysiwyg-dialog-close-button">X</a>');

        $link.click(function () {
          abstractDialog.close(); // this is important it makes sure that is close from the abstract $.wysiwyg.dialog instace, not just locally 
        });
        
        $topbar.find('.wysiwyg-dialog-close-wrapper').prepend($link);

        var $dcontent = $('<div class="wysiwyg-dialog-content">'+content+'</div>');

        that._$dialog.append($topbar).append($dcontent);
        
        // Set dialog's height & width, and position it correctly:
        var dialogHeight = this.options.height == 'auto' ? 300 : this.options.height,
          dialogWidth = this.options.width == 'auto' ? 450 : this.options.width;
        that._$dialog.hide().css({
          "width": dialogWidth,
          "height": dialogHeight,
          "left": (($(window).width() - dialogWidth) / 2),
          "top": (($(window).height() - dialogHeight) / 3)
        });

        $("body").append(that._$dialog);

        return that._$dialog;
      };

      this.show = function () {

        // Modal feature:
        if (this.options.modal) {
          var dimensions = $.wysiwyg.dialog.getDimensions(),
            wrapper    = $('<div class="wysiwyg-dialog-modal-div"></div>')
            .css({"width": dimensions[0], "height": dimensions[1]});
          that._$dialog.wrap(wrapper);
        }
        
        // Draggable feature:
        if (this.options.draggable) { 
          
          var mouseDown = false;
          
          that._$dialog.find("div.wysiwyg-dialog-topbar").bind("mousedown", function (e) {
            e.preventDefault();
            $(this).css({ "cursor": "move" });
            var $topbar = $(this),
              _dialog = $(this).parents(".wysiwyg-dialog"),
              offsetX = (e.pageX - parseInt(_dialog.css("left"), 10)),
              offsetY = (e.pageY - parseInt(_dialog.css("top"), 10));
            mouseDown = true;
            $(this).css({ "cursor": "move" });
            
            $(document).bind("mousemove", function (e) {
              e.preventDefault();
              if (mouseDown) {
                _dialog.css({
                  "top": (e.pageY - offsetY),
                  "left": (e.pageX - offsetX)
                });
              }
            }).bind("mouseup", function (e) {
              e.preventDefault();
              mouseDown = false;
              $topbar.css({ "cursor": "auto" });
              $(document).unbind("mousemove").unbind("mouseup");
            });
          
          });
        }
        
        that._$dialog.show();
        return that._$dialog;

      };

      this.hide = function () {
        that._$dialog.hide();
        return that._$dialog;
      };

      this.destroy = function() {
      
        // Modal feature:
        if (this.options.modal) { 
          that._$dialog.unwrap();
        }
        
        // Draggable feature:
        if (this.options.draggable) { 
          that._$dialog.find("div.wysiwyg-dialog-topbar").unbind("mousedown");
        }
        
        that._$dialog.remove();
        return that._$dialog;
      };
    });
  });
  // end Dialog

  $.fn.wysiwyg = function (method) {
    var args = arguments, plugin;

    if ("undefined" !== typeof $.wysiwyg[method]) {
      // set argument object to undefined
      args = Array.prototype.concat.call([args[0]], [this], Array.prototype.slice.call(args, 1));
      return $.wysiwyg[method].apply($.wysiwyg, Array.prototype.slice.call(args, 1));
    } else if ("object" === typeof method || !method) {
      Array.prototype.unshift.call(args, this);
      return $.wysiwyg.init.apply($.wysiwyg, args);
    } else if ($.wysiwyg.plugin.exists(method)) {
      plugin = $.wysiwyg.plugin.parseName(method);
      args = Array.prototype.concat.call([args[0]], [this], Array.prototype.slice.call(args, 1));
      return $.wysiwyg[plugin.name][plugin.method].apply($.wysiwyg[plugin.name], Array.prototype.slice.call(args, 1));
    } else {
      console.error("Method '" +  method + "' does not exist on jQuery.wysiwyg.\nTry to include some extra controls or plugins");
    }
  };
  
  $.fn.getWysiwyg = function () {
    return this.data("wysiwyg");
  };
})(jQuery);
/**
 * insertContent puts html at the current caret position
 * Depends on jWYSIWYG
 */

(function ($) {
	"use strict";

	if (undefined === $.wysiwyg) {
		throw "wysiwyg.table.js depends on $.wysiwyg";
	}

	if (!$.wysiwyg.controls) {
		$.wysiwyg.controls = {};
	}


	$.wysiwyg.insertContent = function (object, content) {
		return object.each(function () {
			var Wysiwyg = $(this).data("wysiwyg");
			if (!Wysiwyg) {
				return this;
			}
			Wysiwyg.insertHtml(content)
			//Wysiwyg.editorDoc.execCommand("insertHTML", true, content)
			//$(Wysiwyg.editorDoc).trigger("editorRefresh.wysiwyg");

			return this;
		});
	};
})(jQuery);
// Manifest file for including codemirror2 and jquery.wysiwyg plugins









;
/* Placeholders is a simple polyfill for the HTML5 "placeholder" attribute. The placeholder attribute can be used on input elements of certain types
 * and provides a short hint (such as a sample value or a brief description) intended to aid the user with data entry. This polyfill has been tested
 * and functions correctly in Internet Explorer 6 and above, Firefox 3.6 and above, Safari 3.2 and above, Opera 9 and above and Chrome 16 and above.
 * The script will be tested in further browsers in due course and the above list edited accordingly.
 *
 * User agents should display the value of the placeholder attribute when the element's value is the empty string and the element does not
 * have focus. The user agents that have implemented support for this attribute all display the placeholder inside the element, as if it were
 * the element's value, in a light grey colour to differentiate between placeholder text and value text.
 *
 * The Placeholders polyfill attempts to replicate the functionality of compliant user agents so that non-compliant user agents will still function
 * as expected when faced with a "placeholder" attribute.
 * 
 * The script is unobtrusive and will only apply if the placeholder attribute is not supported by the user agent in which it is running. To use a placeholder
 * simply add the "placeholder" attribute to a supporting input element:
 *
 * <input type="text" placeholder="Placeholder text">
 *
 * To get this placeholder to function in non-supporting user agents simply call the init method when appropriate (the DOM must be ready for manipulation,
 * unless the "live" argument is true):
 *
 * Placeholders.init();
 *
 * The init method accepts one argument, "live". If live is truthy, the polyfill will apply to all supported input elements now and in the future, and dynamic
 * changes to the placeholder attribute value will be reflected. If live is falsy, the polyfill will only apply to those elements with a placeholder attribute
 * value in the DOM at the time the method is executed. 
 *
 * If the live option is not used, the placeholders can be refreshed manually by calling Placeholders.refresh()
 *
 * Placeholders.JS: https://github.com/jamesallardice/Placeholders.js
 */

/*jslint browser: true */


var Placeholders = (function () {

	"use strict";

	/* List of input types that do not support the placeholder attribute. We don't want to modify any input elements with one of these types.
	 * WARNING: If an input type is not supported by a browser, the browser will choose the default type (text) and the placeholder shim will 
	 * apply */
	var invalidTypes = [
		"hidden",
		"datetime",
		"date",
		"month",
		"week",
		"time",
		"datetime-local",
		"range",
		"color",
		"checkbox",
		"radio",
		"file",
		"submit",
		"image",
		"reset",
		"button"
	],

	//"interval" will be used if "live" is true
		interval;

	/* The focusHandler function is executed when input elements with placeholder attributes receive a focus event. If necessary, the placeholder
	 * and its associated styles are removed from the element. */
	function focusHandler(elem) {

		//If the placeholder is currently visible, remove it and its associated styles
		if (elem.value === elem.getAttribute("placeholder")) {

			/* Remove the placeholder class name. Use a regular expression to ensure the string being searched for is a complete word, and not part of a longer
			 * string, on the off-chance a class name including that string also exists on the element */
			elem.className = elem.className.replace(/\bplaceholderspolyfill\b/, "");
			elem.value = "";
		}
	}

	/* The blurHandler function is executed when input elements with placeholder attributes receive a blur event. If necessary, the placeholder
	 * and its associated styles are applied to the element. */
	function blurHandler(elem) {

		//If the input value is the empty string, apply the placeholder and its associated styles
		if (elem.value === "") {
			elem.className = elem.className + " placeholderspolyfill";
			elem.value = elem.getAttribute("placeholder");
		}
	}

	/* The submitHandler function is executed when the containing form, if any, of a given input element is submitted. If necessary, placeholders on any
	 * input element descendants of the form are removed so that the placeholder value is not submitted as the element value. */
	function submitHandler(elem) {
		var inputs = elem.getElementsByTagName("input"),
			textareas = elem.getElementsByTagName("textarea"),
			numInputs = inputs.length,
			num = numInputs + textareas.length,
			element,
			placeholder,
			i;
		//Iterate over all descendant input elements and remove placeholder if necessary
		for (i = 0; i < num; i += 1) {
			element = (i < numInputs) ? inputs[i] : textareas[i - numInputs];
			placeholder = element.getAttribute("placeholder");

			//If the value of the input is equal to the value of the placeholder attribute we need to clear the value
			if (element.value === placeholder) {
				element.value = "";
			}
		}
	}

	//The addEventListeners function binds focus and blur event listeners to the specified input or textarea element.
	function addEventListeners(element) {
		if (element.addEventListener) {
			/* Attach event listeners (W3C style. Anonymous event handler used to be consistent with Microsoft style and make it easier to refer
			 * to element in actual handler function */
			element.addEventListener("focus", function () {
				focusHandler(element);
			}, false);
			element.addEventListener("blur", function () {
				blurHandler(element);
			}, false);
		} else if (element.attachEvent) {
			/* Attach event listeners (Microsoft style - since IE < 9 does not bind the value of "this" to the element that triggered the event,
			 * we need to call the real event handler from an anonymous event handler function and pass in the element) */
			element.attachEvent("onfocus", function () {
				focusHandler(element);
			});
			element.attachEvent("onblur", function () {
				blurHandler(element);
			});
		}
	}

	/* The updatePlaceholders function checks all input and textarea elements and updates the placeholder if necessary. Elements that have been
	 * added to the DOM since the call to createPlaceholders will not function correctly until this function is executed. The same goes for
	 * any existing elements whose placeholder property has been changed (via element.setAttribute("placeholder", "new") for example) */
	function updatePlaceholders() {

		//Declare variables, get references to all input and textarea elements
		var inputs = document.getElementsByTagName("input"),
			textareas = document.getElementsByTagName("textarea"),
			numInputs = inputs.length,
			num = numInputs + textareas.length,
			i,
			element,
			oldPlaceholder,
			newPlaceholder;

		//Iterate over all input and textarea elements and apply/update the placeholder polyfill if necessary
		for (i = 0; i < num; i += 1) {

			//Get the next element from either the input NodeList or the textarea NodeList, depending on how many elements we've already looped through
			element = (i < numInputs) ? inputs[i] : textareas[i - numInputs];

			//Get the value of the placeholder attribute
			newPlaceholder = element.getAttribute("placeholder");

			//Check whether the current input element is of a type that supports the placeholder attribute
			if (invalidTypes.indexOf(element.type) === -1) {

				//The input type does support the placeholder attribute. Check whether the placeholder attribute has a value
				if (newPlaceholder) {

					//The placeholder attribute has a value. Get the value of the current placeholder data-* attribute
					oldPlaceholder = element.getAttribute("data-currentplaceholder");

					//Check whether the placeholder attribute value has changed
					if (newPlaceholder !== oldPlaceholder) {

						//The placeholder attribute value has changed so we need to update. Check whether the placeholder should currently be visible.
						if (element.value === oldPlaceholder || element.value === newPlaceholder || !element.value) {

							//The placeholder should be visible so change the element value to that of the placeholder attribute and set placeholder styles
							element.value = newPlaceholder;
							element.className = element.className + " placeholderspolyfill";
						}

						//If the current placeholder data-* attribute has no value the element wasn't present in the DOM when event handlers were bound, so bind them now
						if (!oldPlaceholder) {
							addEventListeners(element);
						}

						//Update the value of the current placeholder data-* attribute to reflect the new placeholder value
						element.setAttribute("data-currentplaceholder", newPlaceholder);
					}
				}
			}
		}
	}

	/* Make form submit event handler (using factory function to avoid JSLint error) */
	function makeSubmitHandler(form) {
		return function () {
			submitHandler(form);
		};
	}

	/* The createPlaceholders function checks all input and textarea elements currently in the DOM for the placeholder attribute. If the attribute
	 * is present, and the element is of a type (e.g. text) that allows the placeholder attribute, it attaches the appropriate event listeners
	 * to the element and if necessary sets its value to that of the placeholder attribute */
	function createPlaceholders() {

		//Declare variables and get references to all input and textarea elements
		var inputs = document.getElementsByTagName("input"),
			textareas = document.getElementsByTagName("textarea"),
			numInputs = inputs.length,
			num = numInputs + textareas.length,
			i,
			element,
			form,
			placeholder;

		//Iterate over all input elements and apply placeholder polyfill if necessary
		for (i = 0; i < num; i += 1) {

			//Get the next element from either the input NodeList or the textarea NodeList, depending on how many elements we've already looped through
			element = (i < numInputs) ? inputs[i] : textareas[i - numInputs];

			//Get the value of the placeholder attribute
			placeholder = element.getAttribute("placeholder");

			//Check whether or not the current element is of a type that allows the placeholder attribute
			if (invalidTypes.indexOf(element.type) === -1) {

				//The input type does support placeholders. Check that the placeholder attribute has been given a value
				if (placeholder) {

					//The placeholder attribute has a value. Keep track of the current placeholder value in an HTML5 data-* attribute
					element.setAttribute("data-currentplaceholder", placeholder);

					//If the value of the element is the empty string set the value to that of the placeholder attribute and apply the placeholder styles
					if (element.value === "" || element.value === placeholder) {
						element.className = element.className + " placeholderspolyfill";
						element.value = placeholder;
					}

					//If the element has a containing form bind to the submit event so we can prevent placeholder values being submitted as actual values
					if (element.form) {

						//Get a reference to the containing form element (if present)
						form = element.form;

						//The placeholdersubmit data-* attribute is set if this form has already been dealt with
						if (!form.getAttribute("data-placeholdersubmit")) {
							if (form.addEventListener) {
								//The placeholdersubmit attribute wasn't set, so attach a submit event handler (W3C standard style)
								form.addEventListener("submit", makeSubmitHandler(form), false);
							} else if (form.attachEvent) {
								//The placeholdersubmit attribute wasn't set, so attach a submit event handler (Microsoft IE < 9 style)
								form.attachEvent("onsubmit", makeSubmitHandler(form));
							}

							//Set the placeholdersubmit attribute so we don't repeatedly bind event handlers to this form element
							form.setAttribute("data-placeholdersubmit", "true");
						}
					}

					/* Attach event listeners to this element. If the event handlers were bound here, and not in a separate function,
					 * we would need to wrap the loop body in a closure to preserve the value of element for each iteration. */
					addEventListeners(element);
				}
			}
		}
	}

	/* The init function checks whether or not we need to polyfill the placeholder functionality. If we do, it sets up various things
	 * needed throughout the script and then calls createPlaceholders to setup initial placeholders */
	function init(live) {

		//Create an input element to test for the presence of the placeholder property. If the placeholder property exists, stop.
		var test = document.createElement("input"),
			styleElem,
			styleRules,
			i,
			j;

		//Test input element for presence of placeholder property. If it doesn't exist, the browser does not support HTML5 placeholders
		if (typeof test.placeholder === "undefined") {
			//HTML5 placeholder attribute not supported.

			//Create style element for placeholder styles
			styleElem = document.createElement("style");
			styleElem.type = "text/css";

			//Create style rules as text node
			styleRules = document.createTextNode(".placeholderspolyfill { color:#999 !important; }");

			//Append style rules to newly created stylesheet
			if (styleElem.styleSheet) {
				styleElem.styleSheet.cssText = styleRules.nodeValue;
			} else {
				styleElem.appendChild(styleRules);
			}

			//Append new style element to the head
			document.getElementsByTagName("head")[0].appendChild(styleElem);

			//We use Array.prototype.indexOf later, so make sure it exists
			if (!Array.prototype.indexOf) {
				Array.prototype.indexOf = function (obj, start) {
					for (i = (start || 0), j = this.length; i < j; i += 1) {
						if (this[i] === obj) { return i; }
					}
					return -1;
				};
			}

			//Create placeholders for input elements currently part of the DOM
			createPlaceholders();

			/* If the live argument is truthy, call updatePlaceholders repeatedly to keep up to date with any DOM changes.
			 * We use an interval over events such as DOMAttrModified (which are used in some other implementations of the placeholder attribute)
			 * since the DOM level 2 mutation events are deprecated in the level 3 spec. */
			if (live) {
				interval = setInterval(updatePlaceholders, 100);
			}
		}

		//Placeholder attribute already supported by browser :)
		return false;
	}

	//Expose public methods
	return {
		init: init,
		refresh: updatePlaceholders,
		submitHandler: submitHandler
	};
}());
(function() {

  jQuery(function($) {
    return $(function() {
      var HTMLCloner;
      return window.HTMLCloner = HTMLCloner = (function() {

        function HTMLCloner(args) {
          this.origin = args['origin'];
          this.success = args['success'];
          this.error = args['error'];
          this.redirects = [];
        }

        HTMLCloner.prototype.fixURL = function(url) {
          if (url.match(/https:\/\//)) {
            return url;
          }
          if (!url.match(/\w+:\/\//)) {
            return 'http://' + url;
          }
          return url;
        };

        HTMLCloner.prototype.cloneURL = function(args) {
          args[0]['value'] = this.fixURL(args[0]['value']);
          return $.ajax({
            type: 'POST',
            url: this.origin,
            data: $.param(args),
            dataType: 'json',
            success: this.success,
            error: this.error
          });
        };

        return HTMLCloner;

      })();
    });
  });

}).call(this);
// shim for DOMParser in ie9
"use strict";

(function ($, undefined) {
  var dom_parser = false;

  // based on: https://developer.mozilla.org/en/DOMParser
  // does not work with IE < 9
  // Firefox/Opera/IE throw errors on unsupported types
  try {
    // WebKit returns null on unsupported types
    if ((new DOMParser()).parseFromString("", "text/html")) {
      // text/html parsing is natively supported
      dom_parser = true;
    }
  } catch (ex) {}

  if (dom_parser) {
    $.parseHTMLContent = function (html) {
      return new DOMParser().parseFromString(html, "text/html");
    };
  }
  else if (document.implementation && document.implementation.createHTMLDocument) {
    $.parseHTMLContent = function (html) {
      var doc = document.implementation.createHTMLDocument("");
      var doc_el = doc.documentElement;

      $(doc_el).html(html);

      var els = [], el = doc_el.firstChild;

      while (el) {
        if (el.nodeType === 1) els.push(el);
        el = el.nextSibling;
      }

        // are we dealing with an entire document or a fragment?
      if (els.length === 1 && els[0].localName.toLowerCase() === "html") {
        doc.removeChild(doc_el);
        el = doc_el.firstChild;
        while (el) {
          var next = el.nextSibling;
          doc.appendChild(el);
          el = next;
        }
      }
      else {
        el = doc_el.firstChild;
        while (el) {
          var next = el.nextSibling;
          if (el.nodeType !== 1 && el.nodeType !== 3) doc.insertBefore(el,doc_el);
          el = next;
        }
      }

      return doc;
    };
  }

  $.fn.outerHTML = function(){
    // IE, Chrome & Safari will comply with the non-standard outerHTML, all others (FF) will have a fall-back for cloning
    return (!this.length) ? this : (this[0].outerHTML || (
      function(el){
        var div = document.createElement('div');
        div.appendChild(el.cloneNode(true));
        var contents = div.innerHTML;
        div = null;
        return contents;
      })(this[0])
    );
}
})(jQuery);
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
(function() {

  jQuery(function($) {
    return window.renderPortableFileEdit = function() {
      var $config, $fileInputs, $form, fileFormatSearch, moduleInitialConfig, modulePath, moduleTitle, workspace;
      $form = $('.ui-tabs-wrap:visible form');
      workspace = WORKSPACE_ID;
      fileFormatSearch = null;
      modulePath = $('meta[name=module-path]', $form).attr('content');
      moduleTitle = $('meta[name=module-title]', $form).attr('content');
      moduleInitialConfig = $.parseJSON($('meta[name=module-data]', $form).attr('content'));
      $config = $('.exploit-module-config', $form);
      $fileInputs = $('.file li#social_engineering_portable_file_file_generation_type_input input', $form);
      $fileInputs.change(function(e) {
        var className;
        if (!$(this).filter(':checked')) {
          return;
        }
        className = $fileInputs.filter(':checked').last().val();
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
            paramWrapName: 'social_engineering_portable_file'
          }));
          fileFormatSearch.activate();
          return modulePath = moduleTitle = moduleInitialConfig = null;
        }
      });
      return $fileInputs.change();
    };
  });

}).call(this);
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
/*
 Copyright 2012 Igor Vaynberg

 Version: 3.2 Timestamp: Mon Sep 10 10:38:04 PDT 2012

 Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in
 compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under the License is
 distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and limitations under the License.
 */

 (function ($) {
 	if(typeof $.fn.each2 == "undefined"){
 		$.fn.extend({
 			/*
			* 4-10 times faster .each replacement
			* use it carefully, as it overrides jQuery context of element on each iteration
			*/
			each2 : function (c) {
				var j = $([0]), i = -1, l = this.length;
				while (
					++i < l
					&& (j.context = j[0] = this[i])
					&& c.call(j[0], i, j) !== false //"this"=DOM, i=index, j=jQuery object
				);
				return this;
			}
 		});
 	}
})(jQuery);

(function ($, undefined) {
    "use strict";
    /*global document, window, jQuery, console */

    if (window.Select2 !== undefined) {
        return;
    }

    var KEY, AbstractSelect2, SingleSelect2, MultiSelect2, nextUid, sizer;

    KEY = {
        TAB: 9,
        ENTER: 13,
        ESC: 27,
        SPACE: 32,
        LEFT: 37,
        UP: 38,
        RIGHT: 39,
        DOWN: 40,
        SHIFT: 16,
        CTRL: 17,
        ALT: 18,
        PAGE_UP: 33,
        PAGE_DOWN: 34,
        HOME: 36,
        END: 35,
        BACKSPACE: 8,
        DELETE: 46,
        isArrow: function (k) {
            k = k.which ? k.which : k;
            switch (k) {
            case KEY.LEFT:
            case KEY.RIGHT:
            case KEY.UP:
            case KEY.DOWN:
                return true;
            }
            return false;
        },
        isControl: function (e) {
            var k = e.which;
            switch (k) {
            case KEY.SHIFT:
            case KEY.CTRL:
            case KEY.ALT:
                return true;
            }

            if (e.metaKey) return true;

            return false;
        },
        isFunctionKey: function (k) {
            k = k.which ? k.which : k;
            return k >= 112 && k <= 123;
        }
    };

    nextUid=(function() { var counter=1; return function() { return counter++; }; }());

    function indexOf(value, array) {
        var i = 0, l = array.length, v;

        if (typeof value === "undefined") {
          return -1;
        }

        if (value.constructor === String) {
            for (; i < l; i = i + 1) if (value.localeCompare(array[i]) === 0) return i;
        } else {
            for (; i < l; i = i + 1) {
                v = array[i];
                if (v.constructor === String) {
                    if (v.localeCompare(value) === 0) return i;
                } else {
                    if (v === value) return i;
                }
            }
        }
        return -1;
    }

    /**
     * Compares equality of a and b taking into account that a and b may be strings, in which case localeCompare is used
     * @param a
     * @param b
     */
    function equal(a, b) {
        if (a === b) return true;
        if (a === undefined || b === undefined) return false;
        if (a === null || b === null) return false;
        if (a.constructor === String) return a.localeCompare(b) === 0;
        if (b.constructor === String) return b.localeCompare(a) === 0;
        return false;
    }

    /**
     * Splits the string into an array of values, trimming each value. An empty array is returned for nulls or empty
     * strings
     * @param string
     * @param separator
     */
    function splitVal(string, separator) {
        var val, i, l;
        if (string === null || string.length < 1) return [];
        val = string.split(separator);
        for (i = 0, l = val.length; i < l; i = i + 1) val[i] = $.trim(val[i]);
        return val;
    }

    function getSideBorderPadding(element) {
        return element.outerWidth() - element.width();
    }

    function installKeyUpChangeEvent(element) {
        var key="keyup-change-value";
        element.bind("keydown", function () {
            if ($.data(element, key) === undefined) {
                $.data(element, key, element.val());
            }
        });
        element.bind("keyup", function () {
            var val= $.data(element, key);
            if (val !== undefined && element.val() !== val) {
                $.removeData(element, key);
                element.trigger("keyup-change");
            }
        });
    }

    $(document).delegate("body", "mousemove", function (e) {
        $.data(document, "select2-lastpos", {x: e.pageX, y: e.pageY});
    });

    /**
     * filters mouse events so an event is fired only if the mouse moved.
     *
     * filters out mouse events that occur when mouse is stationary but
     * the elements under the pointer are scrolled.
     */
    function installFilteredMouseMove(element) {
	    element.bind("mousemove", function (e) {
            var lastpos = $.data(document, "select2-lastpos");
            if (lastpos === undefined || lastpos.x !== e.pageX || lastpos.y !== e.pageY) {
                $(e.target).trigger("mousemove-filtered", e);
            }
        });
    }

    /**
     * Debounces a function. Returns a function that calls the original fn function only if no invocations have been made
     * within the last quietMillis milliseconds.
     *
     * @param quietMillis number of milliseconds to wait before invoking fn
     * @param fn function to be debounced
     * @param ctx object to be used as this reference within fn
     * @return debounced version of fn
     */
    function debounce(quietMillis, fn, ctx) {
        ctx = ctx || undefined;
        var timeout;
        return function () {
            var args = arguments;
            window.clearTimeout(timeout);
            timeout = window.setTimeout(function() {
                fn.apply(ctx, args);
            }, quietMillis);
        };
    }

    /**
     * A simple implementation of a thunk
     * @param formula function used to lazily initialize the thunk
     * @return {Function}
     */
    function thunk(formula) {
        var evaluated = false,
            value;
        return function() {
            if (evaluated === false) { value = formula(); evaluated = true; }
            return value;
        };
    };

    function installDebouncedScroll(threshold, element) {
        var notify = debounce(threshold, function (e) { element.trigger("scroll-debounced", e);});
        element.bind("scroll", function (e) {
            if (indexOf(e.target, element.get()) >= 0) notify(e);
        });
    }

    function killEvent(event) {
        event.preventDefault();
        event.stopPropagation();
    }

    function measureTextWidth(e) {
        if (!sizer){
        	var style = e[0].currentStyle || window.getComputedStyle(e[0], null);
        	sizer = $("<div></div>").css({
	            position: "absolute",
	            left: "-10000px",
	            top: "-10000px",
	            display: "none",
	            fontSize: style.fontSize,
	            fontFamily: style.fontFamily,
	            fontStyle: style.fontStyle,
	            fontWeight: style.fontWeight,
	            letterSpacing: style.letterSpacing,
	            textTransform: style.textTransform,
	            whiteSpace: "nowrap"
	        });
        	$("body").append(sizer);
        }
        sizer.text(e.val());
        return sizer.width();
    }

    function markMatch(text, term, markup) {
        var match=text.toUpperCase().indexOf(term.toUpperCase()),
            tl=term.length;

        if (match<0) {
            markup.push(text);
            return;
        }

        markup.push(text.substring(0, match));
        markup.push("<span class='select2-match'>");
        markup.push(text.substring(match, match + tl));
        markup.push("</span>");
        markup.push(text.substring(match + tl, text.length));
    }

    /**
     * Produces an ajax-based query function
     *
     * @param options object containing configuration paramters
     * @param options.transport function that will be used to execute the ajax request. must be compatible with parameters supported by $.ajax
     * @param options.url url for the data
     * @param options.data a function(searchTerm, pageNumber, context) that should return an object containing query string parameters for the above url.
     * @param options.dataType request data type: ajax, jsonp, other datatatypes supported by jQuery's $.ajax function or the transport function if specified
     * @param options.traditional a boolean flag that should be true if you wish to use the traditional style of param serialization for the ajax request
     * @param options.quietMillis (optional) milliseconds to wait before making the ajaxRequest, helps debounce the ajax function if invoked too often
     * @param options.results a function(remoteData, pageNumber) that converts data returned form the remote request to the format expected by Select2.
     *      The expected format is an object containing the following keys:
     *      results array of objects that will be used as choices
     *      more (optional) boolean indicating whether there are more results available
     *      Example: {results:[{id:1, text:'Red'},{id:2, text:'Blue'}], more:true}
     */
    function ajax(options) {
        var timeout, // current scheduled but not yet executed request
            requestSequence = 0, // sequence used to drop out-of-order responses
            handler = null,
            quietMillis = options.quietMillis || 100;

        return function (query) {
            window.clearTimeout(timeout);
            timeout = window.setTimeout(function () {
                requestSequence += 1; // increment the sequence
                var requestNumber = requestSequence, // this request's sequence number
                    data = options.data, // ajax data function
                    transport = options.transport || $.ajax,
                    traditional = options.traditional || false,
                    type = options.type || 'GET'; // set type of request (GET or POST)

                data = data.call(this, query.term, query.page, query.context);

                if( null !== handler) { handler.abort(); }

                handler = transport.call(null, {
                    url: options.url,
                    dataType: options.dataType,
                    data: data,
                    type: type,
                    traditional: traditional,
                    success: function (data) {
                        if (requestNumber < requestSequence) {
                            return;
                        }
                        // TODO 3.0 - replace query.page with query so users have access to term, page, etc.
                        var results = options.results(data, query.page);
                        query.callback(results);
                    }
                });
            }, quietMillis);
        };
    }

    /**
     * Produces a query function that works with a local array
     *
     * @param options object containing configuration parameters. The options parameter can either be an array or an
     * object.
     *
     * If the array form is used it is assumed that it contains objects with 'id' and 'text' keys.
     *
     * If the object form is used ti is assumed that it contains 'data' and 'text' keys. The 'data' key should contain
     * an array of objects that will be used as choices. These objects must contain at least an 'id' key. The 'text'
     * key can either be a String in which case it is expected that each element in the 'data' array has a key with the
     * value of 'text' which will be used to match choices. Alternatively, text can be a function(item) that can extract
     * the text.
     */
    function local(options) {
        var data = options, // data elements
            dataText,
            text = function (item) { return ""+item.text; }; // function used to retrieve the text portion of a data item that is matched against the search

        if (!$.isArray(data)) {
            text = data.text;
            // if text is not a function we assume it to be a key name
            if (!$.isFunction(text)) {
              dataText = data.text; // we need to store this in a separate variable because in the next step data gets reset and data.text is no longer available
              text = function (item) { return item[dataText]; };
            }
            data = data.results;
        }

        return function (query) {
            var t = query.term, filtered = { results: [] }, process;
            if (t === "") {
                query.callback({results: data});
                return;
            }

            process = function(datum, collection) {
                var group, attr;
                datum = datum[0];
                if (datum.children) {
                    group = {};
                    for (attr in datum) {
                        if (datum.hasOwnProperty(attr)) group[attr]=datum[attr];
                    }
                    group.children=[];
                    $(datum.children).each2(function(i, childDatum) { process(childDatum, group.children); });
                    if (group.children.length) {
                        collection.push(group);
                    }
                } else {
                    if (query.matcher(t, text(datum))) {
                        collection.push(datum);
                    }
                }
            };

            $(data).each2(function(i, datum) { process(datum, filtered.results); });
            query.callback(filtered);
        };
    }

    // TODO javadoc
    function tags(data) {
        // TODO even for a function we should probably return a wrapper that does the same object/string check as
        // the function for arrays. otherwise only functions that return objects are supported.
        if ($.isFunction(data)) {
            return data;
        }

        // if not a function we assume it to be an array

        return function (query) {
            var t = query.term, filtered = {results: []};
            $(data).each(function () {
                var isObject = this.text !== undefined,
                    text = isObject ? this.text : this;
                if (t === "" || query.matcher(t, text)) {
                    filtered.results.push(isObject ? this : {id: this, text: this});
                }
            });
            query.callback(filtered);
        };
    }

    /**
     * Checks if the formatter function should be used.
     *
     * Throws an error if it is not a function. Returns true if it should be used,
     * false if no formatting should be performed.
     *
     * @param formatter
     */
    function checkFormatter(formatter, formatterName) {
        if ($.isFunction(formatter)) return true;
        if (!formatter) return false;
        throw new Error("formatterName must be a function or a falsy value");
    }

    function evaluate(val) {
        return $.isFunction(val) ? val() : val;
    }

    function countResults(results) {
        var count = 0;
        $.each(results, function(i, item) {
            if (item.children) {
                count += countResults(item.children);
            } else {
                count++;
            }
        });
        return count;
    }

    /**
     * Default tokenizer. This function uses breaks the input on substring match of any string from the
     * opts.tokenSeparators array and uses opts.createSearchChoice to create the choice object. Both of those
     * two options have to be defined in order for the tokenizer to work.
     *
     * @param input text user has typed so far or pasted into the search field
     * @param selection currently selected choices
     * @param selectCallback function(choice) callback tho add the choice to selection
     * @param opts select2's opts
     * @return undefined/null to leave the current input unchanged, or a string to change the input to the returned value
     */
    function defaultTokenizer(input, selection, selectCallback, opts) {
        var original = input, // store the original so we can compare and know if we need to tell the search to update its text
            dupe = false, // check for whether a token we extracted represents a duplicate selected choice
            token, // token
            index, // position at which the separator was found
            i, l, // looping variables
            separator; // the matched separator

        if (!opts.createSearchChoice || !opts.tokenSeparators || opts.tokenSeparators.length < 1) return undefined;

        while (true) {
            index = -1;

            for (i = 0, l = opts.tokenSeparators.length; i < l; i++) {
                separator = opts.tokenSeparators[i];
                index = input.indexOf(separator);
                if (index >= 0) break;
            }

            if (index < 0) break; // did not find any token separator in the input string, bail

            token = input.substring(0, index);
            input = input.substring(index + separator.length);

            if (token.length > 0) {
                token = opts.createSearchChoice(token, selection);
                if (token !== undefined && token !== null && opts.id(token) !== undefined && opts.id(token) !== null) {
                    dupe = false;
                    for (i = 0, l = selection.length; i < l; i++) {
                        if (equal(opts.id(token), opts.id(selection[i]))) {
                            dupe = true; break;
                        }
                    }

                    if (!dupe) selectCallback(token);
                }
            }
        }

        if (original.localeCompare(input) != 0) return input;
    }

    /**
     * blurs any Select2 container that has focus when an element outside them was clicked or received focus
     *
     * also takes care of clicks on label tags that point to the source element
     */
    $(document).ready(function () {
        $(document).delegate("body", "mousedown touchend", function (e) {
            var target = $(e.target).closest("div.select2-container").get(0), attr;
            if (target) {
                $(document).find("div.select2-container-active").each(function () {
                    if (this !== target) $(this).data("select2").blur();
                });
            } else {
                target = $(e.target).closest("div.select2-drop").get(0);
                $(document).find("div.select2-drop-active").each(function () {
                    if (this !== target) $(this).data("select2").blur();
                });
            }

            target=$(e.target);
            attr = target.attr("for");
            if ("LABEL" === e.target.tagName && attr && attr.length > 0) {
                target = $("#"+attr);
                target = target.data("select2");
                if (target !== undefined) { target.focus(); e.preventDefault();}
            }
        });
    });

    /**
     * Creates a new class
     *
     * @param superClass
     * @param methods
     */
    function clazz(SuperClass, methods) {
        var constructor = function () {};
        constructor.prototype = new SuperClass;
        constructor.prototype.constructor = constructor;
        constructor.prototype.parent = SuperClass.prototype;
        constructor.prototype = $.extend(constructor.prototype, methods);
        return constructor;
    }

    AbstractSelect2 = clazz(Object, {

        // abstract
        bind: function (func) {
            var self = this;
            return function () {
                func.apply(self, arguments);
            };
        },

        // abstract
        init: function (opts) {
            var results, search, resultsSelector = ".select2-results";

            // prepare options
            this.opts = opts = this.prepareOpts(opts);

            this.id=opts.id;

            // destroy if called on an existing component
            if (opts.element.data("select2") !== undefined &&
                opts.element.data("select2") !== null) {
                this.destroy();
            }

            this.enabled=true;
            this.container = this.createContainer();

            this.containerId="s2id_"+(opts.element.attr("id") || "autogen"+nextUid());
            this.containerSelector="#"+this.containerId.replace(/([;&,\.\+\*\~':"\!\^#$%@\[\]\(\)=>\|])/g, '\\$1');
            this.container.attr("id", this.containerId);

            // cache the body so future lookups are cheap
            this.body = thunk(function() { return opts.element.closest("body"); });

            if (opts.element.attr("class") !== undefined) {
                this.container.addClass(opts.element.attr("class").replace(/validate\[[\S ]+] ?/, ''));
            }

            this.container.css(evaluate(opts.containerCss));
            this.container.addClass(evaluate(opts.containerCssClass));

            // swap container for the element
            this.opts.element
                .data("select2", this)
                .hide()
                .before(this.container);
            this.container.data("select2", this);

            this.dropdown = this.container.find(".select2-drop");
            this.dropdown.addClass(evaluate(opts.dropdownCssClass));
            this.dropdown.data("select2", this);

            this.results = results = this.container.find(resultsSelector);
            this.search = search = this.container.find("input.select2-input");

            search.attr("tabIndex", this.opts.element.attr("tabIndex"));

            this.resultsPage = 0;
            this.context = null;

            // initialize the container
            this.initContainer();
            this.initContainerWidth();

            installFilteredMouseMove(this.results);
            this.dropdown.delegate(resultsSelector, "mousemove-filtered", this.bind(this.highlightUnderEvent));

            installDebouncedScroll(80, this.results);
            this.dropdown.delegate(resultsSelector, "scroll-debounced", this.bind(this.loadMoreIfNeeded));

            // if jquery.mousewheel plugin is installed we can prevent out-of-bounds scrolling of results via mousewheel
            if ($.fn.mousewheel) {
                results.mousewheel(function (e, delta, deltaX, deltaY) {
                    var top = results.scrollTop(), height;
                    if (deltaY > 0 && top - deltaY <= 0) {
                        results.scrollTop(0);
                        killEvent(e);
                    } else if (deltaY < 0 && results.get(0).scrollHeight - results.scrollTop() + deltaY <= results.height()) {
                        results.scrollTop(results.get(0).scrollHeight - results.height());
                        killEvent(e);
                    }
                });
            }

            installKeyUpChangeEvent(search);
            search.bind("keyup-change", this.bind(this.updateResults));
            search.bind("focus", function () { search.addClass("select2-focused"); if (search.val() === " ") search.val(""); });
            search.bind("blur", function () { search.removeClass("select2-focused");});

            this.dropdown.delegate(resultsSelector, "click mouseup", this.bind(function (e) {
                if ($(e.target).closest(".select2-result-selectable:not(.select2-disabled)").length > 0) {
                    this.highlightUnderEvent(e);
                    this.selectHighlighted(e);
                } else {
                    this.focusSearch();
                }
                killEvent(e);
            }));

            // trap all mouse events from leaving the dropdown. sometimes there may be a modal that is listening
            // for mouse events outside of itself so it can close itself. since the dropdown is now outside the select2's
            // dom it will trigger the popup close, which is not what we want
            this.dropdown.bind("click mouseup mousedown", function (e) { e.stopPropagation(); });

            if ($.isFunction(this.opts.initSelection)) {
                // initialize selection based on the current value of the source element
                this.initSelection();

                // if the user has provided a function that can set selection based on the value of the source element
                // we monitor the change event on the element and trigger it, allowing for two way synchronization
                this.monitorSource();
            }

            if (opts.element.is(":disabled") || opts.element.is("[readonly='readonly']")) this.disable();
        },

        // abstract
        destroy: function () {
            var select2 = this.opts.element.data("select2");
            if (select2 !== undefined) {
                select2.container.remove();
                select2.dropdown.remove();
                select2.opts.element
                    .removeData("select2")
                    .unbind(".select2")
                    .show();
            }
        },

        // abstract
        prepareOpts: function (opts) {
            var element, select, idKey, ajaxUrl;

            element = opts.element;

            if (element.get(0).tagName.toLowerCase() === "select") {
                this.select = select = opts.element;
            }

            if (select) {
                // these options are not allowed when attached to a select because they are picked up off the element itself
                $.each(["id", "multiple", "ajax", "query", "createSearchChoice", "initSelection", "data", "tags"], function () {
                    if (this in opts) {
                        throw new Error("Option '" + this + "' is not allowed for Select2 when attached to a <select> element.");
                    }
                });
            }

            opts = $.extend({}, {
                populateResults: function(container, results, query) {
                    var populate,  data, result, children, id=this.opts.id, self=this;

                    populate=function(results, container, depth) {

                        var i, l, result, selectable, compound, node, label, innerContainer, formatted;
                        for (i = 0, l = results.length; i < l; i = i + 1) {

                            result=results[i];
                            selectable=id(result) !== undefined;
                            compound=result.children && result.children.length > 0;

                            node=$("<li></li>");
                            node.addClass("select2-results-dept-"+depth);
                            node.addClass("select2-result");
                            node.addClass(selectable ? "select2-result-selectable" : "select2-result-unselectable");
                            if (compound) { node.addClass("select2-result-with-children"); }
                            node.addClass(self.opts.formatResultCssClass(result));
                            // formatResultCssClass does NOT work as an option, modifying the src instead
                            if (result.id !== undefined && result.id.match(/^[\w]+$/))
                              node.addClass("id-"+result.id)
                            if (result.text !== undefined) node.attr('data-option-text', result.text)

                            label=$("<div></div>");
                            label.addClass("select2-result-label");

                            formatted=opts.formatResult(result, label, query);
                            if (formatted!==undefined) {
                                label.html(self.opts.escapeMarkup(formatted));
                            }

                            node.append(label);

                            if (compound) {

                                innerContainer=$("<ul></ul>");
                                innerContainer.addClass("select2-result-sub");
                                populate(result.children, innerContainer, depth+1);
                                node.append(innerContainer);
                            }

                            node.data("select2-data", result);
                            container.append(node);
                        }
                    };

                    populate(results, container, 0);
                }
            }, $.fn.select2.defaults, opts);

            if (typeof(opts.id) !== "function") {
                idKey = opts.id;
                opts.id = function (e) { return e[idKey]; };
            }

            if (select) {
                opts.query = this.bind(function (query) {
                    var data = { results: [], more: false },
                        term = query.term,
                        children, firstChild, process;

                    process=function(element, collection) {
                        var group;
                        if (element.is("option")) {
                            if (query.matcher(term, element.text(), element)) {
                                collection.push({id:element.attr("value"), text:element.text(), element: element.get(), css: element.attr("class")});
                            }
                        } else if (element.is("optgroup")) {
                            group={text:element.attr("label"), children:[], element: element.get(), css: element.attr("class")};
                            element.children().each2(function(i, elm) { process(elm, group.children); });
                            if (group.children.length>0) {
                                collection.push(group);
                            }
                        }
                    };

                    children=element.children();

                    // ignore the placeholder option if there is one
                    if (this.getPlaceholder() !== undefined && children.length > 0) {
                        firstChild = children[0];
                        if ($(firstChild).text() === "") {
                            children=children.not(firstChild);
                        }
                    }

                    children.each2(function(i, elm) { process(elm, data.results); });

                    query.callback(data);
                });
                // this is needed because inside val() we construct choices from options and there id is hardcoded
                opts.id=function(e) { return e.id; };
                opts.formatResultCssClass = function(data) { return data.css; }
            } else {
                if (!("query" in opts)) {
                    if ("ajax" in opts) {
                        ajaxUrl = opts.element.data("ajax-url");
                        if (ajaxUrl && ajaxUrl.length > 0) {
                            opts.ajax.url = ajaxUrl;
                        }
                        opts.query = ajax(opts.ajax);
                    } else if ("data" in opts) {
                        opts.query = local(opts.data);
                    } else if ("tags" in opts) {
                        opts.query = tags(opts.tags);
                        opts.createSearchChoice = function (term) { return {id: term, text: term}; };
                        opts.initSelection = function (element, callback) {
                            var data = [];
                            $(splitVal(element.val(), opts.separator)).each(function () {
                                var id = this, text = this, tags=opts.tags;
                                if ($.isFunction(tags)) tags=tags();
                                $(tags).each(function() { if (equal(this.id, id)) { text = this.text; return false; } });
                                data.push({id: id, text: text});
                            });

                            callback(data);
                        };
                    }
                }
            }
            if (typeof(opts.query) !== "function") {
                throw "query function not defined for Select2 " + opts.element.attr("id");
            }

            return opts;
        },

        /**
         * Monitor the original element for changes and update select2 accordingly
         */
        // abstract
        monitorSource: function () {
            this.opts.element.bind("change.select2", this.bind(function (e) {
                if (this.opts.element.data("select2-change-triggered") !== true) {
                    this.initSelection();
                }
            }));
        },

        /**
         * Triggers the change event on the source element
         */
        // abstract
        triggerChange: function (details) {

            details = details || {};
            details= $.extend({}, details, { type: "change", val: this.val() });
            // prevents recursive triggering
            this.opts.element.data("select2-change-triggered", true);
            this.opts.element.trigger(details);
            this.opts.element.data("select2-change-triggered", false);

            // some validation frameworks ignore the change event and listen instead to keyup, click for selects
            // so here we trigger the click event manually
            this.opts.element.click();

            // ValidationEngine ignorea the change event and listens instead to blur
            // so here we trigger the blur event manually if so desired
            if (this.opts.blurOnChange)
                this.opts.element.blur();
        },


        // abstract
        enable: function() {
            if (this.enabled) return;

            this.enabled=true;
            this.container.removeClass("select2-container-disabled");
        },

        // abstract
        disable: function() {
            if (!this.enabled) return;

            this.close();

            this.enabled=false;
            this.container.addClass("select2-container-disabled");
        },

        // abstract
        opened: function () {
            return this.container.hasClass("select2-dropdown-open");
        },

        // abstract
        positionDropdown: function() {
            var offset = this.container.offset(),
                height = this.container.outerHeight(),
                width = this.container.outerWidth(),
                dropHeight = this.dropdown.outerHeight(),
                viewportBottom = $(window).scrollTop() + document.documentElement.clientHeight,
                dropTop = offset.top + height,
                dropLeft = offset.left,
                enoughRoomBelow = dropTop + dropHeight <= viewportBottom,
                enoughRoomAbove = (offset.top - dropHeight) >= this.body().scrollTop(),
                aboveNow = this.dropdown.hasClass("select2-drop-above"),
                bodyOffset,
                above,
                css;

            // console.log("below/ droptop:", dropTop, "dropHeight", dropHeight, "sum", (dropTop+dropHeight)+" viewport bottom", viewportBottom, "enough?", enoughRoomBelow);
            // console.log("above/ offset.top", offset.top, "dropHeight", dropHeight, "top", (offset.top-dropHeight), "scrollTop", this.body().scrollTop(), "enough?", enoughRoomAbove);

            // fix positioning when body has an offset and is not position: static

            if (this.body().css('position') !== 'static') {
                bodyOffset = this.body().offset();
                dropTop -= bodyOffset.top;
                dropLeft -= bodyOffset.left;
            }

            // always prefer the current above/below alignment, unless there is not enough room

            if (aboveNow) {
                above = true;
                if (!enoughRoomAbove && enoughRoomBelow) above = false;
            } else {
                above = false;
                if (!enoughRoomBelow && enoughRoomAbove) above = true;
            }

            if (above) {
                dropTop = offset.top - dropHeight;
                this.container.addClass("select2-drop-above");
                this.dropdown.addClass("select2-drop-above");
            }
            else {
                this.container.removeClass("select2-drop-above");
                this.dropdown.removeClass("select2-drop-above");
            }

            css = $.extend({
                top: dropTop,
                left: dropLeft,
                width: width
            }, evaluate(this.opts.dropdownCss));

            this.dropdown.css(css);
        },

        // abstract
        shouldOpen: function() {
            var event;

            if (this.opened()) return false;

            event = $.Event("open");
            this.opts.element.trigger(event);
            return !event.isDefaultPrevented();
        },

        // abstract
        clearDropdownAlignmentPreference: function() {
            // clear the classes used to figure out the preference of where the dropdown should be opened
            this.container.removeClass("select2-drop-above");
            this.dropdown.removeClass("select2-drop-above");
        },

        /**
         * Opens the dropdown
         *
         * @return {Boolean} whether or not dropdown was opened. This method will return false if, for example,
         * the dropdown is already open, or if the 'open' event listener on the element called preventDefault().
         */
        // abstract
        open: function () {

            if (!this.shouldOpen()) return false;

            window.setTimeout(this.bind(this.opening), 1);

            return true;
        },

        /**
         * Performs the opening of the dropdown
         */
        // abstract
        opening: function() {
            var cid = this.containerId, selector = this.containerSelector,
                scroll = "scroll." + cid, resize = "resize." + cid;

            this.container.parents().each(function() {
                $(this).bind(scroll, function() {
                    var s2 = $(selector);
                    if (s2.length == 0) {
                        $(this).unbind(scroll);
                    }
                    s2.select2("close");
                });
            });

            $(window).bind(resize, function() {
                var s2 = $(selector);
                if (s2.length == 0) {
                    $(window).unbind(resize);
                }
                s2.select2("close");
            });

            this.clearDropdownAlignmentPreference();

            if (this.search.val() === " ") { this.search.val(""); }

            this.container.addClass("select2-dropdown-open").addClass("select2-container-active");

            this.updateResults(true);

            if(this.dropdown[0] !== this.body().children().last()[0]) {
                this.dropdown.detach().appendTo(this.body());
            }

            this.dropdown.show();

            this.positionDropdown();
            this.dropdown.addClass("select2-drop-active");

            this.ensureHighlightVisible();

            this.focusSearch();
        },

        // abstract
        close: function () {
            if (!this.opened()) return;

            var self = this;

            this.container.parents().each(function() {
                $(this).unbind("scroll." + self.containerId);
            });
            $(window).unbind("resize." + this.containerId);

            this.clearDropdownAlignmentPreference();

            this.dropdown.hide();
            this.container.removeClass("select2-dropdown-open").removeClass("select2-container-active");
            this.results.empty();
            this.clearSearch();

            this.opts.element.trigger($.Event("close"));
        },

        // abstract
        clearSearch: function () {

        },

        // abstract
        ensureHighlightVisible: function () {
            var results = this.results, children, index, child, hb, rb, y, more;

            index = this.highlight();

            if (index < 0) return;

            if (index == 0) {

                // if the first element is highlighted scroll all the way to the top,
                // that way any unselectable headers above it will also be scrolled
                // into view

                results.scrollTop(0);
                return;
            }

            children = results.find(".select2-result-selectable");

            child = $(children[index]);

            hb = child.offset().top + child.outerHeight();

            // if this is the last child lets also make sure select2-more-results is visible
            if (index === children.length - 1) {
                more = results.find("li.select2-more-results");
                if (more.length > 0) {
                    hb = more.offset().top + more.outerHeight();
                }
            }

            rb = results.offset().top + results.outerHeight();
            if (hb > rb) {
                results.scrollTop(results.scrollTop() + (hb - rb));
            }
            y = child.offset().top - results.offset().top;

            // make sure the top of the element is visible
            if (y < 0) {
                results.scrollTop(results.scrollTop() + y); // y is negative
            }
        },

        // abstract
        moveHighlight: function (delta) {
            var choices = this.results.find(".select2-result-selectable"),
                index = this.highlight();

            while (index > -1 && index < choices.length) {
                index += delta;
                var choice = $(choices[index]);
                if (choice.hasClass("select2-result-selectable") && !choice.hasClass("select2-disabled")) {
                    this.highlight(index);
                    break;
                }
            }
        },

        // abstract
        highlight: function (index) {
            var choices = this.results.find(".select2-result-selectable").not(".select2-disabled");

            if (arguments.length === 0) {
                return indexOf(choices.filter(".select2-highlighted")[0], choices.get());
            }

            if (index >= choices.length) index = choices.length - 1;
            if (index < 0) index = 0;

            choices.removeClass("select2-highlighted");

            $(choices[index]).addClass("select2-highlighted");
            this.ensureHighlightVisible();

        },

        // abstract
        countSelectableResults: function() {
            return this.results.find(".select2-result-selectable").not(".select2-disabled").length;
        },

        // abstract
        highlightUnderEvent: function (event) {
            var el = $(event.target).closest(".select2-result-selectable");
            if (el.length > 0 && !el.is(".select2-highlighted")) {
        		var choices = this.results.find('.select2-result-selectable');
                this.highlight(choices.index(el));
            } else if (el.length == 0) {
                // if we are over an unselectable item remove al highlights
                this.results.find(".select2-highlighted").removeClass("select2-highlighted");
            }
        },

        // abstract
        loadMoreIfNeeded: function () {
            var results = this.results,
                more = results.find("li.select2-more-results"),
                below, // pixels the element is below the scroll fold, below==0 is when the element is starting to be visible
                offset = -1, // index of first element without data
                page = this.resultsPage + 1,
                self=this,
                term=this.search.val(),
                context=this.context;

            if (more.length === 0) return;
            below = more.offset().top - results.offset().top - results.height();

            if (below <= 0) {
                more.addClass("select2-active");
                this.opts.query({
                        term: term,
                        page: page,
                        context: context,
                        matcher: this.opts.matcher,
                        callback: this.bind(function (data) {

                    // ignore a response if the select2 has been closed before it was received
                    if (!self.opened()) return;


                    self.opts.populateResults.call(this, results, data.results, {term: term, page: page, context:context});

                    if (data.more===true) {
                        more.detach().appendTo(results).text(self.opts.formatLoadMore(page+1));
                        window.setTimeout(function() { self.loadMoreIfNeeded(); }, 10);
                    } else {
                        more.remove();
                    }
                    self.positionDropdown();
                    self.resultsPage = page;
                })});
            }
        },

        /**
         * Default tokenizer function which does nothing
         */
        tokenize: function() {

        },

        /**
         * @param initial whether or not this is the call to this method right after the dropdown has been opened
         */
        // abstract
        updateResults: function (initial) {
            var search = this.search, results = this.results, opts = this.opts, data, self=this, input;

            // if the search is currently hidden we do not alter the results
            if (initial !== true && (this.showSearchInput === false || !this.opened())) {
                return;
            }

            search.addClass("select2-active");

            function postRender() {
                results.scrollTop(0);
                search.removeClass("select2-active");
                self.positionDropdown();
            }

            function render(html) {
                results.html(self.opts.escapeMarkup(html));
                postRender();
            }

            if (opts.maximumSelectionSize >=1) {
                data = this.data();
                if ($.isArray(data) && data.length >= opts.maximumSelectionSize && checkFormatter(opts.formatSelectionTooBig, "formatSelectionTooBig")) {
            	    render("<li class='select2-selection-limit'>" + opts.formatSelectionTooBig(opts.maximumSelectionSize) + "</li>");
            	    return;
                }
            }

            if (search.val().length < opts.minimumInputLength && checkFormatter(opts.formatInputTooShort, "formatInputTooShort")) {
                render("<li class='select2-no-results'>" + opts.formatInputTooShort(search.val(), opts.minimumInputLength) + "</li>");
                return;
            }
            else {
                render("<li class='select2-searching'>" + opts.formatSearching() + "</li>");
            }

            // give the tokenizer a chance to pre-process the input
            input = this.tokenize();
            if (input != undefined && input != null) {
                search.val(input);
            }

            this.resultsPage = 1;
            opts.query({
                    term: search.val(),
                    page: this.resultsPage,
                    context: null,
                    matcher: opts.matcher,
                    callback: this.bind(function (data) {
                var def; // default choice

                // ignore a response if the select2 has been closed before it was received
                if (!this.opened()) return;

                // save context, if any
                this.context = (data.context===undefined) ? null : data.context;

                // create a default choice and prepend it to the list
                if (this.opts.createSearchChoice && search.val() !== "") {
                    def = this.opts.createSearchChoice.call(null, search.val(), data.results);
                    if (def !== undefined && def !== null && self.id(def) !== undefined && self.id(def) !== null) {
                        if ($(data.results).filter(
                            function () {
                                return equal(self.id(this), self.id(def));
                            }).length === 0) {
                            data.results.unshift(def);
                        }
                    }
                }

                if (data.results.length === 0 && checkFormatter(opts.formatNoMatches, "formatNoMatches")) {
                    render("<li class='select2-no-results'>" + opts.formatNoMatches(search.val()) + "</li>");
                    return;
                }

                results.empty();
                self.opts.populateResults.call(this, results, data.results, {term: search.val(), page: this.resultsPage, context:null});

                if (data.more === true && checkFormatter(opts.formatLoadMore, "formatLoadMore")) {
                    results.append("<li class='select2-more-results'>" + self.opts.escapeMarkup(opts.formatLoadMore(this.resultsPage)) + "</li>");
                    window.setTimeout(function() { self.loadMoreIfNeeded(); }, 10);
                }

                this.postprocessResults(data, initial);

                postRender();
            })});
        },

        // abstract
        cancel: function () {
            this.close();
        },

        // abstract
        blur: function () {
            this.close();
            this.container.removeClass("select2-container-active");
            this.dropdown.removeClass("select2-drop-active");
            // synonymous to .is(':focus'), which is available in jquery >= 1.6
            if (this.search[0] === document.activeElement) { this.search.blur(); }
            this.clearSearch();
            this.selection.find(".select2-search-choice-focus").removeClass("select2-search-choice-focus");
        },

        // abstract
        focusSearch: function () {
            // need to do it here as well as in timeout so it works in IE
            this.search.show();
            this.search.focus();

            /* we do this in a timeout so that current event processing can complete before this code is executed.
             this makes sure the search field is focussed even if the current event would blur it */
            window.setTimeout(this.bind(function () {
                // reset the value so IE places the cursor at the end of the input box
                this.search.show();
                this.search.focus();
                this.search.val(this.search.val());
            }), 10);
        },

        // abstract
        selectHighlighted: function () {
            var index=this.highlight(),
                highlighted=this.results.find(".select2-highlighted").not(".select2-disabled"),
                data = highlighted.closest('.select2-result-selectable').data("select2-data");
            if (data) {
                highlighted.addClass("select2-disabled");
                this.highlight(index);
                this.onSelect(data);
            }
        },

        // abstract
        getPlaceholder: function () {
            return this.opts.element.attr("placeholder") ||
                this.opts.element.attr("data-placeholder") || // jquery 1.4 compat
                this.opts.element.data("placeholder") ||
                this.opts.placeholder;
        },

        /**
         * Get the desired width for the container element.  This is
         * derived first from option `width` passed to select2, then
         * the inline 'style' on the original element, and finally
         * falls back to the jQuery calculated element width.
         */
        // abstract
        initContainerWidth: function () {
            function resolveContainerWidth() {
                var style, attrs, matches, i, l;

                if (this.opts.width === "off") {
                    return null;
                } else if (this.opts.width === "element"){
                    return this.opts.element.outerWidth() === 0 ? 'auto' : this.opts.element.outerWidth() + 'px';
                } else if (this.opts.width === "copy" || this.opts.width === "resolve") {
                    // check if there is inline style on the element that contains width
                    style = this.opts.element.attr('style');
                    if (style !== undefined) {
                        attrs = style.split(';');
                        for (i = 0, l = attrs.length; i < l; i = i + 1) {
                            matches = attrs[i].replace(/\s/g, '')
                                .match(/width:(([-+]?([0-9]*\.)?[0-9]+)(px|em|ex|%|in|cm|mm|pt|pc))/);
                            if (matches !== null && matches.length >= 1)
                                return matches[1];
                        }
                    }

                    if (this.opts.width === "resolve") {
                        // next check if css('width') can resolve a width that is percent based, this is sometimes possible
                        // when attached to input type=hidden or elements hidden via css
                        style = this.opts.element.css('width');
                        if (style.indexOf("%") > 0) return style;

                        // finally, fallback on the calculated width of the element
                        return (this.opts.element.outerWidth() === 0 ? 'auto' : this.opts.element.outerWidth() + 'px');
                    }

                    return null;
                } else if ($.isFunction(this.opts.width)) {
                    return this.opts.width();
                } else {
                    return this.opts.width;
               }
            };

            var width = resolveContainerWidth.call(this);
            if (width !== null) {
                this.container.attr("style", "width: "+width);
            }
        }
    });

    SingleSelect2 = clazz(AbstractSelect2, {

        // single

		createContainer: function () {
            var container = $("<div></div>", {
                "class": "select2-container"
            }).html([
                "    <a href='#' onclick='return false;' class='select2-choice'>",
                "   <span></span><abbr class='select2-search-choice-close' style='display:none;'></abbr>",
                "   <div><b></b></div>" ,
                "</a>",
                "    <div class='select2-drop select2-offscreen'>" ,
                "   <div class='select2-search'>" ,
                "       <input type='text' autocomplete='off' class='select2-input'/>" ,
                "   </div>" ,
                "   <ul class='select2-results'>" ,
                "   </ul>" ,
                "</div>"].join(""));
            return container;
        },

        // single
        opening: function () {
            this.search.show();
            this.parent.opening.apply(this, arguments);
            this.dropdown.removeClass("select2-offscreen");
        },

        // single
        close: function () {
            if (!this.opened()) return;
            this.parent.close.apply(this, arguments);
            this.dropdown.removeAttr("style").addClass("select2-offscreen").insertAfter(this.selection).show();
        },

        // single
        focus: function () {
            this.close();
            this.selection.focus();
        },

        // single
        isFocused: function () {
            return this.selection[0] === document.activeElement;
        },

        // single
        cancel: function () {
            this.parent.cancel.apply(this, arguments);
            this.selection.focus();
        },

        // single
        initContainer: function () {

            var selection,
                container = this.container,
                dropdown = this.dropdown,
                clickingInside = false;

            this.selection = selection = container.find(".select2-choice");

            this.search.bind("keydown", this.bind(function (e) {
                if (!this.enabled) return;

                if (e.which === KEY.PAGE_UP || e.which === KEY.PAGE_DOWN) {
                    // prevent the page from scrolling
                    killEvent(e);
                    return;
                }

                if (this.opened()) {
                    switch (e.which) {
                        case KEY.UP:
                        case KEY.DOWN:
                            this.moveHighlight((e.which === KEY.UP) ? -1 : 1);
                            killEvent(e);
                            return;
                        case KEY.TAB:
                        case KEY.ENTER:
                            this.selectHighlighted();
                            killEvent(e);
                            return;
                        case KEY.ESC:
                            this.cancel(e);
                            killEvent(e);
                            return;
                    }
                } else {

                    if (e.which === KEY.TAB || KEY.isControl(e) || KEY.isFunctionKey(e) || e.which === KEY.ESC) {
                        return;
                    }

                    if (this.opts.openOnEnter === false && e.which === KEY.ENTER) {
                        return;
                    }

                    this.open();

                    if (e.which === KEY.ENTER) {
                        // do not propagate the event otherwise we open, and propagate enter which closes
                        return;
                    }
                }
            }));

            this.search.bind("focus", this.bind(function() {
                this.selection.attr("tabIndex", "-1");
            }));
            this.search.bind("blur", this.bind(function() {
                if (!this.opened()) this.container.removeClass("select2-container-active");
                window.setTimeout(this.bind(function() { this.selection.attr("tabIndex", this.opts.element.attr("tabIndex")); }), 10);
            }));

            selection.bind("mousedown", this.bind(function (e) {
                clickingInside = true;

                if (this.opened()) {
                    this.close();
                    this.selection.focus();
                } else if (this.enabled) {
                    this.open();
                }

                clickingInside = false;
            }));

            dropdown.bind("mousedown", this.bind(function() { this.search.focus(); }));

            selection.bind("focus", this.bind(function() {
                this.container.addClass("select2-container-active");
                // hide the search so the tab key does not focus on it
                this.search.attr("tabIndex", "-1");
            }));

            selection.bind("blur", this.bind(function() {
                if (!this.opened()) {
                    this.container.removeClass("select2-container-active");
                }
                window.setTimeout(this.bind(function() { this.search.attr("tabIndex", this.opts.element.attr("tabIndex")); }), 10);
            }));

            selection.bind("keydown", this.bind(function(e) {
                if (!this.enabled) return;

                if (e.which === KEY.PAGE_UP || e.which === KEY.PAGE_DOWN) {
                    // prevent the page from scrolling
                    killEvent(e);
                    return;
                }

                if (e.which === KEY.TAB || KEY.isControl(e) || KEY.isFunctionKey(e)
                 || e.which === KEY.ESC) {
                    return;
                }

                if (this.opts.openOnEnter === false && e.which === KEY.ENTER) {
                    return;
                }

                if (e.which == KEY.DELETE) {
                    if (this.opts.allowClear) {
                        this.clear();
                    }
                    return;
                }

                this.open();

                if (e.which === KEY.ENTER) {
                    // do not propagate the event otherwise we open, and propagate enter which closes
                    killEvent(e);
                    return;
                }

                // do not set the search input value for non-alpha-numeric keys
                // otherwise pressing down results in a '(' being set in the search field
                if (e.which < 48 ) { // '0' == 48
                    killEvent(e);
                    return;
                }

                var keyWritten = String.fromCharCode(e.which).toLowerCase();

                if (e.shiftKey) {
                    keyWritten = keyWritten.toUpperCase();
                }

                // focus the field before calling val so the cursor ends up after the value instead of before
                this.search.focus();
                this.search.val(keyWritten);

                // prevent event propagation so it doesnt replay on the now focussed search field and result in double key entry
                killEvent(e);
            }));

            selection.delegate("abbr", "mousedown", this.bind(function (e) {
                if (!this.enabled) return;
                this.clear();
                killEvent(e);
                this.close();
                this.triggerChange();
                this.selection.focus();
            }));

            this.setPlaceholder();

            this.search.bind("focus", this.bind(function() {
                this.container.addClass("select2-container-active");
            }));
        },

        // single
        clear: function() {
            this.opts.element.val("");
            this.selection.find("span").empty();
            this.selection.removeData("select2-data");
            this.setPlaceholder();
        },

        /**
         * Sets selection based on source element's value
         */
        // single
        initSelection: function () {
            var selected;
            if (this.opts.element.val() === "") {
                this.close();
                this.setPlaceholder();
            } else {
                var self = this;
                this.opts.initSelection.call(null, this.opts.element, function(selected){
                    if (selected !== undefined && selected !== null) {
                        self.updateSelection(selected);
                        self.close();
                        self.setPlaceholder();
                    }
                });
            }
        },

        // single
        prepareOpts: function () {
            var opts = this.parent.prepareOpts.apply(this, arguments);

            if (opts.element.get(0).tagName.toLowerCase() === "select") {
                // install the selection initializer
                opts.initSelection = function (element, callback) {
                    var selected = element.find(":selected");
                    // a single select box always has a value, no need to null check 'selected'
                    if ($.isFunction(callback))
                        callback({id: selected.attr("value"), text: selected.text()});
                };
            }

            return opts;
        },

        // single
        setPlaceholder: function () {
            var placeholder = this.getPlaceholder();

            if (this.opts.element.val() === "" && placeholder !== undefined) {

                // check for a first blank option if attached to a select
                if (this.select && this.select.find("option:first").text() !== "") return;

                this.selection.find("span").html(this.opts.escapeMarkup(placeholder));

                this.selection.addClass("select2-default");

                this.selection.find("abbr").hide();
            }
        },

        // single
        postprocessResults: function (data, initial) {
            var selected = 0, self = this, showSearchInput = true;

            // find the selected element in the result list

            this.results.find(".select2-result-selectable").each2(function (i, elm) {
                if (equal(self.id(elm.data("select2-data")), self.opts.element.val())) {
                    selected = i;
                    return false;
                }
            });

            // and highlight it

            this.highlight(selected);

            // hide the search box if this is the first we got the results and there are a few of them

            if (initial === true) {
                showSearchInput = this.showSearchInput = countResults(data.results) >= this.opts.minimumResultsForSearch;
                this.dropdown.find(".select2-search")[showSearchInput ? "removeClass" : "addClass"]("select2-search-hidden");

                //add "select2-with-searchbox" to the container if search box is shown
                $(this.dropdown, this.container)[showSearchInput ? "addClass" : "removeClass"]("select2-with-searchbox");
            }

        },

        // single
        onSelect: function (data) {
            var old = this.opts.element.val();

            this.opts.element.val(this.id(data));
            this.updateSelection(data);
            this.close();
            this.selection.focus();

            this.triggerChange();
        },

        // single
        updateSelection: function (data) {

            var container=this.selection.find("span"), formatted;

            this.selection.data("select2-data", data);

            container.empty();
            formatted=this.opts.formatSelection(data, container);
            if (formatted !== undefined) {
                container.append(this.opts.escapeMarkup(formatted));
            }

            this.selection.removeClass("select2-default");

            if (this.opts.allowClear && this.getPlaceholder() !== undefined) {
                this.selection.find("abbr").show();
            }
        },

        // single
        val: function () {
            var val, data = null, self = this;

            if (arguments.length === 0) {
                return this.opts.element.val();
            }

            val = arguments[0];

            if (this.select) {
                this.select
                    .val(val)
                    .find(":selected").each2(function (i, elm) {
                        data = {id: elm.attr("value"), text: elm.text()};
                        return false;
                    });
                this.updateSelection(data);
                this.setPlaceholder();
            } else {
                if (this.opts.initSelection === undefined) {
                    throw new Error("cannot call val() if initSelection() is not defined");
                }
                // val is an id. !val is true for [undefined,null,'']
                if (!val) {
                    this.clear();
                    return;
                }
                this.opts.element.val(val);
                this.opts.initSelection(this.opts.element, function(data){
                    self.opts.element.val(!data ? "" : self.id(data));
                    self.updateSelection(data);
                    self.setPlaceholder();
                });
            }
        },

        // single
        clearSearch: function () {
            this.search.val("");
        },

        // single
        data: function(value) {
            var data;

            if (arguments.length === 0) {
                data = this.selection.data("select2-data");
                if (data == undefined) data = null;
                return data;
            } else {
                if (!value || value === "") {
                    this.clear();
                } else {
                    this.opts.element.val(!value ? "" : this.id(value));
                    this.updateSelection(value);
                }
            }
        }
    });

    MultiSelect2 = clazz(AbstractSelect2, {

        // multi
        createContainer: function () {
            var container = $("<div></div>", {
                "class": "select2-container select2-container-multi"
            }).html([
                "    <ul class='select2-choices'>",
                //"<li class='select2-search-choice'><span>California</span><a href="javascript:void(0)" class="select2-search-choice-close"></a></li>" ,
                "  <li class='select2-search-field'>" ,
                "    <input type='text' autocomplete='off' class='select2-input'>" ,
                "  </li>" ,
                "</ul>" ,
                "<div class='select2-drop select2-drop-multi' style='display:none;'>" ,
                "   <ul class='select2-results'>" ,
                "   </ul>" ,
                "</div>"].join(""));
			return container;
        },

        // multi
        prepareOpts: function () {
            var opts = this.parent.prepareOpts.apply(this, arguments);

            // TODO validate placeholder is a string if specified

            if (opts.element.get(0).tagName.toLowerCase() === "select") {
                // install sthe selection initializer
                opts.initSelection = function (element,callback) {

                    var data = [];
                    element.find(":selected").each2(function (i, elm) {
                        data.push({id: elm.attr("value"), text: elm.text()});
                    });

                    if ($.isFunction(callback))
                        callback(data);
                };
            }

            return opts;
        },

        // multi
        initContainer: function () {

            var selector = ".select2-choices", selection;

            this.searchContainer = this.container.find(".select2-search-field");
            this.selection = selection = this.container.find(selector);

            this.search.bind("keydown", this.bind(function (e) {
                if (!this.enabled) return;

                if (e.which === KEY.BACKSPACE && this.search.val() === "") {
                    this.close();

                    var choices,
                        selected = selection.find(".select2-search-choice-focus");
                    if (selected.length > 0) {
                        this.unselect(selected.first());
                        this.search.width(10);
                        killEvent(e);
                        return;
                    }

                    choices = selection.find(".select2-search-choice");
                    if (choices.length > 0) {
                        choices.last().addClass("select2-search-choice-focus");
                    }
                } else {
                    selection.find(".select2-search-choice-focus").removeClass("select2-search-choice-focus");
                }

                if (this.opened()) {
                    switch (e.which) {
                    case KEY.UP:
                    case KEY.DOWN:
                        this.moveHighlight((e.which === KEY.UP) ? -1 : 1);
                        killEvent(e);
                        return;
                    case KEY.ENTER:
                    case KEY.TAB:
                        this.selectHighlighted();
                        killEvent(e);
                        return;
                    case KEY.ESC:
                        this.cancel(e);
                        killEvent(e);
                        return;
                    }
                }

                if (e.which === KEY.TAB || KEY.isControl(e) || KEY.isFunctionKey(e)
                 || e.which === KEY.BACKSPACE || e.which === KEY.ESC) {
                    return;
                }

                if (this.opts.openOnEnter === false && e.which === KEY.ENTER) {
                    return;
                }

                this.open();

                if (e.which === KEY.PAGE_UP || e.which === KEY.PAGE_DOWN) {
                    // prevent the page from scrolling
                    killEvent(e);
                }
            }));

            this.search.bind("keyup", this.bind(this.resizeSearch));

            this.search.bind("blur", this.bind(function(e) {
                this.container.removeClass("select2-container-active");
                this.search.removeClass("select2-focused");
                this.clearSearch();
                e.stopImmediatePropagation();
            }));

            this.container.delegate(selector, "mousedown", this.bind(function (e) {
                if (!this.enabled) return;
                if ($(e.target).closest(".select2-search-choice").length > 0) {
                    // clicked inside a select2 search choice, do not open
                    return;
                }
                this.clearPlaceholder();
                this.open();
                this.focusSearch();
                e.preventDefault();
            }));

            this.container.delegate(selector, "focus", this.bind(function () {
                if (!this.enabled) return;
                this.container.addClass("select2-container-active");
                this.dropdown.addClass("select2-drop-active");
                this.clearPlaceholder();
            }));

            // set the placeholder if necessary
            this.clearSearch();
        },

        // multi
        enable: function() {
            if (this.enabled) return;

            this.parent.enable.apply(this, arguments);

            this.search.removeAttr("disabled");
        },

        // multi
        disable: function() {
            if (!this.enabled) return;

            this.parent.disable.apply(this, arguments);

            this.search.attr("disabled", true);
        },

        // multi
        initSelection: function () {
            var data;
            if (this.opts.element.val() === "") {
                this.updateSelection([]);
                this.close();
                // set the placeholder if necessary
                this.clearSearch();
            }
            if (this.select || this.opts.element.val() !== "") {
                var self = this;
                this.opts.initSelection.call(null, this.opts.element, function(data){
                    if (data !== undefined && data !== null) {
                        self.updateSelection(data);
                        self.close();
                        // set the placeholder if necessary
                        self.clearSearch();
                    }
                });
            }
        },

        // multi
        clearSearch: function () {
            var placeholder = this.getPlaceholder();

            if (placeholder !== undefined  && this.getVal().length === 0 && this.search.hasClass("select2-focused") === false) {
                this.search.val(placeholder).addClass("select2-default");
                // stretch the search box to full width of the container so as much of the placeholder is visible as possible
                this.resizeSearch();
            } else {
                // we set this to " " instead of "" and later clear it on focus() because there is a firefox bug
                // that does not properly render the caret when the field starts out blank
                this.search.val(" ").width(10);
            }
        },

        // multi
        clearPlaceholder: function () {
            if (this.search.hasClass("select2-default")) {
                this.search.val("").removeClass("select2-default");
            } else {
                // work around for the space character we set to avoid firefox caret bug
                if (this.search.val() === " ") this.search.val("");
            }
        },

        // multi
        opening: function () {
            this.parent.opening.apply(this, arguments);

            this.clearPlaceholder();
			this.resizeSearch();
            this.focusSearch();
        },

        // multi
        close: function () {
            if (!this.opened()) return;
            this.parent.close.apply(this, arguments);
        },

        // multi
        focus: function () {
            this.close();
            this.search.focus();
        },

        // multi
        isFocused: function () {
            return this.search.hasClass("select2-focused");
        },

        // multi
        updateSelection: function (data) {
            var ids = [], filtered = [], self = this;

            // filter out duplicates
            $(data).each(function () {
                if (indexOf(self.id(this), ids) < 0) {
                    ids.push(self.id(this));
                    filtered.push(this);
                }
            });
            data = filtered;

            this.selection.find(".select2-search-choice").remove();
            $(data).each(function () {
                self.addSelectedChoice(this);
            });
            self.postprocessResults();
        },

        tokenize: function() {
            var input = this.search.val();
            input = this.opts.tokenizer(input, this.data(), this.bind(this.onSelect), this.opts);
            if (input != null && input != undefined) {
                this.search.val(input);
                if (input.length > 0) {
                    this.open();
                }
            }

        },

        // multi
        onSelect: function (data) {
            this.addSelectedChoice(data);
            if (this.select) { this.postprocessResults(); }

            if (this.opts.closeOnSelect) {
                this.close();
                this.search.width(10);
            } else {
                if (this.countSelectableResults()>0) {
                    this.search.width(10);
                    this.resizeSearch();
                    this.positionDropdown();
                } else {
                    // if nothing left to select close
                    this.close();
                }
            }

            // since its not possible to select an element that has already been
            // added we do not need to check if this is a new element before firing change
            this.triggerChange({ added: data });

            this.focusSearch();
        },

        // multi
        cancel: function () {
            this.close();
            this.focusSearch();
        },

        // multi
        addSelectedChoice: function (data) {
            var choice=$(
                    "<li class='select2-search-choice'>" +
                    "    <div></div>" +
                    "    <a href='#' onclick='return false;' class='select2-search-choice-close' tabindex='-1'></a>" +
                    "</li>"),
                id = this.id(data),
                val = this.getVal(),
                formatted;

            formatted=this.opts.formatSelection(data, choice);
            choice.find("div").replaceWith("<div>"+this.opts.escapeMarkup(formatted)+"</div>");
            choice.find(".select2-search-choice-close")
                .bind("mousedown", killEvent)
                .bind("click dblclick", this.bind(function (e) {
                if (!this.enabled) return;

                $(e.target).closest(".select2-search-choice").fadeOut('fast', this.bind(function(){
                    this.unselect($(e.target));
                    this.selection.find(".select2-search-choice-focus").removeClass("select2-search-choice-focus");
                    this.close();
                    this.focusSearch();
                })).dequeue();
                killEvent(e);
            })).bind("focus", this.bind(function () {
                if (!this.enabled) return;
                this.container.addClass("select2-container-active");
                this.dropdown.addClass("select2-drop-active");
            }));

            choice.data("select2-data", data);
            choice.insertBefore(this.searchContainer);

            val.push(id);
            this.setVal(val);
        },

        // multi
        unselect: function (selected) {
            var val = this.getVal(),
                data,
                index;

            selected = selected.closest(".select2-search-choice");

            if (selected.length === 0) {
                throw "Invalid argument: " + selected + ". Must be .select2-search-choice";
            }

            data = selected.data("select2-data");

            index = indexOf(this.id(data), val);

            if (index >= 0) {
                val.splice(index, 1);
                this.setVal(val);
                if (this.select) this.postprocessResults();
            }
            selected.remove();
            this.triggerChange({ removed: data });
        },

        // multi
        postprocessResults: function () {
            var val = this.getVal(),
                choices = this.results.find(".select2-result-selectable"),
                compound = this.results.find(".select2-result-with-children"),
                self = this;

            choices.each2(function (i, choice) {
                var id = self.id(choice.data("select2-data"));
                if (indexOf(id, val) >= 0) {
                    choice.addClass("select2-disabled").removeClass("select2-result-selectable");
                } else {
                    choice.removeClass("select2-disabled").addClass("select2-result-selectable");
                }
            });

            compound.each2(function(i, e) {
                if (e.find(".select2-result-selectable").length==0) {
                    e.addClass("select2-disabled");
                } else {
                    e.removeClass("select2-disabled");
                }
            });

            choices.each2(function (i, choice) {
                if (!choice.hasClass("select2-disabled") && choice.hasClass("select2-result-selectable")) {
                    self.highlight(0);
                    return false;
                }
            });

        },

        // multi
        resizeSearch: function () {

            var minimumWidth, left, maxWidth, containerLeft, searchWidth,
            	sideBorderPadding = getSideBorderPadding(this.search);

            minimumWidth = measureTextWidth(this.search) + 10;

            left = this.search.offset().left;

            maxWidth = this.selection.width();
            containerLeft = this.selection.offset().left;

            searchWidth = maxWidth - (left - containerLeft) - sideBorderPadding;
            if (searchWidth < minimumWidth) {
                searchWidth = maxWidth - sideBorderPadding;
            }

            if (searchWidth < 40) {
                searchWidth = maxWidth - sideBorderPadding;
            }
            this.search.width(searchWidth);
        },

        // multi
        getVal: function () {
            var val;
            if (this.select) {
                val = this.select.val();
                return val === null ? [] : val;
            } else {
                val = this.opts.element.val();
                return splitVal(val, this.opts.separator);
            }
        },

        // multi
        setVal: function (val) {
            var unique;
            if (this.select) {
                this.select.val(val);
            } else {
                unique = [];
                // filter out duplicates
                $(val).each(function () {
                    if (indexOf(this, unique) < 0) unique.push(this);
                });
                this.opts.element.val(unique.length === 0 ? "" : unique.join(this.opts.separator));
            }
        },

        // multi
        val: function () {
            var val, data = [], self=this;

            if (arguments.length === 0) {
                return this.getVal();
            }

            val = arguments[0];

            if (!val) {
                this.opts.element.val("");
                this.updateSelection([]);
                this.clearSearch();
                return;
            }

            // val is a list of ids
            this.setVal(val);

            if (this.select) {
                this.select.find(":selected").each(function () {
                    data.push({id: $(this).attr("value"), text: $(this).text()});
                });
                this.updateSelection(data);
            } else {
                if (this.opts.initSelection === undefined) {
                    throw new Error("val() cannot be called if initSelection() is not defined")
                }

                this.opts.initSelection(this.opts.element, function(data){
                    var ids=$(data).map(self.id);
                    self.setVal(ids);
                    self.updateSelection(data);
                    self.clearSearch();
                });
            }
            this.clearSearch();
        },

        // multi
        onSortStart: function() {
            if (this.select) {
                throw new Error("Sorting of elements is not supported when attached to <select>. Attach to <input type='hidden'/> instead.");
            }

            // collapse search field into 0 width so its container can be collapsed as well
            this.search.width(0);
            // hide the container
            this.searchContainer.hide();
        },

        // multi
        onSortEnd:function() {

            var val=[], self=this;

            // show search and move it to the end of the list
            this.searchContainer.show();
            // make sure the search container is the last item in the list
            this.searchContainer.appendTo(this.searchContainer.parent());
            // since we collapsed the width in dragStarted, we resize it here
            this.resizeSearch();

            // update selection

            this.selection.find(".select2-search-choice").each(function() {
                val.push(self.opts.id($(this).data("select2-data")));
            });
            this.setVal(val);
            this.triggerChange();
        },

        // multi
        data: function(values) {
            var self=this, ids;
            if (arguments.length === 0) {
                 return this.selection
                     .find(".select2-search-choice")
                     .map(function() { return $(this).data("select2-data"); })
                     .get();
            } else {
                if (!values) { values = []; }
                ids = $.map(values, function(e) { return self.opts.id(e)});
                this.setVal(ids);
                this.updateSelection(values);
                this.clearSearch();
            }
        }
    });

    $.fn.select2 = function () {

        var args = Array.prototype.slice.call(arguments, 0),
            opts,
            select2,
            value, multiple, allowedMethods = ["val", "destroy", "opened", "open", "close", "focus", "isFocused", "container", "onSortStart", "onSortEnd", "enable", "disable", "positionDropdown", "data"];

        this.each(function () {
            if (args.length === 0 || typeof(args[0]) === "object") {
                opts = args.length === 0 ? {} : $.extend({}, args[0]);
                opts.element = $(this);

                if (opts.element.get(0).tagName.toLowerCase() === "select") {
                    multiple = opts.element.attr("multiple");
                } else {
                    multiple = opts.multiple || false;
                    if ("tags" in opts) {opts.multiple = multiple = true;}
                }

                select2 = multiple ? new MultiSelect2() : new SingleSelect2();
                select2.init(opts);
            } else if (typeof(args[0]) === "string") {

                if (indexOf(args[0], allowedMethods) < 0) {
                    throw "Unknown method: " + args[0];
                }

                value = undefined;
                select2 = $(this).data("select2");
                if (select2 === undefined) return;
                if (args[0] === "container") {
                    value=select2.container;
                } else {
                    value = select2[args[0]].apply(select2, args.slice(1));
                }
                if (value !== undefined) {return false;}
            } else {
                throw "Invalid arguments to select2 plugin: " + args;
            }
        });
        return (value === undefined) ? this : value;
    };

    // plugin defaults, accessible to users
    $.fn.select2.defaults = {
        width: "copy",
        closeOnSelect: true,
        openOnEnter: true,
        containerCss: {},
        dropdownCss: {},
        containerCssClass: "",
        dropdownCssClass: "",
        formatResult: function(result, container, query) {
            var markup=[];
            markMatch(result.text, query.term, markup);
            return markup.join("");
        },
        formatSelection: function (data, container) {
            return data ? data.text : undefined;
        },
        formatResultCssClass: function(data) {return undefined;},
        formatNoMatches: function () { return "No matches found"; },
        formatInputTooShort: function (input, min) { return "Please enter " + (min - input.length) + " more characters"; },
        formatSelectionTooBig: function (limit) { return "You can only select " + limit + " item" + (limit == 1 ? "" : "s"); },
        formatLoadMore: function (pageNumber) { return "Loading more results..."; },
        formatSearching: function () { return "Searching..."; },
        minimumResultsForSearch: 0,
        minimumInputLength: 0,
        maximumSelectionSize: 0,
        id: function (e) { return e.id; },
        matcher: function(term, text) {
            return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;
        },
        separator: ",",
        tokenSeparators: [],
        tokenizer: defaultTokenizer,
        escapeMarkup: function (markup) {
            if (markup && typeof(markup) === "string") {
                return markup.replace(/&/g, "&amp;");
            }
            return markup;
        },
        blurOnChange: false
    };

    // exports
    window.Select2 = {
        query: {
            ajax: ajax,
            local: local,
            tags: tags
        }, util: {
            debounce: debounce,
            markMatch: markMatch
        }, "class": {
            "abstract": AbstractSelect2,
            "single": SingleSelect2,
            "multi": MultiSelect2
        }
    };

}(jQuery));
// moment.js
// version : 1.7.2
// author : Tim Wood
// license : MIT
// momentjs.com
(function(a){function E(a,b,c,d){var e=c.lang();return e[a].call?e[a](c,d):e[a][b]}function F(a,b){return function(c){return K(a.call(this,c),b)}}function G(a){return function(b){var c=a.call(this,b);return c+this.lang().ordinal(c)}}function H(a,b,c){this._d=a,this._isUTC=!!b,this._a=a._a||null,this._lang=c||!1}function I(a){var b=this._data={},c=a.years||a.y||0,d=a.months||a.M||0,e=a.weeks||a.w||0,f=a.days||a.d||0,g=a.hours||a.h||0,h=a.minutes||a.m||0,i=a.seconds||a.s||0,j=a.milliseconds||a.ms||0;this._milliseconds=j+i*1e3+h*6e4+g*36e5,this._days=f+e*7,this._months=d+c*12,b.milliseconds=j%1e3,i+=J(j/1e3),b.seconds=i%60,h+=J(i/60),b.minutes=h%60,g+=J(h/60),b.hours=g%24,f+=J(g/24),f+=e*7,b.days=f%30,d+=J(f/30),b.months=d%12,c+=J(d/12),b.years=c,this._lang=!1}function J(a){return a<0?Math.ceil(a):Math.floor(a)}function K(a,b){var c=a+"";while(c.length<b)c="0"+c;return c}function L(a,b,c){var d=b._milliseconds,e=b._days,f=b._months,g;d&&a._d.setTime(+a+d*c),e&&a.date(a.date()+e*c),f&&(g=a.date(),a.date(1).month(a.month()+f*c).date(Math.min(g,a.daysInMonth())))}function M(a){return Object.prototype.toString.call(a)==="[object Array]"}function N(a,b){var c=Math.min(a.length,b.length),d=Math.abs(a.length-b.length),e=0,f;for(f=0;f<c;f++)~~a[f]!==~~b[f]&&e++;return e+d}function O(a,b,c,d){var e,f,g=[];for(e=0;e<7;e++)g[e]=a[e]=a[e]==null?e===2?1:0:a[e];return a[7]=g[7]=b,a[8]!=null&&(g[8]=a[8]),a[3]+=c||0,a[4]+=d||0,f=new Date(0),b?(f.setUTCFullYear(a[0],a[1],a[2]),f.setUTCHours(a[3],a[4],a[5],a[6])):(f.setFullYear(a[0],a[1],a[2]),f.setHours(a[3],a[4],a[5],a[6])),f._a=g,f}function P(a,c){var d,e,g=[];!c&&h&&(c=require("./lang/"+a));for(d=0;d<i.length;d++)c[i[d]]=c[i[d]]||f.en[i[d]];for(d=0;d<12;d++)e=b([2e3,d]),g[d]=new RegExp("^"+(c.months[d]||c.months(e,""))+"|^"+(c.monthsShort[d]||c.monthsShort(e,"")).replace(".",""),"i");return c.monthsParse=c.monthsParse||g,f[a]=c,c}function Q(a){var c=typeof a=="string"&&a||a&&a._lang||null;return c?f[c]||P(c):b}function R(a){return a.match(/\[.*\]/)?a.replace(/^\[|\]$/g,""):a.replace(/\\/g,"")}function S(a){var b=a.match(k),c,d;for(c=0,d=b.length;c<d;c++)D[b[c]]?b[c]=D[b[c]]:b[c]=R(b[c]);return function(e){var f="";for(c=0;c<d;c++)f+=typeof b[c].call=="function"?b[c].call(e,a):b[c];return f}}function T(a,b){function d(b){return a.lang().longDateFormat[b]||b}var c=5;while(c--&&l.test(b))b=b.replace(l,d);return A[b]||(A[b]=S(b)),A[b](a)}function U(a){switch(a){case"DDDD":return p;case"YYYY":return q;case"S":case"SS":case"SSS":case"DDD":return o;case"MMM":case"MMMM":case"dd":case"ddd":case"dddd":case"a":case"A":return r;case"Z":case"ZZ":return s;case"T":return t;case"MM":case"DD":case"YY":case"HH":case"hh":case"mm":case"ss":case"M":case"D":case"d":case"H":case"h":case"m":case"s":return n;default:return new RegExp(a.replace("\\",""))}}function V(a,b,c,d){var e,f;switch(a){case"M":case"MM":c[1]=b==null?0:~~b-1;break;case"MMM":case"MMMM":for(e=0;e<12;e++)if(Q().monthsParse[e].test(b)){c[1]=e,f=!0;break}f||(c[8]=!1);break;case"D":case"DD":case"DDD":case"DDDD":b!=null&&(c[2]=~~b);break;case"YY":c[0]=~~b+(~~b>70?1900:2e3);break;case"YYYY":c[0]=~~Math.abs(b);break;case"a":case"A":d.isPm=(b+"").toLowerCase()==="pm";break;case"H":case"HH":case"h":case"hh":c[3]=~~b;break;case"m":case"mm":c[4]=~~b;break;case"s":case"ss":c[5]=~~b;break;case"S":case"SS":case"SSS":c[6]=~~(("0."+b)*1e3);break;case"Z":case"ZZ":d.isUTC=!0,e=(b+"").match(x),e&&e[1]&&(d.tzh=~~e[1]),e&&e[2]&&(d.tzm=~~e[2]),e&&e[0]==="+"&&(d.tzh=-d.tzh,d.tzm=-d.tzm)}b==null&&(c[8]=!1)}function W(a,b){var c=[0,0,1,0,0,0,0],d={tzh:0,tzm:0},e=b.match(k),f,g;for(f=0;f<e.length;f++)g=(U(e[f]).exec(a)||[])[0],g&&(a=a.slice(a.indexOf(g)+g.length)),D[e[f]]&&V(e[f],g,c,d);return d.isPm&&c[3]<12&&(c[3]+=12),d.isPm===!1&&c[3]===12&&(c[3]=0),O(c,d.isUTC,d.tzh,d.tzm)}function X(a,b){var c,d=a.match(m)||[],e,f=99,g,h,i;for(g=0;g<b.length;g++)h=W(a,b[g]),e=T(new H(h),b[g]).match(m)||[],i=N(d,e),i<f&&(f=i,c=h);return c}function Y(a){var b="YYYY-MM-DDT",c;if(u.exec(a)){for(c=0;c<4;c++)if(w[c][1].exec(a)){b+=w[c][0];break}return s.exec(a)?W(a,b+" Z"):W(a,b)}return new Date(a)}function Z(a,b,c,d,e){var f=e.relativeTime[a];return typeof f=="function"?f(b||1,!!c,a,d):f.replace(/%d/i,b||1)}function $(a,b,c){var e=d(Math.abs(a)/1e3),f=d(e/60),g=d(f/60),h=d(g/24),i=d(h/365),j=e<45&&["s",e]||f===1&&["m"]||f<45&&["mm",f]||g===1&&["h"]||g<22&&["hh",g]||h===1&&["d"]||h<=25&&["dd",h]||h<=45&&["M"]||h<345&&["MM",d(h/30)]||i===1&&["y"]||["yy",i];return j[2]=b,j[3]=a>0,j[4]=c,Z.apply({},j)}function _(a,c){b.fn[a]=function(a){var b=this._isUTC?"UTC":"";return a!=null?(this._d["set"+b+c](a),this):this._d["get"+b+c]()}}function ab(a){b.duration.fn[a]=function(){return this._data[a]}}function bb(a,c){b.duration.fn["as"+a]=function(){return+this/c}}var b,c="1.7.2",d=Math.round,e,f={},g="en",h=typeof module!="undefined"&&module.exports,i="months|monthsShort|weekdays|weekdaysShort|weekdaysMin|longDateFormat|calendar|relativeTime|ordinal|meridiem".split("|"),j=/^\/?Date\((\-?\d+)/i,k=/(\[[^\[]*\])|(\\)?(Mo|MM?M?M?|Do|DDDo|DD?D?D?|ddd?d?|do?|w[o|w]?|YYYY|YY|a|A|hh?|HH?|mm?|ss?|SS?S?|zz?|ZZ?|.)/g,l=/(\[[^\[]*\])|(\\)?(LT|LL?L?L?)/g,m=/([0-9a-zA-Z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+)/gi,n=/\d\d?/,o=/\d{1,3}/,p=/\d{3}/,q=/\d{1,4}/,r=/[0-9a-z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+/i,s=/Z|[\+\-]\d\d:?\d\d/i,t=/T/i,u=/^\s*\d{4}-\d\d-\d\d(T(\d\d(:\d\d(:\d\d(\.\d\d?\d?)?)?)?)?([\+\-]\d\d:?\d\d)?)?/,v="YYYY-MM-DDTHH:mm:ssZ",w=[["HH:mm:ss.S",/T\d\d:\d\d:\d\d\.\d{1,3}/],["HH:mm:ss",/T\d\d:\d\d:\d\d/],["HH:mm",/T\d\d:\d\d/],["HH",/T\d\d/]],x=/([\+\-]|\d\d)/gi,y="Month|Date|Hours|Minutes|Seconds|Milliseconds".split("|"),z={Milliseconds:1,Seconds:1e3,Minutes:6e4,Hours:36e5,Days:864e5,Months:2592e6,Years:31536e6},A={},B="DDD w M D d".split(" "),C="M D H h m s w".split(" "),D={M:function(){return this.month()+1},MMM:function(a){return E("monthsShort",this.month(),this,a)},MMMM:function(a){return E("months",this.month(),this,a)},D:function(){return this.date()},DDD:function(){var a=new Date(this.year(),this.month(),this.date()),b=new Date(this.year(),0,1);return~~((a-b)/864e5+1.5)},d:function(){return this.day()},dd:function(a){return E("weekdaysMin",this.day(),this,a)},ddd:function(a){return E("weekdaysShort",this.day(),this,a)},dddd:function(a){return E("weekdays",this.day(),this,a)},w:function(){var a=new Date(this.year(),this.month(),this.date()-this.day()+5),b=new Date(a.getFullYear(),0,4);return~~((a-b)/864e5/7+1.5)},YY:function(){return K(this.year()%100,2)},YYYY:function(){return K(this.year(),4)},a:function(){return this.lang().meridiem(this.hours(),this.minutes(),!0)},A:function(){return this.lang().meridiem(this.hours(),this.minutes(),!1)},H:function(){return this.hours()},h:function(){return this.hours()%12||12},m:function(){return this.minutes()},s:function(){return this.seconds()},S:function(){return~~(this.milliseconds()/100)},SS:function(){return K(~~(this.milliseconds()/10),2)},SSS:function(){return K(this.milliseconds(),3)},Z:function(){var a=-this.zone(),b="+";return a<0&&(a=-a,b="-"),b+K(~~(a/60),2)+":"+K(~~a%60,2)},ZZ:function(){var a=-this.zone(),b="+";return a<0&&(a=-a,b="-"),b+K(~~(10*a/6),4)}};while(B.length)e=B.pop(),D[e+"o"]=G(D[e]);while(C.length)e=C.pop(),D[e+e]=F(D[e],2);D.DDDD=F(D.DDD,3),b=function(c,d){if(c===null||c==="")return null;var e,f;return b.isMoment(c)?new H(new Date(+c._d),c._isUTC,c._lang):(d?M(d)?e=X(c,d):e=W(c,d):(f=j.exec(c),e=c===a?new Date:f?new Date(+f[1]):c instanceof Date?c:M(c)?O(c):typeof c=="string"?Y(c):new Date(c)),new H(e))},b.utc=function(a,c){return M(a)?new H(O(a,!0),!0):(typeof a=="string"&&!s.exec(a)&&(a+=" +0000",c&&(c+=" Z")),b(a,c).utc())},b.unix=function(a){return b(a*1e3)},b.duration=function(a,c){var d=b.isDuration(a),e=typeof a=="number",f=d?a._data:e?{}:a,g;return e&&(c?f[c]=a:f.milliseconds=a),g=new I(f),d&&(g._lang=a._lang),g},b.humanizeDuration=function(a,c,d){return b.duration(a,c===!0?null:c).humanize(c===!0?!0:d)},b.version=c,b.defaultFormat=v,b.lang=function(a,c){var d;if(!a)return g;(c||!f[a])&&P(a,c);if(f[a]){for(d=0;d<i.length;d++)b[i[d]]=f[a][i[d]];b.monthsParse=f[a].monthsParse,g=a}},b.langData=Q,b.isMoment=function(a){return a instanceof H},b.isDuration=function(a){return a instanceof I},b.lang("en",{months:"January_February_March_April_May_June_July_August_September_October_November_December".split("_"),monthsShort:"Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec".split("_"),weekdays:"Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),weekdaysShort:"Sun_Mon_Tue_Wed_Thu_Fri_Sat".split("_"),weekdaysMin:"Su_Mo_Tu_We_Th_Fr_Sa".split("_"),longDateFormat:{LT:"h:mm A",L:"MM/DD/YYYY",LL:"MMMM D YYYY",LLL:"MMMM D YYYY LT",LLLL:"dddd, MMMM D YYYY LT"},meridiem:function(a,b,c){return a>11?c?"pm":"PM":c?"am":"AM"},calendar:{sameDay:"[Today at] LT",nextDay:"[Tomorrow at] LT",nextWeek:"dddd [at] LT",lastDay:"[Yesterday at] LT",lastWeek:"[last] dddd [at] LT",sameElse:"L"},relativeTime:{future:"in %s",past:"%s ago",s:"a few seconds",m:"a minute",mm:"%d minutes",h:"an hour",hh:"%d hours",d:"a day",dd:"%d days",M:"a month",MM:"%d months",y:"a year",yy:"%d years"},ordinal:function(a){var b=a%10;return~~(a%100/10)===1?"th":b===1?"st":b===2?"nd":b===3?"rd":"th"}}),b.fn=H.prototype={clone:function(){return b(this)},valueOf:function(){return+this._d},unix:function(){return Math.floor(+this._d/1e3)},toString:function(){return this._d.toString()},toDate:function(){return this._d},toArray:function(){var a=this;return[a.year(),a.month(),a.date(),a.hours(),a.minutes(),a.seconds(),a.milliseconds(),!!this._isUTC]},isValid:function(){return this._a?this._a[8]!=null?!!this._a[8]:!N(this._a,(this._a[7]?b.utc(this._a):b(this._a)).toArray()):!isNaN(this._d.getTime())},utc:function(){return this._isUTC=!0,this},local:function(){return this._isUTC=!1,this},format:function(a){return T(this,a?a:b.defaultFormat)},add:function(a,c){var d=c?b.duration(+c,a):b.duration(a);return L(this,d,1),this},subtract:function(a,c){var d=c?b.duration(+c,a):b.duration(a);return L(this,d,-1),this},diff:function(a,c,e){var f=this._isUTC?b(a).utc():b(a).local(),g=(this.zone()-f.zone())*6e4,h=this._d-f._d-g,i=this.year()-f.year(),j=this.month()-f.month(),k=this.date()-f.date(),l;return c==="months"?l=i*12+j+k/30:c==="years"?l=i+(j+k/30)/12:l=c==="seconds"?h/1e3:c==="minutes"?h/6e4:c==="hours"?h/36e5:c==="days"?h/864e5:c==="weeks"?h/6048e5:h,e?l:d(l)},from:function(a,c){return b.duration(this.diff(a)).lang(this._lang).humanize(!c)},fromNow:function(a){return this.from(b(),a)},calendar:function(){var a=this.diff(b().sod(),"days",!0),c=this.lang().calendar,d=c.sameElse,e=a<-6?d:a<-1?c.lastWeek:a<0?c.lastDay:a<1?c.sameDay:a<2?c.nextDay:a<7?c.nextWeek:d;return this.format(typeof e=="function"?e.apply(this):e)},isLeapYear:function(){var a=this.year();return a%4===0&&a%100!==0||a%400===0},isDST:function(){return this.zone()<b([this.year()]).zone()||this.zone()<b([this.year(),5]).zone()},day:function(a){var b=this._isUTC?this._d.getUTCDay():this._d.getDay();return a==null?b:this.add({d:a-b})},startOf:function(a){switch(a.replace(/s$/,"")){case"year":this.month(0);case"month":this.date(1);case"day":this.hours(0);case"hour":this.minutes(0);case"minute":this.seconds(0);case"second":this.milliseconds(0)}return this},endOf:function(a){return this.startOf(a).add(a.replace(/s?$/,"s"),1).subtract("ms",1)},sod:function(){return this.clone().startOf("day")},eod:function(){return this.clone().endOf("day")},zone:function(){return this._isUTC?0:this._d.getTimezoneOffset()},daysInMonth:function(){return b.utc([this.year(),this.month()+1,0]).date()},lang:function(b){return b===a?Q(this):(this._lang=b,this)}};for(e=0;e<y.length;e++)_(y[e].toLowerCase(),y[e]);_("year","FullYear"),b.duration.fn=I.prototype={weeks:function(){return J(this.days()/7)},valueOf:function(){return this._milliseconds+this._days*864e5+this._months*2592e6},humanize:function(a){var b=+this,c=this.lang().relativeTime,d=$(b,!a,this.lang()),e=b<=0?c.past:c.future;return a&&(typeof e=="function"?d=e(d):d=e.replace(/%s/i,d)),d},lang:b.fn.lang};for(e in z)z.hasOwnProperty(e)&&(bb(e,z[e]),ab(e.toLowerCase()));bb("Weeks",6048e5),h&&(module.exports=b),typeof ender=="undefined"&&(this.moment=b),typeof define=="function"&&define.amd&&define("moment",[],function(){return b})}).call(this);
(function() {

  window.Helpers = {
    truncate: function(string, limit) {
      if (string.length > limit) {
        return string.substring(0, limit).replace(/[\s+]$/g, '') + '...';
      } else {
        return string;
      }
    }
  };

}).call(this);
(function() {

  jQueryInWindow(function($) {
    var DELAY_LOGIN_CHECK, LOGGED_OUT_TEXT, checkIfLoggedIn, jumpToComponent, loggedOut, numCampaigns,
      _this = this;
    $(document).click(function(e) {
      if ($(e.target).hasClass('ui-disabled')) {
        return e.preventDefault() && e.stopPropagation() && e.stopImmediatePropagation();
      }
    });
    window.dateFormat = function(dateStr) {
      var d;
      d = moment(new Date(dateStr));
      return d.format('MMMM D, YYYY') + ' at ' + d.format('h:mm A');
    };
    window.dataTableDateFormat = function(row) {
      var d;
      d = row.aData['created_at'];
      return "<span title='" + d + "'>" + (dateFormat(d)) + "</span>";
    };
    LOGGED_OUT_TEXT = 'Your session has expired, please log in again.';
    loggedOut = false;
    $(document).ajaxError(function(e, jqXHR) {
      if (jqXHR.status === 403 && !loggedOut) {
        loggedOut = true;
        alert(LOGGED_OUT_TEXT);
        return document.location.reload(true);
      }
    });
    $('#modals').appendTo($('body'));
    DELAY_LOGIN_CHECK = 10000;
    checkIfLoggedIn = function() {
      return $.ajax({
        url: './campaigns/logged_in',
        success: function() {
          return _.delay(checkIfLoggedIn, DELAY_LOGIN_CHECK);
        },
        error: function(jqXHR) {
          if (jqXHR.status === 403 && !loggedOut) {
            loggedOut = true;
            alert(LOGGED_OUT_TEXT);
            return document.location.reload(true);
          }
        }
      });
    };
    _.delay(checkIfLoggedIn, DELAY_LOGIN_CHECK);
    _.templateSettings = {
      evaluate: /\{%([\s\S]+?)%\}/g,
      escape: /\{\{([\s\S]+?)\}\}/g
    };
    jumpToComponent = window.location.href.match(/show=(.*?)([#|&]|$)/i);
    if (jumpToComponent && jumpToComponent.length > 1) {
      jumpToComponent = [jumpToComponent[1]];
    }
    this.JUMP_TO_COMPONENT = jumpToComponent || null;
    _.deepClone = function(obj) {
      return $.extend(true, {}, obj);
    };
    numCampaigns = $('meta[name=num-campaigns]').attr('content');
    this.PASSWORD_UNCHANGED = $('meta[name=smtp-password-unchanged]').attr('content');
    this.DEFAULT_SELECT2_OPTS = {
      minimumResultsForSearch: 12,
      formatResultCssClass: function(result) {
        return "id-" + result.id;
      }
    };
    return $(document).ready(function() {
      var campaignSummary, index;
      Placeholders.init(true);
      campaignSummary = new CampaignSummary();
      index = numCampaigns > 0 ? 1 : 0;
      return _this.tabView = new CampaignTabView({
        el: $('#tab-wrap'),
        campaignSummary: campaignSummary,
        index: index
      });
    });
  });

}).call(this);
(function() {

  jQueryInWindow(function($) {
    this.Poller = (function() {

      Poller.TIME_OUT = 8000;

      function Poller(collection) {
        this.collection = collection;
      }

      Poller.prototype.start = function() {
        var outerCollection, repoll,
          _this = this;
        outerCollection = this.collection;
        this.stopped = false;
        repoll = function(collection) {
          if (_this.stopped || _this.polling) {
            return;
          }
          _this.polling = true;
          return $.ajax({
            url: collection.url + '?t=' + Math.round((new Date()).getTime() / 1000),
            dataType: 'json',
            success: function(data) {
              var collectionChanged, toRemove;
              collectionChanged = false;
              toRemove = _.filter(collection.models, function(m) {
                return _.all(data, function(mm) {
                  return mm.id !== m.id;
                });
              });
              _.each(data, function(model) {
                var newModel, oldModel;
                oldModel = _.find(collection.models, function(m) {
                  return m.id === model.id;
                });
                if (oldModel) {
                  return oldModel.set(model);
                } else {
                  newModel = new CampaignSummary;
                  collection.unshift(newModel, {
                    silent: true
                  });
                  newModel.set(model);
                  return collectionChanged = true;
                }
              });
              collection.remove(toRemove);
              _this.polling = false;
              if (collectionChanged) {
                collection.trigger('change');
              }
              return _.delay((function() {
                return repoll.call(_this, collection);
              }), Poller.TIME_OUT);
            },
            error: function(e) {
              _this.polling = false;
              return _.delay((function() {
                return repoll.call(_this, collection);
              }), Poller.TIME_OUT);
            }
          });
        };
        return repoll(this.collection);
      };

      Poller.prototype.stop = function() {
        return this.stopped = true;
      };

      return Poller;

    })();
    return this.SingleModelPoller = (function() {

      function SingleModelPoller(model, url, TIME_OUT, cb) {
        this.model = model;
        this.url = url != null ? url : '';
        this.TIME_OUT = TIME_OUT != null ? TIME_OUT : 8000;
        this.cb = cb != null ? cb : function() {};
      }

      SingleModelPoller.prototype.start = function() {
        var outerModel, repoll,
          _this = this;
        outerModel = this.model;
        this.stopped = false;
        repoll = function(model) {
          if (_this.cb) {
            _this.cb.call(_this);
          }
          if (_this.stopped || _this.polling) {
            return;
          }
          _this.polling = true;
          return $.ajax({
            url: _this.url + '?t=' + Math.round((new Date()).getTime() / 1000),
            dataType: 'json',
            success: function(data) {
              outerModel.set(data);
              _this.polling = false;
              return _.delay((function() {
                return repoll.call(_this, model);
              }), _this.TIME_OUT);
            },
            error: function(e) {
              _this.polling = false;
              return _.delay((function() {
                return repoll.call(_this, model);
              }), _this.TIME_OUT);
            }
          });
        };
        return repoll(this.model);
      };

      SingleModelPoller.prototype.stop = function() {
        return this.stopped = true;
      };

      return SingleModelPoller;

    })();
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignSummary = (function(_super) {

      __extends(CampaignSummary, _super);

      function CampaignSummary() {
        return CampaignSummary.__super__.constructor.apply(this, arguments);
      }

      CampaignSummary.prototype.defaults = {
        name: '',
        config_type: 'wizard',
        web_host: '',
        web_port: 80,
        notification_enabled: false,
        notification_email_address: '',
        notification_email_subject: '',
        notification_email_message: '',
        id: null,
        campaign_facts: {
          emails_sent: {
            visible: false,
            count: ''
          },
          emails_opened: {
            visible: false,
            count: ''
          },
          links_clicked: {
            visible: false,
            count: ''
          },
          forms_started: {
            visible: false,
            count: ''
          },
          forms_submitted: {
            visible: false,
            count: ''
          },
          prone_to_bap: {
            visible: false,
            count: ''
          },
          sessions_opened: {
            visible: false,
            count: ''
          }
        },
        campaign_details: {
          current_status: '',
          email_count: '',
          web_page_count: '',
          portable_file_count: '',
          email_targets_count: '',
          started_at: '',
          evidence_collected: '',
          name: ''
        },
        campaign_components: [],
        campaign_configuration: {
          web_config: {
            configured: false
          },
          smtp_config: {
            configured: false
          }
        }
      };

      CampaignSummary.prototype.webPages = function() {
        var components;
        components = this.get('campaign_components');
        return _.filter(components, function(c) {
          return c.type === 'web_page';
        });
      };

      CampaignSummary.prototype.emails = function() {
        var components;
        components = this.get('campaign_components');
        return _.filter(components, function(c) {
          return c.type === 'email';
        });
      };

      CampaignSummary.prototype.hasWebPagesOrEmails = function() {
        var cd;
        cd = this.get('campaign_details');
        return cd.email_count + cd.web_page_count > 0;
      };

      CampaignSummary.prototype.hasBeenLaunched = function() {
        return this.get('campaign_details').started_at.toLowerCase() !== 'not started';
      };

      CampaignSummary.prototype.running = function() {
        return this.get('campaign_details').current_status.toLowerCase() === 'running';
      };

      CampaignSummary.prototype.preparing = function() {
        return this.get('campaign_details').current_status.toLowerCase() === 'preparing';
      };

      CampaignSummary.prototype.launchable = function() {
        return this.get('campaign_details').startable;
      };

      CampaignSummary.prototype.usesWizard = function() {
        return this.get('config_type') === 'wizard';
      };

      CampaignSummary.prototype.save = function(opts) {
        var name, paramNames, params, url, _i, _len;
        if (opts == null) {
          opts = {};
        }
        url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + this.id + ".json";
        paramNames = ['config_type', 'name', 'notification_enabled', 'notification_email_message', 'notification_email_address', 'notification_email_subject'];
        params = [];
        for (_i = 0, _len = paramNames.length; _i < _len; _i++) {
          name = paramNames[_i];
          params.push({
            name: "social_engineering_campaign[" + name + "]",
            value: this.get(name)
          });
        }
        params.push({
          name: '_method',
          value: 'PUT'
        });
        return $.ajax({
          url: url,
          data: params,
          type: 'POST',
          success: opts['success'],
          error: opts['success']
        });
      };

      return CampaignSummary;

    })(Backbone.Model);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.TabView = (function(_super) {

      __extends(TabView, _super);

      function TabView() {
        return TabView.__super__.constructor.apply(this, arguments);
      }

      TabView.prototype.initialize = function(opts) {
        var pageWrap, _ref;
        this.touchEnabled = false;
        this.index = (_ref = typeof JUMP_TO_COMPONENT !== "undefined" && JUMP_TO_COMPONENT !== null ? JUMP_TO_COMPONENT : opts['index']) != null ? _ref : 0;
        this.tabs || (this.tabs = []);
        this.size || (this.size = this.tabs.length);
        this.render();
        pageWrap = $($.parseHTML($('#tab-pages').html())).appendTo(this.el);
        this.tabs.each(function(tab) {
          tab.setElement($('.pages', pageWrap));
          return tab.render();
        });
        return this.enableTouchAfter(0.2);
      };

      TabView.prototype.template = _.template($('#tab-header', TabView.el).html());

      TabView.prototype.enableTouchAfter = function(seconds) {
        var _this = this;
        return _.delay((function() {
          return _this.touchEnabled = true;
        }), seconds * 1000);
      };

      TabView.prototype.disableTouch = function() {
        return this.touchEnabled = false;
      };

      TabView.prototype.setTabIndex = function(index) {
        var $allPages, $page, oldIndex,
          _this = this;
        if (index < 0 || index >= this.tabs.length) {
          return;
        }
        if (this.oldDelay) {
          window.clearTimeout(this.oldDelay);
        }
        oldIndex = this.index;
        this.index = index;
        $(this.tabs[oldIndex]).trigger('willHide');
        $(this.tabs[this.index]).trigger('willDisplay');
        $('.tab-header>.cell', this.el).removeClass('selected');
        $('.tab-header>.cell', this.el).eq(index).addClass('selected');
        $allPages = $('.slider .pages>.cell', this.el);
        $page = $('.slider .pages>.cell', this.el).eq(index);
        $allPages.css({
          height: 'auto'
        });
        this.oldDelay = _.delay((function() {
          _this.oldDelay = null;
          return $('.slider .pages>.cell', _this.el).not(':eq(' + index + ')').css({
            height: '1px',
            overflow: 'hidden',
            visibility: 'hidden'
          });
        }), 200);
        $page.css({
          height: 'auto',
          overflow: 'visible',
          visibility: 'visible'
        });
        $('.slider .pages', this.el).css('left', (index * -100) + '%');
        if (index === 0) {
          if ($page.hasClass('loading')) {
            return $page.removeClass('loading');
          }
        } else if ($page.hasClass('loading')) {
          if (this.animatable) {
            return _.delay((function() {
              return $page.removeClass('loading');
            }), 300);
          } else {
            return $page.removeClass('loading');
          }
        }
      };

      TabView.prototype.events = {
        'click .tab-header>.cell': 'tabClicked'
      };

      TabView.prototype.tabClicked = function(e) {
        var $target, idx;
        $target = $(e.target).parentsUntil('.tab-header', '.cell');
        if (!$target.length) {
          $target = $(e.target);
        }
        if ($target) {
          idx = $('.tab-header>.cell', this.el).index($target);
          return this.userClickedTab(idx);
        }
      };

      TabView.prototype.userClickedTab = function(idx) {
        if (!this.touchEnabled) {
          return;
        }
        if (this.index === idx) {
          return;
        }
        this.disableTouch();
        this.enableTouchAfter(0.2);
        return this.setTabIndex(idx);
      };

      TabView.prototype.render = function(opts) {
        var _this = this;
        if (this.dom) {
          this.dom.remove();
        }
        this.dom = $($.parseHTML(this.template(this))[1]).prependTo($(this.el));
        return _.delay((function() {
          _this.setTabIndex(_this.index);
          if (_this.animatable) {
            return;
          }
          return _.defer(function() {
            _this.animatable = true;
            return $('.slider .pages', _this.el).addClass('animatable');
          });
        }), 0);
      };

      return TabView;

    })(Backbone.View);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.SingleTabPageView = (function(_super) {

      __extends(SingleTabPageView, _super);

      function SingleTabPageView() {
        return SingleTabPageView.__super__.constructor.apply(this, arguments);
      }

      SingleTabPageView.prototype.initialize = function() {
        return _.bindAll(this, 'render');
      };

      SingleTabPageView.prototype.template = _.template('<div class="cell loading"></div>');

      SingleTabPageView.prototype.render = function() {
        return $($.parseHTML(this.template(this))[0]).appendTo($(this.el));
      };

      return SingleTabPageView;

    })(Backbone.View);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.ReusableCampaignElementsView = (function(_super) {

      __extends(ReusableCampaignElementsView, _super);

      function ReusableCampaignElementsView() {
        return ReusableCampaignElementsView.__super__.constructor.apply(this, arguments);
      }

      ReusableCampaignElementsView.EMAIL_TEMPLATES = 1;

      ReusableCampaignElementsView.MALICIOUS_FILES = 3;

      ReusableCampaignElementsView.TARGET_LISTS = 0;

      ReusableCampaignElementsView.WEB_TEMPLATES = 2;

      ReusableCampaignElementsView.prototype.initialize = function() {
        return _.bindAll(this, 'render', 'updateTable', 'willDisplay', 'editClicked', 'deleteClicked');
      };

      ReusableCampaignElementsView.prototype.tblTemplate = _.template($('#reusable-elements').html());

      ReusableCampaignElementsView.prototype.events = {
        'change select[name=element_type]': 'updateTable',
        'click a.new': 'newClicked',
        'click .delete-span': 'deleteClicked'
      };

      ReusableCampaignElementsView.prototype.willDisplay = function() {
        return this.render();
      };

      ReusableCampaignElementsView.generateTableHeaders = function() {
        var cboxWidth, checkboxDisplay, headers, renderCheckbox, renderName, renderNameShow, renderNameWithoutLink,
          _this = this;
        renderName = function(row, link) {
          var id, name, selIdx, url;
          if (link == null) {
            link = true;
          }
          url = $('select[name=element_type]', this.el).val();
          selIdx = $('select[name=element_type]', this.el).attr('selectedIndex');
          name = row.aData.name || row.aData.attachable_type;
          id = row.aData.id;
          if (selIdx === ReusableCampaignElementsView.MALICIOUS_FILES || !link) {
            return name;
          }
          return "<a class='name' href='" + (_.escape(url)) + "/" + (_.escape(id)) + "/edit' target='_blank' data-id='" + (_.escape(id)) + "'>" + (_.escape(name)) + "</a>";
        };
        renderNameWithoutLink = function(row) {
          return renderName(row, false);
        };
        renderNameShow = function(row) {
          var id, name, url;
          url = $('select[name=element_type]', this.el).val();
          name = row.aData.name || row.aData.attachable_type;
          id = row.aData.id;
          return "<a class='name' href='" + (_.escape(url)) + "/" + (_.escape(id)) + "' target='_blank' data-id='" + (_.escape(id)) + "'>" + (_.escape(name)) + "</a>";
        };
        renderCheckbox = function(model_name) {
          return function(row) {
            var id;
            id = row.aData.id;
            return "<input type='checkbox' name='" + model_name + "_ids[]' value='" + (_.escape(id)) + "' />";
          };
        };
        checkboxDisplay = function(model_name) {
          return "<input type='checkbox' name='all_" + (_.escape(model_name)) + "s' value='false' />";
        };
        headers = [];
        cboxWidth = '20px';
        headers[this.EMAIL_TEMPLATES] = [
          {
            bSortable: false,
            display: checkboxDisplay('email_template'),
            sWidth: cboxWidth,
            fnRender: renderCheckbox('email_template')
          }, {
            mDataProp: 'name',
            display: 'Name',
            fnRender: renderName
          }, {
            mDataProp: 'created_at',
            display: 'Created',
            fnRender: dataTableDateFormat
          }
        ];
        headers[this.MALICIOUS_FILES] = [
          {
            bSortable: false,
            display: checkboxDisplay('user_submitted_file'),
            sWidth: cboxWidth,
            fnRender: renderCheckbox('user_submitted_file')
          }, {
            mDataProp: 'name',
            display: 'Name',
            fnRender: renderNameWithoutLink
          }, {
            mDataProp: 'user_name',
            display: 'User'
          }, {
            mDataProp: 'file_size',
            display: 'File Size',
            fnRender: function(row) {
              var fs;
              fs = row.aData['file_size'];
              return helpers.formatBytes(fs);
            }
          }, {
            mDataProp: 'created_at',
            display: 'Created',
            fnRender: dataTableDateFormat
          }
        ];
        headers[this.TARGET_LISTS] = [
          {
            bSortable: false,
            display: checkboxDisplay('target_list'),
            sWidth: cboxWidth,
            fnRender: renderCheckbox('target_list')
          }, {
            mDataProp: 'name',
            display: 'Name',
            fnRender: renderNameShow
          }, {
            mDataProp: 'targets_count',
            display: '# Targets'
          }, {
            mDataProp: 'created_at',
            display: 'Created',
            fnRender: dataTableDateFormat
          }
        ];
        headers[this.WEB_TEMPLATES] = [
          {
            bSortable: false,
            display: checkboxDisplay('email_template'),
            sWidth: cboxWidth,
            fnRender: renderCheckbox('web_template')
          }, {
            mDataProp: 'name',
            display: 'Name',
            fnRender: renderName
          }, {
            mDataProp: 'created_at',
            display: 'Created',
            fnRender: dataTableDateFormat
          }
        ];
        return headers;
      };

      ReusableCampaignElementsView.prototype.tableHeaders = ReusableCampaignElementsView.generateTableHeaders();

      ReusableCampaignElementsView.prototype.headerForRow = function(row) {
        var headers;
        headers = this.tableHeaders[row];
        return "<tr><th>" + (_.pluck(headers, 'display').join('</th><th>')) + "</th></tr>";
      };

      ReusableCampaignElementsView.prototype.updateTable = function(e) {
        var $select, $table, name, newURL, row, singleName, sort_col, tblMarkup, url,
          _this = this;
        $select = $('select[name=element_type]', this.el);
        url = $select.val();
        name = $('option:selected', $select).text();
        this._url = url;
        tblMarkup = '<table class="list sortable"><thead></thead><tbody></tbody></table>';
        $table = $(tblMarkup);
        $('.table', this.el).html('').append($table);
        row = $select.get(0).selectedIndex;
        $('thead', $table).html(this.headerForRow(row));
        sort_col = [[this.tableHeaders[row].length - 1, 'desc']];
        this.tableHeaders[row][0].sClass = 'checkbox';
        this.dataTable = $table.dataTable({
          oLanguage: {
            sEmptyTable: "No data has been recorded."
          },
          aoColumns: this.tableHeaders[row],
          bServerSide: true,
          sAjaxSource: "" + url + ".json",
          bFilter: false,
          bProcessing: true,
          aaSorting: sort_col,
          sDom: 't<"list-table-footer clearfix"ip <"sel" l>>r',
          sPaginationType: 'r7Style',
          fnDrawCallback: function() {
            var resetDeleteBtn;
            $('.table a.name', _this.el).click(_this.editClicked);
            resetDeleteBtn = function() {
              var $boxes, anyChecked;
              $boxes = $(".table input[type=checkbox]", _this.el).not('[name^=all_]');
              anyChecked = _.find($boxes, function(box) {
                return $(box).is(':checked');
              });
              return $('.delete-span', _this.el).show().toggleClass('ui-disabled', !!!anyChecked);
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
        singleName = name.replace(/s$/, '');
        $('.table', this.el).removeClass('loading');
        newURL = "" + url + "/new";
        $('a.new', this.el).attr('href', newURL).text("New " + singleName);
        return $('.reusable-elements form', this.el).attr('action', url);
      };

      ReusableCampaignElementsView.prototype.classForSelectedOption = function() {
        var selIdx;
        selIdx = $('select[name=element_type] option:selected', this.el).index();
        return [TargetListView, EmailTemplateView, WebTemplateView, MaliciousFileView][selIdx];
      };

      ReusableCampaignElementsView.prototype.newClicked = function(e) {
        var fv, klass, url,
          _this = this;
        e.preventDefault();
        url = $(e.target).attr('href');
        klass = this.classForSelectedOption();
        fv = new klass({
          onClose: function() {
            return _this.updateTable();
          }
        });
        return fv.load(url);
      };

      ReusableCampaignElementsView.prototype.editClicked = function(e) {
        var fv, klass, url,
          _this = this;
        e.preventDefault();
        url = $(e.target).attr('href');
        klass = this.classForSelectedOption();
        fv = new klass({
          onClose: (function() {
            return _this.updateTable();
          }),
          buttons: false
        });
        return fv.load(url);
      };

      ReusableCampaignElementsView.prototype.deleteClicked = function(e) {
        var $form, $sels, name, pluralizedName, singleName, url,
          _this = this;
        e.preventDefault();
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        $form = $('.reusable-elements form', this.el);
        $sels = $('td input[type=checkbox]:checked', $form);
        name = $('select[name=element_type] option:selected', this.el).text();
        singleName = name.replace(/s$/, '');
        pluralizedName = $sels.size() === 1 ? singleName : name;
        if (!confirm("Are you sure you want to delete " + ($sels.size()) + " " + pluralizedName + "?")) {
          return;
        }
        $(e.currentTarget).addClass('ui-disabled');
        url = $form.attr('action');
        return $.ajax({
          url: url,
          type: 'POST',
          data: $form.serialize(),
          success: function(data) {
            $('.reusable-elements .status', _this.el).show().removeClass('errors').addClass('success').text("Successfully deleted " + name + ".").delay(5000).fadeOut();
            $(e.currentTarget).removeClass('ui-disabled');
            return _this.updateTable();
          },
          error: function(e) {
            var data;
            data = $.parseJSON(e.responseText);
            $('.reusable-elements .status', _this.el).show().addClass('errors').removeClass('success').text(data['error']).delay(5000).fadeOut();
            $(e.currentTarget).removeClass('ui-disabled');
            return $('.reusable-elements .delete-span', _this.el).removeClass('ui-disabled');
          }
        });
      };

      ReusableCampaignElementsView.prototype.render = function() {
        this.dom || (this.dom = ReusableCampaignElementsView.__super__.render.apply(this, arguments));
        if (this.tblDom) {
          this.tblDom.remove();
        }
        this.tblDom = $($.parseHTML(this.tblTemplate(this))).appendTo(this.dom);
        this._url = null;
        $('select', this.el).select2(DEFAULT_SELECT2_OPTS);
        return this.updateTable();
      };

      return ReusableCampaignElementsView;

    })(SingleTabPageView);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.MultiView = (function(_super) {

      __extends(MultiView, _super);

      function MultiView() {
        return MultiView.__super__.constructor.apply(this, arguments);
      }

      MultiView.prototype.initialize = function(opts) {
        this.subviews = [];
        this.options = opts;
        this.subviewClasses = opts['subviews'] || [];
        return MultiView.__super__.initialize.apply(this, arguments);
      };

      MultiView.prototype.addSubview = function(subview) {
        this.subviews.push(subview);
        return subview;
      };

      MultiView.prototype.render = function() {
        var el,
          _this = this;
        el = MultiView.__super__.render.apply(this, arguments);
        return this.subviewClasses.each(function(subview) {
          var opts;
          opts = _.extend(_this.options, {
            el: el
          });
          return _this.addSubview(new subview(opts)).render();
        });
      };

      return MultiView;

    })(SingleTabPageView);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignComponentsView = (function(_super) {

      __extends(CampaignComponentsView, _super);

      function CampaignComponentsView() {
        return CampaignComponentsView.__super__.constructor.apply(this, arguments);
      }

      CampaignComponentsView.prototype.initialize = function(opts) {
        this.editing = false;
        this.campaignSummary = opts['campaignSummary'];
        this.currComponentType = 'email';
        _.bindAll(this, 'render', 'implicitlyCreateCampaign', 'toggleTray', 'renderComponentInModal');
        return this.campaignSummary.bind('change:campaign_components change:config_type', this.render);
      };

      CampaignComponentsView.prototype.template = _.template($('#campaign-components').html());

      CampaignComponentsView.prototype.baseURL = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + this.campaignSummary.id;
      };

      CampaignComponentsView.prototype.implicitlyCreateCampaign = function(e) {
        var data;
        if (this.campaignSummary.id === null) {
          e.stopImmediatePropagation();
          e.stopPropagation();
          e.preventDefault();
          data = $('form.social_engineering_campaign', this.el).serialize();
          return $(document).trigger('createCampaign', {
            data: data,
            callback: function() {
              return $(e.target).click();
            }
          });
        }
      };

      CampaignComponentsView.prototype.openModalWindow = function(url, cb) {
        var formViewClass, opts,
          _this = this;
        if (cb == null) {
          cb = function() {};
        }
        formViewClass = this.currComponentType === 'portable_file' ? FormView : PaginatedFormView;
        opts = {
          campaignSummary: this.campaignSummary,
          formQuery: this.editFormQuery,
          confirm: 'Are you sure you want to close? Your unsaved changes will be lost.',
          save: function() {
            var $form;
            $form = $('form', _this.modal.el);
            Placeholders.submitHandler($form[0]);
            $('textarea.to-code-mirror', $form).trigger('loadFromEditor');
            $form.trigger('syncWysiwyg');
            return $.ajax({
              url: $form.attr('action'),
              type: $form.attr('method'),
              data: $form.serialize(),
              success: function(data) {
                _this.campaignSummary.set(data);
                _this.render();
                return _this.modal.close({
                  confirm: false
                });
              },
              error: function(response) {
                var $errs, $page, pageIdx;
                $('.content-frame>.content', _this.modal.el).html(response.responseText);
                $errs = $('p.inline-errors', _this.modal.el);
                $page = $errs.first().parents('.page>div.cell').first();
                pageIdx = $page.index();
                _this.renderComponentInModal();
                return _this.modal.onLoad();
              }
            });
          }
        };
        if (this.currComponentType === 'portable_file') {
          this.modal = new FormView(opts);
        } else if (this.currComponentType === 'email') {
          this.modal = new EmailFormView(opts);
        } else if (this.currComponentType === 'web_page') {
          this.modal = new WebPageFormView(opts);
        }
        return this.modal.load(url, cb);
      };

      CampaignComponentsView.prototype.renderComponentInModal = function() {
        if (this.currComponentType === 'web_page') {
          window.renderCodeMirror();
          window.renderWebPageEdit();
          return window.renderAttributeDropdown();
        } else if (this.currComponentType === 'portable_file') {
          return window.renderPortableFileEdit();
        }
      };

      CampaignComponentsView.prototype.setCurrComponentType = function(currComponentType) {
        this.currComponentType = currComponentType;
      };

      CampaignComponentsView.prototype.setEditFormQuery = function(editFormQuery) {
        this.editFormQuery = editFormQuery;
      };

      CampaignComponentsView.prototype.calculateEditFormQuery = function(name) {
        var query;
        if (!this.campaignSummary.usesWizard()) {
          return '';
        }
        query = '?hide_name=true';
        if (name) {
          query += "&init_name=" + name;
        }
        if (this.currComponentType === 'web_page' && name === encodeURIComponent('Landing Page')) {
          query += '&attack_type=phishing&disable_attack_type=true';
          query += '&show_only_custom_redirect_page=true';
        }
        return query;
      };

      CampaignComponentsView.prototype.getComponentPath = function(target) {
        var $a, $li, id, name, query;
        $li = $(target).parents('ul.add-nav li');
        if (!$li.size()) {
          $li = $(target);
        }
        $a = $('a', $li);
        id = $a.attr('component-id');
        name = encodeURIComponent($('p', $li).text());
        query = this.calculateEditFormQuery(name);
        this.setEditFormQuery(query);
        if (id && id.length > 0) {
          return "" + id + "/edit" + query;
        } else {
          return "new" + query;
        }
      };

      CampaignComponentsView.prototype.addEmailButtonClicked = function(e) {
        var path;
        e.preventDefault();
        if (this.editing) {
          return;
        }
        this.setCurrComponentType('email');
        path = this.getComponentPath(e.target);
        return this.openModalWindow("" + (this.baseURL()) + "/emails/" + path, this.renderComponentInModal);
      };

      CampaignComponentsView.prototype.addWebPageButtonClicked = function(e) {
        var path;
        e.preventDefault();
        if (this.editing) {
          return;
        }
        this.setCurrComponentType('web_page');
        path = this.getComponentPath(e.target);
        return this.openModalWindow("" + (this.baseURL()) + "/web_pages/" + path, this.renderComponentInModal);
      };

      CampaignComponentsView.prototype.addPortableKeyButtonClicked = function(e) {
        var path;
        e.preventDefault();
        if (this.editing) {
          return;
        }
        this.setCurrComponentType('portable_file');
        path = this.getComponentPath(e.target);
        return this.openModalWindow("" + (this.baseURL()) + "/portable_files/" + path, this.renderComponentInModal);
      };

      CampaignComponentsView.prototype.resetShadowArrowPosition = function() {
        var pos;
        pos = $('.inline-add', this.el).position();
        return $('.shadow-arrow', this.el).css({
          left: "" + (pos.left + 53) + "px"
        });
      };

      CampaignComponentsView.prototype.toggleTray = function(e) {
        e.preventDefault();
        $('.shadow-arrow', this.el).toggle();
        this.resetShadowArrowPosition();
        return $('.component-buttons', this.el).animate({
          height: 'toggle'
        }, 200);
      };

      CampaignComponentsView.prototype.events = {
        'click .component-buttons ul.add-nav li.component a': 'implicitlyCreateCampaign',
        'click .campaign-components ul.add-nav li a': 'implicitlyCreateCampaign',
        'click li .add-portable_file': 'addPortableKeyButtonClicked',
        'click li .add-email': 'addEmailButtonClicked',
        'click li .add-web_page': 'addWebPageButtonClicked',
        'click .toggle-component-edit-mode': 'toggleComponentEditMode',
        'click a.add-component': 'toggleTray',
        'click div.delete': 'deleteComponent'
      };

      CampaignComponentsView.prototype.findOrCreateComponentByName = function(name, type) {
        if (type == null) {
          type = '';
        }
        return _.find(this.campaignComponents, function(comp) {
          return comp.name === name;
        }) || {
          name: name,
          id: null,
          type: type,
          classText: 'unconfigured'
        };
      };

      CampaignComponentsView.prototype.deleteComponent = function(e) {
        var component, id, type, url,
          _this = this;
        id = $(e.target).parents('li.component').find('a').attr('component-id');
        if (!(id && id.length > 0)) {
          return;
        }
        id = parseInt(id);
        component = _.find(this.campaignSummary.get('campaign_components'), (function(comp) {
          return comp.id === id;
        }));
        if (!component) {
          return;
        }
        if (!confirm("Are you sure you want to delete this " + (_.str.humanize(component.type)) + "?")) {
          return;
        }
        type = component.type;
        type = type === 'portable_file' ? 'portable_file' : type;
        url = "" + (this.baseURL()) + "/" + type + "s/" + id;
        return $.ajax({
          url: url,
          type: 'POST',
          data: {
            '_method': 'DELETE'
          },
          success: function() {
            var newComponents, originalComponents;
            originalComponents = _this.campaignSummary.get('campaign_components');
            newComponents = _.without(originalComponents, component);
            if (newComponents.length === 0) {
              _this.editing = false;
            }
            return _this.campaignSummary.set({
              'campaign_components': newComponents
            });
          },
          error: function() {
            var newComponents, originalComponents;
            originalComponents = _this.campaignSummary.get('campaign_components');
            newComponents = _.without(originalComponents, component);
            if (newComponents.length === 0) {
              _this.editing = false;
            }
            return _this.campaignSummary.set({
              'campaign_components': newComponents
            });
          }
        });
      };

      CampaignComponentsView.prototype.setEditing = function(editing) {
        this.editing = editing;
        $('.campaign-components a.toggle-component-edit-mode', this.el).toggleClass('active', this.editing);
        $('.campaign-components .add-nav', this.el).toggleClass('editing', this.editing);
        $('.campaign-components .inline-add', this.el).toggleClass('editing', this.editing);
        if (this.editing) {
          return $('.campaign-components .component-buttons, .shadow-arrow', this.el).hide();
        }
      };

      CampaignComponentsView.prototype.toggleComponentEditMode = function() {
        this.setEditing(!this.editing);
        return false;
      };

      CampaignComponentsView.prototype.pollForPortableFilesIfNecessary = function() {
        var components, pFiles, url,
          _this = this;
        components = this.campaignSummary.get('campaign_components');
        if (this.portableFilePoller) {
          this.portableFilePoller.stop();
        }
        this.portableFilePoller = null;
        pFiles = _.filter(components, function(c) {
          return c.type === 'portable_file' && !c.download;
        });
        url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + this.campaignSummary.id + ".json";
        if (!(pFiles.length > 0)) {
          return;
        }
        this.portableFilePoller = new SingleModelPoller(this.campaignSummary, url, 2000, function() {
          if (_this.portableFilePoller && CampaignTabView.activeView.index !== 0) {
            _this.portableFilePoller.stop();
            return _this.portableFilePoller = null;
          }
        });
        return this.portableFilePoller.start();
      };

      CampaignComponentsView.prototype.render = function() {
        var $next, component1, component2, component3, pdo;
        this.campaignComponents = this.campaignSummary.get('campaign_components');
        this.wrapperClass = '';
        if (this.campaignSummary.get('config_type') === 'wizard') {
          component1 = this.findOrCreateComponentByName('Landing Page', 'web_page');
          pdo = component1['phishing_redirect_origin'];
          if (pdo && pdo === 'phishing_wizard_redirect_page') {
            component2 = this.findOrCreateComponentByName('Redirect Page', 'web_page');
          }
          component3 = this.findOrCreateComponentByName('E-mail', 'email');
          this.wizardComponents = [component3];
          this.wizardComponents.push(component1);
          if (component2) {
            this.wizardComponents.push(component2);
          }
          this.wrapperClass = 'wizard';
        }
        if (this.dom) {
          $next = this.dom.next().first();
        }
        if (this.dom) {
          this.dom.remove();
        }
        if ($next && $next.size()) {
          this.dom = $($.parseHTML(this.template(this))[1]);
          this.dom.insertBefore($next);
        } else {
          this.dom = $($.parseHTML(this.template(this))[1]);
          this.dom.appendTo($(this.el));
        }
        this.setEditing(this.editing);
        return this.pollForPortableFilesIfNecessary();
      };

      return CampaignComponentsView;

    })(Backbone.View);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignConfigurationView = (function(_super) {

      __extends(CampaignConfigurationView, _super);

      function CampaignConfigurationView() {
        return CampaignConfigurationView.__super__.constructor.apply(this, arguments);
      }

      CampaignConfigurationView.prototype.initialize = function(opts) {
        this.campaignSummary = opts['campaignSummary'];
        _.bindAll(this, 'render', 'update', 'radioChanged');
        this.campaignSummary.bind('change', this.update);
        return this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Submitting... ',
          autoOpen: false,
          closeOnEscape: false
        });
      };

      CampaignConfigurationView.prototype.template = _.template($('#campaign-configuration').html());

      CampaignConfigurationView.prototype.events = {
        'keydown [name^=\'social_engineering_campaign\']': 'nameChanged',
        'keydown input[type=radio]': 'radioKeyPress',
        'change input[type=radio]': 'radioChanged'
      };

      CampaignConfigurationView.prototype.nameChanged = function(e) {
        $('~p.inline-errors', e.target).remove();
        if (e.keyCode === 9 || e.which === 9) {
          if (!$('input[type=radio]', this.el).first().attr('disabled')) {
            $('input[type=radio]', this.el).first().focus();
          }
          e.preventDefault();
          e.stopImmediatePropagation();
          e.stopPropagation();
          return false;
        }
      };

      CampaignConfigurationView.prototype.radioKeyPress = function(e) {
        if (e.keyCode === 9 || e.which === 9) {
          if (e.shiftKey) {
            return;
          }
          return e.preventDefault();
        }
      };

      CampaignConfigurationView.prototype.radioChanged = function(e) {
        var components, configType, confirmMsg, name,
          _this = this;
        configType = $('[name="social_engineering_campaign[config_type]"]:checked', this.el).val();
        if (configType === this.campaignSummary.get('config_type')) {
          return;
        }
        name = $("[name='social_engineering_campaign[name]']", this.el).val();
        if (this.campaignSummary.get('id') === null) {
          return this.campaignSummary.set({
            config_type: configType,
            name: name
          });
        } else {
          components = this.campaignSummary.get('campaign_components');
          confirmMsg = ("Are you sure you want to switch this campaign to " + configType + " mode? ") + "This will destroy any web pages, emails, or portable files that " + "are currently associated with the campaign.";
          if (components.length > 0 && !confirm(confirmMsg)) {
            $('[name="social_engineering_campaign[config_type]"]:not(:checked)', this.el).attr('checked', 'checked');
            return;
          }
          this.campaignSummary.set({
            config_type: configType,
            campaign_components: []
          });
          this.loadingModal.dialog('open');
          return this.campaignSummary.save({
            success: function() {
              return _this.loadingModal.dialog('close');
            },
            error: function() {
              return _this.loadingModal.dialog('close');
            }
          });
        }
      };

      CampaignConfigurationView.prototype.update = function() {
        var $radioBtns, name, radioIdx;
        name = this.campaignSummary.get('name');
        $("[name='social_engineering_campaign[name]']", this.el).val(name).nextAll('p.inline-errors').fadeOut().delay(200).remove();
        radioIdx = this.campaignSummary.usesWizard() ? 0 : 1;
        $radioBtns = $("input[name='social_engineering_campaign[config_type]']");
        $radioBtns.prop('checked', false);
        return $radioBtns.eq(radioIdx).prop('checked', true);
      };

      CampaignConfigurationView.prototype.render = function() {
        if (this.dom) {
          this.dom.remove();
        }
        this.campaignConfig = this.campaignSummary.get('campaign_configuration');
        return this.dom = $($.parseHTML(this.template(this))[1]).appendTo($(this.el));
      };

      return CampaignConfigurationView;

    })(Backbone.View);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignServerConfigurationsView = (function(_super) {

      __extends(CampaignServerConfigurationsView, _super);

      function CampaignServerConfigurationsView() {
        return CampaignServerConfigurationsView.__super__.constructor.apply(this, arguments);
      }

      CampaignServerConfigurationsView.prototype.SMTP_CHECK_URL = "email_server_config/check_smtp";

      CampaignServerConfigurationsView.prototype.initialize = function(opts) {
        _.bindAll(this, 'render', 'update', 'webServerConfigClicked', 'emailServerConfigClicked');
        this.campaignSummary = opts['campaignSummary'];
        return this.campaignSummary.bind('change', this.update);
      };

      CampaignServerConfigurationsView.prototype.events = {
        'click ul li a': 'implicitlyCreateCampaign',
        'click .web-server-config-open-modal': 'webServerConfigClicked',
        'click .email-server-config-open-modal': 'emailServerConfigClicked'
      };

      CampaignServerConfigurationsView.prototype.baseURL = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + this.campaignSummary.id;
      };

      CampaignServerConfigurationsView.prototype.configModalOpts = function() {
        var opts,
          _this = this;
        return opts = {
          confirm: 'Are you sure you want to close? Your unsaved changes will be lost.',
          save: function() {
            var $form, data;
            $form = $('form', _this.modal.el).first();
            Placeholders.submitHandler($form[0]);
            if ($(':file', $form).size() > 0) {
              data = $(':input', $form[0]).not(':file').serializeArray();
              return $.ajax({
                url: $form.attr('action'),
                type: $form.attr('method'),
                data: data,
                iframe: true,
                files: $(':file', $form),
                processData: false,
                complete: function(data) {
                  data = $.parseJSON(data.responseText);
                  if (data.success === true) {
                    return _this._successCallback(data);
                  } else {
                    return _this._errorCallback(data.error);
                  }
                }
              });
            } else {
              return $.ajax({
                url: $form.attr('action'),
                type: $form.attr('method'),
                data: $form.serialize(),
                success: function(data) {
                  return _this._successCallback(data);
                },
                error: function(response) {
                  return _this._errorCallback(response.responseText);
                }
              });
            }
          }
        };
      };

      CampaignServerConfigurationsView.prototype._errorCallback = function(error) {
        $('.content-frame>.content', this.modal.el).html(error);
        this.modal.onLoad();
        if (this.modal.options['onLoad']) {
          return this.modal.options['onLoad'].call(this);
        }
      };

      CampaignServerConfigurationsView.prototype._successCallback = function(data) {
        this.campaignSummary.set(data);
        this.update();
        return this.modal.close({
          confirm: false
        });
      };

      CampaignServerConfigurationsView.prototype.implicitlyCreateCampaign = function(e) {
        var data;
        if (this.campaignSummary.id === null) {
          e.stopImmediatePropagation();
          e.stopPropagation();
          e.preventDefault();
          data = $('form.social_engineering_campaign', this.el).serialize();
          return $(document).trigger('createCampaign', {
            data: data,
            callback: function() {
              return $(e.target).click();
            }
          });
        }
      };

      CampaignServerConfigurationsView.prototype.webServerConfigClicked = function(e) {
        var bapExists, opts, saveCallback, shouldShowBapOptions, url;
        url = "" + (this.baseURL()) + "/web_server_config/edit";
        bapExists = _.any(this.campaignSummary.get('campaign_components'), function(comp) {
          return comp.type === 'web_page' && comp.attack_type.toLowerCase() === 'bap';
        });
        shouldShowBapOptions = !this.campaignSummary.usesWizard() && bapExists;
        opts = this.configModalOpts();
        opts['onLoad'] = function() {
          var $customCertCheckbox, $sslCheckbox, $textField,
            _this = this;
          $("[name='social_engineering_campaign[web_host]']", this.el).last().bind('click focus', function() {
            return $("input[name='social_engineering_campaign[web_host_custom]']", _this.el).focus();
          });
          $("[name='social_engineering_campaign[web_host]'][checked]", this.el).focus();
          $sslCheckbox = $("[name='social_engineering_campaign[web_ssl]']", this.el);
          $sslCheckbox.change(function(e) {
            var $port, ssl;
            ssl = $(e.target).is(':checked');
            $('div.ssl-options').toggle(ssl);
            $port = $("[name='social_engineering_campaign[web_port]']", this.el);
            if (ssl && $port.val() === '80') {
              $port.val('443');
            }
            if (!ssl && $port.val() === '443') {
              return $port.val('80');
            }
          });
          $sslCheckbox.change();
          $customCertCheckbox = $("[name='social_engineering_campaign[web_ssl_use_custom_cert]']", this.el);
          $customCertCheckbox.change(function(e) {
            var $tf, checked;
            checked = $(e.target).is(':checked');
            $tf = $("[name='social_engineering_campaign[web_ssl_cert]']", this.el);
            return $tf.toggle(checked);
          });
          $customCertCheckbox.change();
          $textField = $("input[name='social_engineering_campaign[web_host_custom]']", this.el);
          $("label[for=social_engineering_campaign_web_host_custom_value]", this.el).append($textField);
          return $('.bap-options', this.el).toggle(shouldShowBapOptions);
        };
        saveCallback = opts['save'];
        opts['save'] = function() {
          var $lastRadio, $textField;
          $lastRadio = $("[name='social_engineering_campaign[web_host]']", this.el).last();
          if ($lastRadio.prop('checked')) {
            $textField = $("input[name='social_engineering_campaign[web_host_custom]']", this.el);
            $lastRadio.val($textField.val());
            $textField.remove();
          }
          Placeholders.submitHandler($('form', this.el)[0]);
          if (saveCallback) {
            return saveCallback.call(this);
          }
        };
        this.modal = new FormView(opts);
        return this.modal.load(url);
      };

      CampaignServerConfigurationsView.prototype.emailServerConfigClicked = function(e) {
        var opts, saveCallback, smtpCheckUrl, url;
        url = "" + (this.baseURL()) + "/email_server_config/edit";
        smtpCheckUrl = "" + (this.baseURL()) + "/" + this.SMTP_CHECK_URL;
        opts = this.configModalOpts();
        saveCallback = opts['save'];
        opts['save'] = function() {
          var $form, data,
            _this = this;
          $form = $('form', this.el).first();
          data = $form.serialize();
          $('.validate-box .status', this.el).removeClass('bad ok').text('Verifying SMTP settings...').addClass('spinning');
          $('a.save.primary', this.el).addClass('ui-disabled').parent('span').addClass('ui-disabled');
          return $.ajax({
            url: smtpCheckUrl,
            type: 'POST',
            data: data,
            success: function(resp) {
              var $status;
              if (!_this.opened) {
                return;
              }
              $status = $('.validate-box .status', _this.el);
              $status.removeClass('spinning bad').addClass('ok');
              data = $.parseJSON(resp.responseText);
              $status.text('Connection successful');
              $('a.save.primary', _this.el).removeClass('ui-disabled').parent('span').removeClass('ui-disabled');
              return saveCallback();
            },
            error: function(resp) {
              var $status;
              if (!_this.opened) {
                return;
              }
              $status = $('.validate-box .status', _this.el);
              $status.removeClass('spinning ok').addClass('bad');
              data = $.parseJSON(resp.responseText);
              $status.text(data['error_msg']);
              $('a.save.primary', _this.el).removeClass('ui-disabled').parent('span').removeClass('ui-disabled');
              if (!confirm("We were unable to connect to the provided SMTP server." + " Do you want to save anyway?")) {
                return;
              }
              return saveCallback();
            }
          });
        };
        opts['onLoad'] = function() {
          var $smtpPassField, TAB_KEY_CODE;
          TAB_KEY_CODE = 9;
          $smtpPassField = $("input[name='social_engineering_campaign[smtp_password]']", this.el);
          return $smtpPassField.keydown(function(e) {
            if (e.keyCode !== TAB_KEY_CODE && !e.shiftKey && $(e.target).val() === PASSWORD_UNCHANGED) {
              return $(e.target).val('');
            }
          });
        };
        this.modal = new FormView(opts);
        return this.modal.load(url);
      };

      CampaignServerConfigurationsView.prototype.template = _.template($('#campaign-server-configurations').html());

      CampaignServerConfigurationsView.prototype.update = function() {
        var $li, components, configData, configType, emailCount, showWebConfigured, webCount;
        components = this.campaignSummary.get('campaign_components');
        configType = this.campaignSummary.get('config_type');
        webCount = components.filter(function(c) {
          return c.type === 'web_page';
        }).length;
        emailCount = components.filter(function(c) {
          return c.type === 'email';
        }).length;
        configData = this.campaignSummary.get('campaign_configuration');
        if (configType !== 'wizard' && (!this.campaignSummary.id || (webCount + emailCount === 0))) {
          return $('.campaign-server-config-div', this.el).addClass('disabled');
        } else {
          $('.campaign-server-config-div', this.el).removeClass('disabled');
          $('ul.campaign-server-config-items>li', this.el).hide();
          if (configType === 'wizard' || webCount > 0) {
            $li = $('li.web-server-config-open-modal', this.el);
            $li.show().removeClass('unconfigured');
            showWebConfigured = configType === 'wizard' && this.campaignSummary.id === null;
            if (!(showWebConfigured || configData['web_config']['configured'])) {
              $li.addClass('unconfigured');
            }
          }
          if (configType === 'wizard' || emailCount > 0) {
            $li = $('li.email-server-config-open-modal', this.el);
            $li.show().removeClass('unconfigured');
            if (!configData['smtp_config']['configured']) {
              return $li.addClass('unconfigured');
            }
          }
        }
      };

      CampaignServerConfigurationsView.prototype.render = function() {
        this.dom = $($.parseHTML(this.template(this))[1]).appendTo($(this.el));
        return this.update();
      };

      return CampaignServerConfigurationsView;

    })(Backbone.View);
  });

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var DEFAULT_NOTIFICATION_MESSAGE, DEFAULT_NOTIFICATION_SUBJECT;
    DEFAULT_NOTIFICATION_MESSAGE = 'This is to let you know that we are about to launch ' + 'a social engineering campaign from Metasploit. ' + 'For more information, please contact ' + '[INSERT YOUR CONTACT NAME HERE.]';
    DEFAULT_NOTIFICATION_SUBJECT = 'Launching Metasploit social engineering campaign';
    return this.CampaignNotificationView = (function(_super) {

      __extends(CampaignNotificationView, _super);

      function CampaignNotificationView() {
        this.update = __bind(this.update, this);

        this.notificationsEnabledChanged = __bind(this.notificationsEnabledChanged, this);
        return CampaignNotificationView.__super__.constructor.apply(this, arguments);
      }

      CampaignNotificationView.prototype.initialize = function(opts) {
        return this.campaignSummary = opts['campaignSummary'];
      };

      CampaignNotificationView.prototype.createModal = function() {
        var email, msg, subject,
          _this = this;
        this.modal = $('#notification-dialog').dialog({
          modal: true,
          title: 'Notification Settings',
          autoOpen: false,
          closeOnEscape: false,
          width: 475,
          buttons: {
            "Cancel": function() {
              var $checkbox;
              $(_this.modal).dialog("close");
              if (_this.formSuccessRequired) {
                $checkbox = $('input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']', _this.el);
                $checkbox.removeAttr('checked');
                return _this.notificationsEnabledChanged({
                  target: $checkbox[0]
                });
              }
            },
            "Save": function() {
              return _this.saveNotificationSetup();
            }
          }
        });
        email = this.campaignSummary.get('notification_email_address');
        msg = this.campaignSummary.get('notification_email_message') || DEFAULT_NOTIFICATION_MESSAGE;
        subject = this.campaignSummary.get('notification_email_subject') || DEFAULT_NOTIFICATION_SUBJECT;
        this.setFormValue('notification_email_address', email);
        this.setFormValue('notification_email_message', msg);
        return this.setFormValue('notification_email_subject', subject);
      };

      CampaignNotificationView.prototype.setModalLoading = function(loading) {
        if (loading == null) {
          loading = false;
        }
        this.loadingModal || (this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Loading...',
          autoOpen: false,
          resizable: false,
          closeOnEscape: false,
          width: 300
        }));
        if (loading) {
          this.modal.dialog('close');
          return this.loadingModal.dialog('open');
        } else {
          this.modal.dialog('open');
          return this.loadingModal.dialog('close');
        }
      };

      CampaignNotificationView.prototype.setFormValue = function(name, value) {
        return $("[name='social_engineering_campaign[" + name + "]']", this.modal).val(value);
      };

      CampaignNotificationView.prototype.getFormValue = function(name) {
        return $("[name='social_engineering_campaign[" + name + "]']", this.modal).val();
      };

      CampaignNotificationView.prototype.template = _.template($('#campaign-notification').html());

      CampaignNotificationView.prototype.events = {
        'change input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']': 'notificationsEnabledChanged',
        'click a.notification-settings': 'showNotificationSetup'
      };

      CampaignNotificationView.prototype.toggleNotificationsEnabled = function(enabled) {
        var $checkbox;
        if (enabled == null) {
          enabled = true;
        }
        $checkbox = $('input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']', this.el);
        if (enabled) {
          return $checkbox.attr('checked', 'checked');
        } else {
          return $checkbox.removeAttr('checked');
        }
      };

      CampaignNotificationView.prototype.notificationsEnabledChanged = function(e) {
        var $checkbox, enabled,
          _this = this;
        $checkbox = $(e.target);
        enabled = $checkbox.is(':checked');
        this.campaignSummary.set('notification_enabled', enabled);
        $('.notification-settings', this.el).toggle(enabled);
        if (enabled) {
          this.formSuccessRequired = true;
          return this.showFormModal();
        } else {
          this.setModalLoading(true);
          return this.campaignSummary.save({
            success: function() {
              return $(_this.loadingModal).dialog('close');
            },
            error: function() {
              return $(_this.loadingModal).dialog('close');
            }
          });
        }
      };

      CampaignNotificationView.prototype.showNotificationSetup = function(e) {
        e.preventDefault();
        if (e && e.target && $(e.target).hasClass('ui-disabled')) {
          return;
        }
        this.formSuccessRequired = false;
        return this.showFormModal();
      };

      CampaignNotificationView.prototype.showFormModal = function() {
        this.createModal();
        $('.errors', this.modal).hide();
        return this.modal.dialog('open');
      };

      CampaignNotificationView.prototype.saveNotificationSetup = function() {
        var enabled, oldEmail, oldMsg, oldSubject,
          _this = this;
        this.setModalLoading(true);
        enabled = $('input[type=checkbox]', this.dom).is(':checked');
        oldEmail = this.campaignSummary.get('notification_email_address');
        oldMsg = this.campaignSummary.get('notification_email_message');
        oldSubject = this.campaignSummary.get('notification_email_subject');
        this.campaignSummary.set('notification_email_address', this.getFormValue('notification_email_address'));
        this.campaignSummary.set('notification_email_message', this.getFormValue('notification_email_message'));
        this.campaignSummary.set('notification_email_subject', this.getFormValue('notification_email_subject'));
        return this.campaignSummary.save({
          success: function(data) {
            _this.setModalLoading(false);
            if (data['success']) {
              return _this.modal.dialog('close');
            } else {
              $('.errors', _this.modal).show().html(data['message']);
              _this.campaignSummary.set('notification_email_address', oldEmail);
              _this.campaignSummary.set('notification_email_message', oldMsg);
              return _this.campaignSummary.set('notification_email_subject', oldSubject);
            }
          },
          error: function() {
            _this.setModalLoading(false);
            return _this.modal.dialog('close');
          }
        });
      };

      CampaignNotificationView.prototype.update = function() {
        var enabled, newDom;
        if (this.dom) {
          newDom = $($.parseHTML(this.template(this))[1]);
          this.dom.replaceWith(newDom);
          this.dom = newDom;
        }
        if (this.dom && this.campaignSummary) {
          this.dom.toggle(this.campaignSummary.id !== null);
        }
        enabled = this.campaignSummary.get('notification_enabled');
        if (enabled) {
          $('input[type=checkbox]', this.dom).attr('checked', 'checked');
        } else {
          $('input[type=checkbox]', this.dom).removeAttr('checked');
        }
        return $('.notification-settings', this.el).toggle(enabled);
      };

      CampaignNotificationView.prototype.render = function() {
        return this.dom = $($.parseHTML(this.template(this))[1]).appendTo($(this.el));
      };

      return CampaignNotificationView;

    })(Backbone.View);
  });

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignFactsView = (function(_super) {

      __extends(CampaignFactsView, _super);

      function CampaignFactsView() {
        this.resize = __bind(this.resize, this);
        return CampaignFactsView.__super__.constructor.apply(this, arguments);
      }

      CampaignFactsView.prototype.initialize = function(opts) {
        this.actions = ['sent_emails', 'opened_emails', 'links_clicked', 'sent_emails', 'submitted_forms', 'opened_sessions', 'opened_sessions'];
        this.attributes = ['emails_sent', 'emails_opened', 'links_clicked', 'forms_started', 'forms_submitted', 'sessions_opened', 'sessions_opened', 'prone_to_bap'];
        this.campaignSummary = opts['campaignSummary'];
        this.tabView = opts['tabView'];
        _.bindAll(this, 'render', 'circleClicked');
        this.campaignSummary.bind('change', this.render);
        this.prevPercentages = {};
        this.canvWidth = 200;
        return $(window).resize(this.resize);
      };

      CampaignFactsView.prototype.template = _.template($('#campaign-facts').html());

      CampaignFactsView.prototype.circlesTemplate = _.template($('#campaign-facts-circles').html());

      CampaignFactsView.prototype.events = {
        'click .large-circles .circle': 'circleClicked',
        'click .campaign-facts-lvl2 .circle': 'subCircleClicked'
      };

      CampaignFactsView.prototype.getClickedCircle = function(e) {
        var $circle;
        this.tabView.setTabIndex(1);
        $circle = $(e.target).parent('.circle');
        if (!$circle.size()) {
          $circle = $(e.target);
        }
        return $circle;
      };

      CampaignFactsView.prototype.subCircleClicked = function(e) {
        var $circle, idx;
        $circle = this.getClickedCircle(e);
        idx = 6;
        return $(this.tabView).trigger('scrollToCircle', [$circle, idx]);
      };

      CampaignFactsView.prototype.circleClicked = function(e) {
        var $circle, idx;
        $circle = this.getClickedCircle(e);
        idx = $circle.parents('.cell').first().prevAll().size();
        return $(this.tabView).trigger('scrollToCircle', [$circle, idx]);
      };

      CampaignFactsView.prototype.addVisibilityClasses = function(campaignFacts) {
        var fact, factName, _results;
        _results = [];
        for (factName in campaignFacts) {
          if (!__hasProp.call(campaignFacts, factName)) continue;
          fact = campaignFacts[factName];
          fact['cellClass'] = fact.visible ? '' : 'hidden-cell';
          _results.push(fact['cellClass'] += " " + factName);
        }
        return _results;
      };

      CampaignFactsView.prototype.resetCircleClasses = function() {
        var $circs;
        $circs = $('.large-circles .cell', this.el).not('.hidden-cell').removeClass('first last');
        $circs.first().addClass('first');
        return $circs.last().addClass('last');
      };

      CampaignFactsView.prototype.visibleCircles = function() {
        return $('.large-circles .cell', this.el).not('.hidden-cell');
      };

      CampaignFactsView.prototype.leftMargin = function() {
        return (100 - (this.visibleCircles().size() * (11.66667 + 5) - 11.6667)) / 2;
      };

      CampaignFactsView.prototype.centerCircles = function() {
        var $circs;
        $circs = this.visibleCircles();
        $circs.removeAttr('style');
        return $circs.first().css('margin-left', this.leftMargin() + '%');
      };

      CampaignFactsView.prototype.anyCirclesVisible = function(campaignFacts) {
        return !!_.find(campaignFacts, function(fact) {
          return fact.visible;
        });
      };

      CampaignFactsView.prototype.setVisible = function(v) {
        var $facts;
        return $facts = $('.campaign-facts', this.el).toggle(v).prev('h3').toggle(v);
      };

      CampaignFactsView.prototype.renderPie = function(idx, perc) {
        var $canvases, attr, c, campaignFacts, total, w;
        if (typeof perc !== 'number') {
          attr = this.attributes[idx];
          campaignFacts = this.campaignSummary.get('campaign_facts');
          total = parseInt(campaignFacts['emails_sent'].count) || 0;
          if (campaignFacts[attr].count === '') {
            return;
          }
          perc = campaignFacts[attr].count / total * 100;
        }
        $canvases = $('canvas', this.el);
        if (!($canvases.size() > idx)) {
          return;
        }
        c = $canvases[idx].getContext('2d');
        if (!c) {
          return;
        }
        w = this.canvWidth;
        c.clearRect(0, 0, w, w);
        c.beginPath();
        c.moveTo(w / 2, w / 2);
        c.arc(w / 2, w / 2, w / 2, -Math.PI / 2, Math.PI * perc * 2 / (w / 2) - Math.PI / 2, false);
        c.closePath();
        c.fillStyle = '#bbb';
        if (idx === this.selIdx) {
          c.fillStyle = '#FF9327';
        }
        return c.fill();
      };

      CampaignFactsView.prototype.animatePie = function(idx) {
        var $canv, attr, campaignFacts, percent,
          _this = this;
        $canv = $('canvas', this.el).eq(idx);
        $canv.css('font-size', '0');
        attr = this.attributes[idx];
        campaignFacts = this.campaignSummary.get('campaign_facts');
        percent = campaignFacts[attr].percentage;
        return _.delay((function() {
          $canv.parent().css({
            'font-size': _this.prevPercentages[attr] || 0
          });
          $canv.parent().animate({
            'font-size': percent + 'px'
          }, {
            duration: 400,
            step: function(currSize) {
              var dur;
              dur = parseInt(currSize);
              return _this.renderPie(idx, dur);
            },
            queue: true
          });
          return _this.prevPercentages[attr] = percent;
        }), 300);
      };

      CampaignFactsView.prototype.resize = function() {
        var i, _i, _ref, _results;
        this.canvWidth = $('.circle:visible', this.el).first().width();
        $('canvas', this.el).attr('width', this.canvWidth).attr('height', this.canvWidth);
        _results = [];
        for (i = _i = 0, _ref = this.actions.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(this.animatePie(i));
        }
        return _results;
      };

      CampaignFactsView.prototype.render = function() {
        var campaignDetails, campaignFacts, i, _i, _ref, _results;
        campaignFacts = _.deepClone(this.campaignSummary.get('campaign_facts'));
        campaignDetails = _.deepClone(this.campaignSummary.get('campaign_details'));
        this.addVisibilityClasses(campaignFacts);
        this.dom || (this.dom = $(this.template({
          campaignFacts: campaignFacts,
          campaignDetails: campaignDetails
        })).appendTo(this.$el));
        $('.circles', this.el).html(this.circlesTemplate({
          campaignFacts: campaignFacts
        }));
        this.resetCircleClasses();
        this.centerCircles();
        _results = [];
        for (i = _i = 0, _ref = this.actions.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(this.animatePie(i));
        }
        return _results;
      };

      return CampaignFactsView;

    })(Backbone.View);
  });

}).call(this);
(function() {
  var $,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $ = jQuery;

  this.CampaignSlideFactsView = (function(_super) {

    __extends(CampaignSlideFactsView, _super);

    function CampaignSlideFactsView() {
      this.tabClicked = __bind(this.tabClicked, this);
      return CampaignSlideFactsView.__super__.constructor.apply(this, arguments);
    }

    CampaignSlideFactsView.EMAILS_SENT_VIEW = 0;

    CampaignSlideFactsView.EMAIL_OPENINGS_VIEW = 1;

    CampaignSlideFactsView.VISITS_VIEW = 2;

    CampaignSlideFactsView.FORM_ACTIVITY_VIEW = 3;

    CampaignSlideFactsView.PHISHING_RESULTS_VIEW = 4;

    CampaignSlideFactsView.SESSIONS_VIEW = 5;

    CampaignSlideFactsView.prototype.initialize = function() {
      this.hideSubCircles = false;
      this.showTray = true;
      this.selIdx = -1;
      this._tc = null;
      CampaignSlideFactsView.__super__.initialize.apply(this, arguments);
      _.bindAll(this, 'scrollToCircle', 'updateDataTable');
      $(this.tabView).bind('scrollToCircle', this.scrollToCircle);
      $(this.tabView).bind('scrollToSubCircle', this.scrollToSubCircle);
      return this.campaignSummary.bind('change', this.updateDataTable);
    };

    CampaignSlideFactsView.prototype.dataTableColumns = function() {
      var columns, renderHumanTargetLink, renderPhishingResultLink,
        _this = this;
      columns = [
        {
          mDataProp: 'email_address',
          display: 'Email Address'
        }, {
          mDataProp: 'first_name',
          display: 'First Name'
        }, {
          mDataProp: 'last_name',
          display: 'Last Name'
        }
      ];
      renderPhishingResultLink = function(row) {
        var id, url;
        id = row.aData.phishing_result_id;
        url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + _this.campaignSummary.id + "/phishing_results/" + id;
        return "<a href='" + (_.escape(url)) + "' target='_blank' data-pr-id='" + (_.escape(id)) + "' class='anonymous'>Anonymous</a>";
      };
      renderHumanTargetLink = function(row) {
        var email_address, id, url;
        email_address = row.aData.email_address;
        id = row.aData.human_target_id;
        url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/human_targets/" + id;
        return "<a href='" + (_.escape(url)) + "' target='_blank' data-ht-id='" + (_.escape(id)) + "'>" + (_.escape(email_address)) + "</a>";
      };
      if (this.selIdx === CampaignSlideFactsView.PHISHING_RESULTS_VIEW) {
        columns[0]['fnRender'] = function(row) {
          var email_address;
          email_address = row.aData.email_address;
          if (email_address === null) {
            return renderPhishingResultLink(row);
          } else {
            return renderHumanTargetLink(row);
          }
        };
        columns.push({
          mDataProp: 'web_page_name',
          display: 'Web Page'
        });
        columns.push({
          mDataProp: 'created_at',
          display: 'Submitted on',
          sType: 'title-string',
          fnRender: dataTableDateFormat
        });
      } else if (this.selIdx === CampaignSlideFactsView.EMAIL_OPENINGS_VIEW) {
        columns[0]['fnRender'] = function(row) {
          return renderHumanTargetLink(row);
        };
        columns.push({
          mDataProp: 'created_at',
          display: 'Opened on',
          sType: 'title-string',
          fnRender: dataTableDateFormat
        });
      } else if (this.selIdx === CampaignSlideFactsView.VISITS_VIEW) {
        columns[0]['fnRender'] = function(row) {
          return renderHumanTargetLink(row);
        };
        columns.push({
          mDataProp: 'created_at',
          display: 'Clicked on',
          sType: 'title-string',
          fnRender: dataTableDateFormat
        });
      } else if (this.selIdx === CampaignSlideFactsView.SESSIONS_VIEW) {
        columns = [
          {
            mDataProp: 'id',
            display: 'Name',
            sWidth: '100px',
            fnRender: function(row) {
              return "<a target='_blank' href='/workspaces/" + WORKSPACE_ID + "/sessions/" + (_.escape(row.aData.id)) + "'>Session " + (_.escape(row.aData.id)) + "</a>";
            }
          }, {
            mDataProp: 'host_name',
            display: 'Host'
          }, {
            mDataProp: 'desc',
            display: 'Description'
          }, {
            mDataProp: 'stype',
            display: 'Session Type'
          }, {
            mDataProp: 'via_exploit',
            display: 'Attack Module'
          }, {
            mDataProp: 'os',
            display: 'OS',
            sWidth: '150px'
          }, {
            mDataProp: 'platform',
            display: 'Platform'
          }, {
            mDataProp: 'opened_at',
            display: 'Opened',
            sWidth: '150px'
          }
        ];
      }
      return columns;
    };

    CampaignSlideFactsView.prototype.updateDataTable = function() {
      if (this.dataTable) {
        return this.dataTable.fnReloadAjax();
      }
    };

    CampaignSlideFactsView.prototype.template = _.template($('#campaign-facts').html());

    CampaignSlideFactsView.prototype.currentCircleUrl = function() {
      var id;
      id = this.campaignSummary.get('id');
      return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + id + "/" + this.actions[this.selIdx];
    };

    CampaignSlideFactsView.prototype.exportButtonClicked = function() {
      return window.location.href = "" + (this.currentCircleUrl()) + ".csv";
    };

    CampaignSlideFactsView.prototype.events = _.extend({
      'click .tray .export': 'exportButtonClicked',
      'click ul.tabs li.tab a': 'tabClicked',
      'click .action-btn a': 'campaignActionClicked'
    }, CampaignFactsView.prototype.events);

    CampaignSlideFactsView.prototype.tabClicked = function(e) {
      var $tabs, idx;
      idx = $(e.currentTarget).parent().index();
      $tabs = this.$el.find('.tab-container div.tabs div.tab');
      $tabs.hide();
      $tabs.eq(idx).show();
      this.$el.find('.tab-container ul.tabs li.tab a').removeClass('active');
      $(e.currentTarget).addClass('active');
      e.preventDefault();
      return false;
    };

    CampaignSlideFactsView.prototype.circleClicked = function(e) {
      var $circle, idx;
      $circle = $(e.target).parent('.circle');
      if (!$circle.size()) {
        $circle = $(e.target);
      }
      idx = $circle.parents('.cell').first().prevAll().size();
      return this.scrollToCircle(e, $circle, idx);
    };

    CampaignSlideFactsView.prototype.campaignActionClicked = function(e) {
      var id, url;
      if (campaignDetails.current_status !== 'Finished' && $(e.target)[0].innerText !== 'Generate Report') {
        e.preventDefault();
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        id = this.campaignSummary.get('id');
        url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + id + "/execute";
        $(e.currentTarget).addClass('ui-disabled');
        return $.ajax({
          url: url,
          type: 'POST',
          dataType: 'json',
          success: function(data) {
            this.campaignSummary = new CampaignSummary(data);
            if ($(e.currentTarget)[0].innerText === 'Start') {
              $(e.currentTarget)[0].innerText = 'Stop';
            } else {
              $(e.currentTarget)[0].innerText = 'Generate Report';
              campaignDetails.current_status === 'Finished';
            }
            return $(e.currentTarget).removeClass('ui-disabled');
          }
        });
      }
    };

    CampaignSlideFactsView.prototype.render = function() {
      var $circle, $circles, $reportLink, href, newUrl,
        _this = this;
      CampaignSlideFactsView.__super__.render.apply(this, arguments);
      if (this.selIdx > -1) {
        $circles = $('.circle', this.el);
        $circles.each(function() {
          return $(this).parent('.cell').removeClass('selected');
        });
        $circles.eq(this.selIdx).addClass('selected').parent('cell').addClass('selected');
      } else {
        $circle = $('.large-circles .cell:not(.hidden-cell) .circle', this.el).first();
        this.scrollToCircle(null, $circle, $circle.parents('.cell').first().index());
      }
      if (this.visibleCircles().length === 0) {
        this.$el.find('.tab-container ul.tabs li.tab').first().hide().end().last().find('a').click();
      }
      if (!(this._tc != null)) {
        initRequire(['/assets/shared/backbone/views/task_console-2b33ca95cff5e52d76224f72a04e65c43567724dde282154d9eec61ad3e31df3.js'], function(TaskConsole) {
          var request, success, url;
          url = "campaigns/" + _this.campaignSummary.id + "/to_task.json";
          success = function(data) {
            var el, id;
            id = data.id;
            el = _this.$el.find('div.task-console')[0];
            _this._tc = new TaskConsole({
              el: el,
              task: id,
              prerendered: false
            });
            _this._tc.startUpdating();
            return $(el).removeClass('tab-loading');
          };
          request = function() {
            return $.getJSON(url, success).error(function() {
              return _.delay(request, 2500);
            });
          };
          return request();
        });
      }
      $reportLink = $('.action-btn a', this.el);
      href = $reportLink.attr('href');
      newUrl = href + ("?campaign_id=" + this.campaignSummary.id);
      if (!href.match(/\?/)) {
        return $reportLink.attr('href', newUrl);
      }
    };

    CampaignSlideFactsView.prototype.scrollToCircle = function(e, circle, idx) {
      var $cell, $circles, currPageClicked, delay,
        _this = this;
      currPageClicked = $(circle).parents().index(this.$el) > -1;
      delay = currPageClicked ? 75 : 200;
      if (idx !== this.selIdx || !currPageClicked) {
        this.selIdx = idx;
        circle = $('.circle', this.el)[idx];
        $cell = $(circle).parents('.row > div').first();
        $circles = $('.circle', this.el);
        $circles.each(function() {
          return $(this).parent('.cell').removeClass('selected');
        });
        $circles.removeClass('selected').eq(idx).addClass('selected').parent('.cell').addClass('selected');
        $('.tray', this.el).html('').addClass('loading');
        return _.delay((function() {
          var cWidth, col, columns, i, left, thead, totalW, visibleIdx, _i, _j, _len, _ref;
          if (!(_this.visibleCircles().length > 0)) {
            return;
          }
          visibleIdx = _this.visibleCircles().index($('.circle', $cell));
          left = $cell.position().left + parseInt($cell.css('margin-left'));
          cWidth = parseInt($cell.width());
          totalW = $('.large-circles').width();
          $('.shadow-arrow', _this.el).css({
            left: (left + cWidth / 2 - 20) / totalW * 100 + '%',
            bottom: '-7px',
            top: 'auto'
          });
          $('.tray', _this.el).css({
            height: 'auto'
          }).show();
          $('.campaign-facts.border-box', _this.el).css({
            'padding-bottom': 0
          }).removeClass('rd-shadow');
          $('.shadow-arrow-row', _this.el).css({
            height: '26px'
          });
          $('.shadow-arrow,.shadow-arrow-row', _this.el).show();
          for (i = _i = 0, _ref = _this.actions.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
            _this.renderPie(i);
          }
          columns = _this.dataTableColumns();
          thead = '';
          for (_j = 0, _len = columns.length; _j < _len; _j++) {
            col = columns[_j];
            thead += "<th>" + col.display + "</th>";
          }
          $('.tray', _this.el).html(_.template($('#targets-table').html()).call());
          $('.tray table>thead>tr', _this.el).html(thead);
          _this.dataTable = $('.tray table', _this.el).dataTable({
            oLanguage: {
              sEmptyTable: "No data has been recorded."
            },
            sDom: 'ft<"list-table-footer clearfix"ip <"sel" l>>r',
            sPaginationType: 'r7Style',
            bServerSide: true,
            sAjaxSource: _this.currentCircleUrl(),
            aoColumns: columns,
            bProcessing: true
          });
          return $('.tray', _this.el).removeClass('loading');
        }), delay);
      } else {
        return null;
      }
    };

    return CampaignSlideFactsView;

  })(CampaignFactsView);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var CampaignSummaryList;
    CampaignSummaryList = (function(_super) {

      __extends(CampaignSummaryList, _super);

      function CampaignSummaryList() {
        return CampaignSummaryList.__super__.constructor.apply(this, arguments);
      }

      CampaignSummaryList.prototype.model = CampaignSummary;

      CampaignSummaryList.prototype.url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns.json";

      return CampaignSummaryList;

    })(Backbone.Collection);
    return this.CampaignListView = (function(_super) {

      __extends(CampaignListView, _super);

      function CampaignListView() {
        return CampaignListView.__super__.constructor.apply(this, arguments);
      }

      CampaignListView.DISABLE_CLICK_FN = function(e) {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        return false;
      };

      CampaignListView.MAX_CAMPAIGNS_RUNNING = 1;

      CampaignListView.CAMPAIGN_RUN_LIMIT_MSG = "Cannot run more than " + CampaignListView.MAX_CAMPAIGNS_RUNNING + " campaign at a time.";

      CampaignListView.checkForInitializationErrors = function(opts) {
        var url;
        url = ("/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/") + ("" + opts.campaign.id + "/check_for_configuration_errors");
        return $.ajax({
          url: url,
          success: opts['success'] || function() {},
          error: opts['error'] || function() {}
        });
      };

      CampaignListView.prototype.initialize = function() {
        var jsonBlob, models;
        _.bindAll(this, 'render', 'testClicked', 'findingsClicked', 'editClicked', 'previewClicked', 'deleteClicked', 'renderIfVisible', 'willDisplay');
        jsonBlob = $.parseJSON($('meta[name=campaign-summaries-init]').attr('content'));
        $('meta[name=campaign-summaries-init]').remove();
        models = _.map(jsonBlob, function(modelAttrs) {
          return new CampaignSummary(modelAttrs);
        });
        this.disabledRows = {};
        this.collection = new CampaignSummaryList(models);
        this.collection.bind('change', this.renderIfVisible);
        this.poller = new Poller(this.collection);
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Loading... ',
          closeOnEscape: false,
          autoOpen: false
        });
        return CampaignListView.__super__.initialize.apply(this, arguments);
      };

      CampaignListView.prototype.willDisplay = function() {
        this.visible = true;
        this.poller.start();
        return this.render();
      };

      CampaignListView.prototype.willHide = function() {
        this.visible = false;
        if (this.poller) {
          return this.poller.stop();
        }
      };

      CampaignListView.prototype.renderIfVisible = function(e) {
        if (this.visible) {
          return this.render();
        }
      };

      CampaignListView.prototype.tblTemplate = _.template($('#campaign-list').html());

      CampaignListView.prototype.ajaxAlertOnError = function(opts) {
        return $.ajax({
          url: opts['url'],
          data: opts['data'] || {},
          dataType: opts['dataType'] || 'json',
          type: opts['type'] || 'get',
          success: opts['success'],
          error: function(e) {
            var fail;
            fail = $.parseJSON(e.responseText);
            if (fail && fail['error']) {
              alert(fail['error']);
            }
            if (opts['error']) {
              return opts['error'].call(this);
            }
          }
        });
      };

      CampaignListView.prototype.events = {
        'click .row': 'editClicked',
        'click .row .actions': 'stopPropagation',
        'click .row a.start': 'stopPropagation',
        'click .row .cell .actions a.test': 'testClicked',
        'click .row .cell .actions a.findings': 'findingsClicked',
        'click .row .cell .actions a.edit': 'editClicked',
        'click .row .cell .actions a.delete': 'deleteClicked',
        'click .row .cell .actions a.reset': 'resetClicked',
        'click .row .cell .actions a.preview': 'previewClicked',
        'click .row .cell a.start': 'startClicked',
        'click .row .cell a.stop-campaign': 'stopClicked',
        'click .new-action .btn a.new': 'newCampaignClicked',
        'click .row .cell .actions a.download-portable-file': 'showPortableFileDownloads'
      };

      CampaignListView.prototype.stopPropagation = function(e) {
        return e.stopPropagation();
      };

      CampaignListView.prototype.flashCampaign = function(id) {
        var _this = this;
        if (!id) {
          return;
        }
        return _.delay((function() {
          var $row;
          $row = $("div.row[campaign-id=" + id + "]", _this.el);
          $('html,body').animate({
            scrollTop: $row.offset().top - 0.35 * ($(window).height())
          }, 200);
          return $row.stop().css("background-color", "#DFF0D8").animate({
            backgroundColor: "#F8F8F8"
          }, 1600);
        }), 100);
      };

      CampaignListView.prototype.rowForClickTarget = function(e) {
        var $row;
        $row = $(e.target).parents('.row').first();
        if (!($row.size() > 0)) {
          $row = $(e.target);
        }
        if ($(e.target).hasClass('row')) {
          $row = $(e.target);
        }
        return $row;
      };

      CampaignListView.prototype.rowIndexForClickTarget = function(e) {
        var $row;
        $row = this.rowForClickTarget(e);
        return $row.first().prevAll().size();
      };

      CampaignListView.prototype.testClicked = function(e) {
        var idx;
        idx = this.rowIndexForClickTarget(e);
        return e.preventDefault();
      };

      CampaignListView.prototype.findingsClicked = function(e) {
        var facts, idx;
        idx = this.rowIndexForClickTarget(e);
        facts = new CampaignFactsRollupModalView({
          campaignSummary: this.collection.models[idx]
        });
        facts.open();
        return e.preventDefault();
      };

      CampaignListView.prototype.showPortableFileDownloads = function(e) {
        var campaign, idx, url,
          _this = this;
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        url = "" + (this.baseURL()) + "/" + campaign.id + "/portable_file_downloads";
        this.loadingModal.dialog('open');
        $.ajax({
          url: url,
          success: function(data) {
            var newModal;
            _this.loadingModal.dialog('close');
            return newModal = $('<div></div>').html(data).dialog({
              modal: true,
              title: 'Portable File Downloads'
            });
          },
          error: function() {
            return _this.loadingModal.dialog('close');
          }
        });
        return e.preventDefault();
      };

      CampaignListView.prototype.editClicked = function(e) {
        var $row, campaign, idx;
        e.preventDefault();
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!(campaign.running() || campaign.preparing())) {
          $row = this.rowForClickTarget(e);
          if ($row.hasClass('ui-disabled') || $(e.target).hasClass('ui-disabled')) {
            return;
          }
          if (!this.rowIsEnabled(campaign.id)) {
            return;
          }
          return $(document).trigger('editCampaign', campaign);
        }
      };

      CampaignListView.prototype.newCampaignClicked = function() {
        var campaign;
        campaign = new CampaignSummary;
        return $(document).trigger('editCampaign', campaign);
      };

      CampaignListView.prototype.deleteClicked = function(e) {
        var campaign, idx, url,
          _this = this;
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        if (!confirm('Are you sure you want to delete this campaign? ' + 'All associated campaign data will also be deleted.')) {
          return;
        }
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!this.rowIsEnabled(campaign.id)) {
          return;
        }
        url = "" + (this.baseURL()) + "/" + campaign.id;
        this.ajaxAlertOnError({
          url: url,
          type: 'post',
          data: {
            _method: 'delete'
          },
          success: function(resp) {
            var $row;
            $row = $("div.row[campaign-id=" + campaign.id + "]", _this.el);
            $row.fadeOut(200);
            $('a', $row).addClass('ui-disabled').click(CampaignListView.DISABLE_CLICK_FN);
            return _.delay((function() {
              _this.collection.remove(campaign);
              return _this.render();
            }), 200);
          }
        });
        return e.preventDefault();
      };

      CampaignListView.prototype.baseURL = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns";
      };

      CampaignListView.prototype.toggleLaunchButtons = function(id, enabled) {
        var $row;
        if (enabled == null) {
          enabled = false;
        }
        $row = $("div.row[campaign-id=" + id + "]", this.el);
        return $('div.launch a', $row).toggleClass('ui-disabled', !enabled);
      };

      CampaignListView.prototype.startClicked = function(e) {
        var campaign, idx,
          _this = this;
        e.preventDefault();
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!this.rowIsEnabled(campaign.id)) {
          return;
        }
        this.toggleLaunchButtons(campaign.id, false);
        return $(document).trigger('launchCampaign', {
          campaign: campaign,
          error: function() {
            return _this.toggleLaunchButtons(campaign.id, true);
          }
        });
      };

      CampaignListView.prototype.stopClicked = function(e) {
        var campaign, idx, url;
        e.preventDefault();
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!this.rowIsEnabled(campaign.id)) {
          return;
        }
        this.toggleLaunchButtons(campaign.id, false);
        url = "" + (this.baseURL()) + "/" + campaign.id + "/execute";
        return $.ajax({
          url: url,
          type: 'POST',
          dataType: 'json',
          success: function(data) {
            return campaign.set(data);
          }
        });
      };

      CampaignListView.prototype.resetClicked = function(e) {
        var $row, campaign, idx, newCampaign,
          _this = this;
        e.preventDefault();
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        $row = this.rowForClickTarget(e);
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!this.rowIsEnabled(campaign.id)) {
          return;
        }
        if (!confirm('Are you sure you want to reset your campaign? This will ' + 'clear all findings and data discovered by the campaign.')) {
          return;
        }
        this.disableRow(campaign.id);
        newCampaign = new CampaignSummary;
        campaign.set('campaign_facts', newCampaign.get('campaign_facts'));
        return $.ajax({
          type: "POST",
          url: "" + (this.baseURL()) + "/" + campaign.id + "/reset",
          success: function() {
            return _this.enableRow(campaign.id);
          },
          error: function() {
            return _this.enableRow(campaign.id);
          }
        });
      };

      CampaignListView.prototype.previewClicked = function(e) {
        var idx, modal;
        e.preventDefault();
        idx = this.rowIndexForClickTarget(e);
        modal = new CampaignPreviewModal({
          campaignSummary: this.collection.models[idx]
        });
        return modal.open();
      };

      CampaignListView.prototype.disableRow = function(id, doUpdate) {
        if (doUpdate == null) {
          doUpdate = true;
        }
        this.disabledRows[id + ''] = true;
        if (!doUpdate) {
          return this.update();
        }
      };

      CampaignListView.prototype.enableRow = function(id, doUpdate) {
        if (doUpdate == null) {
          doUpdate = true;
        }
        delete this.disabledRows[id + ''];
        if (!doUpdate) {
          return this.update();
        }
      };

      CampaignListView.prototype.rowIsEnabled = function(id) {
        return !this.disabledRows[id + ''];
      };

      CampaignListView.prototype.update = function() {
        var key, val, _ref, _results;
        _ref = this.disabledRows;
        _results = [];
        for (key in _ref) {
          if (!__hasProp.call(_ref, key)) continue;
          val = _ref[key];
          _results.push($(".row[campaign-id=" + key + "]", this.el).addClass('ui-disabled'));
        }
        return _results;
      };

      CampaignListView.prototype.render = function() {
        this.dom || (this.dom = CampaignListView.__super__.render.apply(this, arguments));
        if (this.tblDom) {
          this.tblDom.remove();
        }
        this.tblDom = $($.parseHTML(this.tblTemplate(this))).appendTo(this.dom);
        $('.campaign-list .row', this.el).last().addClass('last');
        $('.campaign-list .row', this.el).first().addClass('first');
        $('.campaign-list .row', this.el).parents('.cell').first().css({
          'padding-top': '0',
          'padding-bottom': '0'
        });
        return this.update();
      };

      return CampaignListView;

    })(SingleTabPageView);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignTabView = (function(_super) {

      __extends(CampaignTabView, _super);

      function CampaignTabView() {
        return CampaignTabView.__super__.constructor.apply(this, arguments);
      }

      CampaignTabView.prototype.initialize = function() {
        CampaignTabView.activeView || (CampaignTabView.activeView = this);
        this.tabs = [new CampaignConfigurationTabPageView(), new CampaignListView(), new ReusableCampaignElementsView()];
        return CampaignTabView.__super__.initialize.apply(this, arguments);
      };

      CampaignTabView.prototype.userClickedTab = function(idx) {
        if (idx === 0 && idx !== this.index) {
          $(document).trigger('editCampaign', new CampaignSummary, false);
        }
        return CampaignTabView.__super__.userClickedTab.call(this, idx);
      };

      CampaignTabView.prototype.render = function() {
        return CampaignTabView.__super__.render.apply(this, arguments);
      };

      return CampaignTabView;

    })(this.TabView);
  });

}).call(this);
(function() {
  var $,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $ = jQuery;

  this.RollupModalView = (function(_super) {

    __extends(RollupModalView, _super);

    function RollupModalView() {
      this.render = __bind(this.render, this);
      return RollupModalView.__super__.constructor.apply(this, arguments);
    }

    RollupModalView.prototype.initialize = function(opts) {
      this.options = opts;
      this.content || (this.content = this.options['content'] || '');
      this.buttons || (this.buttons = this.options['buttons'] || []);
      _.bindAll(this, 'load', 'closeClicked', 'close');
      this.opened = false;
      this.$el.addClass('rollup-modal');
      window.origConfirm || (window.origConfirm = window.confirm);
      return this.render();
    };

    RollupModalView.prototype.stubCustomConfirm = function() {
      var _this = this;
      return window.confirm = function() {
        if (_this.opened) {
          _this.escEnabled = false;
          _.delay((function() {
            return _this.escEnabled = true;
          }), 300);
          return origConfirm.apply(window, arguments);
        } else {
          return origConfirm.apply(window, arguments);
        }
      };
    };

    RollupModalView.prototype.open = function() {
      var _this = this;
      if (this.opened) {
        return;
      }
      if ($('#modals>div').size()) {
        return;
      }
      $('#modals').removeClass('empty');
      this.opened = true;
      this.openingDelayComplete = false;
      this.stubCustomConfirm();
      if (!$('#modals').parent('body').size()) {
        $('#modals').appendTo($('body'));
      }
      this.$el.appendTo($('#modals'));
      _.defer(function() {
        return _this.$el.addClass('up') && _this.onOpen();
      });
      return _.delay((function() {
        $('body').css({
          height: '100%',
          'overflow-y': 'hidden'
        });
        $('div.rollup-modal.up').click(function(e) {
          if (!$(e.target).hasClass('rollup-modal')) {
            return;
          }
          e.preventDefault();
          return _this.close();
        });
        _this.initScroll = [window.scrollX, window.scrollY];
        _this.escEnabled = true;
        $(window).on('keyup.rollup_modal_esc', function(e) {
          var $dialog;
          if (e.keyCode === 27 && _this.escEnabled) {
            $dialog = $('.ui-dialog:visible');
            if ($dialog.size() > 0) {
              if (!($('.loading:visible', $dialog).size() > 0)) {
                $('.ui-dialog-content', $dialog).dialog('close');
              }
              return;
            }
            return _this.close();
          }
        });
        return _this.openingDelayComplete = true;
      }), 300);
    };

    RollupModalView.prototype.close = function(opts) {
      var _ref;
      if (opts == null) {
        opts = {};
      }
      if (!this.opened) {
        return;
      }
      if ((_ref = opts['confirm']) == null) {
        opts['confirm'] = this.options['confirm'];
      }
      if (opts['confirm'] && !confirm(opts['confirm'])) {
        return false;
      }
      this.escEnabled = true;
      this.opened = false;
      this.$el.removeClass('up');
      this.onClose();
      $('body').css({
        height: 'auto',
        'overflow-y': 'auto'
      });
      _.delay((function() {
        $('#modals').html('');
        if (opts['callback']) {
          return opts['callback'].call(this);
        }
      }), 320);
      $(window).unbind('keyup.rollup_modal_esc');
      $('body').css({
        height: 'auto',
        'overflow-y': 'auto'
      });
      return _.delay((function() {
        $('#modals').html('');
        $('#modals').addClass('empty');
        if (opts['callback']) {
          return opts['callback'].call(this);
        }
      }), 320);
    };

    RollupModalView.prototype.events = {
      'click a.close': 'closeClicked'
    };

    RollupModalView.prototype.closeClicked = function(e) {
      this.close();
      return false;
    };

    RollupModalView.prototype.template = _.template($('#rollup-modal').html());

    RollupModalView.prototype.load = function(url, cb) {
      var $content,
        _this = this;
      if (cb == null) {
        cb = function() {};
      }
      $content = $('.content', this.$el).addClass('loading');
      $content.html('');
      this.open();
      return $.ajax({
        url: url,
        dataType: "html",
        success: function(data) {
          var loadit;
          loadit = function() {
            $content.removeClass('loading');
            $content.html(data);
            cb.apply(_this, arguments);
            if (_this.onLoad) {
              return _this.onLoad.call(_this);
            }
          };
          if (!_this.openingDelayComplete) {
            return _.delay(loadit, 300);
          } else {
            return loadit.call(_this, data);
          }
        }
      });
    };

    RollupModalView.prototype.onClose = function() {
      if (this.options['onClose']) {
        return this.options['onClose'].call(this);
      }
    };

    RollupModalView.prototype.onOpen = function() {
      if (this.options['onOpen']) {
        return this.options['onOpen'].call(this);
      }
    };

    RollupModalView.prototype.onLoad = function() {
      if (this.options['onLoad']) {
        return this.options['onLoad'].call(this);
      }
    };

    RollupModalView.prototype.render = function() {
      var $btn,
        _this = this;
      RollupModalView.__super__.render.apply(this, arguments);
      this.$el.html(this.template(this));
      $btn = null;
      _.each(this.buttons || [], function(btn) {
        var $span;
        $span = $('<span />', {
          "class": 'btn'
        });
        if (btn["class"] != null) {
          $span.addClass(btn["class"]);
        }
        $btn = $('<a />', {
          "class": 'btn'
        });
        $btn.text(btn.name);
        if (btn["class"] != null) {
          $btn.addClass(btn["class"]);
        }
        $span.append($btn);
        return _.defer(function() {
          return $('div.actions', _this.el).append($span);
        });
      });
      return this.el;
    };

    return RollupModalView;

  })(Backbone.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.PaginatedRollupModalView = (function(_super) {

      __extends(PaginatedRollupModalView, _super);

      function PaginatedRollupModalView() {
        return PaginatedRollupModalView.__super__.constructor.apply(this, arguments);
      }

      PaginatedRollupModalView.prototype.PREV_BUTTON = ['prev', 'Previous'];

      PaginatedRollupModalView.prototype.NEXT_BUTTON = ['next', 'Next'];

      PaginatedRollupModalView.prototype.initialize = function() {
        this.idx || (this.idx = -1);
        this.length = 1;
        _.bindAll(this, 'next', 'prev', 'page', 'resetPaging');
        return PaginatedRollupModalView.__super__.initialize.apply(this, arguments);
      };

      PaginatedRollupModalView.prototype.actionButtons = function() {
        return [];
      };

      PaginatedRollupModalView.prototype.onLoad = function() {
        this.resetPaging();
        if (this.initPage) {
          this.page(this.initPage);
          this.initPage = null;
        } else {
          this.page(0);
        }
        return PaginatedRollupModalView.__super__.onLoad.apply(this, arguments);
      };

      PaginatedRollupModalView.prototype.resetPaging = function() {
        var $cells;
        $cells = $('div.content div.row.page>div.cell', this.$el);
        this.length = $cells.size() || 1;
        $('div.content div.page.row', this.$el).css('width', 100 * this.length + '%');
        return $cells.css('width', 100 / this.length + '%').scrollTop(0);
      };

      PaginatedRollupModalView.prototype.renderActionButtons = function() {
        var $actions, $outerBtn, btn, btns, idx, _i, _len, _ref, _results;
        $actions = $('>div.actions', this.$el);
        try {
          $actions.html('');
          btns = this.actionButtons();
          idx = this.idx < 0 ? 0 : this.idx;
          _ref = btns[idx];
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            btn = _ref[_i];
            if (btn[0].match(/no-span/)) {
              $outerBtn = $("<a href='#' class='" + btn[0] + "'>" + btn[1] + "</a>");
            } else {
              $outerBtn = $("<span class='btn " + btn[0] + "'></span>");
              $outerBtn.html("<a href='#' class='" + btn[0] + "'>" + btn[1] + "</a>");
            }
            _results.push($outerBtn.appendTo($actions));
          }
          return _results;
        } catch (e) {

        }
      };

      PaginatedRollupModalView.prototype.page = function(idx) {
        var $cells,
          _this = this;
        if (idx === this.idx || idx >= this.length || idx < 0) {
          return;
        }
        this.idx = idx;
        $cells = $('div.content div.page.row>div.cell', this.$el);
        $cells.eq(idx).css({
          height: 'auto',
          visibility: 'visible',
          'overflow-y': 'visible'
        });
        $('div.content div.page.row', this.$el).css('left', -this.idx * 100 + '%');
        _.delay((function() {
          $cells = $('div.content div.page.row>div.cell', _this.$el);
          return $cells.not(":eq(" + idx + ")").css({
            height: '1px',
            'overflow-y': 'hidden',
            visibility: 'hidden'
          });
        }), 200);
        return this.renderActionButtons();
      };

      PaginatedRollupModalView.prototype.events = _.extend({
        'click .actions a.next': 'next',
        'click .actions a.prev': 'prev'
      }, RollupModalView.prototype.events);

      PaginatedRollupModalView.prototype.next = function(e) {
        this.page(this.idx + 1);
        if (e) {
          return e.preventDefault();
        }
      };

      PaginatedRollupModalView.prototype.prev = function(e) {
        this.page(this.idx - 1);
        if (e) {
          return e.preventDefault();
        }
      };

      return PaginatedRollupModalView;

    })(this.RollupModalView);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignFactsRollupModalView = (function(_super) {

      __extends(CampaignFactsRollupModalView, _super);

      function CampaignFactsRollupModalView() {
        return CampaignFactsRollupModalView.__super__.constructor.apply(this, arguments);
      }

      CampaignFactsRollupModalView.prototype.initialize = function(opts) {
        _.bindAll(this, 'render');
        this.campaignSummary = opts['campaignSummary'];
        CampaignFactsRollupModalView.__super__.initialize.apply(this, arguments);
        return this.length = 1;
      };

      CampaignFactsRollupModalView.prototype.render = function() {
        var $content, factsView;
        CampaignFactsRollupModalView.__super__.render.apply(this, arguments);
        $content = $('div.content', this.el);
        factsView = new CampaignSlideFactsView({
          el: $content[0],
          campaignSummary: this.campaignSummary
        });
        factsView.render();
        return this.renderActionButtons();
      };

      CampaignFactsRollupModalView.prototype.events = _.extend({
        'click .actions span.done a': 'close'
      }, PaginatedRollupModalView.prototype.events);

      CampaignFactsRollupModalView.prototype.actionButtons = function() {
        return [[['done primary', 'Done']]];
      };

      return CampaignFactsRollupModalView;

    })(this.PaginatedRollupModalView);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignStatusStrip = (function(_super) {

      __extends(CampaignStatusStrip, _super);

      function CampaignStatusStrip() {
        return CampaignStatusStrip.__super__.constructor.apply(this, arguments);
      }

      CampaignStatusStrip.prototype.initialize = function(opts) {
        this.campaignSummary = opts['campaignSummary'];
        _.bindAll(this, 'render', 'updateStatusStrip');
        this.campaignSummary.bind('change', this.updateStatusStrip);
        this.prevId = null;
        return CampaignStatusStrip.__super__.initialize.apply(this, arguments);
      };

      CampaignStatusStrip.prototype.template = _.template($('#campaign-status').html());

      CampaignStatusStrip.prototype.setInitialCampaign = function(campaign) {
        return this.prevId = campaign.id;
      };

      CampaignStatusStrip.prototype.updateStatusStrip = function() {
        if (this.prevId !== null) {
          return this.render();
        }
      };

      CampaignStatusStrip.prototype.render = function() {
        var $next, campaignDetails, context, persisted;
        campaignDetails = this.campaignSummary.get('campaign_details');
        persisted = this.campaignSummary.id !== null;
        context = {
          campaignDetails: campaignDetails,
          persisted: persisted
        };
        if (this.dom) {
          $next = this.dom.next().first();
        }
        if (this.dom) {
          this.dom.remove();
        }
        if ($next && $next.size()) {
          this.dom = $($.parseHTML(this.template(context)));
          return this.dom.insertBefore($next);
        } else {
          this.dom = $($.parseHTML(this.template(context)));
          this.dom.appendTo($(this.el));
          return $(this.el).css({
            position: 'relative'
          });
        }
      };

      return CampaignStatusStrip;

    })(Backbone.View);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var CREATE_URL;
    CREATE_URL = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns.js";
    return this.CampaignConfigurationTabPageView = (function(_super) {

      __extends(CampaignConfigurationTabPageView, _super);

      function CampaignConfigurationTabPageView() {
        return CampaignConfigurationTabPageView.__super__.constructor.apply(this, arguments);
      }

      CampaignConfigurationTabPageView.prototype.initialize = function() {
        var opts;
        this.campaign = new CampaignSummary;
        _.bindAll(this, 'setCampaign', 'createCampaignEvent', 'updateButtons', 'launchCampaignEvent');
        $(document).bind('createCampaign', this.createCampaignEvent);
        $(document).bind('launchCampaign', this.launchCampaignEvent);
        $(document).bind('editCampaign', this.setCampaign);
        this.campaign.bind('change', this.updateButtons);
        opts = {
          el: this.el,
          campaignSummary: this.campaign
        };
        this.serverConfigView = new CampaignServerConfigurationsView(opts);
        this.campaignStatusStrip = new CampaignStatusStrip(opts);
        this.campaignComponentsView = new CampaignComponentsView(opts);
        this.campaignConfigView = new CampaignConfigurationView(opts);
        this.campaignNotificationView = new CampaignNotificationView(opts);
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Creating campaign... ',
          autoOpen: false,
          closeOnEscape: false
        });
        return CampaignConfigurationTabPageView.__super__.initialize.apply(this, arguments);
      };

      CampaignConfigurationTabPageView.prototype.events = {
        'click .save-campaign': 'saveCampaignClicked',
        'click .cancel-campaign': 'cancelCampaignClicked',
        'click .launch-campaign': 'launchCampaignClicked'
      };

      CampaignConfigurationTabPageView.prototype.btnsTemplate = _.template($('#edit-buttons').html());

      CampaignConfigurationTabPageView.prototype.willDisplay = function() {
        var _this = this;
        return _.defer(function() {
          return $('form input[type=text]', _this.el).first().focus();
        });
      };

      CampaignConfigurationTabPageView.prototype.createCampaignEvent = function(e, opts) {
        return this.createCampaign(opts['data'], opts['callback']);
      };

      CampaignConfigurationTabPageView.prototype.createCampaign = function(data, callback) {
        var _this = this;
        if (this.creatingCampaign) {
          return;
        }
        $("[name^='social_engineering_campaign']~p.inline-errors").remove();
        this.creatingCampaign = true;
        this.loadingModal.dialog('open');
        return $.ajax({
          type: 'POST',
          url: CREATE_URL,
          data: data,
          dataType: 'json',
          async: false,
          success: function(data) {
            _this.creatingCampaign = false;
            _this.loadingModal.dialog('close');
            if (_this.campaign.usesWizard()) {
              _this.campaign.get('campaign_configuration')['web_config']['configured'] = true;
            }
            _this.campaign.set(data);
            _this.updateButtons();
            _this.campaignConfigView.update();
            _this.campaignNotificationView.update();
            return callback.call(_this);
          },
          error: function(err) {
            var $input, errHash, key, msgArray, _results;
            _this.creatingCampaign = false;
            _this.loadingModal.dialog('close');
            errHash = $.parseJSON(err.responseText)['error'];
            if (!errHash) {
              return;
            }
            _results = [];
            for (key in errHash) {
              if (!__hasProp.call(errHash, key)) continue;
              msgArray = errHash[key];
              $input = $("[name='social_engineering_campaign[" + key + "]']").focus();
              _results.push($("<p class='inline-errors'>" + msgArray[0] + "</p>").insertAfter($input).hide().slideDown().fadeIn());
            }
            return _results;
          }
        });
      };

      CampaignConfigurationTabPageView.prototype.baseURL = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns";
      };

      CampaignConfigurationTabPageView.prototype.ajaxAlertOnError = function(opts) {
        return $.ajax({
          url: opts['url'],
          data: opts['data'] || {},
          dataType: opts['dataType'] || 'json',
          type: opts['type'] || 'get',
          success: opts['success'],
          error: function(e) {
            var fail;
            fail = $.parseJSON(e.responseText);
            if (fail && fail['error']) {
              alert(fail['error']);
            }
            if (opts['error']) {
              return opts['error'].call(this);
            }
          }
        });
      };

      CampaignConfigurationTabPageView.prototype.launchCampaignEvent = function(e, opts) {
        return this.launchCampaign(opts['campaign'], opts);
      };

      CampaignConfigurationTabPageView.prototype.checkForInitializationErrors = function(opts) {
        var url;
        url = ("/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/") + ("" + opts.campaign.id + "/check_for_configuration_errors");
        return $.ajax({
          url: url,
          success: opts['success'] || function() {},
          error: opts['error'] || function() {}
        });
      };

      CampaignConfigurationTabPageView.prototype.launchCampaign = function(campaign, opts) {
        var _this = this;
        if (opts == null) {
          opts = {};
        }
        return this.checkForInitializationErrors({
          campaign: campaign,
          error: function(e) {
            var data;
            data = $.parseJSON(e.responseText);
            alert(data['error']);
            if (opts['error']) {
              return opts['error'].call(_this);
            }
          },
          success: function() {
            var emailsText, firstEmail, listName, numTargets, url;
            numTargets = campaign.get('campaign_details').email_targets_count;
            firstEmail = _.find(campaign.get('campaign_components'), (function(comp) {
              return comp.type === 'email';
            }));
            if (numTargets > 0 && firstEmail) {
              emailsText = numTargets === 1 ? 'e-mail' : 'e-mails';
              listName = firstEmail.target_list_name;
              if (!confirm("You are about to send " + numTargets + " " + emailsText + " to the '" + listName + "' target list.  Are you sure?")) {
                if (opts['error']) {
                  opts['error'].call(_this);
                }
                return;
              }
            }
            url = "" + (_this.baseURL()) + "/" + campaign.id + "/execute";
            return _this.ajaxAlertOnError({
              type: 'POST',
              url: url,
              success: function(data) {
                var facts, listView, newCampaign;
                listView = CampaignTabView.activeView.tabs[1];
                newCampaign = _.find(listView.collection.models, function(c) {
                  return c.id === campaign.id;
                });
                if (!newCampaign) {
                  listView.collection.unshift(campaign);
                  newCampaign = campaign;
                }
                newCampaign.set(data);
                facts = new CampaignFactsRollupModalView({
                  campaignSummary: newCampaign
                });
                facts.open();
                if (opts['success']) {
                  return opts['success'].call(this);
                }
              },
              error: opts['error'] || function() {}
            });
          }
        });
      };

      CampaignConfigurationTabPageView.prototype.saveCampaignClicked = function(e) {
        var data, listView, name,
          _this = this;
        if (this.campaign.id === null) {
          this.loadingModal.dialog('open');
          data = $('form.social_engineering_campaign', this.el).serialize();
          this.createCampaign(data, function() {
            var listView;
            CampaignTabView.activeView.setTabIndex(1);
            listView = CampaignTabView.activeView.tabs[1];
            return listView.flashCampaign(_this.campaign.id);
          });
        } else {
          name = $("[name='social_engineering_campaign[name]']", this.el).val();
          if (name !== this.campaign.get('name')) {
            this.campaign.set('name', name);
            this.campaign.save();
          }
          CampaignTabView.activeView.setTabIndex(1);
          listView = CampaignTabView.activeView.tabs[1];
          listView.flashCampaign(this.campaign.id);
        }
        return e.preventDefault();
      };

      CampaignConfigurationTabPageView.prototype.cancelCampaignClicked = function(e) {
        var listView;
        e.preventDefault();
        CampaignTabView.activeView.setTabIndex(1);
        listView = CampaignTabView.activeView.tabs[1];
        listView.flashCampaign(this.campaign.id);
        return this.setCampaign(null, new CampaignSummary(CampaignSummary.defaults), false);
      };

      CampaignConfigurationTabPageView.prototype.launchCampaignClicked = function(e) {
        var $launchBtn,
          _this = this;
        $launchBtn = $('a.launch-campaign', this.el);
        if ($launchBtn.hasClass('ui-disabled')) {
          return;
        }
        $launchBtn.addClass('ui-disabled').parent('span').addClass('ui-disabled');
        this.launchCampaign(this.campaign, {
          success: function(data) {
            var listView;
            CampaignTabView.activeView.setTabIndex(1);
            listView = CampaignTabView.activeView.tabs[1];
            return listView.flashCampaign(_this.campaign.id);
          },
          error: function() {
            return $('a.launch-campaign', _this.el).removeClass('ui-disabled').parent('span').removeClass('ui-disabled');
          }
        });
        return e.preventDefault();
      };

      CampaignConfigurationTabPageView.prototype.setCampaign = function(e, newCampaign, slide) {
        if (slide == null) {
          slide = true;
        }
        if (slide) {
          CampaignTabView.activeView.setTabIndex(0);
        }
        this.campaign.set(newCampaign.attributes);
        this.campaignComponentsView.render();
        this.campaignComponentsView.setEditing(false);
        this.campaignConfigView.update();
        this.campaignStatusStrip.setInitialCampaign(newCampaign);
        this.campaignStatusStrip.render();
        this.campaignNotificationView.update(this.campaign);
        return this.updateButtons();
      };

      CampaignConfigurationTabPageView.prototype.updateButtons = function() {
        var actionBtn, btnsHtml;
        actionBtn = 'Save';
        btnsHtml = this.btnsTemplate({
          actionBtnTitle: actionBtn
        });
        return $('.buttons-go-here', this.el).html(btnsHtml);
      };

      CampaignConfigurationTabPageView.prototype.render = function() {
        var el;
        el = CampaignConfigurationTabPageView.__super__.render.apply(this, arguments);
        _.each([this.campaignStatusStrip, this.campaignConfigView, this.campaignComponentsView, this.serverConfigView, this.campaignNotificationView], function(view) {
          view.setElement(el);
          return view.render();
        });
        $('<div class="buttons-go-here">').appendTo(el);
        return this.updateButtons();
      };

      return CampaignConfigurationTabPageView;

    })(SingleTabPageView);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.FormView = (function(_super) {

      __extends(FormView, _super);

      function FormView() {
        return FormView.__super__.constructor.apply(this, arguments);
      }

      FormView.prototype.initialize = function(opts) {
        this.options = opts;
        this.saveCallback = this.options['save'] || this.saveCallback;
        this.length = 1;
        _.bindAll(this, 'save', 'onLoad');
        return FormView.__super__.initialize.apply(this, arguments);
      };

      FormView.prototype.events = _.extend({
        'click .actions a.cancel': 'close',
        'click .actions a.save': 'save'
      }, PaginatedRollupModalView.prototype.events);

      FormView.prototype.save = function() {
        if (this.saveCallback) {
          return this.saveCallback.call(this);
        }
      };

      FormView.prototype.onLoad = function() {
        var $form, currAction, setInputChangedFn,
          _this = this;
        this.inputChanged = false;
        setInputChangedFn = function(e) {
          var str;
          str = String.fromCharCode(e.keyCode);
          if (str.match(/\w/) || str === ' ') {
            return _this.inputChanged = true;
          }
        };
        $('input,select,textarea', this.el).keydown(setInputChangedFn);
        $('select,input,textarea', this.el).change(function() {
          return _this.inputChanged = true;
        });
        if (this.options['formQuery']) {
          $form = $('form', this.el).first();
          currAction = $form.attr('action');
          $form.attr('action', "" + currAction + this.options['formQuery']);
        }
        _.each($('select>option', this.el), function(item) {
          if ($(item).val() === '') {
            return $(item).removeAttr('value');
          }
        });
        if (!this.dontRenderSelect2) {
          $('select', this.el).select2(DEFAULT_SELECT2_OPTS);
        }
        return FormView.__super__.onLoad.apply(this, arguments);
      };

      FormView.prototype.close = function(opts) {
        var optionsConfirm, optsConfirm;
        if (opts == null) {
          opts = {};
        }
        if (this.inputChanged) {
          return FormView.__super__.close.call(this, opts);
        } else {
          optionsConfirm = this.options.confirm;
          this.options.confirm = null;
          optsConfirm = opts.confirm;
          opts.confirm = null;
          FormView.__super__.close.call(this, opts);
          this.options.confirm = optionsConfirm;
          return opts.confirm = optsConfirm;
        }
      };

      FormView.prototype.actionButtons = function() {
        return [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]];
      };

      return FormView;

    })(this.PaginatedRollupModalView);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.PaginatedFormView = (function(_super) {

      __extends(PaginatedFormView, _super);

      function PaginatedFormView() {
        return PaginatedFormView.__super__.constructor.apply(this, arguments);
      }

      PaginatedFormView.prototype.initialize = function() {
        PaginatedFormView.__super__.initialize.apply(this, arguments);
        return _.bindAll(this, 'circleClicked', 'page');
      };

      PaginatedFormView.prototype.events = _.extend({
        'click .actions a.cancel': 'close',
        'click .actions a.save': 'save',
        'click .page-circles .cell': 'circleClicked'
      }, PaginatedRollupModalView.prototype.events);

      PaginatedFormView.prototype.headerTemplate = _.template($('#paginated-rollup-view-header').html());

      PaginatedFormView.prototype.circleClicked = function(e) {
        var idx;
        idx = $('.header .page-circles .cell', this.el).index($(e.currentTarget));
        return this.page(idx);
      };

      PaginatedFormView.prototype.page = function(idx) {
        PaginatedFormView.__super__.page.apply(this, arguments);
        $('.header .page-circles .cell', this.el).removeClass('selected');
        $('.header .page-circles .cell', this.el).eq(idx).addClass('selected');
        if (this.largeTitles && this.largeTitles.length > idx && this.largeTitles[idx]) {
          return $('.header h3', this.el).text(this.largeTitles[idx]);
        }
      };

      PaginatedFormView.prototype.onLoad = function() {
        var focusFirst,
          _this = this;
        this.renderHeader();
        PaginatedFormView.__super__.onLoad.apply(this, arguments);
        focusFirst = function() {
          return $('button,input,textarea,select,:input', _this.el).filter(':visible').first().focus();
        };
        return _.defer(focusFirst);
      };

      PaginatedFormView.prototype.renderHeader = function() {
        var hdr;
        this.largeTitles = _.map($('div.page.row>div.cell', this.el), function(item) {
          return $(item).attr('title-large');
        });
        this.pageNames = _.map($('div.page.row>div.cell', this.el), function(item) {
          return $(item).attr('title');
        });
        this.title = $('div.page.row', this.el).attr('title');
        hdr = this.headerTemplate(this);
        this.header || (this.header = $($.parseHTML(hdr)).insertAfter($('.content-frame', this.el)));
        if (this.largeTitles && this.largeTitles.length > 0 && this.largeTitles[0]) {
          return $('.header h3', this.el).text(this.largeTitles[0]);
        }
      };

      PaginatedFormView.prototype.actionButtons = function() {
        return [[['next primary', 'Next']], [['prev link3 no-span', 'Previous'], ['save primary', 'Save']]];
      };

      return PaginatedFormView;

    })(this.FormView);
  });

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.WebPageFormView = (function(_super) {

      __extends(WebPageFormView, _super);

      function WebPageFormView() {
        this.uploadFile = __bind(this.uploadFile, this);

        this.editorChanged = __bind(this.editorChanged, this);

        this.fileChanged = __bind(this.fileChanged, this);
        return WebPageFormView.__super__.constructor.apply(this, arguments);
      }

      WebPageFormView.prototype.initialize = function() {
        var _this = this;
        this.configuring = false;
        this.dontRenderSelect2 = true;
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Loading... ',
          autoOpen: false,
          width: '700px',
          closeOnEscape: false,
          close: function() {
            return _.delay((function() {
              return _this.configuring = false;
            }), 300);
          },
          buttons: {
            "Cancel": function() {
              return $(this).dialog("close");
            },
            "Upload": this.uploadFile
          }
        });
        return WebPageFormView.__super__.initialize.apply(this, arguments);
      };

      WebPageFormView.prototype.events = _.extend({
        "click .clone-btn": 'showCloneDialog',
        "change [name=editor-buttonset]": 'editorChanged',
        "change li#social_engineering_web_page_template_id_input select": 'editorChanged',
        'scrollProxy': 'scrollProxy'
      }, PaginatedFormView.prototype.events);

      WebPageFormView.prototype.scrollProxy = function() {
        var $iframe;
        $iframe = $('.preview iframe', this.el);
        return $iframe.contents().scrollTop($('.blocker', this.el).scrollTop());
      };

      WebPageFormView.prototype.fileUrl = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/files/new?inline=true";
      };

      WebPageFormView.prototype.fileChanged = function(e) {
        var $selOption;
        $selOption = $('option:selected', e.target);
        if ($selOption.index() === 1) {
          this.beginFileSetup();
          return $selOption.parents('select').select2("val", "");
        }
      };

      WebPageFormView.prototype.editorChanged = function(e) {
        var $form, $iframe, $input, $inputs, $new_form, $preview, content, h, reverse, self, tmpl, url, val, _i, _len,
          _this = this;
        self = this;
        val = $('[name=editor-buttonset]:checked', this.el).val();
        h = $('.CodeMirror-scroll', this.el).height();
        $form = $('form', this.el).first();
        reverse = function(str) {
          return str.split("").reverse().join("");
        };
        content = reverse($form.triggerHandler('getMirrorContent'));
        $('.CodeMirror,.clone-btn', this.el).toggle(val === 'edit');
        $preview = $('.preview', this.el);
        $preview.toggle(val === 'preview');
        if (val === 'preview') {
          $iframe = $('.preview iframe', this.el);
          $iframe.css({
            width: '100%',
            border: '0'
          }).hide().height(h);
          tmpl = $('li#social_engineering_web_page_template_id_input select option:selected', this.el).val();
          url = $('meta[name=preview-url]', this.el).attr('content');
          $preview.addClass('loading').height(380).css({
            'min-height': '0'
          }).show().css({
            border: '1px solid #ddd'
          });
          $new_form = $("<form method='POST' style='display:none'></form>").appendTo($('body'));
          $new_form.attr('action', url);
          $new_form.attr('target', 'web-page-iframe');
          $inputs = [$('<input type="hidden" name="template_id"></input>'), $('<input type="hidden" name="content"></input>'), $('<input type="hidden" name="authenticity_token"></input>')];
          $inputs[0].val(tmpl);
          $inputs[1].val(content);
          $inputs[2].val($('meta[name=csrf-token]').attr('content'));
          for (_i = 0, _len = $inputs.length; _i < _len; _i++) {
            $input = $inputs[_i];
            $new_form.append($input);
          }
          $new_form.submit();
          return $iframe[0].onload = function() {
            var iframeWin;
            $('.preview', _this.el).show().removeClass('loading').css({
              height: 'auto'
            });
            h = $('.CodeMirror-scroll', _this.el).height();
            $iframe.show().height(h);
            $new_form.remove();
            $('.blocker', $form).height(h);
            iframeWin = $iframe[0].contentWindow || $iframe[0].contentWindow.parentWindow;
            if (iframeWin.document.body) {
              $('.blocker .spacer').height(iframeWin.document.documentElement.scrollHeight || iframeWin.document.body.scrollHeight);
            }
            return $('.blocker', _this.el).scroll(function() {
              return $(self.el).trigger('scrollProxy');
            });
          };
        }
      };

      WebPageFormView.prototype.showLoading = function() {
        this.loadingModal.dialog('close');
        this.loadingModal.dialog({
          width: '430px',
          title: 'Loading...'
        });
        $('.ui-dialog-titlebar-close', this.loadingModal.parents('.ui-dialog')).hide();
        this.loadingModal.html('<div class="loading"></div>');
        this.loadingModal.dialog('open');
        return $('.ui-dialog-buttonpane', this.loadingModal.parents('.ui-dialog')).hide();
      };

      WebPageFormView.prototype.showFileConfig = function() {
        this.loadingModal.dialog('close');
        this.loadingModal.dialog({
          title: 'Upload a new file',
          width: '700px'
        });
        this.loadingModal.css({
          'max-height': '450px'
        });
        this.loadingModal.removeClass('loading');
        $('.ui-dialog-titlebar-close', this.loadingModal.parents('.ui-dialog')).show();
        this.loadingModal.dialog('open');
        return $('.ui-dialog-buttonpane', this.loadingModal.parents('.ui-dialog')).show();
      };

      WebPageFormView.prototype.uploadFile = function() {
        var _this = this;
        $.ajax({
          url: $('form', this.loadingModal).attr('action'),
          type: 'POST',
          files: $('form :file', this.loadingModal),
          data: $('form input,select,textarea', this.loadingModal).not(':file').serializeArray(),
          iframe: true,
          processData: false,
          success: function(data, status) {
            var $newOption, $select, file, jsonData, saveStatus;
            _this.loadingModal.html(data);
            saveStatus = $('meta[name=save-status]', _this.loadingModal).attr('content');
            if (saveStatus === 'false' || !saveStatus) {
              return _this.showFileConfig();
            } else {
              jsonData = $.parseJSON(saveStatus);
              _this.loadingModal.dialog('close');
              _this.configuring = {
                falsewidth: '430px'
              };
              file = jsonData['user_submitted_file'];
              $select = $("select[name='social_engineering_web_page[user_supplied_file]']", _this.el);
              $newOption = $("<option>").val(file.id).html(_.escape(file.name));
              $select.append($newOption);
              return $select.select2('val', file.id);
            }
          },
          error: function() {}
        });
        return this.showLoading();
      };

      WebPageFormView.prototype.beginFileSetup = function() {
        var url,
          _this = this;
        this.configuring = true;
        url = this.fileUrl();
        this.showLoading();
        return $(this.loadingModal).load(url, function() {
          return _this.showFileConfig();
        });
      };

      WebPageFormView.prototype.onLoad = function() {
        var $li, $opts;
        WebPageFormView.__super__.onLoad.apply(this, arguments);
        $opts = $("select[name='social_engineering_web_page[phishing_redirect_web_page_id]'] option");
        if ($opts.size() === 0 || ($opts.size() === 1 && $opts.eq(0).text() === '')) {
          $li = $opts.parents('li').first().addClass('ui-disabled');
          $li.after($('<div>').addClass('no-pages').text('You must create another Web Page to redirect to first.'));
        }
        $('select', this.el).select2($.extend({
          escapeMarkup: function(markup) {
            return markup;
          },
          formatSelection: function(state) {
            return _.escape(state['text']);
          },
          formatResult: function(state, container) {
            var img;
            if (state['id'] !== 'Upload a new file...') {
              return _.escape(state['text']);
            }
            img = '<img alt="+" style="vertical-align: middle; position: relative; bottom: 2px; right: 1px;" src="/assets/icons/silky/add-c06a52df3361df380a02a45159a0858d6f7cd8cbc3f71ff732a65d6c25ea6af6.png" />';
            $(container).css({
              'border-bottom': '1px dotted #ccc'
            });
            $(container).css({
              'border-top': '1px dotted #ccc'
            });
            $(container).css({
              'margin-bottom': '4px'
            });
            $(container).css({
              'padding-bottom': '8px'
            });
            $(container).css({
              'padding-top': '8px'
            });
            return img + state['text'];
          }
        }, DEFAULT_SELECT2_OPTS));
        $('.white-box.editor-box', this.el).buttonset();
        return $("select[name='social_engineering_web_page[user_supplied_file]']", this.el).change(this.fileChanged);
      };

      WebPageFormView.prototype.showCloneDialog = function() {
        return window.renderCloneDialog();
      };

      return WebPageFormView;

    })(PaginatedFormView);
  });

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.EmailFormView = (function(_super) {

      __extends(EmailFormView, _super);

      function EmailFormView() {
        this.fileChanged = __bind(this.fileChanged, this);

        this.uploadFile = __bind(this.uploadFile, this);
        return EmailFormView.__super__.constructor.apply(this, arguments);
      }

      EmailFormView.prototype.initialize = function(opts) {
        var _this = this;
        _.bindAll(this, 'targetListChanged', 'bindForm');
        this.configuring = false;
        this.campaignSummary = opts['campaignSummary'];
        this.dontRenderSelect2 = true;
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          maxHeight: 480,
          title: 'Loading... ',
          autoOpen: false,
          width: '430px',
          closeOnEscape: false,
          close: function() {
            return _.delay((function() {
              return _this.configuring = false;
            }), 300);
          },
          buttons: {
            "Cancel": function() {
              return $(this).dialog("close");
            },
            "Upload": this.uploadFile
          }
        });
        return EmailFormView.__super__.initialize.apply(this, arguments);
      };

      EmailFormView.prototype.uploadFile = function() {
        var _this = this;
        $.ajax({
          url: $('form', this.loadingModal).attr('action'),
          type: 'POST',
          files: $('form :file', this.loadingModal),
          data: $('form input,select,textarea', this.loadingModal).not(':file').serializeArray(),
          iframe: true,
          processData: false,
          success: function(data, status) {
            var $newOption, $select, file, jsonData, saveStatus;
            _this.loadingModal.html(data);
            saveStatus = $('meta[name=save-status]', _this.loadingModal).attr('content');
            if (saveStatus === 'false' || !saveStatus) {
              return _this.showFileConfig();
            } else {
              jsonData = $.parseJSON(saveStatus);
              _this.loadingModal.dialog('close');
              _this.configuring = false;
              file = jsonData['user_submitted_file'];
              $select = $("select[name='social_engineering_email[user_supplied_file]']", _this.el);
              $newOption = $("<option>").val(file.id).html(_.escape(file.name));
              $select.append($newOption);
              return $select.select2('val', file.id);
            }
          },
          error: function() {}
        });
        return this.showLoading();
      };

      EmailFormView.prototype.beginFileSetup = function() {
        var url,
          _this = this;
        this.configuring = true;
        url = this.fileUrl();
        this.showLoading();
        return $(this.loadingModal).load(url, function() {
          return _this.showFileConfig();
        });
      };

      EmailFormView.prototype.fileUrl = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/files/new?inline=true";
      };

      EmailFormView.prototype.fileChanged = function(e) {
        var $selOption;
        $selOption = $('option:selected', e.target);
        if ($selOption.index() === 1) {
          this.beginFileSetup();
          return $selOption.parents('select').select2("val", "");
        }
      };

      EmailFormView.prototype.showFileConfig = function() {
        this.loadingModal.dialog('close');
        this.loadingModal.dialog({
          title: 'Upload a new file',
          width: '700px'
        });
        this.loadingModal.css({
          'max-height': '450px'
        });
        this.loadingModal.removeClass('loading');
        $('.ui-dialog-titlebar-close', this.loadingModal.parents('.ui-dialog')).show();
        this.loadingModal.dialog('open');
        return $('.ui-dialog-buttonpane', this.loadingModal.parents('.ui-dialog')).show();
      };

      EmailFormView.prototype.targetListUrl = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/target_lists/new.html?inline=true";
      };

      EmailFormView.prototype.targetListChanged = function(e) {
        var $selOption;
        $selOption = $('option:selected', e.target);
        if ($selOption.index() === 1) {
          this.beginTargetListSetup();
          return $selOption.parents('select').select2("val", "");
        }
      };

      EmailFormView.prototype.showLoading = function() {
        this.loadingModal.dialog('close');
        this.loadingModal.dialog({
          width: '430px',
          title: 'Loading...'
        });
        $('.ui-dialog-titlebar-close', this.loadingModal.parents('.ui-dialog')).hide();
        this.loadingModal.html('<div class="loading"></div>');
        this.loadingModal.dialog('open');
        return $('.ui-dialog-buttonpane', this.loadingModal.parents('.ui-dialog')).hide();
      };

      EmailFormView.prototype.showTargetListConfig = function(dontBind) {
        var _this = this;
        if (dontBind == null) {
          dontBind = false;
        }
        this.loadingModal.dialog('close');
        this.loadingModal.dialog({
          title: 'New Target List',
          width: '700px'
        });
        this.loadingModal.css({
          'max-height': '450px'
        });
        this.loadingModal.removeClass('loading');
        $('.ui-dialog-titlebar-close', this.loadingModal.parents('.ui-dialog')).show();
        this.loadingModal.dialog('open');
        $('.ui-dialog-buttonpane', this.loadingModal.parents('.ui-dialog')).hide();
        if (!dontBind) {
          return _.delay((function() {
            return _this.bindForm();
          }), 0);
        }
      };

      EmailFormView.prototype.beginTargetListSetup = function() {
        var url,
          _this = this;
        this.configuring = true;
        url = this.targetListUrl();
        this.showLoading();
        return $(this.loadingModal).load(url, function() {
          return _this.showTargetListConfig();
        });
      };

      EmailFormView.prototype.bindForm = function() {
        var _this = this;
        window.renderTargets();
        $('a.save-targets').click(function(e) {
          $('form', _this.loadingModal).first().submit();
          return e.preventDefault();
        });
        return $('form', this.loadingModal).first().submit(function(e) {
          e.preventDefault();
          $('form', _this.loadingModal).hide();
          $('.target-list-new>div.full_errors', _this.loadingModal).remove();
          $.ajax({
            url: $(e.target).attr('action'),
            type: 'POST',
            files: $('form :file', _this.loadingModal),
            data: $('form input,select,textarea', _this.loadingModal).not(':file').serializeArray(),
            iframe: true,
            processData: false,
            success: function(data, status) {
              var $newOption, $sandbox, $select, jsonData, saveStatus, targetList;
              $sandbox = $('<div style="display:none">').appendTo($('body'));
              $sandbox.html(data);
              saveStatus = $('meta[name=save-status]', $sandbox).attr('content');
              if (saveStatus === 'false' || !saveStatus) {
                $('.loading', _this.loadingModal).remove();
                $('form', _this.loadingModal).show();
                $('#errorExplanation', $sandbox).parent().addClass('full_errors').prependTo($('.target-list-new', _this.loadingModal));
                return _this.showTargetListConfig(true);
              } else {
                jsonData = $.parseJSON(saveStatus);
                _this.loadingModal.dialog('close');
                _this.configuring = false;
                targetList = jsonData['target_list'];
                $select = $("select[name='social_engineering_email[target_list_id]']");
                $newOption = $("<option>").val(targetList.id).html(_.escape(targetList.name));
                $select.append($newOption);
                return $select.select2('val', targetList.id);
              }
            },
            error: function() {}
          });
          _this.loadingModal.dialog('close');
          _this.loadingModal.dialog({
            width: '430px',
            title: 'Loading...'
          });
          _this.loadingModal.append($('<div class="loading"></div>'));
          return _this.loadingModal.dialog('open');
        });
      };

      EmailFormView.prototype.close = function() {
        if (this.configuring) {
          return;
        }
        return EmailFormView.__super__.close.apply(this, arguments);
      };

      EmailFormView.prototype.page = function(idx) {
        EmailFormView.__super__.page.apply(this, arguments);
        if (idx === 1) {
          return $('.editor-box input[type=radio]', this.el).change();
        }
      };

      EmailFormView.prototype.onLoad = function() {
        EmailFormView.__super__.onLoad.apply(this, arguments);
        $('fieldset.inputs', this.el).css('float', 'none');
        $('input[type=checkbox],input[type=radio]', this.el).css('vertical-align', 'baseline');
        $("select[name='social_engineering_email[target_list_id]']", this.el).change(this.targetListChanged);
        $('.white-box.editor-box', this.el).buttonset();
        $('select', this.el).select2($.extend({
          escapeMarkup: function(markup) {
            return markup;
          },
          formatSelection: function(state) {
            return _.escape(state['text']);
          },
          formatResult: function(state, container) {
            var img;
            if (!(state['id'] === 'Create a new Target List...' || state['id'] === 'Upload a new file...')) {
              return _.escape(state['text']);
            }
            img = '<img style="vertical-align: middle; position: relative;bottom: 2px; right: 1px;" alt="+" src="/assets/icons/silky/add-c06a52df3361df380a02a45159a0858d6f7cd8cbc3f71ff732a65d6c25ea6af6.png" />';
            $(container).css({
              'border-bottom': '1px dotted #ccc'
            });
            $(container).css({
              'border-top': '1px dotted #ccc'
            });
            $(container).css({
              'margin-bottom': '4px'
            });
            $(container).css({
              'padding-bottom': '8px'
            });
            $(container).css({
              'padding-top': '8px'
            });
            return img + state['text'];
          }
        }, DEFAULT_SELECT2_OPTS));
        $("select[name='social_engineering_email[user_supplied_file]']", this.el).change(this.fileChanged);
        window.renderAttributeDropdown();
        window.renderCodeMirror();
        return window.renderEmailEdit();
      };

      return EmailFormView;

    })(PaginatedFormView);
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.EmailTemplateView = (function(_super) {

      __extends(EmailTemplateView, _super);

      function EmailTemplateView() {
        return EmailTemplateView.__super__.constructor.apply(this, arguments);
      }

      EmailTemplateView.prototype.initialize = function() {
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Submitting... ',
          autoOpen: false,
          closeOnEscape: false
        });
        return EmailTemplateView.__super__.initialize.apply(this, arguments);
      };

      EmailTemplateView.prototype.onLoad = function() {
        EmailTemplateView.__super__.onLoad.apply(this, arguments);
        $('select>option', this.el).each(function() {
          if ($(this).val() === '') {
            return $(this).removeAttr('value');
          }
        });
        $('select', this.el).select2(DEFAULT_SELECT2_OPTS);
        $('.clone-btn', this.el).click(window.renderCloneDialog);
        window.renderAttributeDropdown();
        return window.renderCodeMirror(240);
      };

      EmailTemplateView.prototype.renderHeader = function() {
        EmailTemplateView.__super__.renderHeader.apply(this, arguments);
        $('.header .page-circles', this.el).hide();
        return $('.header', this.el).addClass('no-box-shadow');
      };

      EmailTemplateView.prototype.actionButtons = function() {
        return [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]];
      };

      EmailTemplateView.prototype.save = function() {
        var $form,
          _this = this;
        $form = $('form', this.el);
        this.loadingModal.dialog('open');
        Placeholders.submitHandler($form[0]);
        $('textarea.to-code-mirror', $form).trigger('loadFromEditor');
        $form.trigger('syncWysiwyg');
        $.ajax({
          url: $form.attr('action'),
          type: $form.attr('method'),
          data: $form.serialize(),
          success: function(data) {
            _this.render();
            _this.close({
              confirm: false
            });
            return _this.loadingModal.dialog('close');
          },
          error: function(response) {
            $('.content-frame>.content', _this.el).html(response.responseText);
            _this.onLoad();
            return _this.loadingModal.dialog('close');
          }
        });
        return EmailTemplateView.__super__.save.apply(this, arguments);
      };

      return EmailTemplateView;

    })(FormView);
  });

}).call(this);
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
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.WebTemplateView = (function(_super) {

      __extends(WebTemplateView, _super);

      function WebTemplateView() {
        return WebTemplateView.__super__.constructor.apply(this, arguments);
      }

      WebTemplateView.prototype.initialize = function() {
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Submitting...',
          autoOpen: false,
          closeOnEscape: false
        });
        return WebTemplateView.__super__.initialize.apply(this, arguments);
      };

      WebTemplateView.prototype.onLoad = function() {
        WebTemplateView.__super__.onLoad.apply(this, arguments);
        $('select>option', this.el).each(function() {
          if ($(this).val() === '') {
            return $(this).removeAttr('value');
          }
        });
        $('select', this.el).select2(DEFAULT_SELECT2_OPTS);
        window.renderAttributeDropdown();
        window.renderCodeMirror(220);
        return $('a.clone-btn', this.el).click(window.renderCloneDialog);
      };

      WebTemplateView.prototype.actionButtons = function() {
        return [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]];
      };

      WebTemplateView.prototype.save = function() {
        var $form,
          _this = this;
        this.loadingModal.dialog('open');
        $form = $('form', this.el);
        Placeholders.submitHandler($form[0]);
        $('textarea.to-code-mirror', $form).trigger('loadFromEditor');
        $form.trigger('syncWysiwyg');
        $.ajax({
          url: $form.attr('action'),
          type: $form.attr('method'),
          data: $form.serialize(),
          success: function(data) {
            _this.render();
            _this.close({
              confirm: false
            });
            return _this.loadingModal.dialog('close');
          },
          error: function(response) {
            $('.content-frame>.content', _this.el).html(response.responseText);
            _this.onLoad();
            return _this.loadingModal.dialog('close');
          }
        });
        return WebTemplateView.__super__.save.apply(this, arguments);
      };

      return WebTemplateView;

    })(FormView);
  });

}).call(this);
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
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignPreviewModal = (function(_super) {

      __extends(CampaignPreviewModal, _super);

      function CampaignPreviewModal() {
        return CampaignPreviewModal.__super__.constructor.apply(this, arguments);
      }

      CampaignPreviewModal.prototype.initialize = function(opts) {
        this.campaignSummary = opts['campaignSummary'];
        this.loaded = {};
        $(this.el).addClass('preview');
        return CampaignPreviewModal.__super__.initialize.apply(this, arguments);
      };

      CampaignPreviewModal.prototype.pagesTemplate = _.template($('#campaign-preview-modal').html());

      CampaignPreviewModal.prototype.render = function() {
        var components, el, name, title;
        components = _.filter(this.campaignSummary.get('campaign_components'), function(cp) {
          return cp.type !== 'portable_file';
        });
        name = this.campaignSummary.get('name');
        title = "" + name + ": Preview";
        el = CampaignPreviewModal.__super__.render.apply(this, arguments);
        $('.content', el).html(this.pagesTemplate({
          components: components,
          title: title
        }));
        return this.onLoad();
      };

      CampaignPreviewModal.prototype.findComponentById = function(id, type) {
        return _.find(this.campaignSummary.get('campaign_components'), (function(cp) {
          return parseInt(cp.id) === parseInt(id) && cp.type === type;
        }));
      };

      CampaignPreviewModal.prototype.setLoaded = function(idx) {
        return this.loaded[idx + ''] = true;
      };

      CampaignPreviewModal.prototype.isLoaded = function(idx) {
        return !!this.loaded[idx + ''];
      };

      CampaignPreviewModal.prototype.page = function(idx) {
        var _this = this;
        CampaignPreviewModal.__super__.page.apply(this, arguments);
        return _.delay((function() {
          var $cell, id, type, url;
          $cell = $('.page.row>.cell', _this.el).eq(idx);
          if (!_this.isLoaded(idx)) {
            _this.setLoaded(idx);
            type = $cell.attr('component-type');
            id = $cell.attr('component-id');
            url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + _this.campaignSummary.id + "/" + type + "s/" + id + "/preview_pane";
            return $('.component-content', $cell).load(url, function() {
              var h, iframe;
              h = $('.content', _this.el).height();
              iframe = $('iframe', $cell)[0];
              $('.preview-pane', $cell).css({
                'visibility': 'hidden'
              });
              $(iframe).bind('load', function() {
                var iframeWin;
                $cell.removeClass('loading');
                iframeWin = iframe.contentWindow || iframe.contentWindow.parentWindow;
                if (iframeWin.document.body) {
                  iframe.height = iframeWin.document.documentElement.scrollHeight || iframeWin.document.body.scrollHeight;
                }
                iframe.height = parseInt(iframe.height) + 20;
                $(iframe).css({
                  'margin-bottom': '20px'
                });
                return $('.preview-pane', $cell).css({
                  'visibility': 'visible'
                });
              });
              $('.actions', _this.el).html('');
              return $('.row.action-row', $cell).hide().clone().appendTo($('.actions', _this.el)).show();
            });
          } else {
            $('.actions', _this.el).html('');
            return $('.row.action-row', $cell).clone().appendTo($('.actions', _this.el)).show();
          }
        }), 300);
      };

      CampaignPreviewModal.prototype.renderHeader = function() {
        var $circles, compTypes, i, _i, _ref, _results;
        CampaignPreviewModal.__super__.renderHeader.apply(this, arguments);
        compTypes = _.map($('div.page.row>div.cell', this.el), function(item) {
          return $(item).attr('component-type');
        });
        $circles = $('.header .page-circle', this.el);
        $('.header', this.el).addClass('small-shadow');
        _results = [];
        for (i = _i = 0, _ref = compTypes.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push($circles.eq(i).html('').removeClass('page-circle').parent('.cell').addClass('tab').addClass(compTypes[i]));
        }
        return _results;
      };

      CampaignPreviewModal.prototype.actionButtons = function() {
        return nil;
      };

      return CampaignPreviewModal;

    })(PaginatedFormView);
  });

}).call(this);
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
(function() {

  jQueryInWindow(function($) {
    return this.LinkManipulator = (function() {

      function LinkManipulator(htmlContent) {
        this.htmlContent = htmlContent;
      }

      LinkManipulator.prototype.offsetOfTagAtIndex = function(tagName, n) {
        var idx, m, regex;
        idx = 0;
        m = null;
        regex = new RegExp("<[\s]*" + tagName, 'ig');
        
      while ((m = regex.exec(this.htmlContent)) && idx < n) {
        idx++
      };

        return m.index;
      };

      LinkManipulator.prototype.matchTagsInSelection = function(tagName, start, end, doc) {
        var $aTags, that;
        doc || (doc = $.parseHTMLContent(this.htmlContent));
        $aTags = $(tagName, doc);
        that = this;
        return $aTags.filter(function(idx) {
          var tagEnd, tagStart;
          tagStart = that.offsetOfTagAtIndex('a', idx);
          tagEnd = tagStart + $(this).outerHTML().length;
          return (tagStart > start && tagStart < end) || (tagEnd > start && tagEnd < end) || (start > tagStart && start < tagEnd) || (end > tagStart && end < tagEnd);
        });
      };

      LinkManipulator.prototype.replacePropertyOfTagsInSelection = function(property, tagName, newValue, start, end) {
        var $aTags, doc;
        doc = $.parseHTMLContent(this.htmlContent);
        $aTags = this.matchTagsInSelection(tagName, start, end, doc);
        $aTags.attr(property, newValue);
        return $('body', doc.documentElement).html();
      };

      return LinkManipulator;

    })();
  });

  /*
  # check offsetOfTagAtIndex('a', 2)
  html = '<a href="#">ok</a><a href=\'#\'>ok2</a><a href=\'#\'>ok3</a>'
  lm = new LinkManipulator(html)
  lm.offsetOfTagAtIndex('a', 2) == 37 || debugger 
  # check basic a[href] replacement when entire doc selected
  html = 'asdasd <strong></strong><a href="change/this/url"></a>adasda'
  lm = new LinkManipulator(html)
  newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', 'asdasd', 0, html.length)
  newHTML == 'asdasd <strong></strong><a href="asdasd"></a>adasda' || debugger
  # check basic a[href] replacement when the cursor is: "<|a hr.."
  newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', 'asdasd', 25, 25)
  newHTML == 'asdasd <strong></strong><a href="asdasd"></a>adasda' || debugger
  # check basic a[href] replacement when the just the first part of an <a> is selected
  newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', 'asdasd', 20, 28)
  newHTML == 'asdasd <strong></strong><a href="asdasd"></a>adasda' || debugger
  # check basic a[href] replacement when the just the first part of an <a> is selected
  newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', 'asdasd', 20, 28)
  newHTML == 'asdasd <strong></strong><a href="asdasd"></a>adasda' || debugger
  */


}).call(this);
















// includes all scripts
































;
