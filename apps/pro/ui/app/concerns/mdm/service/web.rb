module Mdm::Service::Web
  extend ActiveSupport::Concern

  #
  # CONSTANTS
  #

  # The Mdm::Service#proto for {Web}, such as in {Mdm::Service::Web::ClassMethods#find_or_create_by_uri!}.
  WEB_PROTO = 'tcp'

  module ClassMethods
    # Uses the uri.scheme to find the Mdm::Service#name, and uri.port to find the Mdm::Service#port.  uri.host is
    # automatically resolved to an address to find the Mdm::Host#address.
    #
    # @param uri [URI::HTTP, URI::HTTPS, #to_str] an unparsed URI string or a parsed URI object that has a host, port
    #   and scheme.
    # @param attributes [Hash] addition attributes for Mdm::Host that cannot be derived from the `uri`.
    # @option attributes [Integer] :workspace_id The ID of the Mdm::Workspace in which the Mdm::Host is contained.
    # @raise [ActiveRecord::RecordInvalid] if created Mdm::Service is invalid because of missing fields in the URI
    #   object.
    # @raise (see Mdm::Host::Web::ClassMethods#find_or_create_by_uri!)
    #
    # @see Mdm::Host::Web#find_or_create_by_uri!
    # @see Web::URI.convert
    def find_or_create_by_uri!(uri, attributes={})
      converted_uri = Web::URI.convert(uri)
      service = nil

      transaction do
        host = Mdm::Host.find_or_create_by_uri!(converted_uri, attributes)
        query = where(
            :host_id => host.id,
            :name => converted_uri.scheme,
            :port => converted_uri.port,
            :proto => WEB_PROTO
        )

        service = query.first_or_create!
      end

      service
    end
  end

  included do
    #
    # Associations
    #
    has_many :web_virtual_hosts, :class_name => 'Web::VirtualHost', :dependent => :destroy
  end
end
