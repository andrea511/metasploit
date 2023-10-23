(function() {
  var $,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $ = jQuery;

  this.GeneratedPayload = (function(_super) {

    __extends(GeneratedPayload, _super);

    function GeneratedPayload() {
      this.isOutputRaw = __bind(this.isOutputRaw, this);

      this.isOutputBuffer = __bind(this.isOutputBuffer, this);

      this.isOutputExe = __bind(this.isOutputExe, this);

      this.findEncoder = __bind(this.findEncoder, this);

      this.findModule = __bind(this.findModule, this);

      this.onChange = __bind(this.onChange, this);

      this.initialize = __bind(this.initialize, this);
      return GeneratedPayload.__super__.constructor.apply(this, arguments);
    }

    GeneratedPayload.prototype.defaults = {
      platform: 'Windows',
      arch: 'x86',
      datastore: {},
      encoder: 'x86/shikata_ga_nai',
      iterations: 1,
      space: null,
      format: 'exe',
      keep: false,
      template: null,
      nops: null,
      badchars: null,
      payload: 'windows/meterpreter/reverse_tcp',
      encoder_options: {},
      payload_options: {},
      outputType: 'exe',
      useStager: true,
      useEncoder: true,
      stager: 'reverse_tcp',
      stage: 'windows/meterpreter',
      single: null
    };

    GeneratedPayload.prototype.initialize = function() {
      return this.on('change', this.onChange);
    };

    GeneratedPayload.prototype.onChange = function() {
      var newPayload;
      newPayload = this.findModule({
        cache: false
      });
      if (this.get('useStager') === 'true') {
        this.set({
          useStager: true
        });
      } else if (this.get('useStager') === 'false') {
        this.set({
          useStager: false
        });
      }
      if ((newPayload != null) && this.get('payload') !== newPayload.refname) {
        return this.set('payload', newPayload.refname);
      }
    };

    GeneratedPayload.prototype.findModule = function(opts) {
      var payload,
        _this = this;
      if (opts == null) {
        opts = {};
      }
      if ((opts != null ? opts.cache : void 0) == null) {
        opts.cache = true;
      }
      if ((this._payload != null) && opts.cache) {
        return this._payload;
      }
      payload = _.find(PayloadCache.payloads(this.attributes), function(p) {
        var stageMatch, stagerMatch;
        if (_this.get('useStager')) {
          stagerMatch = _.str.endsWith(p.refname, _this.get('stager'));
          stageMatch = _.str.include(p.fullname, _this.get('stage'));
          return p.stager && stagerMatch && stageMatch;
        } else {
          return p.single && p.refname === _this.get('single');
        }
      });
      if (!opts.cache) {
        this._payload = payload;
      }
      return payload;
    };

    GeneratedPayload.prototype.findEncoder = function(opts) {
      var encoder,
        _this = this;
      if (opts == null) {
        opts = {};
      }
      if ((opts != null ? opts.cache : void 0) == null) {
        opts.cache = true;
      }
      if (!this.get('useEncoder')) {
        return null;
      }
      if ((this._encoder != null) && opts.cache) {
        return this._encoder;
      }
      encoder = _.find(PayloadCache.encoders(this.attributes), function(p) {
        return p.refname === _this.get('encoder');
      });
      if (!opts.cache) {
        this._encoder = encoder;
      }
      return encoder;
    };

    GeneratedPayload.prototype.isOutputExe = function() {
      return this.get('outputType') === 'exe';
    };

    GeneratedPayload.prototype.isOutputBuffer = function() {
      return this.get('outputType') === 'buffer';
    };

    GeneratedPayload.prototype.isOutputRaw = function() {
      return this.get('outputType') === 'raw';
    };

    return GeneratedPayload;

  })(Backbone.Model);

}).call(this);
