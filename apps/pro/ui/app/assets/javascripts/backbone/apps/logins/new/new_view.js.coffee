define [
  'base_view'
  'base_itemview'
  'base_layout'
  'apps/logins/new/templates/new_layout'
  'apps/logins/new/templates/form'
], () ->
  @Pro.module 'LoginsApp.New', (New, App, Backbone, Marionette, $, _) ->

    #
    # Contains the form for creating a login
    #
    class New.Form extends App.Views.Layout
      template: @::templatePath 'logins/new/form'

      regions:
        accessLevelRegion: '.access-level-region'

      ui:
        host: 'select.host'

      triggers:
        'change @ui.host' : 'updateServices'

      updateService: ->
        @ui.host.trigger('change')

      hideHost: ->
        @ui.host.parent().hide()


    #
    # Layout for login form and tagging form
    #
    class New.Layout extends App.Views.Layout

      template: @::templatePath 'logins/new/new_layout'

      regions:
        tags: '.tags'
        form : 'form'

      ui:
        tags: '.tag-container'

      className: 'tab-loading'

      removeTags: () ->
        @ui.tags.remove()


      removeLoading: () ->
        @$el.removeClass('tab-loading')

      # Render Form Errors
      # @param [Object] hash of errors
      updateErrors: (errors) ->
        $('.error').remove()
        if errors?
          _.each errors, (v, k) =>
            for error in v
              if k == 'port' || k == 'proto'
                k = 'service'

              name = "#{k}"
              $msg = $('<div />', class: 'error').text(error)
              $("[name='#{name}']", @el).addClass('invalid').parent('div').after($msg)