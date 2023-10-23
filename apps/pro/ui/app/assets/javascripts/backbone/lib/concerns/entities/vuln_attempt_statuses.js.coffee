define [], ->
  @Pro.module "Concerns", (Concerns,App,Backbone, Marionette, $, _) ->

    Concerns.VulnAttemptStatuses =
      STATUSES:
        EXPLOITED: 'Exploited'
        NOT_EXPLOITABLE: 'Not Exploitable'

      #
      # @return [Boolean] true if the status of the attempt is "exploited"
      isExploited: ->
        @get('status') == @STATUSES.EXPLOITED || @get('vuln_attempt_status') == @STATUSES.EXPLOITED

      #
      # @return [Boolean] true if the status of the attempt is "Not Exploitable"
      isNotExploitable: ->
        @get('status') == @STATUSES.NOT_EXPLOITABLE || @get('vuln_attempt_status') == @STATUSES.NOT_EXPLOITABLE