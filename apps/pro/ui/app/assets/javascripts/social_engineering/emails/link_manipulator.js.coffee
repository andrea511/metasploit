# Sample Usage:
# lm = new LinkManipulator('<body>..</body>')
# lm.matchTagsInSelection('a', 50, 65) #=> ['a.blah', 'a.new'] (arr of DOMElements)
# lm.replaceHrefOfTagsInSelection('a', 'www.g..' 50, 65) #=> '<body>..</body>'

jQueryInWindow ($) -> 
  class @LinkManipulator
    constructor: (@htmlContent) ->

    offsetOfTagAtIndex: (tagName, n) -> # find the nth 'a' tag
      idx = 0
      m = null
      regex = new RegExp "<[\s]*#{tagName}", 'ig'
      # coffeescript bungles up the syntax for this while loop
      # due to the inline assignment in the loop condition.
      # revert to inline js.
      `
      while ((m = regex.exec(this.htmlContent)) && idx < n) {
        idx++
      }`
      m.index

    matchTagsInSelection: (tagName, start, end, doc) ->
      doc ||= $.parseHTMLContent(@htmlContent)
      $aTags = $(tagName, doc)
      # iterate over each <a> tag, look for intersection with selection
      that = @
      $aTags.filter (idx) ->
        tagStart = that.offsetOfTagAtIndex('a', idx)
        tagEnd = tagStart + $(this).outerHTML().length
        # if selection and tag boundaries intercept
        (tagStart > start && tagStart < end) || # tag is INSIDE selection
        (tagEnd > start && tagEnd < end) ||
        (start > tagStart && start < tagEnd) ||
        (end > tagStart && end < tagEnd) # selection is INSIDE tag

    replacePropertyOfTagsInSelection: (property, tagName, newValue, start, end) ->
      doc = $.parseHTMLContent(@htmlContent)
      $aTags = @matchTagsInSelection(tagName, start, end, doc)
      $aTags.attr(property, newValue)
      $('body', doc.documentElement).html()

# on-the-fly tests
###
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
