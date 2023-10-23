(function() {

  jQuery(function($) {
    $.table = {
      defaults: {
        searchable: true,
        searchInputHint: 'Search',
        sortableClass: 'sortable',
        setFilteringDelay: false,
        datatableOptions: {
          bStateSave: true,
          oLanguage: {
            sSearch: "",
            sProcessing: "Loading..."
          },
          fnDrawCallback: function() {
            return $.table.controlBar.buttons.enable();
          },
          sDom: '<"control-bar"f>t<"list-table-footer clearfix"ip <"sel" l>>r',
          sPaginationType: 'r7Style',
          fnInitComplete: function(oSettings, json) {
            var $a, $searchBox, searchBox, searchTerm, table;
            searchTerm = getParameterByName('search');
            $searchBox = $('#search', $(this).parents().eq(3));
            if (searchTerm) {
              $searchBox.val(searchTerm);
              $searchBox.focus();
            }
            $searchBox.before('<a class="cancel-search" href="#"></a>');
            $a = $('.cancel-search');
            table = this;
            searchTerm = $searchBox.val();
            searchBox = $searchBox.eq(0);
            if (!searchTerm || searchTerm.length < 1) {
              $a.hide();
            }
            $a.click(function(e) {
              table.fnFilter('');
              $(searchBox).blur();
              return e.preventDefault();
            });
            table['fnFilterOld'] = table.fnFilter;
            table.fnFilter = function(str) {
              var end, start;
              $('.cancel-search').toggle(str && str.length > 0);
              start = $searchBox[0].selectionStart;
              end = $searchBox[0].selectionEnd;
              table.fnFilterOld(str);
              if ($searchBox[0].setSelectionRange != null) {
                return $searchBox[0].setSelectionRange(start, end);
              }
            };
            if ((searchTerm != null) && searchTerm.length) {
              return _.defer(function() {
                return table.fnFilter(searchTerm);
              });
            }
          }
        },
        analysisTabOptions: {
          "aLengthMenu": [[10, 50, 100, 250, 500, -1], [10, 50, 100, 250, 500, "All"]],
          "iDisplayLength": 100,
          "bProcessing": true,
          "bServerSide": true,
          "bSortMulti": false
        }
      },
      checkboxes: {
        bind: function() {
          return $("table.list thead tr th input[type='checkbox']").on('click', null, function(e) {
            var $checkboxes, $table;
            $table = $(e.currentTarget).parents('table').first();
            if ($table.data('dataTableObject') == null) {
              return;
            }
            $checkboxes = $table.find("input[type='checkbox']", "table.list tbody tr td:nth-child(1)");
            if ($(this).prop('checked')) {
              return $checkboxes.prop('checked', true);
            } else {
              return $checkboxes.prop('checked', false);
            }
          });
        }
      },
      controlBar: {
        buttons: {
          enable: function() {
            var disable, enable, numChecked;
            numChecked = $("tbody tr td input[type='checkbox']", "table.list").filter(':checked').not('.invisible').size();
            disable = function($button) {
              $button.addClass('disabled');
              return $button.children('input').attr('disabled', 'disabled');
            };
            enable = function($button) {
              $button.removeClass('disabled');
              return $button.children('input').removeAttr('disabled');
            };
            switch (numChecked) {
              case 0:
                disable($('span.button.single', '.control-bar'));
                disable($('span.button.multiple', '.control-bar'));
                return disable($('span.button.any', '.control-bar'));
              case 1:
                enable($('span.button.single', '.control-bar'));
                disable($('span.button.multiple', '.control-bar'));
                return enable($('span.button.any', '.control-bar'));
              default:
                disable($('span.button.single', '.control-bar'));
                enable($('span.button.multiple', '.control-bar'));
                return enable($('span.button.any', '.control-bar'));
            }
          },
          show: {
            bind: function() {
              var $showButton;
              $showButton = $('span.button a.show', '.control-bar');
              if ($showButton.length) {
                return $showButton.click(function(e) {
                  var hostHref;
                  if (!$showButton.parent('span').hasClass('disabled')) {
                    $("table.list tbody tr td input[type='checkbox']").filter(':checked').not('.invisible');
                    hostHref = $("table.list tbody tr td input[type='checkbox']").filter(':checked').parents('tr').children('td:nth-child(2)').children('a').attr('href');
                    window.location = hostHref;
                  }
                  return e.preventDefault();
                });
              }
            }
          },
          edit: {
            bind: function() {
              var $editButton;
              $editButton = $('span.button a.edit', '.control-bar');
              if ($editButton.length) {
                return $editButton.click(function(e) {
                  var hostHref;
                  if (!$editButton.parent('span').hasClass('disabled')) {
                    $("table.list tbody tr td input[type='checkbox']").filter(':checked').not('.invisible');
                    hostHref = $("table.list tbody tr td input[type='checkbox']").filter(':checked').parents('tr').children('td:nth-child(2)').children('span.settings-url').html();
                    window.location = hostHref;
                  }
                  return e.preventDefault();
                });
              }
            }
          },
          bind: function(options) {
            $('.control-bar').prepend($('.control-bar-items').html());
            $('.control-bar-items').remove();
            if (!!options.controlBarLocation) {
              $('.control-bar').appendTo(options.controlBarLocation);
            }
            this.enable();
            this.show.bind();
            return this.edit.bind();
          }
        },
        bind: function($table, options) {
          var $last_selected_row,
            _this = this;
          this.buttons.bind(options);
          $last_selected_row = null;
          return $table.on('click', "input[type='checkbox']", function(e) {
            var $all_trs, $checkbox, $dat_row, $dat_table, checked, idx1, idx2, tmp;
            _this.buttons.enable();
            $checkbox = $(e.currentTarget);
            $dat_table = $checkbox.parents('table').first();
            $dat_row = $checkbox.parents('tr').first();
            if (e.shiftKey && ($last_selected_row != null)) {
              idx1 = $dat_row.index();
              idx2 = $last_selected_row.index();
              if (idx2 < idx1) {
                tmp = idx2;
                idx2 = idx1;
                idx1 = tmp;
              }
              $all_trs = $dat_row.parent().find('tr').slice(idx1, idx2);
              checked = $last_selected_row.find('input[type=checkbox]').is(':checked');
              $('input[type=checkbox]', $all_trs).attr('checked', checked);
            }
            return $last_selected_row = $dat_row;
          });
        }
      },
      searchField: {
        addInputHint: function(options, $table) {
          var $searchInput, searchScope;
          if (options.searchable) {
            if (!!options.controlBarLocation) {
              searchScope = $table.parents().eq(3);
            }
            searchScope || (searchScope = $table.parents().eq(2));
            $searchInput = $('.dataTables_filter input', searchScope);
            $searchInput.attr('id', 'search');
            $searchInput.attr('placeholder', options.searchInputHint);
            return $searchInput.inputHint();
          }
        }
      },
      bind: function($table, options) {
        var $tbody, dataTable, datatableOptions;
        $tbody = $table.children('tbody');
        dataTable = null;
        if ($table.hasClass(options.sortableClass)) {
          if (!$('.control-bar-items').length) {
            options.datatableOptions["sDom"] = '<"list-table-header clearfix"lfr>t<"list-table-footer clearfix"ip>';
          }
          datatableOptions = options.datatableOptions;
          if (options.analysisTab) {
            $.extend(datatableOptions, options.analysisTabOptions);
            options.setFilteringDelay = true;
            options.controlBarLocation = $('.analysis-control-bar');
          }
          dataTable = $table.dataTable(datatableOptions);
          $table.data('dataTableObject', dataTable);
          if (options.setFilteringDelay) {
            dataTable.fnSetFilteringDelay(500);
          }
          if (options.analysisTab) {
            $("#" + ($table.attr('id')) + "_processing").watch('visibility', function() {
              if ($(this).css('visibility') === 'visible') {
                return $table.css({
                  opacity: 0.6
                });
              } else {
                return $table.css({
                  opacity: 1
                });
              }
            });
            $table.on('change', 'tbody tr td input[type=checkbox].hosts', function() {
              return $(this).siblings('input[type=checkbox]').prop('checked', $(this).prop('checked'));
            });
          }
          this.checkboxes.bind();
          this.controlBar.bind($table, options);
          this.searchField.addInputHint(options, $table);
          return $table.css('width', '100%');
        }
      }
    };
    $.fn.table = function(options) {
      var $table, settings;
      settings = $.extend(true, {}, $.table.defaults, options);
      $table = $(this);
      return this.each(function() {
        return $.table.bind($table, settings);
      });
    };
    return $.fn.addCollapsibleSearch = function(options) {
      var searchVal;
      $('.button .search').click(function(e) {
        var $filter, $input;
        $filter = $('.dataTables_filter');
        $input = $('input', $filter);
        if ($filter.css('bottom').charAt(0) === '-') {
          if (!$input.val() || $input.val().length < 1) {
            $filter.css('bottom', '1000px');
          }
        } else {
          $filter.css('bottom', '-42px');
          $input.focus();
        }
        return e.preventDefault();
      });
      searchVal = $('.dataTables_filter input').val();
      if (searchVal && searchVal.length > 0) {
        return $('.button .search').click();
      }
    };
  });

}).call(this);
