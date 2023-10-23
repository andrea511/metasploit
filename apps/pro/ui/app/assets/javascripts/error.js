//= require jquery

$(document).ready(function() {
  $("input.page-reload").on('click', function() {
    document.location.reload();
    return false;
  });
});
