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
