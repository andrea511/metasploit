# The Web::VirtualHost host class is used to help with the problem that Mdm::Host only tracks the address of a host
# (Mdm::Host#virtual_host does exist, but it means the virtual machine host, like 'VMWare') while Mdm::Service tracks
# the port and scheme (through Mdm::Service#name), so there is no way to specify a particular virtual hosts on the a
# given host web server that's on the same port and scheme.
#
# To properly use Rex::Socket's pivoting switchboard, the Mdm::Host address (accessible as `service.host.address`) must
# be used along with the virtual host {#name} as currently the Rex switchboard does not have support for DNS lookup, so
# the IP must be explicit to use the pivot.
class Web::VirtualHost < ApplicationRecord

  #
  # CONSTANTS
  #

  # Maps the Mdm::Service#name to the scheme-specific URI::Generic subclass that should be used for {#uri}
  URI_CLASS_BY_SERVICE_NAME = {
      'http' => URI::HTTP,
      'https' => URI::HTTPS
  }

  #
  # Associations
  #

  # @!attribute [rw] requests
  #   @return [Array<Web::Request>] requests made to this virtual host.
  has_many :requests, :class_name => 'Web::Request', :dependent => :destroy

  # @!attribute [rw] service
  #   @return [Mdm::Service] Tracks the scheme ('http' or 'https') in Mdm::Service#name and the port in
  #     Mdm::Service#port.
  belongs_to :service, :class_name => 'Mdm::Service'

  #
  # Attributes (so yard can link to column attributes)
  #

  # @!attribute [rw] name
  #   @return [String] The virtual host name.

  #
  # Validations
  #

  validates :name,
            :presence => true,
            :uniqueness => {
                :scope => :service_id
            }
  validates :service, :presence => true

  #
  # Methods
  #


  # Uses the uri.host to find the {Web::VirtualHost#name}, uri.scheme to find the Mdm::Service#name, and uri.port to
  # find the Mdm::Service#port.  uri.host is automatically resolved to an address to find the Mdm::Host#address.
  #
  # @param uri [URI::HTTP, URI::HTTPS, #to_str] an unparsed URI string or a parsed URI object that has a host, port
  #   and scheme
  # @param attributes [Hash] addition attributes for Mdm::Host that cannot be derived from the `uri`.
  # @option attributes [Integer] :workspace_id The ID of the Mdm::Workspace in which the Mdm::Host is contained.
  # @return [Web::VirtualHost]
  # @raise [ActiveRecord::RecordInvalid] if created Mdm::VirtualHost is invalid because of `nil` `host` in the URI
  #   object.
  # @raise (see Mdm::Service::Web::ClassMethods#find_or_create_by_uri!)
  #
  # @see Mdm::Service::Web#find_or_create_by_uri!
  def self.find_or_create_by_uri!(uri, attributes)
    converted_uri = Web::URI.convert(uri)
    virtual_host = nil

    transaction do
      service = Mdm::Service.find_or_create_by_uri!(converted_uri, attributes)

      virtual_host = where(:name => converted_uri.host, :service_id => service.id).first_or_create!
    end

    virtual_host
  end

  # Return URI with `host` derived from {#name}, `port` derived from {#service service's} Mdm::Service#port, and `scheme`
  # derived from {#service service's} Mdm::Service#name.
  #
  # @return [URI::HTTP] if {#service service's} Mdm::Service#name is 'http'.
  # @return [URI::HTTPS] if {#service service's} Mdm::Service#name is 'https'.
  # @return [nil] if {#service} is nil or {#service service's} Mdm::Service#name is not in {URI_CLASS_BY_SERVICE_NAME}.
  def uri
    uri = nil

    if service
      uri_class = URI_CLASS_BY_SERVICE_NAME[service.name]

      if uri_class
        uri = uri_class.build(
            :host => name,
            :port => service.port
        )
      end
    end

    uri
  end
end
