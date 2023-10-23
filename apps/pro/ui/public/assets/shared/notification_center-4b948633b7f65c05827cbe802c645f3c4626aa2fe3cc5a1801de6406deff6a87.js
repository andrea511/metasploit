jQuery(document).bind('requirejs-ready', function(){
  initRequire(
    [
      'jquery',
      '/assets/shared/notification-center/backbone/controllers/notification_center_controller-50a8273c931ff3fcc54bc19a799a108aa0938aa501df593a01104323148ce897.js',
      '/assets/shared/banner_message/banner_message_controller-077219959280ae1c49ba8328971511d1512be60f0d39cdef743d5c66c2c73da7.js'
    ],
    function($, NotificationCenterController, BannerMessageController){
      NotificationCenterController.start();
      new BannerMessageController();
  });
});
