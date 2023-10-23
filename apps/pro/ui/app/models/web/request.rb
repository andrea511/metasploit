# Either a manual web request made by a user in the request collector or cross-site scripting frame or an automated
# request created by a future automated tool.
class Web::Request < ApplicationRecord

  #
  # CONSTANTS
  #

  METHODS = [
      'DELETE',
      'GET',
      'PATCH',
      'POST',
      'PUT'
  ]

  #
  #
  # Associations
  #
  #

  has_many :transmitted_headers, 
           :class_name => "Web::TransmittedHeader", 
           :dependent => :destroy, 
           :foreign_key => :request_id

  has_many :transmitted_cookies, 
           :class_name => "Web::TransmittedCookie", 
           :dependent => :destroy, 
           :foreign_key => :request_id

  # @!attribute [rw] cookies
  #   @return [Array<Web::Cookie>] cookies sent with this request in the Cookie header.
  has_many :cookies, 
           :through => :transmitted_cookies,
           :class_name => 'Web::Cookie',
           :source => :cookie

  # @!attribute [rw] headers
  #   @return [Array<Web::Header>] headers sent with this request, not including the Cookie header, which is broken out
  #     into individual {#cookies}.
  has_many :headers,
           -> { order(:position) },
           :through => :transmitted_headers,
           :class_name => 'Web::Header'

  # @!attribute [rw] parameters
  #   @return [Array<Web::Parameter] parameters sent with the request.  The send format of the rendered request varies
  #     based on the {#method}.
  has_many :parameters,
           -> { order(:position) },
           :class_name => 'Web::Parameter',
           :dependent => :destroy,
           :foreign_key => :request_id do
    def to_hash
      hash = {}

      each do |parameter|
        name = parameter.name
        new_value = parameter.value
        current_value = hash[name]

        # no other values so far
        if current_value.nil?
          hash[name] = new_value
        # two or more values so far
        elsif current_value.is_a? Array
          current_value << new_value
        # one value so far
        # convert from String value to Array<String> value
        else
          hash[name] = [current_value, new_value]
        end
      end

      hash
    end

    def to_query
      hash = to_hash
      encoded = hash.to_query

      encoded
    end
  end

  # @!attribute [rw] virtual_host
  #   @return [Web::VirtualHost] the virtual host on the web server that is being requested.
  belongs_to :virtual_host, :class_name => 'Web::VirtualHost', optional: true

  # @!attribute [rw] vulns
  #   @return [Array<Mdm::WebVuln>] the vulns identified by this request or that are being verified by this request.
  has_many :vulns, :class_name => 'Mdm::WebVuln', :dependent => :destroy, :foreign_key => :request_id

  # @!attribute [rw] cross_site_scripting
  #   @return [Web::Attack::CrossSiteScripting] the cross site scripting attack that will be tried on the request.
  belongs_to :cross_site_scripting, :class_name => "Web::Attack::CrossSiteScripting", :foreign_key => "cross_site_scripting_id", optional: true

  # @!attribute [rw] request_group
  #   @return [Web::RequestGroup] the cross site scripting attack that will be tried on the request.
  belongs_to :request_group, :class_name => "Web::RequestGroup", :foreign_key => "request_group_id", optional: true

  #
  # Attributes
  #

  # @!attribute [rw] method
  #   @return [String] the HTTP Method of the request.  Will be from {METHODS}.

  # @!attribute [rw] path
  #   @return [String] path portion of the {#uri}.  Will never be `nil`, only `''` if there is no path.

  #
  # Validations
  #


  validates_associated :cross_site_scripting, :if => :attack_vector?

  validates :method,
            :inclusion => {
                :in => METHODS
            }
  validates :path,
            :format => {
                :with => /\A\Z|\A\/.*/
            }
  validates :virtual_host, :presence => true

  #
  # Methods
  #

  # Uses the URI to derive the {#virtual_host} and {#parameters} for a new {Web::Request}.
  #
  # @note This will create a {Web::VirtualHost} using {Web::VirtualHost.find_or_create_by_uri!} if a matching
  #   {Web::VirtualHost} does not already exist.
  #
  # @param uri [URI::HTTP, URI::HTTPS, #to_str] an unparsed URI string or a parsed URI object with a host, port, and
  #   scheme.  The URI query is only used if `:method` `attribute` is `'GET'`.
  # @param attributes [Hash] addition attributes for Mdm::Host that cannot be derived from the `uri`.
  # @option attributes [String] :encloser_type The class name of the encloser.
  # @option attributes [String] :escaper_type The class name of the escaper.
  # @option attributes [String] :evader_type The class name of the evader.
  # @option attributes [String] :executor_type The class name of the executor.
  # @option attributes [String] :method The HTTP Method of the request.  Must be one of the methods in {METHODS}.
  # @option attributes [Mdm::User] :user The user who is either manually making this request or started the automated
  #   requests.  This user must be able to use the workspace.
  # @option attributes [Integer, String] :user_id The ID of the Mdm::User.  `:user` will be favored over `:user_id`
  #   over `:user_id` since `:user` will contain an already resolved Mdm::User that does not require an additional
  #   query to the database.
  # @option attributes [Integer, String] :workspace_id The ID of the Mdm::Workspace in which the Mdm::Host is contained.
  # @return [Web::Request]
  # @raise (see Web::VirtualHost.find_or_create_by_uri!)
  # @raise [ActiveRecord::RecordInvalid] if :encloser_type is not a member of
  #   `Web::RequestEngine.part_class_names(:encloser)`
  # @raise [ActiveRecord::RecordInvalid] if :escaper_type is not a member of
  #   `Web::RequestEngine.part_class_names(:escaper)`
  # @raise [ActiveRecord::RecordInvalid] if :evader_type is not a member of
  #   `Web::RequestEngine.part_class_names(:evader)`
  # @raise [ActiveRecord::RecordInvalid] if :executor_type is not a member of
  #   `Web::RequestEngine.part_class_names(:executor)`
  # @raise [ActiveRecord::RecordInvalid] if {#user} is nil because :user is missing or :user_id does not resolve to an
  #    Mdm::User.
  # @raise [ActiveRecord::RecordInvalid] if {#workspace} is nil because :workspace is missing or :workspace_id does not
  #   resolve to an Mdm::Workspace.
  # @raise [ActiveRecord::RecordInvalid] if {#workspace} is not {Mdm::Workspace::Authorization#usable_by? usable_by?}
  #   {#user}.
  # @raise [KeyError] if `:method` is not in `attributes`.
  #
  # @see Web::VirtualHost.find_or_create_by_uri!
  # @see Mdm::Workspace::Authorization#usable_by?
  def self.create_by_uri!(uri, attributes={})
    converted_uri = Web::URI.convert(uri)

    virtual_host = Web::VirtualHost.find_or_create_by_uri!(converted_uri, attributes)

    create_attributes = attributes.merge(
        :path => converted_uri.path,
        :virtual_host => virtual_host
    )

    # filter out attributes not on Web::Request that will cause an ActiveRecord::UnknownAttributeError.
    create_attributes.delete_if { |attribute_name, _|
      normalized_attribute_name = attribute_name.to_sym

      [:workspace, :workspace_id].include? normalized_attribute_name
    }

    request = create!(create_attributes)

    if request.method == 'GET' and converted_uri.query
      parsed_parameters = CGI.parse(converted_uri.query)

      parsed_parameters.each do |name, values|
        values.each do |value|
          request.parameters.create!(:attack_vector => false, :name => name, :value => value)
        end
      end
    end

    request
  end

  delegate :header, :to => :request_group, :allow_nil => true
  delegate :cookie, :to => :request_group, :allow_nil => true

  # The Mdm::Service#host of the {#virtual_host} {Web::VirtualHost#service service}.
  #
  # @return [Mdm::Host]
  # @return [nil] if {#service} is `nil` or {#service service's} Mdm::Service#host is `nil`
  delegate :host, :to => :service, :allow_nil => true

  # The {Web::VirtualHost#service} of the {#virtual_host}.
  #
  # @return [Mdm::Service]
  # @return [nil] if {#virtual_host} is `nil` or {#virtual_host virtual_host's} {Web::VirtualHost#service service} is
  #   `nil`.
  delegate :service, :to => :virtual_host, :allow_nil => true

  # Return a URI object equivalent to the browser URI entered to generate this request that includes a
  # URI::Generic#query if {#method} is `'GET'`.
  #
  # @return [URI::HTTP] if {#virtual_host}'s {Web::VirtualHost#service service's} Mdm::Service#name is `'http'`.
  # @return [URI::HTTPS] if {#virtual_host}'s {Web::VirtualHost#service service's} Mdm::Service#name is `'https'`.
  # @return [nil] if {#virtual_host} is `nil`.
  def uri
    uri = nil

    if virtual_host
      uri = virtual_host.uri
      uri.path = path

      # add in {#parameters} as query only if {#method} is GET
      if method == 'GET'
        uri.query = parameters.to_query
      end
    end

    uri
  end

  # The workspace of this request
  #
  # @return [Mdm::Workspace]
  # @return [nil] if {#request_group} is `nil` or {#host host's} Mdm::Host#workspace is `nil`.
  delegate :workspace, :to => :request_group, :allow_nil => true

  def hostname
    hostname = "#{uri.scheme}://#{uri.host}"
    unless [80,443].include?(uri.port)
      hostname << ":#{uri.port}"
    end
    hostname
  end
end
