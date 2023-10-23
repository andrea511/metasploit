(function() {
  var PRELOADED_IMAGES;

  PRELOADED_IMAGES = ["/assets/icons/silky/information_hover-14a9d682776bb882f5a94d77a6503aa1e2ad652adfe979d5790e09b4ba9930fe.png", "/assets/spinner-e008bc0bca2fa6f9b9c113fad73551230961baec88c06b20997ec50171bb2b6b.gif", "/assets/loader-bar-8411d80c628ffbe753443d652de05d8952e41238ac8e4ab9990f3435909f5a85.gif"];

  _.each(PRELOADED_IMAGES, function(src) {
    return (new Image).src = src;
  });

}).call(this);
