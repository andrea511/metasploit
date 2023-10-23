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
