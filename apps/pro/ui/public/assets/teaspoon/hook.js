(function() {

  Teaspoon.hook = function(name, payload) {
    var xhr, xhrRequest;
    if (payload == null) {
      payload = {};
    }
    xhr = null;
    xhrRequest = function(url, payload, callback) {
      if (window.XMLHttpRequest) {
        xhr = new XMLHttpRequest();
      } else if (window.ActiveXObject) {
        try {
          xhr = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
          try {
            xhr = new ActiveXObject("Microsoft.XMLHTTP");
          } catch (e) {

          }
        }
      }
      if (!xhr) {
        throw "Unable to make Ajax Request";
      }
      xhr.onreadystatechange = callback;
      xhr.open("POST", "" + Teaspoon.root + "/" + url, false);
      xhr.setRequestHeader("Content-Type", "application/json");
      return xhr.send(JSON.stringify({
        args: payload
      }));
    };
    return xhrRequest("" + Teaspoon.suites.active + "/" + name, payload, function() {
      if (xhr.readyState !== 4) {
        return;
      }
      throw JSON.parse(xhr.response).err;
    });
  };

}).call(this);
