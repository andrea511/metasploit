(function() {

  Handlebars.registerHelper('encodeURIComponent', function(obj) {
    return encodeURIComponent(obj);
  });

  Handlebars.registerHelper('exists?', function(obj) {
    return obj != null;
  });

  Handlebars.registerHelper('humanize', function(obj) {
    return _.str.humanize(obj);
  });

  Handlebars.registerHelper('downcase', function(obj) {
    return obj.toLowerCase();
  });

  Handlebars.registerHelper('upcase', function(obj) {
    return obj.toUpperCase();
  });

  Handlebars.registerHelper('camelize', function(obj) {
    return _.str.camelize(obj);
  });

  Handlebars.registerHelper('lower', function(obj) {
    if (obj.toLowerCase != null) {
      return obj.toLowerCase();
    }
  });

  Handlebars.registerHelper('lookupStat', function(obj, obj2) {
    return obj[obj2] || 0;
  });

  Handlebars.registerHelper('humanizeStat', function(app, statName) {
    var schema;
    schema = _.find(app.stats, function(stat) {
      return stat.num === statName;
    });
    return _.str.humanize((schema != null ? schema.name : void 0) || obj2);
  });

  Handlebars.registerHelper('formatStat', function(obj, obj2) {
    var num, stat;
    stat = obj[obj2] || 0;
    if (("" + stat).match(/^[\d]+$/) && parseInt(stat) > 1000) {
      num = (parseInt(stat) / 1000).toFixed(1);
      return ("" + num + "k").replace(/\.0/, '');
    } else {
      return stat;
    }
  });

  Handlebars.registerHelper('even_class?', function(options) {
    if ((parseInt(options.fn(this)) + 2) % 2 === 0) {
      return "even";
    } else {
      return "odd";
    }
  });

  Handlebars.registerHelper('percentize', function(arr, stats) {
    var percent;
    percent = stats[arr[0]] / stats[arr[1]] * 100 || 0;
    percent = percent.toFixed(1);
    return ("" + percent + "%").replace(/\.0/, '');
  });

  Handlebars.registerHelper('underscored', function(options) {
    return _.str.underscored(options.fn(this));
  });

  Handlebars.registerHelper('titleize', function(options) {
    return _.str.titleize(options.fn(this).replace('_', ' '));
  });

  Handlebars.registerHelper('if_arrContains', function(context, options) {
    if (_.contains(context, options.hash.compare)) {
      return options.fn(this);
    }
    return options.inverse(this);
  });

  Handlebars.registerHelper('unless_arrContains', function(context, options) {
    if (_.contains(context, options.hash.compare)) {
      return options.inverse(this);
    }
    return options.fn(this);
  });

  Handlebars.registerHelper('utc_to_datepicker', function(options) {
    if (options.fn(this)) {
      return moment(options.fn(this)).format('MM/DD/YYYY');
    } else {
      return options.fn(this);
    }
  });

  Handlebars.registerHelper('if_present', function(context, options) {
    var isLengthy;
    isLengthy = (context != null) && (typeof context === 'string' || (context instanceof Array));
    if ((context != null) && (!isLengthy || (isLengthy && context.length > 0))) {
      return options.fn(this);
    } else {
      return options.inverse(this);
    }
  });

}).call(this);
