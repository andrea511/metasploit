(function() {

  jQuery(function($) {
    var loadNews, toggleNewsPane;
    toggleNewsPane = function(e) {
      var $a;
      $a = $(e.target).unbind('click');
      Effect.toggle('product-news', 'blind', {
        duration: 0.2
      });
      if (document.getElementById('project-list').style.width === "60%") {
        $a.html($a.html().replace('Hide', 'Show'));
        $('#project-list').css('width', '100%');
        document.cookie = 'ui-workspace-index-hide-product-news=false';
      } else {
        $a.html($a.html().replace('Show', 'Hide'));
        $('#project-list').css('width', '60%');
        document.cookie = 'ui-workspace-index-hide-product-news=true';
      }
      window.setTimeout((function() {
        return $a.bind('click', toggleNewsPane);
      }), 300);
      return false;
    };
    loadNews = function() {
      var currTitle, data, feedEdition, feedOrigVersion, feedRevision, feedTs, feedURL, feedVersion, newsHidden, pid;
      pid = encodeURIComponent($('meta[name=msp-feed-serial]').attr('content'));
      feedVersion = encodeURIComponent($('meta[name=msp-feed-version]').attr('content'));
      feedRevision = encodeURIComponent($('meta[name=msp-feed-revision]').attr('content'));
      feedEdition = encodeURIComponent($('meta[name=msp-feed-edition]').attr('content'));
      feedTs = encodeURIComponent($('meta[name=msp-feed-ts]').attr('content'));
      feedOrigVersion = encodeURIComponent($('meta[name=msp-feed-orig-version]').attr('content'));
      feedURL = "https://dev.metasploit.com/news.json";
      data = "pid=" + pid + "&ver=" + feedVersion + "&rev=" + feedRevision + "&ed=" + feedEdition + "&over=" + feedOrigVersion + "&ts=" + feedTs;
      window.setTimeout((function() {
        return $.getJSON(feedURL + "?" + data, function(json) {
          var buildFeedItem, item, _i, _len, _ref, _results;
          buildFeedItem = function(item) {
            var content;
            content = "<div class='feeditem'><h3><a href='" + item.link + "' target='_blank'>" + item.title + "</a></h3><p class='blurb'>" + item.blurb + "</p></div>";
            return $("#product-news-content").append(content);
          };
          if (!json || json.feed.items.length === 0) {
            return $("#product-news-content").html('<p>Unable to retrieve the product news from the server.</p>');
          } else {
            $("#product-news-content").html('');
            _ref = json.feed.items;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              item = _ref[_i];
              _results.push(buildFeedItem(item));
            }
            return _results;
          }
        });
      }), 1);
      newsHidden = document.cookie.match(/ui-workspace-index-hide-product-news=false/);
      currTitle = newsHidden ? 'Show News Panel' : 'Hide News Panel';
      $("#product-news-header").before('<a style="float: right; background-image:none;' + '  cursor: pointer;" class="showhide"' + ' href="#">' + currTitle + '</a>');
      $('a.showhide').prepend('<img alt="Newspaper" ' + ' src="/assets/icons/silky/newspaper-9ba7151a9f0262778f4fc5696df43cce92470bf7ab5f80dd259744dbc440581a.png" style="margin-bottom: -3px; ' + ' margin-right: 3px;">').click(toggleNewsPane);
      if (newsHidden) {
        $("#product-news").hide();
        return $('#project-list').css('width', '100%');
      } else {
        $("#product-news").show();
        return $('#project-list').css('width', '60%');
      }
    };
    return $(document).ready(function() {
      $("#all_workspaces").checkAll($("#workspace_checkboxes"));
      if ($('[name=enable_news_feed]').attr('content') === 'true') {
        loadNews();
      }
      $("#workspace-table").table({
        searchable: false,
        datatableOptions: {
          aaSorting: [[7, 'desc']],
          aoColumns: [
            {
              bSortable: false
            }, {}, {}, {}, {}, {}, {
              sType: "title-numeric"
            }, {}
          ]
        }
      });
      $('#search').inputHint({
        fadeOutSpeed: 300,
        padding: '2px',
        paddingLeft: '5px'
      });
      return $('#quick-start-menu li, #global-tools-menu li').click(function(e) {
        var className;
        if ($(e.currentTarget).is('.egadz')) {
          return;
        }
        e.preventDefault();
        className = _.chain($(e.currentTarget).attr('name')).camelize().capitalize().value();
        return new window[className + 'Modal']({
          el: $("#modals")
        }).open();
      });
    });
  });

}).call(this);
