define [
  'base_controller'
  'lib/components/pill/pill_controller'
  'lib/components/pill/pill_views'
  'css!css/components/pill'
], () ->
  @Pro.module "Components.VulnAttemptStatusPill", (VulnAttemptStatusPill, App) ->

    class VulnAttemptStatusPill.Controller extends Pro.Components.Pill.Controller

      initialize: (options) ->
        options.color = switch
          when options.model.isExploited() then 'green'
          when options.model.isNotExploitable() then 'blue'
        super(options)

