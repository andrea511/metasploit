if (parent !== window) {
  top.jQuery(document.body).addClass('embed')
  document.onkeydown = function(e) {
    if (e.keyCode == 27 || (e.keyCode == 192 & e.ctrlKey)) top.toggleConsole();
  }
}

top.jQuery('.console_close').on('click', top.toggleConsole);
