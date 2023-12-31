// # Jquery and Rails powered default application.js
// # Easy Ajax replacement for remote_functions and ajax_form based on class name
// # All actions will reply to the .js format
// # Unostrusive, will only works if Javascript enabled, if not, respond to an HTML as a normal link
// # respond_to do |format|
// #   format.html
// #   format.js {render :layout => false}
// # end
jQuery(function($) {

  jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} })

  function _ajax_request(url, data, callback, type, method) {
      if (jQuery.isFunction(data)) {
          callback = data;
          data = {};
      }
      return jQuery.ajax({
          type: method,
          url: url,
          data: data,
          success: callback,
          dataType: type
          });
  }

  jQuery.extend({
      put: function(url, data, callback, type) {
          return _ajax_request(url, data, callback, type, 'PUT');
      },
      delete_: function(url, data, callback, type) {
          return _ajax_request(url, data, callback, type, 'DELETE');
      }
  });

  /*
  Submit a form with Ajax
  Use the class ajaxForm in your form declaration
  form_for @comment,:html => {:class => "ajaxForm"} do |f|
  */
  jQuery.fn.submitWithAjax = function() {
    this.unbind('submit', false);
    this.submit(function() {
      $.post(this.action, $(this).serialize(), null, "script");
      return false;
    })

    return this;
  };

  /*
  Retreive a page with get
  Use the class get in your link declaration
  link_to 'My link', my_path(),:class => "get"
  */
  jQuery.fn.getWithAjax = function() {
    this.unbind('click', false);
    this.click(function() {
      $.get($(this).attr("href"), $(this).serialize(), null, "script");
      return false;
    })
    return this;
  };

  /*
  Post data via html
  Use the class post in your link declaration
  link_to 'My link', my_new_path(),:class => "post"
  */
  jQuery.fn.postWithAjax = function() {
    this.unbind('click', false);
    this.click(function() {
      $.post($(this).attr("href"), $(this).serialize(), null, "script");
      return false;
    })
    return this;
  };

  /*
  Update/Put data via html
  Use the class put in your link declaration
  link_to 'My link', my_update_path(data),:class => "put",:method => :put
  */
  jQuery.fn.putWithAjax = function() {
    this.unbind('click', false);
    this.click(function() {
      $.put($(this).attr("href"), $(this).serialize(), null, "script");
      return false;
    })
    return this;
  };

  /*
  Delete data
  Use the class delete in your link declaration
  link_to 'My link', my_destroy_path(data),:class => "delete",:method => :delete
  */
  jQuery.fn.deleteWithAjax = function() {
    this.removeAttr('onclick');
    this.unbind('click', false);
    this.click(function() {
      if(confirm("Are you sure you want to delete this vuln?")) {
        $.delete_($(this).attr("href"), $(this).serialize(), null, "script");
      }
      return false;
    })
    return this;
  };

  (function($) {
    return jQuery.fn.insertAt = function(index, element) {
      var lastIndex;
      if (index <= 0) return this.prepend(element);
      lastIndex = this.children().size();
      if (index >= lastIndex) return this.append(element);
      return $(this.children()[index - 1]).after(element);
    };
  })(jQuery);

  /*
  Ajaxify all the links on the page.
  This function is called when the page is loaded. You'll probaly need to call it again when you write render new datas that need to be ajaxyfied.'
  */
  function ajaxLinks(){
      $('.ajax-form').submitWithAjax();
      $('a.ajax-get').getWithAjax();
      $('a.ajax-post').postWithAjax();
      $('a.ajax-put').putWithAjax();
      $('a.ajax-delete').deleteWithAjax();
  }

  $(document).ready(function() {
  // All non-GET requests will add the authenticity token
   $(document).ajaxSend(function(event, request, settings) {
         if (typeof(window.AUTH_TOKEN) == "undefined") return;
         // IE6 fix for http://dev.jquery.com/ticket/3155
         if (settings.type == 'GET' || settings.type == 'get') return;

         settings.data = settings.data || "";
         settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
       });

    ajaxLinks();
  });

});