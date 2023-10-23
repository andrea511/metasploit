# This class performs fetching and record-keeping for a collection of Nexpose vulnerabilities
# and represents the vulns pulled from an {Mdm::NexposeConsole} at a particular point in time.
class ::Nexpose::Data::ImportRun < ApplicationRecord

  include TransactionHandler

  CACHE_EXPIRATION = 6 # minutes

  #
  # Associations
  #

  # @!attribute console
  #   The Nexpose console that this {ImportRun} is retrieving data from
  #
  #   @return [Mdm::NexposeConsole]
  belongs_to :console,
             class_name: "Mdm::NexposeConsole",
             foreign_key: :nx_console_id

  # @!attribute user
  #   The user responsible for this import
  #
  #   @return [Mdm::User]
  belongs_to :user,
             class_name: "Mdm::User"

  # @!attribute workspace
  #   The workspace/project to which this data will be scoped
  #
  #   @return [Mdm::Workspace]
  belongs_to :workspace,
             optional: true, # allow nil when used by wizard before workspace creation.
             class_name: "Mdm::Workspace"

  # @!attribute sites
  #   The Nexpose sites that this import run is pulling from
  #
  #   @return [Nexpose::Data::Site]
  has_many :sites,
           class_name: "::Nexpose::Data::Site",
           foreign_key: "nexpose_data_import_run_id"

  # @!attribute assets
  #   The Nexpose assets imported as part of this {ImportRun}
  #
  #   @return [Nexpose::Data::Asset]
  has_many :assets, through: :sites

  has_many :mdm_vulns,
           class_name: 'Mdm::Vuln',
           as: :origin


  #
  # Validations
  #

  validates :nx_console_id,
            numericality: true,
            presence: true

  ###

  #
  # State machine
  #

  state_machine :state, initial: :not_yet_started, use_transactions: false do
    state :not_yet_started
    state :acquiring_environment_data
    state :ready_to_import
    state :importing
    state :finished
    state :failed

    # The first few states (before importing data) do not require a database
    state all - [:not_yet_started, :acquiring_environment_data, :ready_to_import] do
      validates :workspace_id, :numericality => true, :presence => true
    end

    event :start do
      transition [:not_yet_started] => :acquiring_environment_data
    end

    event :next do
      transition [:acquiring_environment_data] => :ready_to_import
    end
    
    event :import do
      transition [:ready_to_import, :finished] => :importing, :if => :workspace_present?
    end
    
    event :finish do
      transition [:importing] => :finished
    end
    
    event :error do
      transition all => :failed
    end

    after_transition on: :start,  do: :get_sites_and_scan_templates
    after_transition any => :importing, :do => :start_import
  end
  
  # TODO: this needs use_transactions: false, 
  # but use_transaction is broken with active record
  state_machine :import_state, initial: :not_yet_started, namespace: :import, use_transactions: false do
    state :not_yet_started
    state :acquiring_data do
      def run
        #NO-OP
      end
    end
    state :acquiring_assets do
      def run
        get_assets
      end
    end
    state :acquiring_vulnerabilities do
      def run
        get_vulnerabilities
      end
    end
    state :acquiring_vulnerability_instances do
      def run
        get_vulnerability_instances
      end
    end
    state :acquiring_exploit_data
    state :acquiring_exploit_and_references_data do
      def run
        get_exploits_and_refs
      end
    end
    state :finished
    state :failed
    
    event :start do
      transition [:not_yet_started, :finished] => :acquiring_data
    end
    
    event :next do
      transition :not_yet_started => :acquiring_data,
                 :acquiring_data => :acquiring_assets,
                 :acquiring_assets => :acquiring_vulnerabilities,
                 :acquiring_vulnerabilities => :acquiring_vulnerability_instances,
                 :acquiring_vulnerability_instances => :acquiring_exploit_and_references_data,
                 :acquiring_exploit_and_references_data => :finished
    end

    event :error do
      transition all => :failed
    end

    after_transition any => :finished, :do => :finish
    
  end

  attr_accessor :report_proc
  
  delegate :get, to: :console, prefix: true

  # Limits the scope of the ImportRun to the given site IDs
  # @param [Array<Integer>] limit_sites the Sites to import
  # @return [Array<Nexpose::Data::Site>]
  def choose_sites(limit_sites)
    sites.where('id NOT IN (?)', limit_sites).destroy_all
    sites.reload
  end

  # Perform import of all types
  # @return[void]
  def get_all
    while can_next_import?
      begin
        reload  #(ugh)
        run
      rescue NoMethodError
      end
      next_import!
    end
  end

  private

  # Perform import of all {Nexpose::Data::Asset} objects
  # @return[void]
  def get_assets
    sites.find_each do |site|
      site.report_proc = report_proc
      site.get_assets
    end
  end

  # Perform import of all {Nexpose::Data::Exploit} and {Nexpose::Data::VulnerabilityDefinition} objects
  # @return[void]
  def get_exploits_and_refs
    console.report_proc = report_proc

    vuln_def_ids = ::Nexpose::Data::VulnerabilityDefinition.pluck(:vulnerability_definition_id)

    requests = vuln_def_ids.collect do |vuln_def_id|
      [
       {resource: "vulnerability_definitions/#{vuln_def_id}/exploits", params: {}},
       {resource: "vulnerability_definitions/#{vuln_def_id}/vulnerability_references", params: {}}
      ]
    end.flatten
    
    console.get_batch(requests) do |response|
      vuln_def_id = response["url"][/vulnerability_definitions\/(.*)\/(exploits|vulnerability_references)/,1]
      vuln_def = ::Nexpose::Data::VulnerabilityDefinition.where(:vulnerability_definition_id => vuln_def_id).first


      response["resources"].each do |response_attributes|
        if response["url"][/exploits/]
          retry_transaction do
            exploit = ::Nexpose::Data::Exploit.object_from_json(response_attributes)
            vuln_def.exploits << exploit unless vuln_def.exploits.include?(exploit)
          end
        elsif response["url"][/vulnerability_references/]
          retry_transaction do
            vuln_ref = vuln_def.vulnerability_references.object_from_json(response_attributes)
          end
        end
      end
    end
    finish_import!
  end

  # Perform import of all {Nexpose::Data::Site} and {Nexpose::Data::ScanTemplate} objects
  # @return[void]
  def get_sites_and_scan_templates
    console.report_proc = report_proc
    console_get("sites", {"expand" => "summary"}) do |response|
      response["resources"].each do |site_attributes|
        retry_transaction do
          site = sites.object_from_json(site_attributes)
        end
      end
    end
    console.get_scan_templates
    next!
  end

  # Perform import of all {Nexpose::Data::Vulnerability} objects
  # @return[void]
  def get_vulnerabilities
    sites.find_each do |site|
      site.report_proc = report_proc
      site.get_vulnerabilities
    end
  end

  # Perform import of all {Nexpose::Data::VulnerabilityInstance} objects
  # @return[void]
  def get_vulnerability_instances
    sites.find_each do |site|
      site.report_proc = report_proc
      site.get_vulnerability_instances
    end
  end

  # Helper method for state transition to start importing assets
  # @return [Boolean] the ImportRun is attached to a valid workspace
  def workspace_present?; self.workspace.present?; end

end
