(function() {
  var __slice = [].slice;

  Teaspoon.Fixture = (function() {
    var addContent, cleanup, create, jQueryAvailable, load, loadComplete, preload, putContent, set, xhr, xhrRequest,
      _this = this;

    Fixture.cache = {};

    Fixture.el = null;

    Fixture.$el = null;

    Fixture.json = [];

    Fixture.preload = function() {
      var url, urls, _i, _len, _results;
      urls = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _results = [];
      for (_i = 0, _len = urls.length; _i < _len; _i++) {
        url = urls[_i];
        _results.push(preload(url));
      }
      return _results;
    };

    Fixture.load = function() {
      var append, index, url, urls, _i, _j, _len, _results;
      urls = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), append = arguments[_i++];
      if (append == null) {
        append = false;
      }
      if (typeof append !== "boolean") {
        urls.push(append);
        append = false;
      }
      _results = [];
      for (index = _j = 0, _len = urls.length; _j < _len; index = ++_j) {
        url = urls[index];
        _results.push(load(url, append || index > 0));
      }
      return _results;
    };

    Fixture.set = function() {
      var append, html, htmls, index, _i, _j, _len, _results;
      htmls = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), append = arguments[_i++];
      if (append == null) {
        append = false;
      }
      if (typeof append !== "boolean") {
        htmls.push(append);
        append = false;
      }
      _results = [];
      for (index = _j = 0, _len = htmls.length; _j < _len; index = ++_j) {
        html = htmls[index];
        _results.push(set(html, append || index > 0));
      }
      return _results;
    };

    Fixture.cleanup = function() {
      return cleanup();
    };

    function Fixture() {
      window.fixture.load.apply(window, arguments);
    }

    xhr = null;

    preload = function(url) {
      return load(url, false, true);
    };

    load = function(url, append, preload) {
      var cached, value;
      if (preload == null) {
        preload = false;
      }
      if (cached = window.fixture.cache[url]) {
        return loadComplete(url, cached.type, cached.content, append, preload);
      }
      value = null;
      xhrRequest(url, function() {
        if (xhr.readyState !== 4) {
          return;
        }
        if (xhr.status !== 200) {
          throw "Unable to load fixture \"" + url + "\".";
        }
        return value = loadComplete(url, xhr.getResponseHeader("content-type"), xhr.responseText, append, preload);
      });
      return value;
    };

    loadComplete = function(url, type, content, append, preload) {
      window.fixture.cache[url] = {
        type: type,
        content: content
      };
      if (type.match(/application\/json;/)) {
        return Fixture.json[Fixture.json.push(JSON.parse(content)) - 1];
      }
      if (preload) {
        return content;
      }
      if (append) {
        addContent(content);
      } else {
        putContent(content);
      }
      return window.fixture.el;
    };

    set = function(content, append) {
      if (append) {
        return addContent(content);
      } else {
        return putContent(content);
      }
    };

    putContent = function(content) {
      cleanup();
      return addContent(content);
    };

    addContent = function(content) {
      var i, parsed, _i, _ref, _results;
      if (!window.fixture.el) {
        create();
      }
      if (jQueryAvailable()) {
        parsed = jQuery(jQuery.parseHTML(content, document, true));
        _results = [];
        for (i = _i = 0, _ref = parsed.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(window.fixture.el.appendChild(parsed[i]));
        }
        return _results;
      } else {
        return window.fixture.el.innerHTML += content;
      }
    };

    create = function() {
      var _ref;
      window.fixture.el = document.createElement("div");
      if (jQueryAvailable()) {
        window.fixture.$el = jQuery(window.fixture.el);
      }
      window.fixture.el.id = "teaspoon-fixtures";
      return (_ref = document.body) != null ? _ref.appendChild(window.fixture.el) : void 0;
    };

    cleanup = function() {
      var _base, _ref, _ref1;
      (_base = window.fixture).el || (_base.el = document.getElementById("teaspoon-fixtures"));
      if ((_ref = window.fixture.el) != null) {
        if ((_ref1 = _ref.parentNode) != null) {
          _ref1.removeChild(window.fixture.el);
        }
      }
      return window.fixture.el = null;
    };

    xhrRequest = function(url, callback) {
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
      xhr.open("GET", "" + Teaspoon.root + "/fixtures/" + url, false);
      return xhr.send();
    };

    jQueryAvailable = function() {
      return typeof window.jQuery === 'function';
    };

    return Fixture;

  }).call(this);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Jasmine1.Fixture = (function(_super) {

    __extends(Fixture, _super);

    function Fixture() {
      return Fixture.__super__.constructor.apply(this, arguments);
    }

    Fixture.load = function() {
      var args,
        _this = this;
      args = arguments;
      if (!(this.env().currentSuite || this.env().currentSpec)) {
        throw "Teaspoon can't load fixtures outside of describe.";
      }
      if (this.env().currentSuite) {
        this.env().beforeEach(function() {
          return fixture.__super__.constructor.load.apply(_this, args);
        });
        this.env().afterEach(function() {
          return _this.cleanup();
        });
        return Fixture.__super__.constructor.load.apply(this, arguments);
      } else {
        this.env().currentSpec.after(function() {
          return _this.cleanup();
        });
        return Fixture.__super__.constructor.load.apply(this, arguments);
      }
    };

    Fixture.set = function() {
      var args,
        _this = this;
      args = arguments;
      if (!(this.env().currentSuite || this.env().currentSpec)) {
        throw "Teaspoon can't load fixtures outside of describe.";
      }
      if (this.env().currentSuite) {
        this.env().beforeEach(function() {
          return fixture.__super__.constructor.set.apply(_this, args);
        });
        this.env().afterEach(function() {
          return _this.cleanup();
        });
        return Fixture.__super__.constructor.set.apply(this, arguments);
      } else {
        this.env().currentSpec.after(function() {
          return _this.cleanup();
        });
        return Fixture.__super__.constructor.set.apply(this, arguments);
      }
    };

    Fixture.env = function() {
      return window.jasmine.getEnv();
    };

    return Fixture;

  })(Teaspoon.Fixture);

}).call(this);
