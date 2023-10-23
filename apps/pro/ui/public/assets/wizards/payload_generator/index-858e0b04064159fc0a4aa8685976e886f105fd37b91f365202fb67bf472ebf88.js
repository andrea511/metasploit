(function() {
  var DATASTORE_DEFAULT_OVERRIDES, DEFAULT_SKIPPED_DATASTORE_OPTIONS;

  DEFAULT_SKIPPED_DATASTORE_OPTIONS = ['WORKSPACE', 'VERBOSE'];

  DATASTORE_DEFAULT_OVERRIDES = {
    LHOST: '0.0.0.0'
  };

  this.DatastoreMixin = {
    mixin: function(instance) {
      return _.extend(instance, _.omit(DatastoreMixin, 'mixin'));
    },
    skippedDatastoreOptions: DEFAULT_SKIPPED_DATASTORE_OPTIONS,
    showAdvancedOptions: false,
    filteredOptions: function(clause) {
      var opts;
      _.each(this.options, function(v, k) {
        return v.name = k;
      });
      opts = _.chain(this.options).omit(this.skippedDatastoreOptions);
      if (clause != null) {
        opts = opts.where(clause);
      }
      return opts.value();
    }
  };

}).call(this);
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
/*global setImmediate: false, setTimeout: false, console: false */

(function () {

    var async = {};

    // global on the server, window in the browser
    var root, previous_async;

    root = this;
    if (root != null) {
      previous_async = root.async;
    }

    async.noConflict = function () {
        root.async = previous_async;
        return async;
    };

    function only_once(fn) {
        var called = false;
        return function() {
            if (called) throw new Error("Callback was already called.");
            called = true;
            fn.apply(root, arguments);
        }
    }

    //// cross-browser compatiblity functions ////

    var _each = function (arr, iterator) {
        if (arr.forEach) {
            return arr.forEach(iterator);
        }
        for (var i = 0; i < arr.length; i += 1) {
            iterator(arr[i], i, arr);
        }
    };

    var _map = function (arr, iterator) {
        if (arr.map) {
            return arr.map(iterator);
        }
        var results = [];
        _each(arr, function (x, i, a) {
            results.push(iterator(x, i, a));
        });
        return results;
    };

    var _reduce = function (arr, iterator, memo) {
        if (arr.reduce) {
            return arr.reduce(iterator, memo);
        }
        _each(arr, function (x, i, a) {
            memo = iterator(memo, x, i, a);
        });
        return memo;
    };

    var _keys = function (obj) {
        if (Object.keys) {
            return Object.keys(obj);
        }
        var keys = [];
        for (var k in obj) {
            if (obj.hasOwnProperty(k)) {
                keys.push(k);
            }
        }
        return keys;
    };

    //// exported async module functions ////

    //// nextTick implementation with browser-compatible fallback ////
    if (typeof process === 'undefined' || !(process.nextTick)) {
        if (typeof setImmediate === 'function') {
            async.nextTick = function (fn) {
                // not a direct alias for IE10 compatibility
                setImmediate(fn);
            };
            async.setImmediate = async.nextTick;
        }
        else {
            async.nextTick = function (fn) {
                setTimeout(fn, 0);
            };
            async.setImmediate = async.nextTick;
        }
    }
    else {
        async.nextTick = process.nextTick;
        if (typeof setImmediate !== 'undefined') {
            async.setImmediate = function (fn) {
              // not a direct alias for IE10 compatibility
              setImmediate(fn);
            };
        }
        else {
            async.setImmediate = async.nextTick;
        }
    }

    async.each = function (arr, iterator, callback) {
        callback = callback || function () {};
        if (!arr.length) {
            return callback();
        }
        var completed = 0;
        _each(arr, function (x) {
            iterator(x, only_once(function (err) {
                if (err) {
                    callback(err);
                    callback = function () {};
                }
                else {
                    completed += 1;
                    if (completed >= arr.length) {
                        callback(null);
                    }
                }
            }));
        });
    };
    async.forEach = async.each;

    async.eachSeries = function (arr, iterator, callback) {
        callback = callback || function () {};
        if (!arr.length) {
            return callback();
        }
        var completed = 0;
        var iterate = function () {
            iterator(arr[completed], function (err) {
                if (err) {
                    callback(err);
                    callback = function () {};
                }
                else {
                    completed += 1;
                    if (completed >= arr.length) {
                        callback(null);
                    }
                    else {
                        iterate();
                    }
                }
            });
        };
        iterate();
    };
    async.forEachSeries = async.eachSeries;

    async.eachLimit = function (arr, limit, iterator, callback) {
        var fn = _eachLimit(limit);
        fn.apply(null, [arr, iterator, callback]);
    };
    async.forEachLimit = async.eachLimit;

    var _eachLimit = function (limit) {

        return function (arr, iterator, callback) {
            callback = callback || function () {};
            if (!arr.length || limit <= 0) {
                return callback();
            }
            var completed = 0;
            var started = 0;
            var running = 0;

            (function replenish () {
                if (completed >= arr.length) {
                    return callback();
                }

                while (running < limit && started < arr.length) {
                    started += 1;
                    running += 1;
                    iterator(arr[started - 1], function (err) {
                        if (err) {
                            callback(err);
                            callback = function () {};
                        }
                        else {
                            completed += 1;
                            running -= 1;
                            if (completed >= arr.length) {
                                callback();
                            }
                            else {
                                replenish();
                            }
                        }
                    });
                }
            })();
        };
    };


    var doParallel = function (fn) {
        return function () {
            var args = Array.prototype.slice.call(arguments);
            return fn.apply(null, [async.each].concat(args));
        };
    };
    var doParallelLimit = function(limit, fn) {
        return function () {
            var args = Array.prototype.slice.call(arguments);
            return fn.apply(null, [_eachLimit(limit)].concat(args));
        };
    };
    var doSeries = function (fn) {
        return function () {
            var args = Array.prototype.slice.call(arguments);
            return fn.apply(null, [async.eachSeries].concat(args));
        };
    };


    var _asyncMap = function (eachfn, arr, iterator, callback) {
        var results = [];
        arr = _map(arr, function (x, i) {
            return {index: i, value: x};
        });
        eachfn(arr, function (x, callback) {
            iterator(x.value, function (err, v) {
                results[x.index] = v;
                callback(err);
            });
        }, function (err) {
            callback(err, results);
        });
    };
    async.map = doParallel(_asyncMap);
    async.mapSeries = doSeries(_asyncMap);
    async.mapLimit = function (arr, limit, iterator, callback) {
        return _mapLimit(limit)(arr, iterator, callback);
    };

    var _mapLimit = function(limit) {
        return doParallelLimit(limit, _asyncMap);
    };

    // reduce only has a series version, as doing reduce in parallel won't
    // work in many situations.
    async.reduce = function (arr, memo, iterator, callback) {
        async.eachSeries(arr, function (x, callback) {
            iterator(memo, x, function (err, v) {
                memo = v;
                callback(err);
            });
        }, function (err) {
            callback(err, memo);
        });
    };
    // inject alias
    async.inject = async.reduce;
    // foldl alias
    async.foldl = async.reduce;

    async.reduceRight = function (arr, memo, iterator, callback) {
        var reversed = _map(arr, function (x) {
            return x;
        }).reverse();
        async.reduce(reversed, memo, iterator, callback);
    };
    // foldr alias
    async.foldr = async.reduceRight;

    var _filter = function (eachfn, arr, iterator, callback) {
        var results = [];
        arr = _map(arr, function (x, i) {
            return {index: i, value: x};
        });
        eachfn(arr, function (x, callback) {
            iterator(x.value, function (v) {
                if (v) {
                    results.push(x);
                }
                callback();
            });
        }, function (err) {
            callback(_map(results.sort(function (a, b) {
                return a.index - b.index;
            }), function (x) {
                return x.value;
            }));
        });
    };
    async.filter = doParallel(_filter);
    async.filterSeries = doSeries(_filter);
    // select alias
    async.select = async.filter;
    async.selectSeries = async.filterSeries;

    var _reject = function (eachfn, arr, iterator, callback) {
        var results = [];
        arr = _map(arr, function (x, i) {
            return {index: i, value: x};
        });
        eachfn(arr, function (x, callback) {
            iterator(x.value, function (v) {
                if (!v) {
                    results.push(x);
                }
                callback();
            });
        }, function (err) {
            callback(_map(results.sort(function (a, b) {
                return a.index - b.index;
            }), function (x) {
                return x.value;
            }));
        });
    };
    async.reject = doParallel(_reject);
    async.rejectSeries = doSeries(_reject);

    var _detect = function (eachfn, arr, iterator, main_callback) {
        eachfn(arr, function (x, callback) {
            iterator(x, function (result) {
                if (result) {
                    main_callback(x);
                    main_callback = function () {};
                }
                else {
                    callback();
                }
            });
        }, function (err) {
            main_callback();
        });
    };
    async.detect = doParallel(_detect);
    async.detectSeries = doSeries(_detect);

    async.some = function (arr, iterator, main_callback) {
        async.each(arr, function (x, callback) {
            iterator(x, function (v) {
                if (v) {
                    main_callback(true);
                    main_callback = function () {};
                }
                callback();
            });
        }, function (err) {
            main_callback(false);
        });
    };
    // any alias
    async.any = async.some;

    async.every = function (arr, iterator, main_callback) {
        async.each(arr, function (x, callback) {
            iterator(x, function (v) {
                if (!v) {
                    main_callback(false);
                    main_callback = function () {};
                }
                callback();
            });
        }, function (err) {
            main_callback(true);
        });
    };
    // all alias
    async.all = async.every;

    async.sortBy = function (arr, iterator, callback) {
        async.map(arr, function (x, callback) {
            iterator(x, function (err, criteria) {
                if (err) {
                    callback(err);
                }
                else {
                    callback(null, {value: x, criteria: criteria});
                }
            });
        }, function (err, results) {
            if (err) {
                return callback(err);
            }
            else {
                var fn = function (left, right) {
                    var a = left.criteria, b = right.criteria;
                    return a < b ? -1 : a > b ? 1 : 0;
                };
                callback(null, _map(results.sort(fn), function (x) {
                    return x.value;
                }));
            }
        });
    };

    async.auto = function (tasks, callback) {
        callback = callback || function () {};
        var keys = _keys(tasks);
        if (!keys.length) {
            return callback(null);
        }

        var results = {};

        var listeners = [];
        var addListener = function (fn) {
            listeners.unshift(fn);
        };
        var removeListener = function (fn) {
            for (var i = 0; i < listeners.length; i += 1) {
                if (listeners[i] === fn) {
                    listeners.splice(i, 1);
                    return;
                }
            }
        };
        var taskComplete = function () {
            _each(listeners.slice(0), function (fn) {
                fn();
            });
        };

        addListener(function () {
            if (_keys(results).length === keys.length) {
                callback(null, results);
                callback = function () {};
            }
        });

        _each(keys, function (k) {
            var task = (tasks[k] instanceof Function) ? [tasks[k]]: tasks[k];
            var taskCallback = function (err) {
                var args = Array.prototype.slice.call(arguments, 1);
                if (args.length <= 1) {
                    args = args[0];
                }
                if (err) {
                    var safeResults = {};
                    _each(_keys(results), function(rkey) {
                        safeResults[rkey] = results[rkey];
                    });
                    safeResults[k] = args;
                    callback(err, safeResults);
                    // stop subsequent errors hitting callback multiple times
                    callback = function () {};
                }
                else {
                    results[k] = args;
                    async.setImmediate(taskComplete);
                }
            };
            var requires = task.slice(0, Math.abs(task.length - 1)) || [];
            var ready = function () {
                return _reduce(requires, function (a, x) {
                    return (a && results.hasOwnProperty(x));
                }, true) && !results.hasOwnProperty(k);
            };
            if (ready()) {
                task[task.length - 1](taskCallback, results);
            }
            else {
                var listener = function () {
                    if (ready()) {
                        removeListener(listener);
                        task[task.length - 1](taskCallback, results);
                    }
                };
                addListener(listener);
            }
        });
    };

    async.waterfall = function (tasks, callback) {
        callback = callback || function () {};
        if (tasks.constructor !== Array) {
          var err = new Error('First argument to waterfall must be an array of functions');
          return callback(err);
        }
        if (!tasks.length) {
            return callback();
        }
        var wrapIterator = function (iterator) {
            return function (err) {
                if (err) {
                    callback.apply(null, arguments);
                    callback = function () {};
                }
                else {
                    var args = Array.prototype.slice.call(arguments, 1);
                    var next = iterator.next();
                    if (next) {
                        args.push(wrapIterator(next));
                    }
                    else {
                        args.push(callback);
                    }
                    async.setImmediate(function () {
                        iterator.apply(null, args);
                    });
                }
            };
        };
        wrapIterator(async.iterator(tasks))();
    };

    var _parallel = function(eachfn, tasks, callback) {
        callback = callback || function () {};
        if (tasks.constructor === Array) {
            eachfn.map(tasks, function (fn, callback) {
                if (fn) {
                    fn(function (err) {
                        var args = Array.prototype.slice.call(arguments, 1);
                        if (args.length <= 1) {
                            args = args[0];
                        }
                        callback.call(null, err, args);
                    });
                }
            }, callback);
        }
        else {
            var results = {};
            eachfn.each(_keys(tasks), function (k, callback) {
                tasks[k](function (err) {
                    var args = Array.prototype.slice.call(arguments, 1);
                    if (args.length <= 1) {
                        args = args[0];
                    }
                    results[k] = args;
                    callback(err);
                });
            }, function (err) {
                callback(err, results);
            });
        }
    };

    async.parallel = function (tasks, callback) {
        _parallel({ map: async.map, each: async.each }, tasks, callback);
    };

    async.parallelLimit = function(tasks, limit, callback) {
        _parallel({ map: _mapLimit(limit), each: _eachLimit(limit) }, tasks, callback);
    };

    async.series = function (tasks, callback) {
        callback = callback || function () {};
        if (tasks.constructor === Array) {
            async.mapSeries(tasks, function (fn, callback) {
                if (fn) {
                    fn(function (err) {
                        var args = Array.prototype.slice.call(arguments, 1);
                        if (args.length <= 1) {
                            args = args[0];
                        }
                        callback.call(null, err, args);
                    });
                }
            }, callback);
        }
        else {
            var results = {};
            async.eachSeries(_keys(tasks), function (k, callback) {
                tasks[k](function (err) {
                    var args = Array.prototype.slice.call(arguments, 1);
                    if (args.length <= 1) {
                        args = args[0];
                    }
                    results[k] = args;
                    callback(err);
                });
            }, function (err) {
                callback(err, results);
            });
        }
    };

    async.iterator = function (tasks) {
        var makeCallback = function (index) {
            var fn = function () {
                if (tasks.length) {
                    tasks[index].apply(null, arguments);
                }
                return fn.next();
            };
            fn.next = function () {
                return (index < tasks.length - 1) ? makeCallback(index + 1): null;
            };
            return fn;
        };
        return makeCallback(0);
    };

    async.apply = function (fn) {
        var args = Array.prototype.slice.call(arguments, 1);
        return function () {
            return fn.apply(
                null, args.concat(Array.prototype.slice.call(arguments))
            );
        };
    };

    var _concat = function (eachfn, arr, fn, callback) {
        var r = [];
        eachfn(arr, function (x, cb) {
            fn(x, function (err, y) {
                r = r.concat(y || []);
                cb(err);
            });
        }, function (err) {
            callback(err, r);
        });
    };
    async.concat = doParallel(_concat);
    async.concatSeries = doSeries(_concat);

    async.whilst = function (test, iterator, callback) {
        if (test()) {
            iterator(function (err) {
                if (err) {
                    return callback(err);
                }
                async.whilst(test, iterator, callback);
            });
        }
        else {
            callback();
        }
    };

    async.doWhilst = function (iterator, test, callback) {
        iterator(function (err) {
            if (err) {
                return callback(err);
            }
            if (test()) {
                async.doWhilst(iterator, test, callback);
            }
            else {
                callback();
            }
        });
    };

    async.until = function (test, iterator, callback) {
        if (!test()) {
            iterator(function (err) {
                if (err) {
                    return callback(err);
                }
                async.until(test, iterator, callback);
            });
        }
        else {
            callback();
        }
    };

    async.doUntil = function (iterator, test, callback) {
        iterator(function (err) {
            if (err) {
                return callback(err);
            }
            if (!test()) {
                async.doUntil(iterator, test, callback);
            }
            else {
                callback();
            }
        });
    };

    async.queue = function (worker, concurrency) {
        if (concurrency === undefined) {
            concurrency = 1;
        }
        function _insert(q, data, pos, callback) {
          if(data.constructor !== Array) {
              data = [data];
          }
          _each(data, function(task) {
              var item = {
                  data: task,
                  callback: typeof callback === 'function' ? callback : null
              };

              if (pos) {
                q.tasks.unshift(item);
              } else {
                q.tasks.push(item);
              }

              if (q.saturated && q.tasks.length === concurrency) {
                  q.saturated();
              }
              async.setImmediate(q.process);
          });
        }

        var workers = 0;
        var q = {
            tasks: [],
            concurrency: concurrency,
            saturated: null,
            empty: null,
            drain: null,
            push: function (data, callback) {
              _insert(q, data, false, callback);
            },
            unshift: function (data, callback) {
              _insert(q, data, true, callback);
            },
            process: function () {
                if (workers < q.concurrency && q.tasks.length) {
                    var task = q.tasks.shift();
                    if (q.empty && q.tasks.length === 0) {
                        q.empty();
                    }
                    workers += 1;
                    var next = function () {
                        workers -= 1;
                        if (task.callback) {
                            task.callback.apply(task, arguments);
                        }
                        if (q.drain && q.tasks.length + workers === 0) {
                            q.drain();
                        }
                        q.process();
                    };
                    var cb = only_once(next);
                    worker(task.data, cb);
                }
            },
            length: function () {
                return q.tasks.length;
            },
            running: function () {
                return workers;
            }
        };
        return q;
    };

    async.cargo = function (worker, payload) {
        var working     = false,
            tasks       = [];

        var cargo = {
            tasks: tasks,
            payload: payload,
            saturated: null,
            empty: null,
            drain: null,
            push: function (data, callback) {
                if(data.constructor !== Array) {
                    data = [data];
                }
                _each(data, function(task) {
                    tasks.push({
                        data: task,
                        callback: typeof callback === 'function' ? callback : null
                    });
                    if (cargo.saturated && tasks.length === payload) {
                        cargo.saturated();
                    }
                });
                async.setImmediate(cargo.process);
            },
            process: function process() {
                if (working) return;
                if (tasks.length === 0) {
                    if(cargo.drain) cargo.drain();
                    return;
                }

                var ts = typeof payload === 'number'
                            ? tasks.splice(0, payload)
                            : tasks.splice(0);

                var ds = _map(ts, function (task) {
                    return task.data;
                });

                if(cargo.empty) cargo.empty();
                working = true;
                worker(ds, function () {
                    working = false;

                    var args = arguments;
                    _each(ts, function (data) {
                        if (data.callback) {
                            data.callback.apply(null, args);
                        }
                    });

                    process();
                });
            },
            length: function () {
                return tasks.length;
            },
            running: function () {
                return working;
            }
        };
        return cargo;
    };

    var _console_fn = function (name) {
        return function (fn) {
            var args = Array.prototype.slice.call(arguments, 1);
            fn.apply(null, args.concat([function (err) {
                var args = Array.prototype.slice.call(arguments, 1);
                if (typeof console !== 'undefined') {
                    if (err) {
                        if (console.error) {
                            console.error(err);
                        }
                    }
                    else if (console[name]) {
                        _each(args, function (x) {
                            console[name](x);
                        });
                    }
                }
            }]));
        };
    };
    async.log = _console_fn('log');
    async.dir = _console_fn('dir');
    /*async.info = _console_fn('info');
    async.warn = _console_fn('warn');
    async.error = _console_fn('error');*/

    async.memoize = function (fn, hasher) {
        var memo = {};
        var queues = {};
        hasher = hasher || function (x) {
            return x;
        };
        var memoized = function () {
            var args = Array.prototype.slice.call(arguments);
            var callback = args.pop();
            var key = hasher.apply(null, args);
            if (key in memo) {
                callback.apply(null, memo[key]);
            }
            else if (key in queues) {
                queues[key].push(callback);
            }
            else {
                queues[key] = [callback];
                fn.apply(null, args.concat([function () {
                    memo[key] = arguments;
                    var q = queues[key];
                    delete queues[key];
                    for (var i = 0, l = q.length; i < l; i++) {
                      q[i].apply(null, arguments);
                    }
                }]));
            }
        };
        memoized.memo = memo;
        memoized.unmemoized = fn;
        return memoized;
    };

    async.unmemoize = function (fn) {
      return function () {
        return (fn.unmemoized || fn).apply(null, arguments);
      };
    };

    async.times = function (count, iterator, callback) {
        var counter = [];
        for (var i = 0; i < count; i++) {
            counter.push(i);
        }
        return async.map(counter, iterator, callback);
    };

    async.timesSeries = function (count, iterator, callback) {
        var counter = [];
        for (var i = 0; i < count; i++) {
            counter.push(i);
        }
        return async.mapSeries(counter, iterator, callback);
    };

    async.compose = function (/* functions... */) {
        var fns = Array.prototype.reverse.call(arguments);
        return function () {
            var that = this;
            var args = Array.prototype.slice.call(arguments);
            var callback = args.pop();
            async.reduce(fns, args, function (newargs, fn, cb) {
                fn.apply(that, newargs.concat([function () {
                    var err = arguments[0];
                    var nextargs = Array.prototype.slice.call(arguments, 1);
                    cb(err, nextargs);
                }]))
            },
            function (err, results) {
                callback.apply(that, [err].concat(results));
            });
        };
    };

    var _applyEach = function (eachfn, fns /*args...*/) {
        var go = function () {
            var that = this;
            var args = Array.prototype.slice.call(arguments);
            var callback = args.pop();
            return eachfn(fns, function (fn, cb) {
                fn.apply(that, args.concat([cb]));
            },
            callback);
        };
        if (arguments.length > 2) {
            var args = Array.prototype.slice.call(arguments, 2);
            return go.apply(this, args);
        }
        else {
            return go;
        }
    };
    async.applyEach = doParallel(_applyEach);
    async.applyEachSeries = doSeries(_applyEach);

    async.forever = function (fn, callback) {
        function next(err) {
            if (err) {
                if (callback) {
                    return callback(err);
                }
                throw err;
            }
            fn(next);
        }
        next();
    };

    root.async = async;

}());
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
(function() {
  var $;

  $ = jQuery;

  $.fn.ByteEntry = function() {
    var BACKSPACE_KEY, PASSTHRU_KEYS, fixFormatting, lastKey, onChange;
    BACKSPACE_KEY = 8;
    PASSTHRU_KEYS = [BACKSPACE_KEY, 0, 46, 37, 38, 39, 40];
    lastKey = null;
    fixFormatting = function(str) {
      var parts;
      if (str == null) {
        str = '';
      }
      str = str.toLowerCase().replace(/\s+/g, '').replace(/[^0-9a-f]/g, '');
      parts = _.chain(str.split('')).groupBy(function(k, i) {
        return Math.floor(i / 2.0);
      }).map(function(_arg) {
        var a, b;
        a = _arg[0], b = _arg[1];
        return a + (b || '');
      }).value().join(" ");
      if (parts.match(/\w\w$/) && lastKey !== BACKSPACE_KEY) {
        parts += ' ';
      }
      return parts;
    };
    this.css('font-family', 'monospace');
    this.attr('spellcheck', false);
    this.keypress(function(e) {
      var char, code;
      if (_.contains(PASSTHRU_KEYS, e.which)) {
        return;
      }
      char = String.fromCharCode(e.which).toLowerCase();
      code = char.charCodeAt(0);
      if (char && char.length && (code < '0'.charCodeAt(0) || code > 'f'.charCodeAt(0))) {
        e.preventDefault();
        e.stopImmediatePropagation();
        return false;
      }
    });
    onChange = function(e) {
      var _this = this;
      lastKey = e.which || lastKey;
      return _.defer(function() {
        var fixedVal, initVal;
        initVal = $(_this).val();
        fixedVal = fixFormatting(initVal);
        if (initVal !== fixedVal) {
          return $(_this).val(fixedVal);
        }
      });
    };
    this.change(onChange);
    return this.keyup(onChange);
  };

}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["templates/wizards/payload_generator/form"] = function(__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
      
        __out.push('<form class=\'formtastic form\' id=\'payload_generator\'>\n  <li id=\'payload_class\'>\n    <label>\n      <input type=\'radio\' name=\'payload[payload_class]\' value=\'classic_payload\'>\n      Classic Payload\n    </label>\n    <label>\n      <input type=\'radio\' name=\'payload[payload_class]\' value=\'dynamic_stager\' checked>\n      Dynamic Payload (AV evasion)\n    </label>\n  </li>\n\n  <input type=\'hidden\' name=\'_method\' value=\'put\' />\n  <input type=\'hidden\' name=\'authenticity_token\' value=\'\' />\n  <input name=\'payload[options][payload]\' type=\'hidden\' />\n\n  <div class=\'dynamic_payload_form\'>\n    <div class=\'page payload_options upsell\'>\n      <ul>\n        <li style=\'display:none\'>\n          <div>\n            <input name=\'payload[payload_class]\' type=\'hidden\' />\n            <input name=\'payload[options][platform]\' type=\'hidden\' value=\'Windows\' />\n            <input name=\'payload[options][useStager]\' type=\'hidden\' value=\'true\' />\n            <input name=\'payload[options][format]\' type=\'hidden\' value=\'exe\' />\n          </div>\n        </li>\n        <li>\n            <label for=\'payload[options][arch]\'>Architecture</label>\n            <select name=\'payload[options][arch]\' id=\'payload[options][arch]\'></select>\n        </li>\n        <li>\n          <label for=\'payload[options][stager]\'>Stager</label>\n          <select name=\'payload[options][stager]\' id=\'payload[options][stager]\'></select>\n        </li>\n        <li>\n          <label for=\'payload[options][stage]\'>Stage</label>\n          <select name=\'payload[options][stage]\' id=\'payload[options][stage]\'></select>\n        </li>\n\n        <div class="payload-options advanced" style=\'display:block\'>\n          <div class=\'ajax\'></div>\n          <div style=\'display:none\'>\n            <div class=\'ajax-advanced-options\'>\n              <div class=\'render\' style=\'display:none;\'></div>\n              <div style=\'clear:both\'></div>\n            </div>\n          </div>\n        </div>\n      </ul>\n    </div>\n  </div>\n\n  <div class=\'page payload_options\'>\n    <ul>\n      <li>\n        <label for=\'payload[options][platform]\'>Platform</label>\n        <select name=\'payload[options][platform]\' id=\'payload[options][platform]\'></select>\n      </li>\n      <li>\n        <label for=\'payload[options][arch]\'>Architecture</label>\n        <select name=\'payload[options][arch]\' id=\'payload[options][arch]\'></select>\n      </li>\n      <li>\n        <label for=\'payload[options][useStager]\'>\n          <input name=\'payload[options][useStager]\' id=\'payload[options][useStager]\' type=\'checkbox\' />\n          Stager\n        </label>\n        <select name=\'payload[options][stager]\'></select>\n      </li>\n      <li>\n        <label for=\'payload[options][stage]\'>Stage</label>\n        <select name=\'payload[options][stage]\' id=\'payload[options][stage]\'></select>\n      </li>\n      <li>\n        <label for=\'payload[options][single]\'>Payload</label>\n        <select name=\'payload[options][single]\' id=\'payload[options][single]\'></select>\n      </li>\n\n      <div class="payload-options advanced" style=\'display:block\'>\n      <div class=\'ajax\'></div>\n        <span class=\'span-front\'>Added Shellcode</span>\n        <li class=\'file input front\'>\n          <label for=\'payload[options][add_code]\'>File</label>\n          <input name=\'payload[options][add_code]\' id=\'payload[options][add_code]\' type=\'file\' />\n        </li>\n        <li>\n          <label for=\'payload[options][nops]\'>Size of NOP sled</label>\n          <input name=\'payload[options][nops]\' id=\'payload[options][nops]\' type=\'text\' placeholder=\'(bytes)\' />\n        </li>\n        <div class=\'ajax-advanced-options\'>\n          <div class=\'\' style=\'text-align:right;padding-right:20px;padding-bottom:8px;\'>\n            <a href=\'#\' class=\'advanced\' data-toggle-selector=\'.ajax-advanced-options .render\'>Advanced</a>\n          </div>\n          <div class=\'render\' style=\'display:none\'></div>\n        </div>\n      </div>\n    </ul>\n\n  </div>\n\n  <div class=\'page encoding\'>\n    <h3 class=\'enabled\'>Encoding is <span class=\'enabled\'>enabled</span></h3>\n    <ul>\n      <li>\n        <label for=\'payload[options][encoder]\'>Encoder</label>\n        <select name=\'payload[options][encoder]\' id=\'payload[options][encoder]\'></select>\n      </li>\n    </ul>\n\n    <ul>\n      <li class=\'slider\'>\n        <label for=\'payload[options][iterations]\'>Number of iterations</label>\n        <input type=\'text\' name=\'payload[options][iterations]\' id=\'payload[options][iterations]\' data-min=\'1\' data-max=\'10\' value=\'1\'></input>\n      </li>\n\n      <li>\n        <label for=\'payload[options][space]\'>Maximum size of payload</label>\n        <input type=\'text\' name=\'payload[options][space]\' id=\'payload[options][space]\' placeholder=\'(bytes)\'></input>\n      </li>\n\n      <li>\n        <label for=\'payload[options][badchars]\'>Bad characters</label>\n        <textarea name=\'payload[options][badchars]\' id=\'payload[options][badchars]\' id=\'badchars\'></textarea>\n      </li>\n    </ul>\n\n    <div class=\'encoder-options advanced\' style=\'display:block\'>\n      <div class=\'ajax\'></div>\n    </div>\n  </div>\n\n  <div class=\'page output_options\'>\n    <ul>\n      <li class=\'output\'>\n        <label style=\'width:20%;\'>Output type</label>\n        <label style=\'font-weight: normal\'>\n          <input type=\'radio\' name=\'payload[options][outputType]\' value=\'exe\' />\n          Executable file\n        </label>\n        <label style=\'font-weight: normal\'>\n          <input type=\'radio\' name=\'payload[options][outputType]\' value=\'raw\' />\n          Raw bytes\n        </label>\n        <label style=\'font-weight: normal\'>\n          <input type=\'radio\' name=\'payload[options][outputType]\' value=\'buffer\' />\n          Shellcode buffer\n        </label>\n      </li>\n      <li class=\'not-raw\'>\n        <label for=\'payload[options][format]\'>Format</label>\n        <select name=\'payload[options][format]\' id=\'payload[options][format]\'></select>\n      </li>\n      <span class=\'exe span-front\'>Template file</span>\n      <li class=\'exe file input front\'>\n        <label>File</label>\n        <input type=\'file\' name=\'payload[options][template]\' id=\'payload[options][template]\' />\n      </li>\n      <li class=\'exe keep\'>\n        <input type=\'hidden\' name=\'payload[options][keep]\' value=\'false\' />\n        <input type=\'checkbox\' name=\'payload[options][keep]\' id=\'payload[options][keep]\' value=\'true\' />\n        <label for=\'payload[options][keep]\'>\n          Preserve original functionality of the executable\n        </label>\n      </li>\n    </ul>\n  </div>\n\n</form>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
(function() { this.JST || (this.JST = {}); this.JST["templates/wizards/payload_generator/datastore"] = function(__obj) {
    if (!__obj) __obj = {};
    var __out = [], __capture = function(callback) {
      var out = __out, result;
      __out = [];
      callback.call(this);
      result = __out.join('');
      __out = out;
      return __safe(result);
    }, __sanitize = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else if (typeof value !== 'undefined' && value != null) {
        return __escape(value);
      } else {
        return '';
      }
    }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
    __safe = __obj.safe = function(value) {
      if (value && value.ecoSafe) {
        return value;
      } else {
        if (!(typeof value !== 'undefined' && value != null)) value = '';
        var result = new String(value);
        result.ecoSafe = true;
        return result;
      }
    };
    if (!__escape) {
      __escape = __obj.escape = function(value) {
        return ('' + value)
          .replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;');
      };
    }
    (function() {
      (function() {
        var field, name, val, _i, _len, _ref;
      
        __out.push('<!--\n  Render dependencies:\n  {\n    options: an Array of datastore options to render\n    advancedOptions: an Array of advanced (hidden) options\n    optionsHashName: a name that is prepended to every rendered input\n  }\n-->\n<ul>\n  ');
      
        _ref = this.options;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          val = _ref[_i];
          __out.push('\n    ');
          name = val.name;
          __out.push('\n    ');
          field = "" + this.optionsHashName + "[" + name + "]";
          __out.push('\n    ');
          if (val.type === 'path') {
            __out.push('\n      <span class=\'span-front\'>');
            __out.push(__sanitize(name));
            __out.push('</span>\n      <li class=\'file input front\'>\n    ');
          } else {
            __out.push('\n      <li class=\'');
            __out.push(__sanitize(val.type));
            __out.push(' ');
            __out.push(__sanitize(_.str.underscored(name)));
            __out.push('\' style=\'position:relative;\'>\n    ');
          }
          __out.push('\n    ');
          if (val.type === 'path') {
            __out.push('\n      <label class="');
            if (!val.required) {
              __out.push(__sanitize('no-req'));
            }
            __out.push('" for="');
            __out.push(__sanitize(field));
            __out.push('">File');
            if (val.required) {
              __out.push(__sanitize('*'));
            }
            __out.push('</label>\n    ');
          } else {
            __out.push('\n      <label class="');
            if (!val.required) {
              __out.push(__sanitize('no-req'));
            }
            __out.push('" for="');
            __out.push(__sanitize(field));
            __out.push('">');
            __out.push(__sanitize(name));
            if (val.required) {
              __out.push(__sanitize('*'));
            }
            __out.push('</label>\n    ');
          }
          __out.push('\n    ');
          if (name === 'EXITFUNC') {
            __out.push('\n      <select id=\'');
            __out.push(__sanitize(field));
            __out.push('\' name=\'');
            __out.push(__sanitize(this.optionsHashName));
            __out.push('[EXITFUNC]\'>\n        <option value=\'\' ');
            if (val["default"] === 'none') {
              __out.push(__sanitize('selected'));
            }
            __out.push('>None</option>\n        <option value=\'seh\' ');
            if (val["default"] === 'seh') {
              __out.push(__sanitize('selected'));
            }
            __out.push('>SEH</option>\n        <option value=\'thread\' ');
            if (val["default"] === 'thread') {
              __out.push(__sanitize('selected'));
            }
            __out.push('>Thread</option>\n        <option value=\'process\' ');
            if (val["default"] === 'process') {
              __out.push(__sanitize('selected'));
            }
            __out.push('>Process</option>\n      </select>\n    ');
          } else if (_.contains(['raw', 'string', 'address', 'port', 'integer', 'meterpreterdebuglogging'], val.type)) {
            __out.push('\n      <input id=\'');
            __out.push(__sanitize(field));
            __out.push('\' name=\'');
            __out.push(__sanitize(field));
            __out.push('\' type=\'text\' value=\'');
            __out.push(__sanitize(val["default"]));
            __out.push('\' />\n    ');
          } else if (val.type === 'bool') {
            __out.push('\n      <input name=\'');
            __out.push(__sanitize(field));
            __out.push('\' type=\'hidden\' value=\'false\' />\n      <input id=\'');
            __out.push(__sanitize(field));
            __out.push('\' name=\'');
            __out.push(__sanitize(field));
            __out.push('\' type=\'checkbox\' ');
            __out.push(__sanitize(val["default"] ? 'checked' : void 0));
            __out.push(' value=\'true\' />\n    ');
          } else if (val.type === 'path') {
            __out.push('\n      <input id=\'');
            __out.push(__sanitize(field));
            __out.push('\' name=\'');
            __out.push(__sanitize(field));
            __out.push('\' type=\'file\' />\n    ');
          } else {
            __out.push('\n      <input type=\'hidden\' name=\'');
            __out.push(__sanitize(field));
            __out.push('\' value=\'');
            __out.push(__sanitize(val["default"]));
            __out.push('\' />\n    ');
          }
          __out.push('\n    ');
          if (val.type !== 'path') {
            __out.push('\n      <div class=\'inline-help\' data-field=\'');
            __out.push(__sanitize(field));
            __out.push('\' >\n        <a href=\'javascript: void;\' tabindex=\'-1\' target=\'_blank\' class=\'help\' data-field=\'');
            __out.push(__sanitize(field));
            __out.push('\'>\n          <img src=\'/assets/icons/silky/information-c0210a97250ec34cc04d6c8ff768012bf9e054abe33c7fcc558f65bf57a1661a.png\' alt=\'Information\' />\n        </a>\n        <h3>');
            __out.push(__sanitize(_.humanize(name)));
            __out.push('</h3>\n        <p>\n        ');
            __out.push(__sanitize(val.desc));
            __out.push('\n        </p>\n      </div>\n    ');
          }
          __out.push('\n    </li>\n  ');
        }
      
        __out.push('\n</ul>\n');
      
      }).call(this);
      
    }).call(__obj);
    __obj.safe = __objSafe, __obj.escape = __escape;
    return __out.join('');
  };
}).call(this);
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
(function() {
  var $, CLASSIC_DESCRIPTION, DYNAMIC_DESCRIPTION, DYNAMIC_STAGERS, ENCODER_IDX, FORM_URL, NUM_TABS, OUTPUT_IDX, POLL_WAIT, PREFERRED_ARCHES, UPSELL_URL, WIDTH, WINDOWS_ONLY_ENCODERS,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $ = jQuery;

  WIDTH = 700;

  FORM_URL = '/wizards/payload_generator/form/';

  UPSELL_URL = "" + FORM_URL + "upsell";

  PREFERRED_ARCHES = ['x86', 'x64'];

  NUM_TABS = 3;

  ENCODER_IDX = 1;

  OUTPUT_IDX = 2;

  POLL_WAIT = 2000;

  DYNAMIC_STAGERS = ['reverse_tcp', 'reverse_http', 'reverse_https', 'bind_tcp'];

  DYNAMIC_DESCRIPTION = 'Generates a Windows executable that uses a dynamic stager ' + 'written entirely in randomized C code.';

  CLASSIC_DESCRIPTION = 'Builds a customized payload. (All platforms)';

  WINDOWS_ONLY_ENCODERS = ['generic/eicar'];

  this.PayloadGeneratorModal = (function(_super) {

    __extends(PayloadGeneratorModal, _super);

    function PayloadGeneratorModal() {
      this.useDynamicStagers = __bind(this.useDynamicStagers, this);

      this.payloadClass = __bind(this.payloadClass, this);

      this.formEl = __bind(this.formEl, this);

      this.inputEl = __bind(this.inputEl, this);

      this.serialize = __bind(this.serialize, this);

      this.renderUpsell = __bind(this.renderUpsell, this);

      this.formSubmittedSuccessfully = __bind(this.formSubmittedSuccessfully, this);

      this.transformErrorData = __bind(this.transformErrorData, this);

      this.mapErrorToSelector = __bind(this.mapErrorToSelector, this);

      this.formOverrides = __bind(this.formOverrides, this);

      this.renderEncoderOptions = __bind(this.renderEncoderOptions, this);

      this.renderPayloadOptions = __bind(this.renderPayloadOptions, this);

      this.setValue = __bind(this.setValue, this);

      this.setOptions = __bind(this.setOptions, this);

      this.removeNonWindowsEncoders = __bind(this.removeNonWindowsEncoders, this);

      this.updateForm = __bind(this.updateForm, this);

      this.payloadClassChanged = __bind(this.payloadClassChanged, this);

      this.formChanged = __bind(this.formChanged, this);

      this.encodingToggled = __bind(this.encodingToggled, this);

      this.renderForm = __bind(this.renderForm, this);

      this.getLicense = __bind(this.getLicense, this);

      this.validLicense = __bind(this.validLicense, this);

      this.layout = __bind(this.layout, this);

      this.render = __bind(this.render, this);
      return PayloadGeneratorModal.__super__.constructor.apply(this, arguments);
    }

    PayloadGeneratorModal.prototype._lastPayload = null;

    PayloadGeneratorModal.prototype._lastEncoder = null;

    PayloadGeneratorModal.prototype.initialize = function() {
      PayloadGeneratorModal.__super__.initialize.apply(this, arguments);
      this.setTitle('Payload Generator');
      this.setTabs([
        {
          name: 'Payload Options'
        }, {
          name: 'Encoding',
          checkbox: true
        }, {
          name: 'Output Options'
        }
      ]);
      this.setButtons([
        {
          name: 'Cancel',
          "class": 'close'
        }, {
          name: 'Generate',
          "class": 'btn primary'
        }
      ]);
      this._steps = _.map(this._tabs, function(tab) {
        return [tab.name, FORM_URL + _.str.underscored(tab.name)];
      });
      this._url = FORM_URL;
      this.genPayload = new GeneratedPayload();
      return PayloadCache.load(this.renderForm);
    };

    PayloadGeneratorModal.prototype.events = _.extend({
      'change form#payload_generator *': 'formChanged',
      'change input#tab_encoding': 'encodingToggled',
      'change li#payload_class input': 'payloadClassChanged'
    }, TabbedModalView.prototype.events);

    PayloadGeneratorModal.prototype.render = function() {
      var i, _i, _results;
      PayloadGeneratorModal.__super__.render.apply(this, arguments);
      this.tabAt(ENCODER_IDX).find('[type=checkbox]').prop('checked', true);
      _results = [];
      for (i = _i = 1; 1 <= NUM_TABS ? _i < NUM_TABS : _i > NUM_TABS; i = 1 <= NUM_TABS ? ++_i : --_i) {
        _results.push(this.tabAt(i).toggle(false));
      }
      return _results;
    };

    PayloadGeneratorModal.prototype.layout = function() {
      this.$modal.width(WIDTH);
      this.center();
      return this.$modal.addClass('payload-generator');
    };

    PayloadGeneratorModal.prototype.validLicense = function() {
      return "true";
    };

    PayloadGeneratorModal.prototype.getLicense = function() {
      return $('meta[name=msp-feed-edition]').attr('content');
    };

    PayloadGeneratorModal.prototype.renderForm = function() {
      var $hiddenPage, $li, template;
      template = JST['templates/wizards/payload_generator/form'];
      this.content().removeClass('loading tab-loading').html(template(this.genPayload));
      $li = this.content().find('li#payload_class').remove();
      $li.insertAfter($('h1:first', this.$modal));
      $hiddenPage = $('div.dynamic_payload_form');
      this._hiddenPage = $hiddenPage.find('div.page');
      this._hiddenPage.detach();
      $hiddenPage.remove();
      this.inputEl('badchars').ByteEntry();
      $('[name=authenticity_token]', this.$modal).val($('meta[name=csrf-token]').attr('content'));
      this.initTabs();
      if (this.getLicense() !== 'pro') {
        $li.find("input").prop('checked', false);
        $li.find("input[value='classic_payload']").prop('checked', true);
        this.payloadClassChanged();
      }
      return this.payloadClassChanged();
    };

    PayloadGeneratorModal.prototype.encodingToggled = function(e) {
      var $span, checked;
      checked = $(e.target).is(':checked');
      $span = this.pageAt(ENCODER_IDX).find('h3 span');
      this.genPayload.set('useEncoder', checked);
      if (!checked) {
        $span.removeClass('enabled').addClass('disabled').text('disabled');
        return this.pageAt(ENCODER_IDX).css({
          'pointer-events': 'none',
          opacity: 0.5
        });
      } else {
        $span.removeClass('disabled').addClass('enabled').text('enabled');
        return this.pageAt(ENCODER_IDX).css({
          'pointer-events': 'all',
          opacity: 1
        });
      }
    };

    PayloadGeneratorModal.prototype.formChanged = function() {
      var data, _ref, _ref1;
      if (this._updating) {
        return;
      }
      data = Backbone.Syphon.serialize(this.formEl()[0]);
      if (data != null) {
        if ((_ref = data.payload) != null) {
          delete _ref.options['payload'];
        }
      }
      this.genPayload.set((data != null ? (_ref1 = data.payload) != null ? _ref1.options : void 0 : void 0) || {});
      this.genPayload.set('useEncoder', $('#tab_encoding', this.$modal).is(':checked'));
      return this.updateForm();
    };

    PayloadGeneratorModal.prototype.payloadClassChanged = function(e) {
      var $tabs, removed,
        _this = this;
      this._updating = true;
      removed = this.formEl().find('div.page').detach();
      this._lastPayload = this._lastEncoder = null;
      if (this._upsell != null) {
        this._upsell.remove();
      }
      if (this._hiddenPage != null) {
        this.formEl().append(this._hiddenPage);
        this._hiddenPage = null;
      }
      $tabs = $('ul.tabs li', this.$modal).hide();
      _.times(this.formEl().find('div.page').length, function(i) {
        return $tabs.eq(i).show();
      });
      this._hiddenPage = removed;
      this.index(0);
      this.genPayload = new GeneratedPayload;
      if (this.useDynamicStagers()) {
        this.updateDescription(DYNAMIC_DESCRIPTION);
        if (this.getLicense() !== 'pro') {
          this.renderUpsell();
        }
      } else {
        this.updateDescription(CLASSIC_DESCRIPTION);
      }
      this._updating = false;
      return this.updateForm();
    };

    PayloadGeneratorModal.prototype.updateForm = function() {
      var $output, $primaryBtn, encodersPresent, i, numStagers, obj, stagersPresent, _i, _j,
        _this = this;
      obj = this.serialize();
      this._updating = true;
      if (this.genPayload.get('platform') !== 'Windows') {
        obj.encoders = this.removeNonWindowsEncoders(obj.encoders);
      }
      if (!_.contains(obj.arches, this.genPayload.get('arch'))) {
        this.genPayload.set('arch', obj.arches[0]);
        obj = this.serialize();
      }
      if (!_.contains(obj.stagers, this.genPayload.get('stager'))) {
        this.genPayload.set('stager', obj.stagers[0]);
      }
      if (!_.contains(obj.stages, this.genPayload.get('stage'))) {
        this.genPayload.set('stage', obj.stages[0]);
      }
      if (!_.contains(obj.singles, this.genPayload.get('single'))) {
        this.genPayload.set('single', obj.singles[0]);
      }
      if (!_.contains(obj.encoders, this.genPayload.get('encoder'))) {
        this.genPayload.set('encoder', obj.encoders[0]);
      }
      if (this.useDynamicStagers()) {
        obj.stagers = DYNAMIC_STAGERS;
        obj.arches = ["x86", "x64"];
      }
      this.setOptions('platform', obj.platforms);
      this.setOptions('arch', obj.arches);
      this.setOptions('stager', obj.stagers);
      this.setOptions('stage', obj.stages);
      this.setOptions('single', obj.singles);
      this.setOptions('encoder', obj.encoders);
      this.setOptions('format', obj.formats);
      numStagers = this.useDynamicStagers() ? 1 : NUM_TABS;
      for (i = _i = 0; 0 <= numStagers ? _i < numStagers : _i > numStagers; i = 0 <= numStagers ? ++_i : --_i) {
        this.tabAt(i).toggle(true);
      }
      encodersPresent = !_.isEmpty(obj.encoders);
      if (this.formEl().find('div.page').length > 1) {
        this.tabAt(ENCODER_IDX).toggle(encodersPresent);
      }
      $primaryBtn = $('a.btn.primary', this.$modal);
      if (this.useDynamicStagers() && this.getLicense() !== 'pro') {
        for (i = _j = 0; 0 <= NUM_TABS ? _j <= NUM_TABS : _j >= NUM_TABS; i = 0 <= NUM_TABS ? ++_j : --_j) {
          this.tabAt(i).toggle(false);
        }
        this.content().css({
          width: '100%',
          'margin-left': '10px',
          border: 'none'
        });
        $primaryBtn.addClass('_disabled unsupported');
      } else {
        this.content().css({
          width: '80%',
          'margin-left': '0',
          border: '2px solid #d6d6d6'
        });
        if ($primaryBtn.hasClass('unsupported')) {
          $primaryBtn.removeClass('_disabled unsupported');
        }
      }
      stagersPresent = obj.stagers.length > 0 && obj.stages.length > 0;
      if (!stagersPresent) {
        this.genPayload.set('useStager', false);
      }
      this.inputEl('useStager').parent().toggle(!!stagersPresent);
      this.inputEl('arch').parent().toggle(obj.arches.length > 1);
      if (stagersPresent) {
        this.inputEl('stager').parent().show();
        if (this.genPayload.get('useStager')) {
          this.inputEl('stager').css({
            'pointer-events': 'all',
            opacity: 1.0
          });
        } else {
          this.inputEl('stager').css({
            'pointer-events': 'none',
            opacity: 0.5
          });
        }
      } else {
        this.inputEl('stager').parent().hide();
      }
      this.inputEl('stage').parent().toggle(stagersPresent && this.genPayload.get('useStager'));
      this.inputEl('single').parent().toggle(!(stagersPresent && this.genPayload.get('useStager')));
      _.each(this.genPayload.attributes, function(val, key) {
        return _this.setValue(key, val);
      });
      this.renderPayloadOptions(obj);
      this.renderEncoderOptions(obj);
      if (this.useDynamicStagers()) {
        this.pageAt(0).find('li.exitfunc').hide();
      }
      this.inputEl('outputType').prop('checked', false).filter("[value=" + (this.genPayload.get('outputType')) + "]").prop('checked', true);
      $output = this.pageAt(OUTPUT_IDX);
      $output.find('li.exe,span.exe.span-front').toggle(this.genPayload.isOutputExe());
      $output.find('li.source').toggle(this.genPayload.isOutputBuffer());
      $output.find('li.not-raw').toggle(!this.genPayload.isOutputRaw());
      this.inputEl('keep').prop('checked', this.genPayload.get('keep'));
      this.resetErrors();
      this.renderFileInputs();
      this._updating = false;
      return $('ul.tabs li', this.$modal).find('.hasErrors').hide();
    };

    PayloadGeneratorModal.prototype.removeNonWindowsEncoders = function(encoders) {
      return _.reject(encoders, function(enc) {
        return _.contains(WINDOWS_ONLY_ENCODERS, enc);
      });
    };

    PayloadGeneratorModal.prototype.setOptions = function(inputName, options) {
      var $select,
        _this = this;
      if (_.isArray(options)) {
        options = _.object(options, options);
      }
      $select = this.inputEl(inputName).html('');
      return _.each(options, function(displayText, value) {
        return $select.append($('<option />', {
          value: value
        }).text(displayText));
      });
    };

    PayloadGeneratorModal.prototype.setValue = function(inputName, val) {
      var $input, option;
      $input = this.inputEl(inputName);
      if ($input.is(':text')) {
        return $input.val(val);
      } else if ($input.is('select')) {
        $input.find('option').prop('selected', false);
        option = _.find($input.find('option'), function(opt) {
          return opt.value === val;
        });
        if (option != null) {
          return $(option).prop('selected', true);
        }
      } else if ($input.is('[type=checkbox]')) {
        return $input.prop('checked', !!val);
      }
    };

    PayloadGeneratorModal.prototype.renderPayloadOptions = function(obj) {
      var advancedOptions, payload, template, _ref;
      payload = this.genPayload.findModule();
      if ((payload != null ? payload.refname : void 0) === ((_ref = this._lastPayload) != null ? _ref.refname : void 0)) {
        return;
      }
      if (payload == null) {
        return;
      }
      advancedOptions = payload.filteredOptions({
        advanced: true
      });
      template = JST['templates/wizards/payload_generator/datastore'];
      this.formEl().find('.payload-options .ajax').html(template({
        options: payload.filteredOptions({
          advanced: false
        }),
        optionsHashName: 'payload[options][payload_datastore]'
      }));
      this.formEl().find('.payload-options .ajax-advanced-options .render').html(template({
        options: advancedOptions,
        optionsHashName: 'payload[options][payload_datastore]'
      }));
      this.formEl().find('.payload-options .ajax-advanced-options').toggle(advancedOptions.length > 0);
      Forms.renderHelpLinks(this.el);
      $('#modals .inline-help').css({
        position: 'fixed'
      });
      return this._lastPayload = payload;
    };

    PayloadGeneratorModal.prototype.renderEncoderOptions = function(obj) {
      var advOpts, encoder, opts, template, _ref;
      encoder = this.genPayload.findEncoder();
      if (encoder == null) {
        return this.formEl().find('.encoder-options .ajax').html('');
      }
      if ((encoder != null ? encoder.refname : void 0) === ((_ref = this._lastEncoder) != null ? _ref.refname : void 0)) {
        return;
      }
      if (encoder == null) {
        return;
      }
      template = JST['templates/wizards/payload_generator/datastore'];
      opts = encoder.filteredOptions({
        advanced: false
      });
      advOpts = encoder.filteredOptions({
        advanced: true
      });
      this.formEl().find('.encoder-options .ajax').html(template({
        options: opts,
        optionsHashName: 'payload[options][encoder_datastore]'
      }));
      this.formEl().find('.encoder-options .ajax-advanced-options .render').html(template({
        options: advOpts,
        optionsHashName: 'payload[options][encoder_datastore]'
      }));
      this.formEl().find('.encoder-options.advanced').toggle(opts.length > 0);
      this.formEl().find('.encoder-options .ajax-advanced-options').toggle(advOpts.length > 0);
      Forms.renderHelpLinks(this.el);
      $('#modals .inline-help').css({
        position: 'fixed'
      });
      return this._lastEncoder = encoder;
    };

    PayloadGeneratorModal.prototype.formOverrides = function() {
      var overrides, _ref, _ref1;
      overrides = {
        'payload[options][payload]': ((_ref = this.genPayload.findModule()) != null ? _ref.refname : void 0) || '',
        'payload[options][encoder]': ((_ref1 = this.genPayload.findEncoder()) != null ? _ref1.refname : void 0) || '',
        'payload[payload_class]': this.payloadClass()
      };
      if (this.genPayload.isOutputRaw()) {
        _.extend(overrides, {
          'payload[options][format]': 'raw'
        });
      }
      if (!this.genPayload.get('useStager')) {
        _.extend(overrides, {
          'payload[options][stage]': ''
        });
      }
      return overrides;
    };

    PayloadGeneratorModal.prototype.mapErrorToSelector = function(attrName, modelName) {
      return attrName;
    };

    PayloadGeneratorModal.prototype.transformErrorData = function(errors) {
      var _base;
      errors.errors = {
        payload: errors.errors
      };
      if (errors.errors.payload.payload != null) {
        (_base = errors.errors.payload).options || (_base.options = {});
        errors.errors.payload["payload[options][single]"] = errors.errors.payload.payload;
        delete errors.errors.payload.payload;
      }
      return errors;
    };

    PayloadGeneratorModal.prototype.formSubmittedSuccessfully = function(data) {
      var done, poll,
        _this = this;
      if (!_.isEmpty(data != null ? data.errors : void 0)) {
        return this.handleSubmitError(data.errors);
      }
      done = false;
      poll = function() {
        return $.getJSON("" + FORM_URL + "poll?payload_id=" + data.id).done(function(data) {
          var close, modal;
          modal = _this;
          if (data.state === 'generating') {
            return _.delay(poll, POLL_WAIT);
          }
          if (data.state === 'failed') {
            _this._loaderDialog.dialog({
              title: 'Error Occurred',
              buttons: {
                Close: function() {
                  $(this).dialog('close');
                  return $(this).remove();
                }
              }
            });
            return _this._loaderDialog.removeClass('tab-loading loading').addClass('failed').append($('<p class="dialog-msg center">').text(data.generator_error));
          } else {
            close = function() {
              $(this).dialog('close');
              $(this).remove();
              return modal.close();
            };
            _this._loaderDialog.dialog({
              title: 'Payload generated',
              buttons: {
                Close: close,
                Download: function() {
                  var $f;
                  $f = $('<iframe />', {
                    src: "" + FORM_URL + "download?payload_id=" + data.id
                  });
                  $f.css({
                    display: 'none'
                  }).appendTo($('body'));
                  _.delay((function() {
                    return $f.remove();
                  }), 60 * 1000);
                  close.call(this);
                  return $('#modals').html('').addClass('empty');
                }
              }
            });
            _this._loaderDialog.removeClass('tab-loading loading failed').append($('<p class="dialog-msg center">').text("Filename: " + data.options.file_name)).append($('<p class="dialog-msg center">').text("Size: " + window.helpers.formatBytes(data.size)));
            return $('#modals .tabbed-modal').hide();
          }
        }).fail(function() {
          return _.delay(poll, POLL_WAIT);
        });
      };
      return _.delay(poll, POLL_WAIT);
    };

    PayloadGeneratorModal.prototype.renderUpsell = function() {
      var $upsell,
        _this = this;
      $upsell = $('.upsell', this.el).html('').addClass('tab-loading').css({
        height: 'auto',
        'min-height': '350px'
      });
      return $.get(UPSELL_URL, function(data) {
        return $upsell.html(data).removeClass('tab-loading');
      });
    };

    PayloadGeneratorModal.prototype.serialize = function(extraData) {
      if (extraData == null) {
        extraData = {};
      }
      return _.extend({}, this.genPayload.attributes, extraData, {
        platforms: PayloadCache.platforms().sort(),
        arches: PayloadCache.arches(this.genPayload.attributes).sort(),
        stagers: PayloadCache.stagerTypes(this.genPayload.attributes).sort(),
        stages: _.uniq(_.pluck(PayloadCache.stagers(this.genPayload.attributes), 'stageName')).sort(),
        singles: _.pluck(PayloadCache.singles(this.genPayload.attributes), 'refname').sort(),
        encoders: _.pluck(PayloadCache.encoders(this.genPayload.attributes), 'refname').sort(),
        formats: PayloadCache.formats({
          buffer: this.genPayload.isOutputBuffer()
        })
      });
    };

    PayloadGeneratorModal.prototype.inputEl = function(inputName) {
      return this.formEl().find("[name='payload[options][" + inputName + "]']");
    };

    PayloadGeneratorModal.prototype.formEl = function() {
      return this.$el.find('form#payload_generator');
    };

    PayloadGeneratorModal.prototype.payloadClass = function() {
      return this.$el.find('li#payload_class input:checked').val();
    };

    PayloadGeneratorModal.prototype.useDynamicStagers = function() {
      return this.payloadClass() === 'dynamic_stager';
    };

    return PayloadGeneratorModal;

  })(this.TabbedModalView);

}).call(this);










