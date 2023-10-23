define [
  'jquery'
], ($) ->
  class BannerMessageCollection extends Backbone.Collection
    url: '/banner_messages.json'