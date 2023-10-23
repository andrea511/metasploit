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
