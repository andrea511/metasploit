# This class corresponds to a Nexpose site, which is NX's primary way of collecting together assets
# in a logical (and frequently geographical) way.
class ::Nexpose::Data::Site < ApplicationRecord
  self.inheritance_column = :_type_disabled

  include Metasploit::Model::Search
  include TableResponder::UiScopes
  include TransactionHandler

  #
  # Associations
  #

  # @!attribute import_run
  #   The logical container representing the discreet import this {Site} is part of
  #
  #   @return [Nexpose::Data::ImportRun]
  belongs_to :import_run,
             class_name: "::Nexpose::Data::ImportRun",
             foreign_key: "nexpose_data_import_run_id"

  # @!attribute assets
  #   The {Nexpose::Data::Asset} objects that this {Site} contains
  #
  #   @return [ActiveRecord::Relation<Nexpose::Data::Asset>]
  has_and_belongs_to_many :assets,
           class_name: "::Nexpose::Data::Asset",
           association_foreign_key: "nexpose_data_asset_id",
           foreign_key: "nexpose_data_site_id"

  # @!attribute exceptions
  #   The exception objects that have been created for this site
  #
  #   @return [ActiveRecord::Relation<Nexpose::Result::Exception>]
  has_many :exceptions,
           class_name: "::Nexpose::Result::Exception",
           as: :nx_scope

  #
  # Validations
  #
  validates :nexpose_data_import_run_id,
            numericality: true,
            presence: true

  validates :site_id,
            presence: true,
            uniqueness: { scope: :nexpose_data_import_run_id }

  validates :name,
            presence: true


  serialize :summary

  scope :site_id, lambda { |site_id| where(site_id: site_id) }

  attr_accessor :report_proc

  delegate :console_get, to: :import_run



  #
  # Search Attributes
  #
  search_attribute :name,
                   type: :string


  #
  # Rails 4 compatibility, manually create accessible attributes
  #
  ACCESSIBLE_ATTRS = [
    'description',
    'importance',
    'last_scan_date',
    'last_scan_id',
    'name',
    'next_scan_date',
    'site_id',
    'summary',
    'type'
  ]

  # A Ruby representation of the object retrieved from the Nexpose API
  # @param object_attributes [Hash] the deserialized JSON
  # @returns[::Nexpose::Data::Site]
  def self.object_from_json(object_attributes)
    site_attributes = object_attributes.slice(*ACCESSIBLE_ATTRS)
    site            = self.site_id(object_attributes["site_id"]).first_or_create(site_attributes)
    site
  end

  # Perform a fetch of vulnerabilities from Nexpose and create {Nexpose::Data::Vulnerability} objects
  # @return[void]
  def get_vulnerabilities
    import_run.console.report_proc = report_proc
    console_get("sites/#{site_id}/vulnerabilities", request_params("expand" => "definition")) do |response|
      response["resources"].each do |vuln_attributes|
        vulnerability = ::Nexpose::Data::Vulnerability.object_from_json(vuln_attributes)
        vulnerability
      end
    end
  end

  # Perform a fetch of assets from Nexpose and create {Nexpose::Data::Asset} objects
  # @return[void]
  def get_assets
    import_run.console.report_proc = report_proc
    console_get("sites/#{site_id}/assets", {:per_page => 100}) do |response|
      response["resources"].each do |asset_attributes|

        asset = ::Nexpose::Data::Asset.import_runs.import_run_id(import_run.id).asset_id(asset_attributes["asset_id"]).
            object_from_json(asset_attributes)

        #Sometimes Nexpose API sends duplicate assets due to paging in large sites
        unless assets.include?(asset)

          # Get all the Nexpose asset services to merge later
          # into Mdm host services
          get_services(asset_attributes["asset_id"]).each do |s|
            service = ::Nexpose::Data::Service.where(
              nexpose_data_asset_id: asset.id,
              port: s["port"],
              proto: s["protocol"].downcase,
              name: s["name"].downcase).first_or_create
          end
          assets << asset
          report_proc.call(:assets_added, { :count => 1, :asset => asset }) if report_proc
        else
          report_proc.call(:warning, {
            :message => "Warning: Duplicate (asset, site), (#{asset.id}, #{self.id})... Skipping..."
          }) if report_proc
        end

        asset
      end
    end
    self.save
  end

  def get_services(asset_id)
    console_get("assets/#{asset_id}/services")
  end

  # Perform a fetch of vulnerability instances from Nexpose and create {Nexpose::Data::VulnerabilityInstance} objects
  # @return[void]
  def get_vulnerability_instances
    import_run.console.report_proc = report_proc
    console_get("sites/#{site_id}/vulnerability_instances", request_params) do |response|
      response["resources"].each do |vuln_inst_attributes|
        asset                  = assets.asset_id(vuln_inst_attributes["asset_id"]).first
        vulnerability_instance = asset.vulnerability_instances.object_from_json(vuln_inst_attributes)

        vulnerability                        = ::Nexpose::Data::Vulnerability.vulnerability_id(vuln_inst_attributes["vulnerability_id"]).first
        vulnerability_instance.vulnerability = vulnerability
        is_new_record                        = vulnerability_instance.new_record?

        if vulnerability_instance.save and is_new_record and report_proc
          report_proc.call(:vulns_added, { :count => 1 })
        end

        vulnerability_instance
      end
    end
  end

  # Parameters to use in the request
  # @param options[Hash] Any optional request parameters
  # @return[Hash]
  def request_params(options = {})
    params = options.dup
    if import_run.metasploitable_only?
      params.merge!({
                      "vulnerability_exposures" => "metasploit_exploits"
                    })
    end
    params
  end

end
