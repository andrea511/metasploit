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
