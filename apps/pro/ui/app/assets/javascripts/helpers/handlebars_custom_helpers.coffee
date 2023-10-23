Handlebars.registerHelper 'encodeURIComponent', (obj) -> encodeURIComponent(obj)
Handlebars.registerHelper 'exists?', (obj) -> obj?
Handlebars.registerHelper 'humanize', (obj) -> _.str.humanize(obj)
Handlebars.registerHelper 'downcase', (obj) -> obj.toLowerCase()
Handlebars.registerHelper 'upcase', (obj) -> obj.toUpperCase()
Handlebars.registerHelper 'camelize', (obj) -> _.str.camelize(obj)
Handlebars.registerHelper 'lower', (obj) -> obj.toLowerCase() if obj.toLowerCase?
Handlebars.registerHelper 'lookupStat', (obj, obj2) -> obj[obj2] || 0
Handlebars.registerHelper 'humanizeStat', (app, statName) ->
  schema = _.find app.stats, (stat) -> stat.num is statName
  _.str.humanize schema?.name || obj2
  
Handlebars.registerHelper 'formatStat', (obj, obj2) ->
  stat = obj[obj2] || 0
  if "#{stat}".match(/^[\d]+$/) and parseInt(stat) > 1000 # if numeric
    num = (parseInt(stat)/1000).toFixed(1)
    "#{num}k".replace(/\.0/, '')
  else
    stat

Handlebars.registerHelper 'even_class?', (options) ->
  if ((parseInt(options.fn(this))+2)%2==0)
    "even"
  else
    "odd"

Handlebars.registerHelper 'percentize', (arr, stats) ->
  percent = stats[arr[0]]/stats[arr[1]]*100 || 0
  percent = percent.toFixed(1)
  "#{percent}%".replace(/\.0/, '')

# Need to use the wrapping syntax here {{#underscored}}{{name}}{{/underscored}}
#  because hamlbars fails at doing logic inside of a :class => '' key.
Handlebars.registerHelper 'underscored', (options) -> _.str.underscored(options.fn(this))
Handlebars.registerHelper 'titleize', (options) -> _.str.titleize(options.fn(this).replace('_',' '))


Handlebars.registerHelper 'if_arrContains', (context, options) ->
  if (_.contains(context,options.hash.compare))
    return options.fn(@);
  return options.inverse(@);

Handlebars.registerHelper 'unless_arrContains', (context,options) ->
  if(_.contains(context,options.hash.compare))
    return options.inverse(@)
  return options.fn(@)




#Requires Moment.js to be loaded
Handlebars.registerHelper 'utc_to_datepicker', (options) ->
  if options.fn(this)
    moment(options.fn(this)).format('MM/DD/YYYY')
  else
    options.fn(this)


Handlebars.registerHelper 'if_present', (context, options) ->
  isLengthy = context? and (typeof(context) == 'string' or (context instanceof Array))
  if context? and (!isLengthy or (isLengthy && context.length > 0))
  	options.fn(@)
  else
  	options.inverse(@)