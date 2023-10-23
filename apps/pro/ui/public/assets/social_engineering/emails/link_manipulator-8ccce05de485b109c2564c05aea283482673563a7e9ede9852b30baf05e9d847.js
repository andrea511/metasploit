(function() {

  jQueryInWindow(function($) {
    return this.LinkManipulator = (function() {

      function LinkManipulator(htmlContent) {
        this.htmlContent = htmlContent;
      }

      LinkManipulator.prototype.offsetOfTagAtIndex = function(tagName, n) {
        var idx, m, regex;
        idx = 0;
        m = null;
        regex = new RegExp("<[\s]*" + tagName, 'ig');
        
      while ((m = regex.exec(this.htmlContent)) && idx < n) {
        idx++
      };

        return m.index;
      };

      LinkManipulator.prototype.matchTagsInSelection = function(tagName, start, end, doc) {
        var $aTags, that;
        doc || (doc = $.parseHTMLContent(this.htmlContent));
        $aTags = $(tagName, doc);
        that = this;
        return $aTags.filter(function(idx) {
          var tagEnd, tagStart;
          tagStart = that.offsetOfTagAtIndex('a', idx);
          tagEnd = tagStart + $(this).outerHTML().length;
          return (tagStart > start && tagStart < end) || (tagEnd > start && tagEnd < end) || (start > tagStart && start < tagEnd) || (end > tagStart && end < tagEnd);
        });
      };

      LinkManipulator.prototype.replacePropertyOfTagsInSelection = function(property, tagName, newValue, start, end) {
        var $aTags, doc;
        doc = $.parseHTMLContent(this.htmlContent);
        $aTags = this.matchTagsInSelection(tagName, start, end, doc);
        $aTags.attr(property, newValue);
        return $('body', doc.documentElement).html();
      };

      return LinkManipulator;

    })();
  });

  /*
  # check offsetOfTagAtIndex('a', 2)
  html = '<a href="#">ok</a><a href=\'#\'>ok2</a><a href=\'#\'>ok3</a>'
  lm = new LinkManipulator(html)
  lm.offsetOfTagAtIndex('a', 2) == 37 || debugger 
  # check basic a[href] replacement when entire doc selected
  html = 'asdasd <strong></strong><a href="change/this/url"></a>adasda'
  lm = new LinkManipulator(html)
  newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', 'asdasd', 0, html.length)
  newHTML == 'asdasd <strong></strong><a href="asdasd"></a>adasda' || debugger
  # check basic a[href] replacement when the cursor is: "<|a hr.."
  newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', 'asdasd', 25, 25)
  newHTML == 'asdasd <strong></strong><a href="asdasd"></a>adasda' || debugger
  # check basic a[href] replacement when the just the first part of an <a> is selected
  newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', 'asdasd', 20, 28)
  newHTML == 'asdasd <strong></strong><a href="asdasd"></a>adasda' || debugger
  # check basic a[href] replacement when the just the first part of an <a> is selected
  newHTML = lm.replacePropertyOfTagsInSelection('href', 'a', 'asdasd', 20, 28)
  newHTML == 'asdasd <strong></strong><a href="asdasd"></a>adasda' || debugger
  */


}).call(this);
