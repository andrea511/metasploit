document.observe("dom:loaded", function() {
  // wire-up tabs
  $$('ul.tabs').each(function(tab_group) {
    new Control.Tabs(tab_group);
  });
});
