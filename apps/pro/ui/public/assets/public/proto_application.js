// NOTE: this file used to be 'application.js' pre-Rails3 upgrade

// TODO: Rails 3 upgrade - when we drop the rest of this file, we want to keep this
// console.log stuff.
// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) {
      arguments.callee = arguments.callee.caller;
      console.log( Array.prototype.slice.call(arguments) );
  }
};
// make it safe to use console.log always
(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();)b[a]=b[a]||c})(window.console=window.console||{});

function getParameterByName(name)
{
  name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
  var regexS = "[\\?&]" + name + "=([^&#]*)";
  var regex = new RegExp(regexS);
  var results = regex.exec(window.location.href);
  if(results == null)
    return "";
  else
    return decodeURIComponent(results[1].replace(/\+/g, " "));
}
/////////////////////////////////////////////////////////////////

document.observe("dom:loaded", function() {
  // close popup
  var overlay = $('popup_overlay');
  if (overlay) {
    overlay.observe('click', function(e) {
      close_popup();
    });
  }
});

function close_popup() {
  $('popup').hide();
}

function fill_in_tag_form(form_elem,tag_id,bool1,bool2,bool3) {
  form_elem.create_tag_name.value = document.getElementById(tag_id).children[0].innerText;
  form_elem.create_tag_desc.value = document.getElementById(tag_id).children[1].innerText;
  form_elem.create_tag_report_summary.checked = bool1;
  form_elem.create_tag_report_detail.checked = bool2;
  form_elem.create_tag_critical.checked = bool3;
  return true;
}

function remove_fields(link) {
  $(link).previous('input[type=hidden]').value = "1";
  $(link).up('.fields').hide();
}
jQuery(document).on('click', 'a.remove-fields', function(e) {
  e.preventDefault();
  remove_fields(this);
  return false;
});

function add_fields(link, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_object", "g");
  var table = $(link).previous('table');
  var empty_row = table.select('tr.emptyset');
  if (empty_row.size() > 0) {
    empty_row[0].hide();
  };
  // add the content and replace 'new_object' with an ID generated from the current timestamp
  table.insert({
    bottom: content.replace(regexp, new_id)
  });
  // focus the first input field that was inserted
  var rows = table.select('tr');
  var last_row = rows[rows.size()-1];
  last_row.select('input')[0].focus()
}

jQuery(document).ready(function() {
  jQuery(document).on('click', 'a.add-new-fields', function(e) {
    e.preventDefault();
    add_fields(this, jQuery(this).data('new-fields'));
    return false;
  });
});

function show_mitm_warning(element) {
  var value = element.value;
  if (! (value == "127.0.0.1" || value == "localhost")) {
    $('mitm_warning').show();
  } else {
    $('mitm_warning').hide();
  }
}

/*
 * If the given select element is set to "", disables every other element
 * inside the select's form.
 */
function disable_fields_if_select_is_blank(select) {
  var formElement = Element.up(select, "form");
  var fields = formElement.getElements();

  Element.observe(select, "change", function(e) {
    var v = select.getValue();
    for (var i in fields) {
      if (fields[i] != select && fields[i].type && fields[i].type.toLowerCase() != 'hidden' && fields[i].type.toLowerCase() != 'submit') {
        if (v != "") {
          fields[i].disabled = true
        } else {
          fields[i].disabled = false;
        }
        }
    }
  });
}

function enable_fields_with_checkbox(checkbox, div) {
  var fields;

  if (!div) {
    div = Element.up(checkbox, "fieldset")
  }

  f = function(e) {
    fields = div.descendants();
    var v = checkbox.getValue();
    for (var i in fields) {
      if (fields[i] != checkbox && fields[i].type && fields[i].type.toLowerCase() != 'hidden') {
        if (!v) {
          fields[i].disabled = true
        } else {
          fields[i].disabled = false;
        }
      }
    }
  }
  f();
  Element.observe(checkbox, "change", f);
}

function submit_checkboxes_to(path, token) {
  var f = document.createElement('form'); 
  f.style.display = 'none'; 
      
  /* Set the post destination */
  f.method = 'POST'; 
  f.action = path;
    
  /* Create the authenticity_token */
  var s = document.createElement('input'); 
  s.setAttribute('type', 'hidden'); 
  s.setAttribute('name', 'authenticity_token'); 
  s.setAttribute('value', token); 
  f.appendChild(s);
    
  /* Copy the checkboxes from the host form */
  $$("input[type=checkbox]").each(function(e) {
    if (e.checked)  {
      var c = document.createElement('input'); 
      c.setAttribute('type', 'hidden'); 
      c.setAttribute('name',  e.getAttribute('name')  ); 
      c.setAttribute('value', e.getAttribute('value') ); 
      f.appendChild(c);
    }
  })

  /* Look for hidden variables in checkbox form */
  $$("input[type=hidden]").each(function(e) {
    if ( e.getAttribute('name').indexOf("[]") != -1 )  {
      var c = document.createElement('input'); 
      c.setAttribute('type', 'hidden'); 
      c.setAttribute('name',  e.getAttribute('name')  ); 
      c.setAttribute('value', e.getAttribute('value') ); 
      f.appendChild(c);
    }
  })
  
  /* Copy the search field from the host form */
  $$("input#search").each(function (e) {
    var c = document.createElement('input');
    c.setAttribute('type', 'hidden'); 
    c.setAttribute('name',  e.getAttribute('name')  ); 
    c.setAttribute('value', e.value ); 
    f.appendChild(c);
  });

  /* Append to the main form body */
  document.body.appendChild(f);   
  f.submit();
  return false;
}
jQuery(document).on('click', 'a.submit_checkboxes', function(e) {
  e.preventDefault();
  return submit_checkboxes_to(jQuery(this).data('path'), jQuery(this).data('token'));
});

function reveal_tag_rename_field(i) {
  f = document.getElementById("tag_rename_field_" + i);
  f.style.display = "block";
  return true;
}

// Look for the other half of this in app/coffeescripts/forms.coffee
function enableSubmitButtons() {
  $$("form.formtastic input[type='submit']").each(function(elmt) { 
    elmt.removeClassName('disabled'); elmt.removeClassName('submitting'); 
  });
}
;
