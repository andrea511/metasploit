define [
  'jquery'
  'base_itemview'
  'apps/vulns/show/templates/comment_view'
  'entities/note'
], ($) ->
  @Pro.module "Components.Comment", (Comment, App, Backbone, Marionette, $, _) ->

    #
    # Comment View
    #
    class Comment.View extends App.Views.Layout
      template: @::templatePath('vulns/show/comment_view')
      className: 'comment-view'

      ui:
        comment: 'textarea'
        error: '.error'

      triggers:
        'mouseout @ui.comment': 'center'

      # Get comment from ui
      #
      # @return [String] jQuery promise
      getComment: ->
        @ui.comment.val()

      # Interface method required by {Components.Modal}
      #
      # @return [Promise] jQuery promise
      onFormSubmit: () ->
        # jQuery Deferred Object that closes modal when resolved.
        defer = $.Deferred()
        defer.promise()

        commentModel = App.request 'new:note:entity', {
          data:
            comment:@ui.comment.val()
          workspace_id: WORKSPACE_ID
          type: @model.get('type')
          type_id: @model.get('type_id')
        }
        commentModel.save({},
          # Set comment on view's comment model
          #
          # @param [Object] :model The new comment model
          # @option model :data [Object] The new comment data
          # @option data :comment [String] The new comment
          success: (model) =>
            @model.set('data',{
              comment: model.get('data').comment
            })
            defer.resolve()
          error: (model,response) =>
            @ui.error.html(response.responseJSON.error.data[0])
            @ui.error.show()
        )
        defer