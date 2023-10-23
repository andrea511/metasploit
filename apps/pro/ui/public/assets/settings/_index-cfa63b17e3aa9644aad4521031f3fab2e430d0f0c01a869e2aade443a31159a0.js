(function() {
  var $;

  $ = jQuery;

  $(document).ready(function() {
    var $lis, updateTabFromUrl;
    $lis = $('ul.tabs>li');
    $lis.click(function(e) {
      var $me, idx;
      $me = $(e.currentTarget);
      idx = $me.index();
      window.location = '#' + _.str.underscored($me.text());
      $lis.find('a').removeClass('active');
      $me.find('a').addClass('active');
      $('div.tabs>div').hide();
      return $('div.tabs>div').eq(idx).show();
    });
    updateTabFromUrl = function() {
      var chosen, urlTab;
      urlTab = _.str.trim(location.hash, '#');
      chosen = _.find($lis, function(li) {
        return _.str.underscored($(li).text()) === urlTab;
      });
      chosen || (chosen = $lis[0]);
      return $(chosen).click();
    };
    $(window).on('hashchange', updateTabFromUrl);
    return $(window).trigger('hashchange');
  });

}).call(this);
