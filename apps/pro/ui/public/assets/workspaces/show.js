(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var switchButton, topBarPresent;
      $('span.btn a').click(function(e) {
        if ($(this).attr('href') === '#') {
          return e.preventDefault();
        }
      });
      switchButton = function($button) {
        if ($button.hasClass('expanded')) {
          $button.removeClass('expanded');
          return $button.addClass('collapsed');
        } else {
          $button.removeClass('collapsed');
          return $button.addClass('expanded');
        }
      };
      topBarPresent = $('#dashboard-expander').size() > 0;
      $('#dashboard-expander').parent().click(function() {
        $('#dashboard-content').slideToggle();
        return switchButton($(this).find('#dashboard-expander'));
      });
      $('#overview-expander').parent().click(function() {
        if (!topBarPresent) {
          return;
        }
        $('form.overview').slideToggle();
        return switchButton($(this).find('#overview-expander'));
      });
      if (!topBarPresent) {
        return $('#overview-expander').hide().parent().css({
          cursor: 'default'
        });
      }
    });
  });

}).call(this);
