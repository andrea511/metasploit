(function() {

  jQueryInWindow(function($) {
    this.Poller = (function() {

      Poller.TIME_OUT = 8000;

      function Poller(collection) {
        this.collection = collection;
      }

      Poller.prototype.start = function() {
        var outerCollection, repoll,
          _this = this;
        outerCollection = this.collection;
        this.stopped = false;
        repoll = function(collection) {
          if (_this.stopped || _this.polling) {
            return;
          }
          _this.polling = true;
          return $.ajax({
            url: collection.url + '?t=' + Math.round((new Date()).getTime() / 1000),
            dataType: 'json',
            success: function(data) {
              var collectionChanged, toRemove;
              collectionChanged = false;
              toRemove = _.filter(collection.models, function(m) {
                return _.all(data, function(mm) {
                  return mm.id !== m.id;
                });
              });
              _.each(data, function(model) {
                var newModel, oldModel;
                oldModel = _.find(collection.models, function(m) {
                  return m.id === model.id;
                });
                if (oldModel) {
                  return oldModel.set(model);
                } else {
                  newModel = new CampaignSummary;
                  collection.unshift(newModel, {
                    silent: true
                  });
                  newModel.set(model);
                  return collectionChanged = true;
                }
              });
              collection.remove(toRemove);
              _this.polling = false;
              if (collectionChanged) {
                collection.trigger('change');
              }
              return _.delay((function() {
                return repoll.call(_this, collection);
              }), Poller.TIME_OUT);
            },
            error: function(e) {
              _this.polling = false;
              return _.delay((function() {
                return repoll.call(_this, collection);
              }), Poller.TIME_OUT);
            }
          });
        };
        return repoll(this.collection);
      };

      Poller.prototype.stop = function() {
        return this.stopped = true;
      };

      return Poller;

    })();
    return this.SingleModelPoller = (function() {

      function SingleModelPoller(model, url, TIME_OUT, cb) {
        this.model = model;
        this.url = url != null ? url : '';
        this.TIME_OUT = TIME_OUT != null ? TIME_OUT : 8000;
        this.cb = cb != null ? cb : function() {};
      }

      SingleModelPoller.prototype.start = function() {
        var outerModel, repoll,
          _this = this;
        outerModel = this.model;
        this.stopped = false;
        repoll = function(model) {
          if (_this.cb) {
            _this.cb.call(_this);
          }
          if (_this.stopped || _this.polling) {
            return;
          }
          _this.polling = true;
          return $.ajax({
            url: _this.url + '?t=' + Math.round((new Date()).getTime() / 1000),
            dataType: 'json',
            success: function(data) {
              outerModel.set(data);
              _this.polling = false;
              return _.delay((function() {
                return repoll.call(_this, model);
              }), _this.TIME_OUT);
            },
            error: function(e) {
              _this.polling = false;
              return _.delay((function() {
                return repoll.call(_this, model);
              }), _this.TIME_OUT);
            }
          });
        };
        return repoll(this.model);
      };

      SingleModelPoller.prototype.stop = function() {
        return this.stopped = true;
      };

      return SingleModelPoller;

    })();
  });

}).call(this);
