(function() {
  var $, IGNORED_PLATFORMS;

  $ = jQuery;

  IGNORED_PLATFORMS = ['Platform'];

  this.PayloadCache = (function() {

    function PayloadCache() {}

    PayloadCache.PAYLOADS_URL = '/payloads.json';

    PayloadCache.ENCODERS_URL = '/payloads/encoders.json';

    PayloadCache.FORMATS_URL = '/payloads/formats.json';

    PayloadCache.useLocalStorage = false;

    PayloadCache.addPayloads = function(payloadsArray, opts) {
      if (opts == null) {
        opts = {};
      }
      if (_.isEmpty(payloadsArray)) {
        return;
      }
      _.each(payloadsArray, function(hash) {
        return PayloadCache._payloads.push(new Payload(hash));
      });
      if (opts.updateStorage) {
        return PayloadCache._updateLocalStorage();
      }
    };

    PayloadCache.addEncoders = function(encodersArray, opts) {
      if (opts == null) {
        opts = {};
      }
      if (_.isEmpty(encodersArray)) {
        return;
      }
      _.each(encodersArray, function(hash) {
        return PayloadCache._encoders.push(new Encoder(hash));
      });
      if (opts.updateStorage) {
        return PayloadCache._updateLocalStorage();
      }
    };

    PayloadCache.setFormats = function(formatsArray) {
      return PayloadCache._formats = formatsArray;
    };

    PayloadCache.payloads = function(opts) {
      if (opts == null) {
        opts = {};
      }
      return _.filter(PayloadCache._payloads, function(payload) {
        var m1, m2;
        m1 = !(opts.platform != null) || _.contains(payload.platform, opts.platform);
        m2 = !(opts.arch != null) || _.contains(payload.arch, opts.arch);
        return m1 && m2;
      });
    };

    PayloadCache.platforms = function() {
      return _.chain(PayloadCache._payloads).pluck('platform').flatten().uniq().map(function(p) {
        return _.last(p.split('::'));
      }).reject(function(p) {
        return _.contains(IGNORED_PLATFORMS, p);
      }).value();
    };

    PayloadCache.arches = function(opts) {
      var chain;
      if (opts == null) {
        opts = {};
      }
      chain = _.chain(PayloadCache._payloads);
      if (opts.platform != null) {
        chain = chain.filter(function(p) {
          return _.contains(p.platform, opts.platform);
        });
      }
      return chain.pluck('arch').flatten().uniq().value();
    };

    PayloadCache.stagers = function(opts) {
      if (opts == null) {
        opts = {};
      }
      return _.filter(PayloadCache.payloads(opts), function(p) {
        return p.stager;
      });
    };

    PayloadCache.singles = function(opts) {
      if (opts == null) {
        opts = {};
      }
      return _.filter(PayloadCache.payloads(opts), function(p) {
        return p.single;
      });
    };

    PayloadCache.stagerTypes = function(opts) {
      if (opts == null) {
        opts = {};
      }
      return _.chain(PayloadCache.stagers(opts)).map(function(p) {
        return _.last(p.fullname.split('/'));
      }).uniq().value();
    };

    PayloadCache.encoders = function(opts) {
      if (opts == null) {
        opts = {};
      }
      return _.filter(PayloadCache._encoders, function(encoder) {
        var _ref;
        if (encoder.fullname === 'encoder/generic/none' && !(opts.includeNoneEncoder != null)) {
          return false;
        }
        return !(opts.arch != null) || _.contains(encoder.arch, (_ref = opts.arch) != null ? _ref.toLowerCase() : void 0);
      });
    };

    PayloadCache.formats = function(opts) {
      if (opts == null) {
        opts = {};
      }
      if (opts != null ? opts.buffer : void 0) {
        return PayloadCache._formats.buffer;
      } else {
        return PayloadCache._formats.exe;
      }
    };

    PayloadCache.isEmpty = function() {
      return _.isEmpty(PayloadCache._payloads) && _.isEmpty(PayloadCache._encoders) && _.isEmpty(PayloadCache._formats);
    };

    PayloadCache.loadFromCache = function() {
      var data;
      if (!(PayloadCache.useLocalStorage || ((typeof localStorage !== "undefined" && localStorage !== null ? localStorage.PayloadCache : void 0) != null))) {
        return;
      }
      data = JSON.parse(localStorage.PayloadCache);
      PayloadCache.addPayloads(data.payloads);
      PayloadCache.addEncoders(data.encoders);
      return PayloadCache.setFormats(data.formats);
    };

    PayloadCache.loadFromAjax = function(complete) {
      if (complete == null) {
        complete = function() {};
      }
      return async.parallel([
        function(done) {
          return $.getJSON(PayloadCache.PAYLOADS_URL, function(json) {
            return done(null, json);
          });
        }, function(done) {
          return $.getJSON(PayloadCache.ENCODERS_URL, function(json) {
            return done(null, json);
          });
        }, function(done) {
          return $.getJSON(PayloadCache.FORMATS_URL, function(json) {
            return done(null, json);
          });
        }
      ], function(err, _arg) {
        var encoders, formats, payloads;
        payloads = _arg[0], encoders = _arg[1], formats = _arg[2];
        if (err) {
          return _.delay(PayloadCache.loadFromAjax, 3000, complete);
        }
        PayloadCache.addPayloads(payloads);
        PayloadCache.addEncoders(encoders);
        PayloadCache.setFormats(formats);
        return complete(PayloadCache.serialize());
      });
    };

    PayloadCache.load = function(complete) {
      PayloadCache._expireIfNecessary();
      if (!PayloadCache.isEmpty()) {
        return _.defer(function() {
          return complete(PayloadCache.serialize());
        });
      }
      PayloadCache.loadFromCache();
      if (PayloadCache.isEmpty()) {
        return PayloadCache.loadFromAjax(complete);
      } else {
        return _.defer(function() {
          return complete(PayloadCache.serialize());
        });
      }
    };

    PayloadCache.reset = function(opts) {
      if (opts == null) {
        opts = {};
      }
      PayloadCache._payloads = [];
      PayloadCache._encoders = [];
      PayloadCache._formats = [];
      if (!opts.preserveLocalStorage) {
        return delete localStorage.PayloadCache;
      }
    };

    PayloadCache.serialize = function() {
      return {
        payloads: PayloadCache._payloads,
        encoders: PayloadCache._encoders,
        formats: PayloadCache._formats,
        version: PayloadCache._version()
      };
    };

    PayloadCache._encoders = [];

    PayloadCache._payloads = [];

    PayloadCache._expireIfNecessary = function() {
      var savedVersion;
      if (localStorage.PayloadCache == null) {
        return;
      }
      savedVersion = localStorage.PayloadCache.match(/"version":"([^"]+)"/);
      if (!((savedVersion != null) && PayloadCache._version() === savedVersion[1])) {
        return PayloadCache.reset();
      }
    };

    PayloadCache._version = function() {
      var latestVersion;
      return latestVersion = jQuery('#footer .version').html().trim();
    };

    PayloadCache._updateLocalStorage = function() {
      if (!PayloadCache.useLocalStorage) {
        return;
      }
      return localStorage.PayloadCache = JSON.stringify(PayloadCache.serialize());
    };

    return PayloadCache;

  }).call(this);

}).call(this);
