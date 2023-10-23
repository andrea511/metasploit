# An intermediary data-store for containing the configs of different
# Tasks needed by the VulnValidation wizard.
class Wizards::VulnValidation::Form < Wizards::BaseForm

  #
  # Constants
  #

  NEXPOSE_GATHER_TYPES = {
    import: 'Import existing Nexpose vulnerability data',
    scan: 'Start a Nexpose scan to get data'
  }
  VULN_VALIDATION_REPORT_TYPES = [:audit, :compromised_hosts]

  #
  # TaskConfig/Model attributes (represent subtasks/models of the wizard)
  #

  # @attr [CleanupTask] cleanup_task
  attr_accessor :cleanup_task

  # @attr [CollectEvidenceTask] collect_evidence_task
  attr_accessor :collect_evidence_task

  # @attr [Mdm::Tag] custom_tag
  attr_accessor :custom_tag

  # @attr [ExploitTask] exploit_task
  attr_accessor :exploit_task

  # @attr [NexposeTask] nexpose_scan_task
  attr_accessor :nexpose_scan_task

  # @attr [Array<Integer>] nexpose_sites ids of ::Nexpose::Data:Sites
  attr_accessor :nexpose_sites

  # @attr [Report] report
  attr_accessor :report

  # @attr [Mdm::Workspace] workspace
  attr_accessor :workspace

  #
  # "Glue" attributes
  #

  # @attr [Boolean] cleanup_enabled should clean up extra sessions
  attr_accessor :cleanup_enabled

  # @attr [Boolean] collect_evidence should run CollectTask after running Exploit
  attr_accessor :collect_evidence

  # @attr [Integer] import_run_id
  attr_accessor :import_run_id

  # @attr [Integer] nexpose_console_id containing ID for the Mdm::NexposeConsole to use
  attr_accessor :nexpose_console_id

  # @attr [Boolean] report_enabled
  attr_accessor :report_enabled

  # @attr [String] nexpose_gather_type import|scan. @see NEXPOSE_GATHER_TYPES
  attr_accessor :nexpose_gather_type

  # @attr [String] report_type
  attr_accessor :report_type

  # @attr [Boolean] tag_by_os
  attr_accessor :tag_by_os

  # @attr [Boolean] tagging_enabled TODO REMOVE ME
  attr_accessor :tagging_enabled

  # @attr [Boolean] use_custom_tag
  attr_accessor :use_custom_tag


  def initialize(attrs={})
    super
    self.report_enabled = set_default_boolean(attrs[:report_enabled], false)
    self.tagging_enabled = set_default_boolean(attrs[:tagging_enabled], false)
    self.use_custom_tag = set_default_boolean(attrs[:use_custom_tag], false)
    self.tagging_enabled = set_default_boolean(attrs[:tagging_enabled], false)
    self.collect_evidence = set_default_boolean(attrs[:collect_evidence], false)
    self.cleanup_enabled = set_default_boolean(attrs[:cleanup_enabled], false)
    self.tag_by_os = set_default_boolean(attrs[:tag_by_os], false)
    self.nexpose_gather_type ||= :import
  end

  def import?; self.nexpose_gather_type.to_s == 'import'; end
  def scan?; self.nexpose_gather_type.to_s == 'scan'; end
end
