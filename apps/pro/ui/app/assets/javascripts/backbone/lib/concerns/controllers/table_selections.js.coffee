define [], ->
  @Pro.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->
    #
    # Methods that pertain to the selection state of a table. These rely on certain
    # values to be within scope at the time they are called. Eventually, these should
    # live inside of the table component itself.
    #
    Concerns.TableSelections =

      #
      # Determine whether or not multiple items in the table are currently selected.
      #
      # @return [Boolean] true if multiple are selected, false otherwise
      multipleSelected: () ->
        @selectAllState || @selectedIDs.length > 1

      #
      # Return the plural version of a message if multiple items are selected,
      # and the singular version otherwise.
      #
      # @param [String] singularVersion the singular version of the message
      # @param [String] pluralVersion the pluralized version of the message
      #
      # @example Basic usage
      #   "Credential#{ @pluralizedMessage '', 's' } deleted"
      #
      # @return [String] the correct version of the message
      pluralizedMessage: (singularVersion, pluralVersion) ->
        if @multipleSelected() then pluralVersion else singularVersion
