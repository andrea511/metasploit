//= require jquery-cookie
//= require browser_detect
//= require shared/version_nagware

//Append URL Anchor to POST request
$(document).ready(function() {
  var url = jQuery('form').attr('action')+'#'+ window.location.hash.substr(1);
  jQuery('form').attr('action',url);
});
