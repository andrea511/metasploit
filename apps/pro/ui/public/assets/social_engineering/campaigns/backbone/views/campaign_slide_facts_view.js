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
