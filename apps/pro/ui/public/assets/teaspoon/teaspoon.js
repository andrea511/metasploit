(function() {

  this.Teaspoon = (function() {

    function Teaspoon() {}

    Teaspoon.defer = false;

    Teaspoon.slow = 75;

    Teaspoon.root = window.location.pathname.replace(/\/+(index\.html)?$/, "").replace(/\/[^\/]*$/, "");

    Teaspoon.started = false;

    Teaspoon.finished = false;

    Teaspoon.Reporters = {};

    Teaspoon.Date = Date;

    Teaspoon.location = window.location;

    Teaspoon.messages = [];

    Teaspoon.execute = function() {
      if (!Teaspoon.framework) {
        throw "No framework registered. Expected a framework to register itself, but nothing has.";
      }
      if (Teaspoon.defer) {
        Teaspoon.defer = false;
        return;
      }
      if (Teaspoon.started) {
        Teaspoon.reload();
      }
      Teaspoon.started = true;
      return new (Teaspoon.resolveClass("Runner"))();
    };

    Teaspoon.setupErrorHandler = function() {
      var originalOnError;
      originalOnError = window.onerror;
      return window.onerror = function(message) {
        if (originalOnError && originalOnError.call) {
          originalOnError.apply(null, arguments);
        }
        if (Teaspoon.started) {
          return;
        }
        return Teaspoon.messages.push(JSON.stringify({
          _teaspoon: true,
          type: "exception",
          message: message
        }));
      };
    };

    Teaspoon.reload = function() {
      return window.location.reload();
    };

    Teaspoon.onWindowLoad = function(method) {
      var originalOnload;
      originalOnload = window.onload;
      return window.onload = function() {
        if (originalOnload && originalOnload.call) {
          originalOnload();
        }
        return method();
      };
    };

    Teaspoon.resolveDependenciesFromParams = function(all) {
      var dep, deps, file, parts, path, paths, _i, _j, _len, _len1;
      if (all == null) {
        all = [];
      }
      deps = [];
      if ((paths = Teaspoon.location.search.match(/[\?&]file(\[\])?=[^&\?]*/gi)) === null) {
        return all;
      }
      for (_i = 0, _len = paths.length; _i < _len; _i++) {
        path = paths[_i];
        parts = decodeURIComponent(path.replace(/\+/g, " ")).match(/\/(.+)\.(js|js.coffee|coffee)$/i);
        if (parts === null) {
          continue;
        }
        file = parts[1].substr(parts[1].lastIndexOf("/") + 1);
        for (_j = 0, _len1 = all.length; _j < _len1; _j++) {
          dep = all[_j];
          if (dep.indexOf(file) >= 0) {
            deps.push(dep);
          }
        }
      }
      return deps;
    };

    Teaspoon.log = function() {
      Teaspoon.messages.push(arguments[0]);
      try {
        return typeof console !== "undefined" && console !== null ? typeof console.log === "function" ? console.log.apply(console, arguments) : void 0 : void 0;
      } catch (e) {
        throw new Error("Unable to use console.log for logging");
      }
    };

    Teaspoon.getMessages = function() {
      var messages;
      messages = Teaspoon.messages;
      Teaspoon.messages = [];
      return messages;
    };

    Teaspoon.setFramework = function(namespace) {
      Teaspoon.framework = namespace;
      return window.fixture = Teaspoon.resolveClass("Fixture");
    };

    Teaspoon.resolveClass = function(klass) {
      var framework_override, teaspoon_core;
      if (framework_override = Teaspoon.checkNamespace(Teaspoon.framework, klass)) {
        return framework_override;
      } else if (teaspoon_core = Teaspoon.checkNamespace(Teaspoon, klass)) {
        return teaspoon_core;
      }
      throw "Could not find the class you're looking for: " + klass;
    };

    Teaspoon.checkNamespace = function(root, klass) {
      var i, namespace, namespaces, scope, _i, _len;
      namespaces = klass.split(".");
      scope = root;
      for (i = _i = 0, _len = namespaces.length; _i < _len; i = ++_i) {
        namespace = namespaces[i];
        if (!(scope = scope[namespace])) {
          return false;
        }
      }
      return scope;
    };

    return Teaspoon;

  })();

  Teaspoon.setupErrorHandler();

}).call(this);
(function() {

  Teaspoon.Mixins || (Teaspoon.Mixins = {});

}).call(this);
(function() {

  Teaspoon.Mixins.FilterUrl = {
    filterUrl: function(grep) {
      var params;
      params = [];
      params.push("grep=" + (encodeURIComponent(grep)));
      if (Teaspoon.params.file) {
        params.push("file=" + Teaspoon.params.file);
      }
      return "?" + (params.join("&"));
    }
  };

}).call(this);
(function() {

  Teaspoon.Utility = (function() {

    function Utility() {}

    Utility.extend = function(obj, mixin) {
      var method, name;
      for (name in mixin) {
        method = mixin[name];
        obj[name] = method;
      }
      return obj;
    };

    Utility.include = function(klass, mixin) {
      return this.extend(klass.prototype, mixin);
    };

    return Utility;

  })();

}).call(this);
(function() {

  Teaspoon.Runner = (function() {

    Runner.run = false;

    function Runner() {
      if (this.constructor.run) {
        return;
      }
      this.constructor.run = true;
      this.fixturePath = "" + Teaspoon.root + "/fixtures";
      this.params = Teaspoon.params = this.getParams();
      this.setup();
    }

    Runner.prototype.getParams = function() {
      var name, param, params, value, _i, _len, _ref, _ref1;
      params = {};
      _ref = Teaspoon.location.search.substring(1).split("&");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        param = _ref[_i];
        _ref1 = param.split("="), name = _ref1[0], value = _ref1[1];
        params[decodeURIComponent(name)] = decodeURIComponent(value);
      }
      return params;
    };

    Runner.prototype.getReporter = function() {
      if (this.params["reporter"]) {
        return this.findReporter(this.params["reporter"]);
      } else {
        if (window.navigator.userAgent.match(/PhantomJS/)) {
          return this.findReporter("Console");
        } else {
          return this.findReporter("HTML");
        }
      }
    };

    Runner.prototype.setup = function() {};

    Runner.prototype.findReporter = function(type) {
      return Teaspoon.resolveClass("Reporters." + type);
    };

    return Runner;

  })();

}).call(this);
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
(function() {

  Teaspoon.Spec = (function() {

    function Spec() {}

    Teaspoon.Utility.include(Spec, Teaspoon.Mixins.FilterUrl);

    return Spec;

  })();

}).call(this);
(function() {

  Teaspoon.Suite = (function() {

    function Suite() {}

    Teaspoon.Utility.include(Suite, Teaspoon.Mixins.FilterUrl);

    return Suite;

  })();

}).call(this);
(function() {

  Teaspoon.Reporters.BaseView = (function() {

    function BaseView() {
      this.elements = {};
      this.build();
    }

    BaseView.prototype.build = function(className) {
      return this.el = this.createEl("li", className);
    };

    BaseView.prototype.appendTo = function(el) {
      return el.appendChild(this.el);
    };

    BaseView.prototype.append = function(el) {
      return this.el.appendChild(el);
    };

    BaseView.prototype.createEl = function(type, className) {
      var el;
      if (className == null) {
        className = "";
      }
      el = document.createElement(type);
      el.className = className;
      return el;
    };

    BaseView.prototype.findEl = function(id) {
      var _base;
      this.elements || (this.elements = {});
      return (_base = this.elements)[id] || (_base[id] = document.getElementById("teaspoon-" + id));
    };

    BaseView.prototype.setText = function(id, value) {
      var el;
      el = this.findEl(id);
      return el.innerHTML = value;
    };

    BaseView.prototype.setHtml = function(id, value, add) {
      var el;
      if (add == null) {
        add = false;
      }
      el = this.findEl(id);
      if (add) {
        return el.innerHTML += value;
      } else {
        return el.innerHTML = value;
      }
    };

    BaseView.prototype.setClass = function(id, value) {
      var el;
      el = this.findEl(id);
      return el.className = value;
    };

    BaseView.prototype.htmlSafe = function(str) {
      var el;
      el = document.createElement("div");
      el.appendChild(document.createTextNode(str));
      return el.innerHTML;
    };

    return BaseView;

  })();

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Reporters.HTML = (function(_super) {

    __extends(HTML, _super);

    function HTML() {
      this.changeSuite = __bind(this.changeSuite, this);

      this.toggleConfig = __bind(this.toggleConfig, this);

      this.reportRunnerResults = __bind(this.reportRunnerResults, this);
      this.start = new Teaspoon.Date().getTime();
      this.config = {
        "use-catch": true,
        "build-full-report": false,
        "display-progress": true
      };
      this.total = {
        exist: 0,
        run: 0,
        passes: 0,
        failures: 0,
        skipped: 0
      };
      this.views = {
        specs: {},
        suites: {}
      };
      this.filters = [];
      this.setFilters();
      this.readConfig();
      HTML.__super__.constructor.apply(this, arguments);
    }

    HTML.prototype.build = function() {
      var _ref;
      this.buildLayout();
      this.setText("env-info", this.envInfo());
      this.setText("version", Teaspoon.version);
      this.findEl("toggles").onclick = this.toggleConfig;
      this.findEl("suites").innerHTML = this.buildSuiteSelect();
      if ((_ref = this.findEl("suite-select")) != null) {
        _ref.onchange = this.changeSuite;
      }
      this.el = this.findEl("report-all");
      this.showConfiguration();
      this.buildProgress();
      return this.buildFilters();
    };

    HTML.prototype.reportRunnerStarting = function(runner) {
      this.total.exist = runner.total || 0;
      if (this.total.exist) {
        return this.setText("stats-duration", "...");
      }
    };

    HTML.prototype.reportRunnerResults = function() {
      if (!this.total.run) {
        return;
      }
      this.setText("stats-duration", this.elapsedTime());
      if (!this.total.failures) {
        this.setStatus("passed");
      }
      this.setText("stats-passes", this.total.passes);
      this.setText("stats-failures", this.total.failures);
      if (this.total.run < this.total.exist) {
        this.total.skipped = this.total.exist - this.total.run + this.total.skipped;
        this.total.run = this.total.exist;
      }
      this.setText("stats-skipped", this.total.skipped);
      return this.updateProgress();
    };

    HTML.prototype.reportSuiteStarting = function(suite) {};

    HTML.prototype.reportSuiteResults = function(suite) {};

    HTML.prototype.reportSpecStarting = function(spec) {
      if (this.config["build-full-report"]) {
        this.reportView = new (Teaspoon.resolveClass("Reporters.HTML.SpecView"))(spec, this);
      }
      return this.specStart = new Teaspoon.Date().getTime();
    };

    HTML.prototype.reportSpecResults = function(spec) {
      this.total.run += 1;
      this.updateProgress();
      this.updateStatus(spec);
      return delete this.reportView;
    };

    HTML.prototype.buildLayout = function() {
      var el;
      el = this.createEl("div");
      el.id = "teaspoon-interface";
      el.innerHTML = (Teaspoon.resolveClass("Reporters.HTML")).template();
      return document.body.appendChild(el);
    };

    HTML.prototype.buildSuiteSelect = function() {
      var filename, options, path, selected, suite, _i, _len, _ref;
      if (Teaspoon.suites.all.length === 1) {
        return "";
      }
      filename = "";
      if (/index\.html$/.test(window.location.pathname)) {
        filename = "/index.html";
      }
      options = [];
      _ref = Teaspoon.suites.all;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        suite = _ref[_i];
        path = [Teaspoon.root, suite].join("/");
        selected = Teaspoon.suites.active === suite ? " selected" : "";
        options.push("<option" + selected + " value=\"" + path + filename + "\">" + suite + "</option>");
      }
      return "<select id=\"teaspoon-suite-select\">" + (options.join("")) + "</select>";
    };

    HTML.prototype.buildProgress = function() {
      this.progress = Teaspoon.Reporters.HTML.ProgressView.create(this.config["display-progress"]);
      return this.progress.appendTo(this.findEl("progress"));
    };

    HTML.prototype.buildFilters = function() {
      if (this.filters.length) {
        this.setClass("filter", "teaspoon-filtered");
      }
      return this.setHtml("filter-list", "<li>" + (this.filters.join("</li><li>")), true);
    };

    HTML.prototype.elapsedTime = function() {
      return "" + (((new Teaspoon.Date().getTime() - this.start) / 1000).toFixed(3)) + "s";
    };

    HTML.prototype.updateStat = function(name, value) {
      if (!this.config["display-progress"]) {
        return;
      }
      return this.setText("stats-" + name, value);
    };

    HTML.prototype.updateStatus = function(spec) {
      var elapsed, result, _ref;
      elapsed = new Teaspoon.Date().getTime() - this.specStart;
      if ((_ref = this.reportView) != null) {
        _ref.updateState(spec, elapsed);
      }
      result = spec.result();
      if (result.status === "pending") {
        return this.updateStat("skipped", this.total.skipped += 1);
      } else if (result.status === "failed") {
        this.updateStat("failures", this.total.failures += 1);
        if (!this.config["build-full-report"]) {
          new (Teaspoon.resolveClass("Reporters.HTML.FailureView"))(spec).appendTo(this.findEl("report-failures"));
        }
        return this.setStatus("failed");
      } else if (result.skipped) {
        return this.updateStat("skipped", this.total.skipped += 1);
      } else {
        return this.updateStat("passes", this.total.passes += 1);
      }
    };

    HTML.prototype.updateProgress = function() {
      return this.progress.update(this.total.exist, this.total.run);
    };

    HTML.prototype.showConfiguration = function() {
      var key, value, _ref, _results;
      _ref = this.config;
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        _results.push(this.setClass(key, value ? "active" : ""));
      }
      return _results;
    };

    HTML.prototype.setStatus = function(status) {
      return document.body.className = "teaspoon-" + status;
    };

    HTML.prototype.setFilters = function() {
      if (Teaspoon.params["file"]) {
        this.filters.push("by file: " + Teaspoon.params["file"]);
      }
      if (Teaspoon.params["grep"]) {
        return this.filters.push("by match: " + Teaspoon.params["grep"]);
      }
    };

    HTML.prototype.readConfig = function() {
      var config;
      if (config = this.store("teaspoon")) {
        return this.config = config;
      }
    };

    HTML.prototype.toggleConfig = function(e) {
      var button, name;
      button = e.target;
      if (button.tagName.toLowerCase() !== "button") {
        return;
      }
      name = button.getAttribute("id").replace(/^teaspoon-/, "");
      this.config[name] = !this.config[name];
      this.store("teaspoon", this.config);
      return Teaspoon.reload();
    };

    HTML.prototype.changeSuite = function(e) {
      var options;
      options = e.target.options;
      return window.location.href = options[options.selectedIndex].value;
    };

    HTML.prototype.store = function(name, value) {
      var _ref;
      if (((_ref = window.localStorage) != null ? _ref.setItem : void 0) != null) {
        return this.localstore(name, value);
      } else {
        return this.cookie(name, value);
      }
    };

    HTML.prototype.cookie = function(name, value) {
      var date, match;
      if (value == null) {
        value = void 0;
      }
      if (value === void 0) {
        name = name.replace(/([.*+?^=!:${}()|[\]\/\\])/g, "\\$1");
        match = document.cookie.match(new RegExp("(?:^|;)\\s?" + name + "=(.*?)(?:;|$)", "i"));
        return match && JSON.parse(unescape(match[1]).split(" ")[0]);
      } else {
        date = new Teaspoon.Date();
        date.setDate(date.getDate() + 365);
        return document.cookie = "" + name + "=" + (escape(JSON.stringify(value))) + "; expires=" + (date.toUTCString()) + "; path=/;";
      }
    };

    HTML.prototype.localstore = function(name, value) {
      if (value == null) {
        value = void 0;
      }
      if (value === void 0) {
        return JSON.parse(unescape(localStorage.getItem(name)));
      } else {
        return localStorage.setItem(name, escape(JSON.stringify(value)));
      }
    };

    return HTML;

  })(Teaspoon.Reporters.BaseView);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Reporters.HTML.FailureView = (function(_super) {

    __extends(FailureView, _super);

    function FailureView(spec) {
      this.spec = spec;
      FailureView.__super__.constructor.apply(this, arguments);
    }

    FailureView.prototype.build = function() {
      var error, html, _i, _len, _ref;
      FailureView.__super__.build.call(this, "spec");
      html = "<h1 class=\"teaspoon-clearfix\"><a href=\"" + this.spec.link + "\">" + (this.htmlSafe(this.spec.fullDescription)) + "</a></h1>";
      _ref = this.spec.errors();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        error = _ref[_i];
        html += "<div><strong>" + (this.htmlSafe(error.message)) + "</strong><br/>" + (this.htmlSafe(error.stack || "Stack trace unavailable")) + "</div>";
      }
      return this.el.innerHTML = html;
    };

    return FailureView;

  })(Teaspoon.Reporters.BaseView);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Reporters.HTML.ProgressView = (function(_super) {

    __extends(ProgressView, _super);

    function ProgressView() {
      return ProgressView.__super__.constructor.apply(this, arguments);
    }

    ProgressView.create = function(displayProgress) {
      if (displayProgress == null) {
        displayProgress = true;
      }
      if (!displayProgress) {
        return new Teaspoon.Reporters.HTML.ProgressView();
      }
      if (Teaspoon.Reporters.HTML.RadialProgressView.supported) {
        return new Teaspoon.Reporters.HTML.RadialProgressView();
      } else {
        return new Teaspoon.Reporters.HTML.SimpleProgressView();
      }
    };

    ProgressView.prototype.build = function() {
      return this.el = this.createEl("div", "teaspoon-indicator teaspoon-logo");
    };

    ProgressView.prototype.update = function() {};

    return ProgressView;

  })(Teaspoon.Reporters.BaseView);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Reporters.HTML.RadialProgressView = (function(_super) {

    __extends(RadialProgressView, _super);

    function RadialProgressView() {
      return RadialProgressView.__super__.constructor.apply(this, arguments);
    }

    RadialProgressView.supported = !!document.createElement("canvas").getContext;

    RadialProgressView.prototype.build = function() {
      this.el = this.createEl("div", "teaspoon-indicator radial-progress");
      return this.el.innerHTML = "<canvas id=\"teaspoon-progress-canvas\"></canvas>\n<em id=\"teaspoon-progress-percent\">0%</em>";
    };

    RadialProgressView.prototype.appendTo = function() {
      var canvas;
      RadialProgressView.__super__.appendTo.apply(this, arguments);
      this.size = 80;
      try {
        canvas = this.findEl("progress-canvas");
        canvas.width = canvas.height = canvas.style.width = canvas.style.height = this.size;
        this.ctx = canvas.getContext("2d");
        this.ctx.strokeStyle = "#fff";
        return this.ctx.lineWidth = 1.5;
      } catch (e) {

      }
    };

    RadialProgressView.prototype.update = function(total, run) {
      var half, percent;
      percent = total ? Math.ceil((run * 100) / total) : 0;
      this.setHtml("progress-percent", "" + percent + "%");
      if (!this.ctx) {
        return;
      }
      half = this.size / 2;
      this.ctx.clearRect(0, 0, this.size, this.size);
      this.ctx.beginPath();
      this.ctx.arc(half, half, half - 1, 0, Math.PI * 2 * (percent / 100), false);
      return this.ctx.stroke();
    };

    return RadialProgressView;

  })(Teaspoon.Reporters.HTML.ProgressView);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Reporters.HTML.SimpleProgressView = (function(_super) {

    __extends(SimpleProgressView, _super);

    function SimpleProgressView() {
      return SimpleProgressView.__super__.constructor.apply(this, arguments);
    }

    SimpleProgressView.prototype.build = function() {
      this.el = this.createEl("div", "simple-progress");
      return this.el.innerHTML = "<em id=\"teaspoon-progress-percent\">0%</em>\n<span id=\"teaspoon-progress-span\" class=\"teaspoon-indicator\"></span>";
    };

    SimpleProgressView.prototype.update = function(total, run) {
      var percent;
      percent = total ? Math.ceil((run * 100) / total) : 0;
      return this.setHtml("progress-percent", "" + percent + "%");
    };

    return SimpleProgressView;

  })(Teaspoon.Reporters.HTML.ProgressView);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Reporters.HTML.SpecView = (function(_super) {
    var viewId;

    __extends(SpecView, _super);

    viewId = 0;

    function SpecView(spec, reporter) {
      this.spec = spec;
      this.reporter = reporter;
      this.views = this.reporter.views;
      this.spec.viewId = viewId += 1;
      this.views.specs[this.spec.viewId] = this;
      SpecView.__super__.constructor.apply(this, arguments);
    }

    SpecView.prototype.build = function() {
      var classes;
      classes = ["spec"];
      if (this.spec.pending) {
        classes.push("state-pending");
      }
      SpecView.__super__.build.call(this, classes.join(" "));
      this.el.innerHTML = "<a href=\"" + this.spec.link + "\">" + (this.htmlSafe(this.spec.description)) + "</a>";
      this.parentView = this.buildParent();
      return this.parentView.append(this.el);
    };

    SpecView.prototype.buildParent = function() {
      var parent, view;
      parent = this.spec.parent;
      if (!parent) {
        return this.reporter;
      }
      if (parent.viewId) {
        return this.views.suites[parent.viewId];
      } else {
        view = new (Teaspoon.resolveClass("Reporters.HTML.SuiteView"))(parent, this.reporter);
        return this.views.suites[view.suite.viewId] = view;
      }
    };

    SpecView.prototype.buildErrors = function() {
      var div, error, html, _i, _len, _ref;
      div = this.createEl("div");
      html = "";
      _ref = this.spec.errors();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        error = _ref[_i];
        html += "<strong>" + (this.htmlSafe(error.message)) + "</strong><br/>" + (this.htmlSafe(error.stack || "Stack trace unavailable"));
      }
      div.innerHTML = html;
      return this.append(div);
    };

    SpecView.prototype.updateState = function(spec, elapsed) {
      var result;
      result = spec.result();
      this.clearClasses();
      if (result.status === "pending") {
        return this.updatePending(spec, elapsed);
      } else if (result.status === "failed") {
        return this.updateFailed(spec, elapsed);
      } else if (result.skipped) {
        return this.updateDisabled(spec, elapsed);
      } else {
        return this.updatePassed(spec, elapsed);
      }
    };

    SpecView.prototype.updatePassed = function(spec, elapsed) {
      this.addStatusClass("passed");
      if (elapsed > Teaspoon.slow) {
        this.addClass("slow");
      }
      return this.el.innerHTML += "<span>" + elapsed + "ms</span>";
    };

    SpecView.prototype.updateFailed = function(spec, elapsed) {
      var _base;
      this.addStatusClass("failed");
      this.buildErrors();
      return typeof (_base = this.parentView).updateState === "function" ? _base.updateState("failed") : void 0;
    };

    SpecView.prototype.updatePending = function(spec, elapsed) {
      return this.addStatusClass("pending");
    };

    SpecView.prototype.updateDisabled = function(spec, elapsed) {};

    SpecView.prototype.clearClasses = function() {
      return this.el.className = "";
    };

    SpecView.prototype.addStatusClass = function(status) {
      return this.addClass("state-" + status);
    };

    SpecView.prototype.addClass = function(name) {
      return this.el.className += " " + name;
    };

    return SpecView;

  })(Teaspoon.Reporters.BaseView);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Reporters.HTML.SuiteView = (function(_super) {
    var viewId;

    __extends(SuiteView, _super);

    viewId = 0;

    function SuiteView(suite, reporter) {
      this.suite = suite;
      this.reporter = reporter;
      this.views = this.reporter.views;
      this.suite.viewId = viewId += 1;
      this.views.suites[this.suite.viewId] = this;
      this.suite = new (Teaspoon.resolveClass("Suite"))(this.suite);
      SuiteView.__super__.constructor.apply(this, arguments);
    }

    SuiteView.prototype.build = function() {
      SuiteView.__super__.build.call(this, "suite");
      this.el.innerHTML = "<h1><a href=\"" + this.suite.link + "\">" + (this.htmlSafe(this.suite.description)) + "</a></h1>";
      this.parentView = this.buildParent();
      return this.parentView.append(this.el);
    };

    SuiteView.prototype.buildParent = function() {
      var parent, view;
      parent = this.suite.parent;
      if (!parent) {
        return this.reporter;
      }
      if (parent.viewId) {
        return this.views.suites[parent.viewId];
      } else {
        view = new (Teaspoon.resolveClass("Reporters.HTML.SuiteView"))(parent, this.reporter);
        return this.views.suites[view.suite.viewId] = view;
      }
    };

    SuiteView.prototype.append = function(el) {
      if (!this.ol) {
        SuiteView.__super__.append.call(this, this.ol = this.createEl("ol"));
      }
      return this.ol.appendChild(el);
    };

    SuiteView.prototype.updateState = function(state) {
      var _base;
      if (this.state === "failed") {
        return;
      }
      this.el.className = "" + (this.el.className.replace(/\s?state-\w+/, "")) + " state-" + state;
      if (typeof (_base = this.parentView).updateState === "function") {
        _base.updateState(state);
      }
      return this.state = state;
    };

    return SuiteView;

  })(Teaspoon.Reporters.BaseView);

}).call(this);
(function() {

  Teaspoon.Reporters.HTML.template = function() {
    return "<div class=\"teaspoon-clearfix\">\n  <div id=\"teaspoon-title\">\n    <h1><a href=\"" + Teaspoon.root + "\" id=\"teaspoon-root-link\">Teaspoon</a></h1>\n    <ul>\n      <li>version: <b id=\"teaspoon-version\"></b></li>\n      <li id=\"teaspoon-env-info\"></li>\n    </ul>\n  </div>\n  <div id=\"teaspoon-progress\"></div>\n  <ul id=\"teaspoon-stats\">\n    <li>passes: <b id=\"teaspoon-stats-passes\">0</b></li>\n    <li>failures: <b id=\"teaspoon-stats-failures\">0</b></li>\n    <li>skipped: <b id=\"teaspoon-stats-skipped\">0</b></li>\n    <li>duration: <b id=\"teaspoon-stats-duration\">&infin;</b></li>\n  </ul>\n</div>\n\n<div id=\"teaspoon-controls\" class=\"teaspoon-clearfix\">\n  <div id=\"teaspoon-toggles\">\n    <button id=\"teaspoon-use-catch\" title=\"Toggle using try/catch wrappers when possible\">Try/Catch</button>\n    <button id=\"teaspoon-build-full-report\" title=\"Toggle building the full report\">Full Report</button>\n    <button id=\"teaspoon-display-progress\" title=\"Toggle displaying progress as tests run\">Progress</button>\n  </div>\n  <div id=\"teaspoon-suites\"></div>\n</div>\n\n<hr/>\n\n<div id=\"teaspoon-filter\">\n  <h1>Applied Filters [<a href=\"" + window.location.pathname + "\" id=\"teaspoon-filter-clear\">remove</a>]</h1>\n  <ul id=\"teaspoon-filter-list\"></ul>\n</div>\n\n<div id=\"teaspoon-report\">\n  <ol id=\"teaspoon-report-failures\"></ol>\n  <ol id=\"teaspoon-report-all\"></ol>\n</div>";
  };

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Teaspoon.Reporters.Console = (function() {

    function Console() {
      this.reportRunnerResults = __bind(this.reportRunnerResults, this);
      this.start = new Teaspoon.Date();
      this.suites = {};
    }

    Console.prototype.reportRunnerStarting = function(runner) {
      return this.log({
        type: "runner",
        total: runner.total || (typeof runner.specs === "function" ? runner.specs().length : void 0) || 0,
        start: JSON.parse(JSON.stringify(this.start))
      });
    };

    Console.prototype.reportRunnerResults = function() {
      this.log({
        type: "result",
        elapsed: ((new Teaspoon.Date().getTime() - this.start.getTime()) / 1000).toFixed(5),
        coverage: window.__coverage__
      });
      return Teaspoon.finished = true;
    };

    Console.prototype.reportSuiteStarting = function(suite) {};

    Console.prototype.reportSuiteResults = function(suite) {};

    Console.prototype.reportSpecStarting = function(spec) {};

    Console.prototype.reportSuites = function() {
      var index, suite, _i, _len, _ref, _results;
      _ref = this.spec.getParents();
      _results = [];
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        suite = _ref[index];
        if (this.suites[suite.fullDescription]) {
          continue;
        }
        this.suites[suite.fullDescription] = true;
        _results.push(this.log({
          type: "suite",
          label: suite.description,
          level: index
        }));
      }
      return _results;
    };

    Console.prototype.reportSpecResults = function(spec) {
      var result;
      this.spec = spec;
      result = this.spec.result();
      if (result.status === "pending") {
        return this.trackPending(this.spec);
      } else if (result.status === "failed") {
        return this.trackFailed(this.spec);
      } else if (result.skipped) {
        return this.trackDisabled(this.spec);
      } else {
        return this.trackPassed(this.spec);
      }
    };

    Console.prototype.trackPending = function(spec) {
      var result;
      this.reportSuites();
      result = spec.result();
      return this.log({
        type: "spec",
        suite: spec.suiteName,
        label: spec.description,
        status: result.status,
        skipped: result.skipped
      });
    };

    Console.prototype.trackFailed = function(spec) {
      var error, result, _i, _len, _ref, _results;
      this.reportSuites();
      result = spec.result();
      _ref = spec.errors();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        error = _ref[_i];
        _results.push(this.log({
          type: "spec",
          suite: spec.suiteName,
          label: spec.description,
          status: result.status,
          skipped: result.skipped,
          link: spec.fullDescription,
          message: error.message,
          trace: error.stack || error.message || "Stack Trace Unavailable"
        }));
      }
      return _results;
    };

    Console.prototype.trackDisabled = function(spec) {};

    Console.prototype.trackPassed = function(spec, result) {
      this.reportSuites();
      result = spec.result();
      return this.log({
        type: "spec",
        suite: spec.suiteName,
        label: spec.description,
        status: result.status,
        skipped: result.skipped
      });
    };

    Console.prototype.log = function(obj) {
      if (obj == null) {
        obj = {};
      }
      obj["_teaspoon"] = true;
      return Teaspoon.log(JSON.stringify(obj));
    };

    return Console;

  })();

}).call(this);
