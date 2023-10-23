// TODO: convert from prototype
jQuery(document).ready(function() {
  jQuery('#check-for-updates').on('click', function(e) {
    new Ajax.Updater('update_info', '/updates/check', {
      onLoading: $('update_checking').show,
      onComplete: $('update_checking').hide,
      asynchronous: true,
      evalScripts: true,
      parameters: Form.serialize(this.form)});
    e.preventDefault();
    return false;
  });
});
