(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      return $.fn.dataTableExt.oApi.fnInitEditRow = function() {
        var EDIT_BUTTON, EDIT_COLUMN, EDIT_RENDER_COLUMN, aoColumns, cachedRows, editableOpts, init_plugin, oApi, oSettings, selectOptions, _ajax_delete_row, _ajax_post_row, _bind_close_event, _bind_delete_event, _bind_edit_event, _bind_save_event, _cacheRows, _display_edit_columns, _edit_row_init, _enable_row_edit, _ensure_aData_hash, _generate_options_html, _parse_row_data, _reset_rows, _show_edit_column, _show_edit_column_options,
          _this = this;
        oSettings = this.fnSettings();
        EDIT_BUTTON = "<div class='edit-table-row'><a class='pencil' href='javascript:void(0)'></a><a href='javascript:void(0)' class='garbage'></a></span></div>";
        EDIT_COLUMN = "<div class='edit-table-row'><a href='javascript:void(0)' class='save'> Save </a><a href='javascript:void(0)' class='cancel'> Cancel </a></div>";
        EDIT_RENDER_COLUMN = EDIT_BUTTON;
        aoColumns = oSettings.aoColumns;
        oApi = oSettings.oApi;
        editableOpts = oSettings.editableOpts;
        cachedRows = [];
        selectOptions = {};
        _generate_options_html = function($col, colId) {
          var option, selected, str, _i, _len, _ref;
          str = "<select>";
          _ref = editableOpts[colId].options;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            option = _ref[_i];
            selected = $col.html() === option.content ? "selected='selected'" : "";
            str = str + ("<option value='" + option.value + "' " + selected + ">" + option.content + "</option>");
          }
          return str = str + "</select>";
        };
        _show_edit_column_options = function($col) {
          return $col.html(EDIT_COLUMN);
        };
        _show_edit_column = function($col, colId) {
          var html, idValue, safe_html;
          switch (editableOpts[colId].type) {
            case "select":
              html = _generate_options_html($col, colId);
              return $col.html(html);
            case "field":
              idValue = '';
              if (editableOpts[colId].id !== void 0) {
                idValue = "id='" + editableOpts[colId].id + "'";
              }
              safe_html = _.escapeHTML(_.unescapeHTML($col.html()));
              return $col.html("<input type='text' " + idValue + " value='" + safe_html + "'/>");
          }
        };
        _bind_close_event = function() {
          return $('.edit-table-row .cancel', oSettings.nTable).on('click', function(e) {
            var $row, col, propName, rowId, _i, _ref;
            $row = $(e.currentTarget).closest('tr');
            rowId = _this.fnGetPosition($row[0]);
            if ($('.error').size() > 0) {
              oSettings.aoData = cachedRows;
            } else {
              cachedRows = _cacheRows();
            }
            for (col = _i = 0, _ref = oSettings.aoColumns.length; 0 <= _ref ? _i < _ref : _i > _ref; col = 0 <= _ref ? ++_i : --_i) {
              propName = aoColumns[col].mDataProp;
              _this.fnUpdate(oSettings.aoData[rowId]._aData[propName], rowId, col, false);
            }
            return _display_edit_columns();
          });
        };
        _reset_rows = function() {
          var col, propName, row, _i, _ref, _results;
          _results = [];
          for (row = _i = 0, _ref = oSettings.aoData.length; 0 <= _ref ? _i < _ref : _i > _ref; row = 0 <= _ref ? ++_i : --_i) {
            _results.push((function() {
              var _j, _ref1, _results1;
              _results1 = [];
              for (col = _j = 0, _ref1 = oSettings.aoColumns.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; col = 0 <= _ref1 ? ++_j : --_j) {
                propName = aoColumns[col].mDataProp;
                _results1.push(this.fnUpdate(oSettings.aoData[row]._aData[propName], row, col, false));
              }
              return _results1;
            }).call(_this));
          }
          return _results;
        };
        _bind_edit_event = function() {
          $(oSettings.nTable).off('click', '.edit-table-row .pencil');
          return $(oSettings.nTable).on('click', '.edit-table-row .pencil', function(e) {
            var $row, rowId;
            $row = $(e.currentTarget).closest('tr');
            rowId = _this.fnGetPosition($row[0]);
            if ($('.error').size() > 0) {
              oSettings.aoData = cachedRows;
            } else {
              cachedRows = _cacheRows();
            }
            _reset_rows();
            _display_edit_columns();
            return _enable_row_edit($row);
          });
        };
        _ajax_delete_row = function(data) {
          data = {
            aaData: data
          };
          return $.ajax({
            type: "DELETE",
            url: oSettings.sAjaxDelete,
            data: data
          });
        };
        _ajax_post_row = function(data, $row) {
          var opts;
          data = {
            aaData: data
          };
          opts = {
            data: data,
            $row: $row
          };
          return $.ajax({
            context: opts,
            type: "PATCH",
            url: oSettings.sAjaxDestination,
            data: data,
            success: function() {
              _reset_rows();
              $(oSettings.nTable).trigger('rowAdded', oSettings.fnRecordsTotal());
              return _display_edit_columns();
            },
            error: function(e) {
              var response;
              $('.error').remove();
              response = $.parseJSON(e.responseText);
              return _.each(response.error, function(val, key) {
                var $col, $msg, col, cols, _i, _ref, _results;
                _results = [];
                for (col = _i = 0, _ref = oSettings.aoColumns.length; 0 <= _ref ? _i < _ref : _i > _ref; col = 0 <= _ref ? ++_i : --_i) {
                  if (oSettings.aoColumns[col].mDataProp === key) {
                    cols = $row.find('td');
                    $col = $(cols[col]);
                    $msg = $('<div />', {
                      "class": 'error'
                    }).text(val[0]);
                    _results.push($('input', $col).addClass('invalid').after($msg));
                  } else {
                    _results.push(void 0);
                  }
                }
                return _results;
              }, this);
            }
          });
        };
        _ensure_aData_hash = function(aData) {
          var aDataHash, col, mDataProp, _i, _ref;
          aDataHash = {};
          if (aData.constructor === Array) {
            for (col = _i = 0, _ref = oSettings.aoColumns.length; 0 <= _ref ? _i < _ref : _i > _ref; col = 0 <= _ref ? ++_i : --_i) {
              mDataProp = oSettings.aoColumns[col].mDataProp;
              if (editableOpts[col].type !== "none" && editableOpts[col].type !== "control" || mDataProp === "id") {
                if (editableOpts[col].type === "select") {
                  aDataHash[mDataProp] = selectOptions[mDataProp];
                } else {
                  aDataHash[mDataProp] = aData[mDataProp];
                }
              }
            }
            return aDataHash;
          } else {
            return aData;
          }
        };
        _parse_row_data = function($row, rowId) {
          var $cols, $elem, col, colName, html, _i, _ref, _results;
          $cols = $row.find('td');
          _results = [];
          for (col = _i = 0, _ref = oSettings.aoColumns.length; 0 <= _ref ? _i < _ref : _i > _ref; col = 0 <= _ref ? ++_i : --_i) {
            colName = oSettings.aoColumns[col].mDataProp;
            switch (editableOpts[col].type) {
              case "select":
                $elem = $("select :selected", $cols[col]);
                html = $elem.text();
                oSettings.aoData[rowId]._aData[colName] = $elem.html();
                _results.push(selectOptions[colName] = $elem.val());
                break;
              case "field":
                html = $("input", $cols[col]).val();
                _results.push(oSettings.aoData[rowId]._aData[colName] = html);
                break;
              default:
                _results.push(void 0);
            }
          }
          return _results;
        };
        _bind_save_event = function() {
          return $('.edit-table-row .save', oSettings.nTable).on('click', function(e) {
            var $row, data, rowId;
            $row = $(e.currentTarget).closest('tr');
            rowId = _this.fnGetPosition($row[0]);
            _parse_row_data($row, rowId);
            data = _ensure_aData_hash(oSettings.aoData[rowId]._aData);
            return _ajax_post_row(data, $row);
          });
        };
        _bind_delete_event = function() {
          $(oSettings.nTable).off('click', '.edit-table-row .garbage');
          return $(oSettings.nTable).on('click', '.edit-table-row .garbage', function(e) {
            var $row, count, data, records_total, rowId;
            if (window.confirm("Are you sure you want to delete item?")) {
              $row = $(e.currentTarget).closest('tr');
              rowId = _this.fnGetPosition($row[0]);
              _reset_rows();
              _display_edit_columns();
              data = _ensure_aData_hash(oSettings.aoData[rowId]._aData);
              _ajax_delete_row(data);
              records_total = oSettings.fnRecordsTotal();
              count = records_total > 0 ? records_total - 1 : 0;
              _this.fnDeleteRow(rowId, 0, true);
              return $(oSettings.nTable).trigger('rowDeleted', count);
            }
          });
        };
        _enable_row_edit = function($row) {
          var $cols, col, rowId, _i, _ref;
          rowId = _this.fnGetPosition($row[0]);
          $cols = $row.find('td');
          for (col = _i = 0, _ref = oSettings.aoColumns.length; 0 <= _ref ? _i < _ref : _i > _ref; col = 0 <= _ref ? ++_i : --_i) {
            if (!(editableOpts[col].type === "control" || editableOpts[col].type === "none")) {
              _show_edit_column($($cols[col]), col);
            }
            if (editableOpts[col].type === "control") {
              _show_edit_column_options($($cols[col]));
            }
          }
          _bind_save_event();
          return _bind_close_event();
        };
        _display_edit_columns = function() {
          return $.map(editableOpts, function(val, colId) {
            var row, _i, _ref;
            if (editableOpts[colId].type === "control") {
              aoColumns[colId].fnRender = function() {
                return EDIT_RENDER_COLUMN;
              };
              for (row = _i = 0, _ref = oSettings.aoData.length; 0 <= _ref ? _i < _ref : _i > _ref; row = 0 <= _ref ? ++_i : --_i) {
                _this.fnUpdate("", row, colId, false);
              }
              _bind_edit_event();
              return _bind_delete_event();
            }
          });
        };
        _cacheRows = function() {
          var opts;
          opts = {
            cachedRows: cachedRows
          };
          cachedRows = [];
          _.each(oSettings.aoData, function(row) {
            return cachedRows.push($.extend(true, {}, row));
          }, opts);
          return cachedRows;
        };
        _edit_row_init = function() {
          oSettings.aoDrawCallback.pop();
          _display_edit_columns();
          return _cacheRows();
        };
        init_plugin = function() {
          return oSettings.aoDrawCallback.push({
            fn: _edit_row_init,
            sName: "edit_row"
          });
        };
        return init_plugin();
      };
    });
  });

}).call(this);
