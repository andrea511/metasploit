module Mdm::Host::Web
  extend ActiveSupport::Concern

  module ClassMethods
    # `uri.host` is automatically resolved to an address to find the Mdm::Host#address.
    #
    # @param uri [URI::HTTP, URI::HTTPS] an unparsed URI string or a parsed URI object that has a host.
    # @param attributes [Hash] addition attributes for Mdm::Host that cannot be derived from the `uri`.
    # @option attributes [Integer] :workspace_id The ID of the Mdm::Workspace in which the Mdm::Host is contained.
    # @return [Mdm::Host]
    # @raise [ActiveRecord::RecordInvalid] if created Mdm::Host is invalid because of `nil` `host` field in the URI
    #   object.
    # @raise [KeyError] if `:workspace_id` is missing from `attributes`.
    #
    # @see Web::URI.convert
    def find_or_create_by_uri!(uri, attributes={})
      converted_uri = Web::URI.convert(uri)

      address = Rex::Socket.getaddress(converted_uri.host)

      workspace_id = attributes.fetch(:workspace_id)
      host = where(:address => address, :workspace_id => workspace_id).first_or_create!

      host
    end
  end
end