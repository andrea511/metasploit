# This class represents a networked device tracked by a Nexpose instance. It is imported over
# an active connection to an {Mdm::NexposeConsole} as part of activity tracked by an associated
# {Nexpose::Data::ImportRun}.
class ::Nexpose::Data::Asset < ApplicationRecord

  include TransactionHandler

  #
  # Associations
  #

  # @!attribute site
  #   The Nexpose site this asset belongs to
  #
  #   @return [Nexpose::Data::Site]
  has_and_belongs_to_many :sites,
             class_name: "::Nexpose::Data::Site",
             association_foreign_key: "nexpose_data_site_id",
             foreign_key: "nexpose_data_asset_id"

  # @!attribute exceptions
  #   The exception objects that have been created for this asset
  #
  #   @return [ActiveRecord::Relation<Nexpose::Result::Exception>]
  has_many :exceptions,
           class_name: "::Nexpose::Result::Exception",
           as: :nx_scope

  # @!attribute ip_addresses
  #   The IP addresses associated with this Asset
  #
  #   @return [ActiveRecord::Relation<Nexpose::Data::IpAddress>]
  has_many :ip_addresses,
           class_name: "::Nexpose::Data::IpAddress",
           foreign_key: :nexpose_data_asset_id

  # @!attribute services
  #   The services associated with this Asset
  #
  #   @return [ActiveRecord::Relation<Nexpose::Data::Service>]
  has_many :services,
           class_name: "::Nexpose::Data::Service",
           foreign_key: :nexpose_data_asset_id


  # @!attribute mdm_hosts
  #   The Metasploit host objects that correspond to this asset
  #
  #   @return [ActiveRecord::Relation<Mdm::Host>]
  has_and_belongs_to_many :mdm_hosts,
           class_name: "Mdm::Host",
           association_foreign_key: "nexpose_data_asset_id",
           foreign_key: "host_id"


  # @!attribute vulnerability_instances
  #   The Nexpose-tracked instances of particular vulnerabilities found on this asset
  #
  #   @return [ActiveRecord::Relation<Nexpose::Data::VulnerabilityInstance>]
  has_many :vulnerability_instances,
           class_name: "::Nexpose::Data::VulnerabilityInstance",
           foreign_key: :nexpose_data_asset_id

  #
  # Nested Attributes
  #
  accepts_nested_attributes_for :ip_addresses

  #
  # Attributes
  #

  # @!attribute asset_id
  #   The primary key for this asset in the Nexpose instance's database
  #   @return [String]

  # @!attribute host_names
  #   The serialized host names on this asset
  #   @return [String]
  serialize :host_names, Array

  # @!attribute last_scan_date
  #   The date and time of the last scan of this asset by Nexpose
  #   @return [DateTime]

  # @!attribute last_scan_id
  #   The Nexpose database primary key of the last scan of this asset
  #   @return [Integer]

  # @!attribute mac_addresses
  #   The serialized Media Access Control addresses (http://en.wikipedia.org/wiki/MAC_address)
  #   known to Nexpose for this asset
  #   @return [String]
  serialize :mac_addresses, Array

  # @!attribute next_scan_date
  #   The date and time of the next scheduled scan of this asset
  #   @return [DateTime]

  # @!attribute os_name
  #   The operating system this asset is running
  #   @return [String]

  #
  # Scopes
  #

  scope :asset_id, lambda {|asset_id| where(asset_id: asset_id) }
  scope :last_scan_id, lambda {|last_scan_id| where(last_scan_id: last_scan_id)}
  scope :import_run_id, lambda{|import_run_id| where(nexpose_data_import_runs: {id: import_run_id})}
  scope :import_runs, -> {
          joins(
            ::Nexpose::Data::Asset.join_association(:sites),
            ::Nexpose::Data::Site.join_association(:import_run)
          )
  }


  #
  # Attribute Validations
  #
  validates :asset_id, presence: true

  #
  # Rails 4 compatibility, manually create accessible attributes
  #
  ACCESSIBLE_ATTRS = [
    'asset_id',
    'host_names',
    'ip_addresses_attributes',
    'last_scan_date',
    'last_scan_id',
    'mac_address',
    'mac_addresses',
    'next_scan_date',
    'os_name',
    'url'
  ]


  # @returns[::Nexpose::Data::Asset] a valid ::Nexpose::Data::Asset made from the json hash
  # we get from nexpose
  def self.object_from_json(object_attributes)
    asset_attributes         = object_attributes.slice(*ACCESSIBLE_ATTRS)
    ip_addresses_attributes  = object_attributes["addresses"].collect {|address| {"address" => address} }
    asset_attributes["ip_addresses_attributes"] = ip_addresses_attributes
    asset  = first_or_create(asset_attributes)
    asset
  end

  # Iterate over the Asset's collection of ::Nexpose::Data::Vulnerability objects, find Asset's previously saved
  # Mdm::Host objects whose IP address matches the ::Nexpose::Data::Vulnerability#asset_ip_address
  # and create Mdm::Services, using +name+ and +port+ as uniqueness keys. Then create matching Mdm::Vuln
  # objects on the found-or-created Mdm::Service.
  #
  # @param mrefs [Map<String, Array<Module>>] a map of reference keys to modules
  # @param mports [Map<Integer, Array<Module>>] a map of ports to modules
  # @param mservs [Map<Integer, Array<Module>>] a map of service protocols to modules
  # @return [Hash]
  #   * :success [Boolean] whether vulns/services created
  #   * :reason [String] reason if success is false, defaults to empty string
  #   * :new_vulns [Array<Mdm::Vuln>] vulns created for the asset
  #
  def create_services_and_vulns_for_mdm_hosts(mrefs = {}, mports = {}, _mservs = {})
    ret = {
      success: false,
      reason: "",
      new_vulns: []
    }

    metasploitable_only = self.sites.last.import_run.metasploitable_only?

    # returning nil if no hosts created for this asset
    unless mdm_hosts.present?
      ret[:reason] = "No hosts for this asset have been created"
      return ret
    end

    if vulnerability_instances.nil? || vulnerability_instances.empty?
      ret[:reason] = "Hosts do not have any vulns"
      return ret
    end

    unique_vuln_def_with_ports = []
    # I'm sure there is a better "Rails" way to do this.
    vulnerability_instances.with_real_ports.each do |vi|
      unique_vuln_def_with_ports << vi.vulnerability.vulnerability_id
    end

    # I hate special cases:
    #    139 is not longer a preferred default
    #    25 is deferred due to shellshock being more likely on other ports
    deferred_service_ports = [ 139, 25 ]

    vulnerability_instances.each do |vi|
      retry_transaction do
        if vi.port == -1
          # Filter for vulns that have been reported with and without ports.
          next if unique_vuln_def_with_ports.include?(vi.vulnerability.vulnerability_id)
          refs = []
          vuln_def = vi.vulnerability.vulnerability_definition
          vuln_def.vulnerability_references.each do |vuln_ref|
            if vuln_ref.ref_lookup
              ref = Mdm::Ref.where(:name => vuln_ref.ref_lookup).first_or_create
              refs << ref
            end
          end
          matched = mrefs.values_at(*(refs.map { |x| x.name.upcase } & mrefs.keys)).map { |x| x.values }.flatten.uniq
          next if matched.empty?
          match_names = []
          matched.each do |mod|
            match_names << mod.fullname
          end

          second_pass_services = []

          services.each do |service|
            if deferred_service_ports.include?(service.port)
              second_pass_services << service
              next
            end
            if mports[service.port]
              if (match_names - mports[service.port].keys).count < match_names.count
                vi.port = service.port # this modifies the vuln instances in place, not sure how "safe" we should consider this 
                vi.protocol = service.proto
                vi.service = service.name
                vi.save
                break
              end
            end
          end
          # post process any deferred services if no match has been found
          if vi.service.nil? && !second_pass_services.empty?
            second_pass_services.each do |service|
              if mports[service.port]
                if (match_names - mports[service.port].keys).count < match_names.count
                  vi.port = service.port
                  vi.protocol = service.proto
                  vi.service = service.name
                  vi.save
                  break
                end
              end
            end
          end
        end
      end
    end

    # returning nil if this host doest have any vulns with real ports and it is exploitable
    if metasploitable_only and vulnerability_instances.with_real_ports.blank?
      ret[:reason] = "Hosts do not have any vulns with valid ports"
      return ret
    end

    new_vulns = []

    # creating mdm vulns for each vuln nexpose found with real ports if metasploitable_only
    vuln_instances = metasploitable_only ? vulnerability_instances.with_real_ports : vulnerability_instances

    vuln_instances.find_each do |vi|
      retry_transaction do
        host         = mdm_hosts.where(address: vi.asset_ip_address).first

        next unless host && host.nexpose_assets.include?(self)
        next unless vi.vulnerability && vi.vulnerability.vulnerability_definition
        vuln_def     = vi.vulnerability.vulnerability_definition
        trunc_title  = vuln_def.title[0..254]


        #Nexpose treats a vuln with no "real port" as having a port of -1 :-/
        if vi.port == -1
          vuln = host.vulns.where(:name => trunc_title).first_or_create(
            name: trunc_title,
            info: vuln_def.description,
            nexpose_vulnerability_definition: vuln_def
          )
        else
          vuln_service = host.services.where(:proto => vi.protocol, :port => vi.port).first_or_create(
            port:  vi.port,
            name:  vi.service.downcase,
            state: "open",       # If NX found a vuln on it, the service is 'open' as far as Nmap is concerned
            proto: vi.protocol
          )

          vuln = vuln_service.vulns.where(:name => trunc_title).first_or_create(
            host: host,
            name: trunc_title,
            info: vuln_def.description,
            nexpose_vulnerability_definition: vuln_def
          )
        end

        vuln.origin = self.sites.last.import_run

        vuln_def.vulnerability_references.each do |vuln_ref|
          if vuln_ref.ref_lookup
            ref = Mdm::Ref.where(:name => vuln_ref.ref_lookup).first_or_create
            vuln.refs << ref
          end
        end

        vuln.save
        new_vulns << vuln
      end
    end

    # merge Nexpose asset services into Mdm host services
    asset_ip = self.ip_addresses.first.address
    self.services.each do |asset_service|
      host = mdm_hosts.where(address: asset_ip).last

      host.services.where(:proto => asset_service.proto, :port => asset_service.port).first_or_create(
        port:  asset_service.port,
        proto: asset_service.proto,
        name:  asset_service.name,
        state: "open"
      )
    end

    ret[:success] = true
    ret[:new_vulns] = new_vulns
    ret
  end

  # An array of valid {Mdm::Host} objects made from corresponding {Asset} data
  # and scoped to the same {Mdm::Workspace} as the parent {Nexpose::Data::ImportRun object}.
  # Since an Asset on the Nexpose side can have multiple IPs, we have one {Mdm::Host} per.
  # @param blacklist [Array<String>] an array of blacklist ip strings
  # @return [Array<Mdm::Host>]
  def to_mdm_hosts(blacklist=[])
    ip_addresses.pluck(:address).collect do |ip|
      unless blacklist.include? ip.to_s
        retry_transaction do
          host = Mdm::Host.where(
            address: ip,
            workspace_id: sites.first.import_run.workspace_id,
          ).
            first_or_create(
            name: host_names.first,
            mac:  mac_addresses.first,
            os_name: os_name,
            state: "alive"
          )

          self.mdm_hosts << host unless self.mdm_hosts.include?(host)
        end
      end
    end
    self.save
    self.mdm_hosts
  end


  # A string representation of the asset: a hostname if there is one, otherwise
  # the first IP.
  # @return[String]
  def to_s
    if host_names.any? && !host_names.first.blank? && !os_name.blank?
      "#{host_names.first} - #{os_name}"
    elsif host_names.any?
      host_names.first
    elsif ip_addresses.any? && !os_name.blank?
      "#{ip_addresses.first.address} - #{os_name}"
    else
      ip_addresses.first.address
    end
  end
end
