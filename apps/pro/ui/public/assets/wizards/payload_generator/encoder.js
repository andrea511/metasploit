(function() {

  this.Encoder = (function() {

    Encoder.prototype.fullname = '';

    Encoder.prototype.refname = '';

    Encoder.prototype.options = {};

    Encoder.prototype.arch = [];

    Encoder.prototype.platform = [];

    Encoder.prototype.license = '';

    function Encoder(opts) {
      DatastoreMixin.mixin(this);
      _.extend(this, opts);
      this.platform = _.map(this.platform, function(plat) {
        return _.last(plat.split('::'));
      });
      this.refname = this.fullname.replace(/^encoder\//, '');
    }

    Encoder.prototype.toJSON = function() {
      return _.extend({}, this);
    };

    return Encoder;

  })();

}).call(this);
