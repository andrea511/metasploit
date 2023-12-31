// Variables
var console_id;
var console_history = new Array();  // Commands history
var console_hindex  = 0;            // Index to current command history
var console_input;                  // Object to console input
var console_output;                 // Object to console output
var console_replace;                // Object to console output
var console_prompt;                 // Object to console prompt
var console_status;
var console_cmdbar;
var console_window;
var console_spinner;
var console_type;
var console_busy;
var console_dead = false;
var console_token = "invalid";

// Placeholders
var con_prompt  = "";
var con_update  = "";
var con_append  = "";
var con_tabbed  = "";
var con_last_event = "0";

// Internal commands
var cmd_internal =
{
  help:function() {
    console_printline("     Web Console Internal Commands\n");
    console_printline("=========================================\n\n");
    console_printline(" /help       Show this text\n");
    console_printline(" /clear      Clear the screen\n");
    console_printline(" /detach     Detach an active session\n");
    console_printline(" /kill       Abort an active session\n");
    console_printline("\n");
  },
  clear:function() {
    console_output.innerHTML = '';
  },
  detach:function() {
    console_printline(">> Detaching from any active session...\n");
    new Ajax.Updater("console_update", document.location.toString(), {
      asynchronous:true,
      evalScripts:true,
      parameters:"special=detach" + '&authenticity_token=' + escape(console_token),
      method:'post',
    });
  },
  kill:function() {
    console_printline(">> Killing any active session...\n");
    new Ajax.Updater("console_update", document.location.toString(), {
      asynchronous:true,
      evalScripts:true,
      parameters:"special=kill" + '&authenticity_token=' + escape(console_token),
      method:'post',
    });
  }
};

function status_busy() {
  console_input.style.color = "red";
  console_spinner.style.visibility = 'visible';
  console_prompt.style.color = "#555555";
  console_busy = true;
}

function status_free() {
  console_input.style.color = "white";
  console_spinner.style.visibility = 'hidden';
  console_prompt.style.color = "yellow";
  console_busy = false;
}

function console_shutdown() {
  if(! console_dead) {
    console_dead = true;
    console_input.value    = " * * * SESSION HAS DISCONNECTED * * * "
    console_input.disabled = true;
    console_prompt.style.color = "red";
    if (window === top) alert("Session Disconnected");
  }
}

function keystroke_block(e) {
  e.cancelBubble=true;
  e.returnValue = false;
  if (window.event && !window.opera) e.keyCode=0;
  if (e.stopPropagation) e.stopPropagation();
  if (e.preventDefault)  e.preventDefault();
  return false;
}

function console_refocus() {
    console_input.blur();
    console_input.focus();
}

function console_read() {
  if(console_dead) return;
  new Ajax.Updater("console_update", document.location.toString(), {
    asynchronous:true,
    evalScripts:true,
    parameters:"read=yes" + '&authenticity_token=' + escape(console_token) + '&last_event=' + escape(con_last_event),
    onComplete:console_read_output,
    method:'post',
  });
}

function console_printline(s, type) {
    if ((s=String(s))) {
        var n = document.createElement("pre");

    if (! type)
      type = 'output_line';

    // IE has to use innerText
    if (n.innerText != undefined) {
      n.innerText = s;
    // Firefox uses createTextNode
    } else {
          n.appendChild(document.createTextNode(s));
    }

        n.className = type;
        console_output.appendChild(n);

    // console_window.scrollTop = 0;
    console_window.scrollTop = console_window.scrollHeight;

        return n;
    }
}

function console_read_output(req) {
  // Call the console updated
  console_update_output(req);

  // Reschedule the console reader
  setTimeout(console_read, 500);
}

function console_update_output(req) {

  try { eval(req.responseText); } catch(e){
    //console_printline(">> An error occurred in the console reader: " + e + "\n");
    //window.scrollTo(0, 10000000);

    // Shut down the console on error (almost always caused by a dead session)
    console_shutdown();
  }

  if (con_append.length > 0) {

    // cmd_internal['clear']();
    for (var i = 0; i < con_append.length; i++) {
      console_printline( unescape(con_append[i][1]), con_append[i][0]);
    }
    status_free();
  } else {
    if (con_update.length > 0) {
      console_printline(con_update, 'output_line');
      status_free();
    }
  }

  console_prompt.innerHTML = con_prompt;
}

function console_update_tabs(req) {
  try { eval(req.responseText); } catch(e){
    console_printline(">> An error occurred during tab completion: " + e + "\n");
    //window.scrollTo(0, 10000000);
  }

  if (con_update.length > 0) {
    console_printline(con_update, 'output_line');
    status_free();
  }

  console_prompt.innerHTML = con_prompt;
  console_input.value = con_tabbed;

  console_refocus();
}

function console_keypress(e) {
  if (e.keyCode == 13) {          // enter

    console_input.value = (console_input.value.replace(/^ +/,'')).replace(/ +$/,'');

    // ignore duplicate commands in the history
    if(console_history[console_history.length-1] != console_input.value) {
      console_history.push(console_input.value);
      console_hindex = console_history.length - 1;
    }

    // Only print the input if this is a non-shell session
    if (console_type != "shell") {
      console_printline("\n" + console_input.value + "\n\n", 'input_line');
    }

    if(console_input.value[0] == '/') {
      cmd_name = console_input.value.substring(1);

      if(cmd_internal[cmd_name]) {
        cmd_internal[cmd_name]();
        console_input.value = "";
        console_input.focus();
        return keystroke_block(e);
      }
    }

    status_busy();

    new Ajax.Updater("console_update", document.location.toString(), {
      asynchronous:true,
      evalScripts:true,
      parameters:"read=yes&cmd=" + escape(console_input.value) + '&authenticity_token=' + escape(console_token) + '&last_event=' + escape(con_last_event),
      onComplete:console_update_output,
      method:'post',
    });

    console_input.value = "";
    console_input.focus();
    return keystroke_block(e);
  }

}


function console_keydown(e) {

    if (e.keyCode == 38) {   // up

    // do nothing if no history
    if (console_hindex >= console_history.length || console_hindex<0)
      return keystroke_block(e);

    // TODO: place upper cmd in history on console_input.value
    console_input.value = console_history[console_hindex];
    if (console_hindex > 0) {
      console_hindex--;
    }

    return keystroke_block(e);

    } else if (e.keyCode == 40) {   // down

    if (console_hindex >= console_history.length || console_hindex<0)
      return keystroke_block(e);

    if (console_hindex < console_history.length - 1) {
      console_hindex++;
    }
    console_input.value = console_history[console_hindex];

    return keystroke_block(e);

    } else if (e.keyCode == 9) {   // tab

    status_busy();

    new Ajax.Updater("console_update", document.location.toString(), {
      asynchronous:true,
      evalScripts:true,
      parameters:"read=yes&tab=" + escape(console_input.value) + '&authenticity_token=' + escape(console_token) + '&last_event=' + escape(con_last_event),
      onComplete:console_update_tabs,
      method:'post',
    });
    return keystroke_block(e);
    } else if (e.keyCode == 33) { // pg up

      var cwd = console_window.scrollTop;
      cwd -= 200;

      if (cwd < 0) cwd = 0;

      console_window.scrollTop = cwd;
      return keystroke_block(e);
    } else if (e.keyCode == 34) { // pg dwn

      var cwd = console_window.scrollTop;
      cwd += 200;

      if (cwd > console_window.scrollHeight) cwd = console_window.scrollHeight;

      console_window.scrollTop = cwd;
      return keystroke_block(e);
    }
}

function console_init() {
  jQuery = top.jQuery
  jQuery('body', document).ready(function() {
    console_id      = jQuery('meta[name="msp:session_id"]', document).attr('content');
    console_type    = jQuery('meta[name="msp:session_type"]', document).attr('content');
    console_input   = document.getElementById("console_input");
    console_output  = document.getElementById("console_output");
    console_prompt  = document.getElementById("console_prompt");
    console_status  = document.getElementById("console_status");
    console_cmdbar  = document.getElementById("console_command_bar");
    console_window  = document.getElementById("console_window");
    console_spinner = document.getElementById("console_spinner");
    console_token   = jQuery('meta[name="csrf-token"]', document).attr('content');
    web_console_id  = jQuery('meta[name="msp:console_id"]', document).attr('content');
    console_refocus();
    status_free();
    console_read();
    console_bind_iframe(web_console_id);

    jQuery(console_input).on('keydown', console_keydown);
    jQuery(console_input).on('keypress', console_keypress);
  });
}


function console_bind_iframe(web_console_id) {
  if (parent !== window) {
    // add some keyboard shortcuts if rendered in an iframe
    var $ = top.jQuery;
    $('body', document).addClass('embed');
    $(document).bind('keydown', function(e) {
      // ESCAPE or CTRL-~
      if (e.keyCode == 27 || (e.keyCode == 192 & e.ctrlKey)) {
        top.toggleConsole();
      }
    });
    // throw a close button in there.
    $close = $('<a />', { id: 'console_close' }).html('&times;');
    $close.appendTo($('#console_command_bar_inner', document));
    $close.bind('click', top.toggleConsole);
    // pass up the console's ID to the parent, so we can save as a cookie
    $(top.document).triggerHandler('consoleLoad', {id: web_console_id});
  }
}

console_init();
