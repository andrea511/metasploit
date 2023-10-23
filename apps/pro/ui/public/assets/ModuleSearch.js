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
