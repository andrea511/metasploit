(function() {

  define(['jquery'], function($) {
    return this.Pro.module("Concerns", function(Concerns, App) {
      return Concerns.LazyListCollection = {
        ids: null,
        perPage: 20,
        currPage: 0,
        modelsLoaded: 0,
        _idsHash: null,
        loadMore: function(opts) {
          var data,
            _this = this;
          if (opts == null) {
            opts = {};
          }
          if (this.modelsLoaded >= this.ids.length) {
            return;
          }
          _.defaults(opts, {
            attemptsLeft: 5
          });
          data = {
            with_ids: this.ids.slice(this.itemOffset(), this.itemOffset() + this.perPage).join(',')
          };
          this.trigger('loadingMore');
          return $.getJSON(_.result(this, 'url'), data).done(function(results) {
            _this.currPage++;
            _this.modelsLoaded += _this.perPage;
            _this._updateModelsLoaded();
            _.each(results, function(hash) {
              return _this.add(new _this.model(hash));
            });
            return _this.trigger('fetched');
          }).error(function() {
            if (!(opts.attemptsLeft < 1)) {
              return _.delay((function() {
                return _this.loadMore({
                  attemptsLeft: opts.attemptsLeft - 1
                });
              }), 3000);
            }
          });
        },
        initializeLaziness: function(opts) {
          this.perPage = opts.perPage || this.perPage;
          this.currPage = opts.currPage || this.currPage;
          this.ids = opts.ids || this.ids;
          if (!this.laziness) {
            this.ids || (this.ids = []);
            this._idsHash = {};
            this.modelsLoaded = 0;
            return this.laziness = true;
          }
        },
        addIDs: function(ids) {
          var _this = this;
          return _.each(ids, function(id) {
            id = Math.floor(id);
            if (_this._idsHash[id] == null) {
              _this.ids.push(id);
              return _this._idsHash[id] = true;
            }
          });
        },
        itemOffset: function() {
          return this.models.length;
        },
        remove: function(model) {
          var id, idIdx;
          id = Math.floor(model.id);
          delete this._idsHash[id];
          idIdx = _.indexOf(this.ids, id);
          if (idIdx > -1) {
            this.ids.splice(idIdx, 1);
          }
          return this._updateModelsLoaded();
        },
        reset: function() {
          this.ids = [];
          this._idsHash = {};
          return this._updateModelsLoaded();
        },
        _updateModelsLoaded: function() {
          return this.modelsLoaded = _.min([this.modelsLoaded, this.ids.length]);
        }
      };
    });
  });

}).call(this);
