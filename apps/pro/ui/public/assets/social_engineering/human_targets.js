jQuery(document).ready(function() {
  jQuery('li.se-json-result').each(function() {
    j = new PrettyJSON.view.Node({el: this, data: jQuery(this).data('content')});
    j.expandAll();
  });
});
