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
