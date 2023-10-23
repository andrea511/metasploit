(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Payload = (function() {

    Payload.prototype.fullname = '';

    Payload.prototype.refname = '';

    Payload.prototype.type = 'payload';

    Payload.prototype.name = '';

    Payload.prototype.rank = 0;

    Payload.prototype.description = '';

    Payload.prototype.license = '';

    Payload.prototype.filepath = '';

    Payload.prototype.arch = [];

    Payload.prototype.platform = [];

    Payload.prototype.references = [];

    Payload.prototype.authors = [];

    Payload.prototype.privileged = false;

    Payload.prototype.stager = false;

    Payload.prototype.single = false;

    Payload.prototype.options = {};

    function Payload(opts) {
      this._isSingle = __bind(this._isSingle, this);

      this._isStager = __bind(this._isStager, this);

      this.toJSON = __bind(this.toJSON, this);
      DatastoreMixin.mixin(this);
      _.extend(this, opts);
      this.platform = _.map(this.platform, function(plat) {
        return _.last(plat.split('::'));
      });
      this.refname = this.fullname.replace(/^payload\//, '');
      this.stager = this._isStager();
      this.single = this._isSingle();
      if (this.stager) {
        this.stageName = this.fullname.split('/').slice(1, -1).join('/');
      }
    }

    Payload.prototype.toJSON = function() {
      return _.extend({}, this);
    };

    Payload.prototype._isStager = function() {
      return this.filepath.indexOf('/modules/payloads/stagers/') > -1;
    };

    Payload.prototype._isSingle = function() {
      return this.filepath.indexOf('/modules/payloads/singles/') > -1;
    };

    return Payload;

  })();

}).call(this);
