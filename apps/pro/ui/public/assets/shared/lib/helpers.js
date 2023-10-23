(function() {
  var $,
    _this = this;

  $ = jQuery;

  window.helpers || (window.helpers = {
    cloneNodeAndForm: function(oldNode) {
      var clonedNode, clonedNodes, oldNodes;
      clonedNode = $(oldNode).clone(true, true)[0];
      oldNodes = $('textarea, select', oldNode);
      clonedNodes = $('textarea, select', clonedNode);
      _.each(clonedNodes, function(elem, index) {
        var newNode;
        oldNode = oldNodes[index];
        newNode = clonedNodes[index];
        return $(newNode).val($(oldNode).val());
      });
      return clonedNode;
    },
    urlParam: function(name) {
      var results;
      results = new RegExp('[\\?&amp;]' + name + '=([^&amp;#]*)').exec(window.location.href);
      return (results != null ? results[1] : void 0) || 0;
    },
    formatBytes: function(fs) {
      var fmtSize, i, size, units;
      if (!fs || fs === '') {
        return '';
      }
      size = parseInt(fs);
      units = ['B', 'KB', 'MB', 'GB', 'TB'];
      i = 0;
      while (size >= 1024) {
        size /= 1024;
        i++;
      }
      fmtSize = size.toFixed(1) + units[i].toLowerCase();
      return fmtSize;
    },
    parseBytes: function(fs) {
      var i, matches, parsed, units;
      matches = fs.match(/[^0-9.]+/g);
      parsed = parseFloat(fs.replace(/[^0-9.]+/g, ''));
      if ((matches != null) && matches.size() > 0) {
        units = ['B', 'KB', 'MB', 'GB', 'TB'];
        i = 0;
        while (matches[0] !== units[i]) {
          i++;
        }
        return parseInt(parsed * Math.pow(1024, i));
      } else {
        return parseInt(parseFloat(fs * 1024 * 1024));
      }
    },
    loadRemoteTable: function(opts) {
      var $area, cb, dtOpts, _ref,
        _this = this;
      if (opts == null) {
        opts = {};
      }
      $area = opts.el;
      cb = opts.cb;
      dtOpts = opts.dataTable || {};
      dtOpts.sPaginationType = "r7Style";
      dtOpts.sDom = 'ft<"list-table-footer clearfix"ip <"sel" l>>r';
      return $.ajax({
        url: opts != null ? (_ref = opts.dataTable) != null ? _ref.sAjaxSource : void 0 : void 0,
        dataType: 'json',
        success: function(data) {
          var $dataTable, $table, $tr, additionalCols, colArr, colNames, colOverrides, defaultOpts, initCompleteCallback;
          $area.removeClass('tab-loading').html('');
          colNames = data['sColumns'].split(',');
          $area.append('<table><thead><tr /></thead><tbody /></table>');
          $table = $('table', $area).addClass('list');
          $tr = $('thead tr', $area);
          colOverrides = opts.columns || {};
          additionalCols = opts.additionalCols || [];
          colNames = _.union(additionalCols, colNames);
          colArr = _.map(colNames, function(name) {
            var col, _ref1, _ref2;
            $tr.append($('<th />', {
              html: (_ref1 = (_ref2 = colOverrides[name]) != null ? _ref2.name : void 0) != null ? _ref1 : _.str.humanize(name)
            }));
            col = {
              mDataProp: _.str.underscored(name)
            };
            if (colOverrides[name] != null) {
              $.extend(col, colOverrides[name]);
            }
            return col;
          });
          initCompleteCallback = dtOpts.fnInitComplete;
          delete dtOpts['fnInitComplete'];
          defaultOpts = {
            aoColumns: colArr,
            bProcessing: true,
            bServerSide: true,
            sPaginationType: "full_numbers",
            bFilter: false,
            bStateSave: true,
            fnDrawCallback: function() {
              return $table.css('width', '100%');
            },
            fnInitComplete: function() {
              if (initCompleteCallback != null) {
                initCompleteCallback.apply(this, arguments);
              }
              return $table.trigger('tableload');
            }
          };
          $dataTable = $table.dataTable($.extend({}, defaultOpts, dtOpts));
          $area.append($('<div />', {
            style: 'clear:both'
          }));
          if (opts.editableOpts != null) {
            $table.fnSettings().sAjaxDelete = opts.sAjaxDelete;
            $table.fnSettings().sAjaxDestination = opts.sAjaxDestination;
            $table.fnSettings().editableOpts = opts.editableOpts;
            $table.fnInitEditRow();
          }
          if (opts.success != null) {
            return opts.success($dataTable);
          }
        }
      });
    },
    showLoadingDialog: function(loadingMsg) {
      if (loadingMsg == null) {
        loadingMsg = 'Loading...';
      }
      this._loaderDialog = $('<div class="loading tab-loading" />').dialog({
        modal: true,
        closeOnEscape: false,
        title: loadingMsg,
        resizable: false
      });
      this._loaderDialog.parents('.ui-dialog').addClass('white');
      return this._loaderDialog.append($('<p class="dialog-msg center">').text(''));
    },
    hideLoadingDialog: function() {
      var _ref, _ref1, _ref2, _ref3;
      if ((_ref = this._loaderDialog) != null) {
        _ref.dialog();
      }
      if ((_ref1 = this._loaderDialog) != null ? _ref1.dialog('isOpen') : void 0) {
        return (_ref2 = this._loaderDialog) != null ? (_ref3 = _ref2.dialog('close')) != null ? _ref3.remove() : void 0 : void 0;
      }
    },
    setDialogTitle: function(title) {
      return $('.dialog-msg', _this._loaderDialog).text(title);
    }
  });

}).call(this);
