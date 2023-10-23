# contains the logic for inputting a hash of a few different
#   task configurations, and rolling them up into a VulnValidation::Form
#   model, and then into a VulnValidation::Procedure
class Wizards::VulnValidation::Builder < Wizards::BaseBuilder
  # possible options for the scanning phase
  def initialize(params, user)
    self.form = Wizards::VulnValidation::Form.new(params[:vuln_validation] || {})
    super
  end

  # returns an initialized Form instance determined by params
  #
  # @return [Wizards::VulnValidation::Form] with populated attributes
  def build
    # build all of the inner models
    build_workspace_from_params
    build_custom_tag_from_params
    build_nexpose_scan_task_from_params
    build_exploit_task_from_params
    build_collect_evidence_task_from_params
    build_cleanup_task_from_params
    build_report_from_params
    # return our new model
    form
  end

  # After calling .build, to_procedure lets you output the snowballed
  # config to a Wizards::VulnValidation::Procedure
  #
  # @return [Wizards::VulnValidation::Procedure] an initialized Procedure
  #   with a populated config_hash 
  def to_procedure
    procedure = Wizards::VulnValidation::Procedure.new(:config_hash => form.to_hash)
    procedure.config_hash[:custom_tag] = form.custom_tag
    procedure.workspace = form.workspace
    procedure.user = current_user
    procedure
  end

  # Sets default UI options for the user that never drills
  #   down into the "Advanced" fieldsets.
  #
  # @return [Wizards::VulnValidation::Builder] self
  def set_defaults!
    form.report_enabled = true
    form.cleanup_enabled = true
    form.tagging_enabled = true
    form.workspace = Mdm::Workspace.new({
      :boundary => default_ip_range,
      :limit_to_network => true,
      :owner => current_user
    })
    form.custom_tag = Mdm::Tag.new
    form.report = Report.new({
      :report_type        => :audit,
      :file_formats       => [Report::DEFAULT_FILE_FORMAT],
      :options            => Report::DEFAULT_OPTIONS,
    })
    form.exploit_task = ExploitTask.new({
      :workspace => form.workspace,
      :skip_host_validity_check => true,
      :skip_site_existence_check => true,
      :filter_by_os => true # we want to only run OS-specific exploits
    })
    build_collect_evidence_task
    build_cleanup_task
    form.nexpose_scan_task = NexposeTask.new({
      :workspace => form.workspace,
      :username => current_user.username,
      :skip_host_validity_check => true,
      :ensure_whitelist_present => true
    })
    self
  end

  private

  def build_custom_tag_from_params
    form.custom_tag = if form.tagging_enabled and form.use_custom_tag
      tag_params = custom_tag_params
      if tag_params.is_a?(ActionController::Parameters)
        tag_params = tag_params.to_h
        begin
          # Enforce valid keys, in case random keys are passed to #where
          valid_keys = Mdm::Tag.new.attributes.keys - ["id", "type"]
          # assert_valid_keys is strictly typed, so ensure that symbols and strings are accepted
          tag_params.assert_valid_keys(*(valid_keys + valid_keys.map(&:to_sym)))
          # this will be saved when the form is saved
          Mdm::Tag.where(tag_params || {}).first_or_initialize
        rescue ArgumentError
          nil # an invalid key was passed, bail on the tag
        end

      end
    end
  end

  def build_nexpose_scan_task_from_params
    if form.scan?
      nexpose_params = params[:nexpose_scan_task] || {}
      whitelist_string = params[:nexpose_scan_task]['whitelist_string'] || ''
      whitelist_string = Metasploit::Pro::AddressUtils.expand_ip_ranges(
        whitelist_string, :allow_tags => false # tags needs a :workspace param
      ).join("\n")
      form.nexpose_scan_task = NexposeTask.new(nexpose_params.merge({
        :workspace => form.workspace,
        :username => current_user.username,
        :nexpose_console_id => form.nexpose_console_id,
        :skip_host_validity_check => true,
        :ensure_whitelist_present => true,
        :whitelist_string => whitelist_string
      }))
    end
  end

  def build_collect_evidence_task_from_params
    build_collect_evidence_task if form.collect_evidence
  end

  def build_cleanup_task_from_params
    build_cleanup_task if form.cleanup_enabled
  end

  def custom_tag_params
    tag_params = params.fetch(:custom_tag, {})
    unless tag_params.is_a? Hash
      tag_params = {}
    end
    tag_params = ActionController::Parameters.new(tag_params)
    tag_params.permit!
  end
end
