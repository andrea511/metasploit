define [], ->
  @Pro.module "Concerns", (Concerns) ->

    DEFAULT_TIMEOUT = 5000

    #
    # Implements start/stopPolling behavior on a class that with a @poll() method that
    # returns a jQuery deferred object. The client class can also control the poll interval
    # by defining a @pollInterval property on itself with the desired interval in milliseconds.
    #
    Concerns.Pollable =
      
      # @property [Boolean] instance is currently polling
      polling: false

      # Starts the polling loop.
      startPolling: ->
        return if @polling

        @polling = true
        errorMsg = 'Concerns.Pollable: Client class must have a poll() method that returns a $.Deferred object'
        throw new Error(errorMsg) unless @poll?

        clearId = null # hold in closure for privacy

        # redefine in our closure so we can reference private clearId
        @stopPolling = =>
          @polling = false
          clearTimeout(clearId)
          @stopPolling = ->

        # define the polling logic
        pollForever = =>
          return unless @polling
          deferred = @poll()
          return unless deferred?.then?
          throw new Error(errorMsg) unless deferred.then?
          deferred.then =>
            clearId = setTimeout(pollForever, @pollInterval || DEFAULT_TIMEOUT)
        pollForever()

      # Stops the polling loop.
      # Clears any timeouts in the queue and sets the @polling property to false.
      # Until @startPolling() is called, this method is a no-op.
      stopPolling: ->
