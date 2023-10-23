(function() {
  var $, BannerMessage;

  $ = jQuery;

  BannerMessage = {
    cookieKey: 'os-deprecation-announcement',
    cookieDismissedKey: function() {
      return this.cookieKey + '-dismissed';
    },
    cookieViewedKey: function() {
      return this.cookieKey + '-viewed';
    },
    markBannerAsViewed: function() {
      if (!$.cookie(this.cookieViewedKey())) {
        return $.cookie(this.cookieViewedKey(), Date.now());
      }
    },
    daysBetween: function(date1, date2) {
      var date1Ms, date2Ms, differenceMs, oneDay;
      oneDay = 1000 * 60 * 60 * 24;
      date1Ms = date1.getTime();
      date2Ms = date2.getTime();
      differenceMs = date2Ms - date1Ms;
      return Math.round(differenceMs / oneDay);
    },
    bannerExpired: function() {
      var cookieViewedDate;
      cookieViewedDate = new Date();
      cookieViewedDate.setTime($.cookie(this.cookieViewedKey()));
      return this.daysBetween(cookieViewedDate, new Date()) > 5;
    },
    bind: function() {
      var _this = this;
      return $('.banner-message').parent().siblings('.growl-close').on('click', function() {
        return $.cookie(_this.cookieDismissedKey(), '1');
      });
    },
    display: function() {
      this.markBannerAsViewed();
      if (WORKSPACE_ID && !($.cookie(this.cookieDismissedKey()) === '1') && !this.bannerExpired()) {
        $.growl({
          title: 'End of Support Announcement',
          location: 'br',
          style: 'warning',
          "static": true,
          size: 'large',
          message: "<div class='banner-message'>\n  <p>Metasploit will no longer be supported on Windows Server\n  2003 platforms effective July 2015 due to an upcoming end of\n  vendor support for Windows Server 2003. If you are currently\n  running this platform, we strongly recommend you migrate to\n  a newer version of Windows Server before the end of support\n  date.</p>\n</div>"
        });
        return this.bind();
      }
    }
  };

  $(document).ready(function() {
    return BannerMessage.display();
  });

}).call(this);
