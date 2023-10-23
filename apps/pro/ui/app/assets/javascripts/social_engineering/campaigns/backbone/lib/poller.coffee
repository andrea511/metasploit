jQueryInWindow ($) ->
  # poll JSON for CampaignDetails instance
  class @Poller
    @TIME_OUT: 8000
    constructor: (@collection) ->


    start: ->
      outerCollection = @collection
      @stopped = false
      repoll = (collection) =>
        return if @stopped || @polling
        @polling = true
        $.ajax(
          url: collection.url + '?t=' + Math.round((new Date()).getTime() / 1000),
          dataType: 'json',
          success: (data) =>
            collectionChanged = false
            toRemove = _.filter(collection.models, (m) -> _.all(data, (mm) -> mm.id != m.id))
            _.each data, (model) ->
              oldModel = _.find(collection.models, (m) -> m.id == model.id)
              if oldModel
                oldModel.set(model)
              else
                newModel = new CampaignSummary
                collection.unshift(newModel, silent: true)
                newModel.set(model)
                collectionChanged = true
            collection.remove(toRemove)
            @polling = false
            collection.trigger('change') if collectionChanged
            _.delay((=>repoll.call(this, collection)), Poller.TIME_OUT)
          error: (e) =>
            @polling = false
            _.delay((=>repoll.call(this, collection)), Poller.TIME_OUT)
        )
      repoll(@collection)

    stop: ->
      @stopped = true

  class @SingleModelPoller
    constructor: (@model, @url='', @TIME_OUT=8000, @cb=->) ->

    start: ->
      outerModel = @model
      @stopped = false
      repoll = (model) =>
        @cb.call(this) if @cb
        return if @stopped || @polling
        @polling = true
        $.ajax(
          url: @url + '?t=' + Math.round((new Date()).getTime() / 1000),
          dataType: 'json',
          success: (data) =>
            outerModel.set(data)
            @polling = false
            _.delay((=>repoll.call(this, model)), @TIME_OUT)
          error: (e) =>
            @polling = false
            _.delay((=>repoll.call(this, model)), @TIME_OUT)
        )
      repoll(@model)

    stop: ->
      @stopped = true
