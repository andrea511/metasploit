# encoding: UTF-8

#
# Standard Library
#

require 'open3'

class Report < ApplicationRecord
  include Msf::Pro::Locations

  def self.locations
    @_locations ||= Object.new.extend(Msf::Pro::Locations)
  end

  #
  # Includes
  #
  include Metasploit::Pro::Report
  include Metasploit::Pro::Report::Exceptions
  include Metasploit::Pro::Report::Utils
  include Metasploit::Pro::Report::ComplianceTests # PCI, FISMA

  #
  # Constants
  #
  REPORTING_DIR  = File.join(locations.pro_report_directory, '') # Top level report dir
  LOG_DIR        = File.join(locations.pro_ui_log_directory)
  LOG_FILE       = File.join(Report::LOG_DIR, 'reports.log')
  CUSTOM_RES_DIR = locations.pro_report_custom_resources_directory
  TEMP_DIR       = File.join(Report::REPORTING_DIR, 'temp')
  TASKS_DIR = File.join(locations.pro_tasks_directory)
  SERIALIZATION_FORMAT = JSON
  VALID_TYPES   = [:activity,
                   :audit,
                   :collected_evidence,
                   :compromised_hosts,
                   :credentials,
                   :custom,
                   :fisma,
                   :mm_auth, :mm_domino, :mm_pnd, :mm_segment,
                   :pci,
                   :services,
                   :social_engineering,
                   :webapp_assessment
  ]
  METAMODULE_TYPES = [:mm_auth, :mm_domino, :mm_pnd, :mm_segment]

  # Maps short name for each report type to module for that type;
  # report_type => rtype (Report::Type)
  REPORT_TYPE_MAP = ActiveSupport::HashWithIndifferentAccess.new({
      :activity =>
         Metasploit::Pro::Report::Type::Activity,
      :audit =>
        Metasploit::Pro::Report::Type::Audit,
      :credentials =>
        Metasploit::Pro::Report::Type::Credentials,
      :collected_evidence =>
        Metasploit::Pro::Report::Type::CollectedEvidence,
      :compromised_hosts =>
        Metasploit::Pro::Report::Type::Compromised,
      :custom =>
        Metasploit::Pro::Report::Type::Custom,
      :fisma =>
        Metasploit::Pro::Report::Type::FISMA,
      :mm_auth =>
        Metasploit::Pro::Report::Type::MM_Auth,
      :mm_domino =>
        Metasploit::Pro::Report::Type::MM_Domino,
      :mm_segment =>
        Metasploit::Pro::Report::Type::MM_Segment,
      :mm_pnd =>
        Metasploit::Pro::Report::Type::MM_PND,
      :pci =>
        Metasploit::Pro::Report::Type::PCI,
      :services =>
        Metasploit::Pro::Report::Type::Services,
      :social_engineering =>
        Metasploit::Pro::Report::Type::SocialEngineering,
      :webapp_assessment =>
        Metasploit::Pro::Report::Type::WebappAssessment
  })

  OPTIONS_NAMES = {
    :hide_email_addresses => 'Replace email addresses with target IDs',
    :include_charts       => 'Include charts',
    :include_comp_vis     => 'Include Compromised Host Visualization',
    :include_page_code    => 'Include web page code',
    :include_sessions     => 'Include session details',
    :include_task_logs    => 'Include task log content',
    :mask_credentials     => 'Mask discovered credentials'
  }
  # If these are applicable to the selected type they
  # should be defaulted to true:
  DEFAULT_OPTIONS = [:include_charts,
                     :include_sessions,
                     :include_web_data
  ]
  # Best default format for all types
  DEFAULT_FILE_FORMAT = 'pdf'
  # wkhtmltoimage parent directory
  WKHTMLTOIMAGE_DIR = File.join(locations.pro_ui_directory, '..', 'wkhtmltoimage')
  # The Rapid7 logo image to be shown on report cover pages
  STANDARD_REPORT_LOGO = File.join(locations.pro_report_image_directory, 'rapid7_logo_padded.jpg')
  # Directory holding all generated report artifacts
  ARTIFACT_DIR = locations.pro_report_artifact_directory

  #
  # Associations
  #
  belongs_to :workspace, :class_name => 'Mdm::Workspace', :touch => true, optional: true # Wizards create workspace and report inline
  has_many   :report_artifacts, :dependent => :destroy, :class_name => 'ReportArtifact'
  serialize  :addresses,    SERIALIZATION_FORMAT
  serialize  :file_formats, SERIALIZATION_FORMAT
  serialize  :sections,     SERIALIZATION_FORMAT
  serialize  :options,      SERIALIZATION_FORMAT

  #
  # Validations
  #

  # Make Name field optional per MS-3230
  # validates_presence_of :name
  #
  # TODO Find appropriate safe value:
  # validates_length_of :name, :maximum => X
  validate :safe_filename, if: :name
  validates_presence_of :report_template
  validates_presence_of :report_type
  validates :report_type, inclusion: { in: VALID_TYPES }, if: :report_type
  validates_presence_of :workspace_id, if: -> { !skip_data_check } # Wizards create workspace and report inline
  validates_presence_of :created_by
  validate :file_format_selected
  validate :email_addresses_valid, if: -> { !email_recipients.blank? }
  validate :se_campaign_id, if: -> { report_type =~ /social_engineering/ }

  #
  # Scopes
  #

  scope :unaccessed, lambda { |workspace_id|
                     where(workspace_id: workspace_id).joins(:report_artifacts).where(report_artifacts: {accessed_at: nil}).distinct
                   }

  # Ensure at least one format is selected
  def file_format_selected
    if self.file_formats.blank?
      errors.add :file_formats, 'At least one file format must be selected.'
    end
  end

  # TODO Would be nice to inform user what is problematic with entry
  def safe_filename
    if self.name && self.name != sanitize_filename(self.name)
      errors.add :name, 'Filename contains disallowed characters'
    end
  end

  # A very permissive check, basic sanity validation:
  def email_addresses_valid
    invalid = 0
    recipients = emails_string_to_array(self.email_recipients)
    recipients.each do |r|
      # For more on this line of reasoning:
      # http://davidcel.is/blog/2012/09/06/stop-validating-email-addresses-with-regex/
      unless r.include?('@') && r.length >= 3
        invalid += 1
      end
    end
    if invalid == 1
      errors.add :email_recipients, 'One email recipient entered is not a valid address'
    elsif invalid > 1
      errors.add :email_recipients, "#{invalid} email recipients entered are not valid addresses"
    end
  end

  attr_accessor :activity_task_file
  attr_accessor :compliance_test_file

  #
  # Callbacks
  #
  after_initialize do
    self.name ||= default_report_name
  end

  before_validation do
    unless self.report_type =~ /custom/
      if self.rtype
        # Set parent .jrxml file of this report type
        self.report_template = rtype.template_file
      end
    end
  end

  before_save do
    # Ensure report name when form field is blank
    # MS-3230
    if self.name.blank?
      self.name = default_report_name
    end
    self.name = sanitize_filename(self.name) # Ensure filename safety
    self.sections ||= self.rtype.sections.keys # Assume all if none set
    if self.logo_path.blank?
      self.logo_path = STANDARD_REPORT_LOGO
    end
    # TODO This should not be needed:
    # Drop blank file formats from Formtastic
    self.file_formats = self.file_formats.reject(&:blank?) if self.file_formats
    self.options = self.options.reject(&:blank?) if self.options
    self.sections = self.sections.reject(&:blank?) if self.sections
  end

  #
  # State machine
  #
  state_machine :state, :initial => :unverified do

    # Available states:
    state :unverified
    state :verified
    state :preparing
    state :generating
    state :regenerating
    state :cleaning
    state :complete
    state :failed
    state :aborted

    # Verify data needed for requested report is present
    event :readied! do
      transition :unverified => :verified
    end

    # Any needed preparation
    event :prepare! do
      transition :verified => :preparing
    end

    around_transition on: :prepare! do |report, transition, block|
      report.transaction do
        block.call
        report.update(:started_at => Time.now)
      end
    end

    # Start the generation process
    event :generate_artifacts! do
      transition :preparing => :generating
    end

    event :regenerate! do
      transition all => :regenerating
    end

    # Removal of temp files, etc after generation
    event :cleanup! do
      transition :generating => :cleaning
    end

    # All steps finished successfully
    event :complete! do
      transition [:cleaning, :regenerating] => :complete
    end

    around_transition on: :complete! do |report, transition, block|
      report.transaction do
        block.call
        report.update(:completed_at => Time.now)
        # Don't need notification for API context:
        if Rails.application.respond_to? 'routes'
          report_view = Rails.application.routes.url_helpers.workspace_report_path(report.workspace.id, report)
          report.notification_message('Generation complete.', report_view)
        end
      end
    end

    # Errors that stop setup or generating process
    event :fail! do
      transition all => :failed
    end

    around_transition on: :fail! do |report, transition, block|
      report.transaction do
        block.call
        report.notification_message('Error in generation, check log/report.log for details.')
      end
    end

    # User or system cancels generating process
    # TODO Needs to be called from the pertinent places
    event :abort! do
      transition all => :aborted
    end

  end


  #
  # Methods
  #

  def logger
    report_logger
  end

  def notification_message(content = '', url = nil)
    default_options = {
        :workspace => self.workspace,
        :title => "#{self.rtype.name} Report",
        :kind => :report_notification
    }
    Notifications::Message.create(default_options.merge(
                                      :content => content,
                                      :url => url
                                  ))
  end

  # @return [String] Pretty report name with current datetime, no spaces
  def default_report_name
    if self.rtype
      "#{self.rtype.name.gsub(/\s+/, "")}-#{Time.new.strftime("%Y%m%d%H%M%S")}"
    end
  end

  # Populates list of address strings that are allowed in the report.
  # @return [Array]
  def allowed_addresses
    unless instance_variable_defined? :@allowed_addresses
      @allowed_addresses = generate_allowed_addresses(self.included_addresses,
                                                      self.excluded_addresses,
                                                      false,
                                                      self.workspace.id
      )
    end
    @allowed_addresses
  end

  # Hash of report config
  # Used in generation and to generate yml config
  # @return [Hash] of report config used in various operations
  def report_config
    unless instance_variable_defined? :@report_config
      @report_config = generate_config_hash
    end
    @report_config
  end

  # Convenience to disregard string vs symbol:
  def report_type
    report_type = read_attribute(:report_type)
    if report_type.nil?
      nil
    else
      report_type.to_sym
    end
  end

  def pretty_option_names
    options ? self.options.collect { |option| OPTIONS_NAMES[option.to_sym] } : []
  end

  def included_addresses_array
    self.included_addresses ? Metasploit::Pro::AddressUtils.expand_ip_ranges(self.included_addresses) : []
  end

  def excluded_addresses_array
    self.excluded_addresses ? Metasploit::Pro::AddressUtils.expand_ip_ranges(self.excluded_addresses) : []
  end

  # @return [Float] time in seconds to complete the report
  def report_duration
    if not self.completed_at
      0
    else
      self.completed_at - self.started_at
    end
  end

  # @return [Module] defining specific report type
  def rtype
    Report::REPORT_TYPE_MAP[report_type]
  end

  # Checks for run readiness, calls run.
  # @param delayed [Boolean] whether the report should be generated
  # via delayed_job or in a blocking manner.
  def generate(delayed = false)
    # If we don't need to verify that data is present, e.g. for wizards:
    if self.skip_data_check
      self.readied!
    else
      unless data_present?
       raise ReportGenerationError, required_data_message(self.rtype)
      end
    end
    if self.new_record?
      raise ReportGenerationError, 'Report has not been saved.'
    end
    unless licensed_to_report?
      raise ReportGenerationError, 'You are not licensed for report generation.'
    end

    if delayed
      logger.info "Adding #{self.rtype.name} report to delayed_job queue"
      self.delay.run
    else
      logger.debug "Running #{self.rtype.name} report without delayed_job"
      self.run
    end
  end

  # Convenience to call generate with delayed_job
  def generate_delayed
    self.generate(true)
  end

  # Generate the specified format on a report that already has artifacts
  def generate_additional_format(file_format)
    self.regenerate!
    self.started_at = Time.now
    self.completed_at = nil
    # Sets new format on report, is expanded to old + new after
    # generation:
    self.file_formats = [file_format]
    self.save
    self.generate_delayed
  end

  # Copy the report settings into a new report
  def clone_report
    # Reset attrs particular to cloned report generation instance
    drop_attrs = [
      'completed_at',
      'created_at',
      'created_by',
      'id',
      'started_at',
      'state',
      'updated_at',
    ]
    cloned = Report.new(self.attributes.except *drop_attrs)

    # Avoid immediate name collision
    # TODO Probably a better approach/remove entirely:
    cloned.name = self.name + '_clone'
    cloned
  end

  # Wraps license check to handle API case. Since the RPC API is
  # synchronous we can't make an RPC call to check license
  # during a report creation call.
  # @return [Boolean]
  def licensed_to_report?
    # Only Pro licensed users are allowed to make API calls (via token),
    # so if we are in the prosvc context we can assume the call is
    # licensed:
    if $PROGRAM_NAME == 'prosvc'
      true # TODO Would still be better to check a real License object.
    else
      License.get.supports_reports?
    end
  end

  # Checks if all conditions for report generation are met
  # @return [Boolean]
  def ready?
    if (!self.new_record? && data_present? && licensed_to_report?)
      true
    else
      false
    end
  end

  # If required data is defined for this report type,
  # verify that that it is present
  def data_present?
    status = if rtype.required_data.nil?
               true
             else
               data_present = {}
               # Check each type of required data
               rtype.required_data.each do |req|
                 data_present[req] = verify_data_present(req)
               end
               if data_present.values.member? false
                 false
               else
                 true
               end
             end
    if status
      self.readied!
    end
    status
  end


  protected

  # Wrapper for all steps after verifications are complete.
  # Perform setup operations, call Jasper to generate artifacts,
  # perform cleanup operations.
  def run
    report_setup
    if generate_artifacts
      report_cleanup
      self.complete!
      artifact_list = self.report_artifacts.pluck(:file_path)
      logger.info "Generation completed in #{report_duration.round(3)}s"
      update_file_formats
      self.save
    else
      self.notification_message("Error generating report, check reports.log")
    end
  end


  private

  # Runs passed command to Java -> our Java code -> JasperReports;
  # error handling.
  # Afterwards artifacts will exist or an error should have been thrown.
  # @param cmd [String] complete command to run for Java call to generate
  # report artifacts
  def jasper_call(cmd)
    begin
      outs, errs, status = Open3.capture3(cmd)
      outs = outs.encode('UTF-8', :invalid => :replace, :undef => :replace)
      errs = errs.encode('UTF-8', :invalid => :replace, :undef => :replace)
      if !status.success?
        logger.debug "Jasper call failed: #{errs}"
        raise JasperCallFailed, errs
        # Status code 1 not always returned on failure
      elsif errs =~ /Fail/
        logger.debug "Jasper call failed: #{errs}"
        raise JasperCallFailed, errs
      end
      logger.debug "Jasper call completed: #{outs}"
    rescue Errno::ENOMEM
      raise Errno::ENOMEM, 'Ran out of memory during Jasper call'
    rescue IOError
      raise IOError, 'IO error encountered during Jasper call'
    rescue => e
      logger.error "Jasper call unknown general error: #{e} #{e.backtrace}"
      raise e
    end
  end

  # Simple check to verify that there is at least one instance of
  # the required model in the current workspace
  def verify_data_present(model)
    self.workspace.send(model).any?
  end

  # Creates hash of configuration options,
  # consumed by our Java code and on to the Jasper report templates
  def generate_config_hash
    # Provide defaults for not required items:
    self.options            ||= []
    self.sections           ||= []
    self.included_addresses ||= ''
    self.excluded_addresses ||= ''
    if report_type == :webapp_assessment
      self.order_vulns_by   ||= Metasploit::Pro::Report::Type::WebappAssessment::DEFAULT_ORDER
    end

    conf = ActiveSupport::HashWithIndifferentAccess.new(
      {
        :app_run_id          => self.app_run_id,
        :db_env              => Rails.env.to_s,
        :host_address_clause => host_address_clause(self.included_addresses,
                                                    self.excluded_addresses),
        :hide_email_addresses => self.options.member?('hide_email_addresses'),
        :include_charts       => self.options.member?('include_charts'),
        :include_page_code    => self.options.member?('include_page_code'),
        :include_sessions     => self.options.member?('include_sessions'),
        :include_task_logs    => self.options.member?('include_task_logs'),
        :include_web_data     => self.options.member?('include_web_data'),
        :logo_path            => logo_path,
        :mask_credentials     => self.options.member?('mask_credentials'),
        :order_vulns_by       => self.order_vulns_by,
        :product_name         => License.get.product_type,
        :report_dir           => rtype.report_dir,
        :report_id            => self.id,
        :report_name          => name,
        :report_template      => report_template,
        :report_type          => report_type.to_s,
        :report_username      => created_by,
        :reporting_dir        => REPORTING_DIR,
        :se_campaign_id       => self.se_campaign_id,
        :usernames_reported   => self.usernames_reported,
        :workspace_id         => workspace_id,
        :report_time_zone     => ActiveSupport::TimeZone::MAPPING[Mdm::User.where(username: created_by).first.prefs[:time_zone]],
      }
    )
    # Sections show by default in the templates, so just
    # need to set them to false if desired:
    all_sections = self.rtype.sections.stringify_keys.keys
    selected_sections = self.sections
    disabled_sections = all_sections - selected_sections
    disabled_sections.each do |s|
      conf["display_#{s}"] = false
    end
    conf
  end

  # Required setup operations before some reports can be generated
  def report_setup
    self.prepare!
    logger.debug 'Setting up'
    verify_dir_created(Report::TEMP_DIR)

    case report_type
      # SE: Generate preview images
      when /social_engineering/
        se_report_setup
      # PCI, FISMA: Run compliance tests, generate XML data source
      when /pci|fisma/
        compliance_report_setup
      # Activity
      when /activity/
        activity_report_setup
    end

  end

  # Call preview image generation for SE campaign web pages.
  def se_report_setup
    pages = SocialEngineering::WebPage.where(:campaign_id => self.se_campaign_id)
    if pages.count > 0
      pages.each do |page|
        if ['none', 'phishing'].include? page.attack_type
          img_name = "#{page.campaign_id}-#{page.id}"
          img_path = gen_webpage_image(page.name, img_name, page.content)
          if img_path
            temp_files << img_path
          end
        else
          next
        end
      end
    end
  end

  # Runs compliance tests resulting in XML file to be used in report.
  def compliance_report_setup
    xml_file = File.join(Report::TEMP_DIR, "#{report_type.to_s.capitalize}_results_#{Time.new.strftime('%Y-%m-%d_%H%M')}.xml")
    # Runs tests, populates XML data source file:
    case report_type
      when :pci
        Metasploit::Pro::Report::ComplianceTests::PCITest.new(xml_file, report_config, allowed_addresses).test
      when :fisma
        Metasploit::Pro::Report::ComplianceTests::FISMATest.new(xml_file, report_config, allowed_addresses).test
    end
    self.compliance_test_file = xml_file
    unless File.exist? self.compliance_test_file
      logger.error 'Compliance test XML not generated!'
      self.notification_message('Error in compliance testing.')
      self.fail!
    end
    temp_files << self.compliance_test_file
  end

  # Generates XML file with options and log file content for tasks, to
  # be consumed by Jasper. This is done because the options are stored
  # in a format not directly readable, and the task log content is
  # stored on the filesystem in a place we will not have
  # permission to access once in Jasper.
  def activity_report_setup
    xml_path = File.join(Report::TEMP_DIR, "#{report_type.to_s.capitalize}_results_#{Time.new.strftime('%Y-%m-%d_%H%M')}.xml")
    xml_file = File.open(xml_path, 'w')
    xml_content = Nokogiri::XML::Builder.new(:encoding => 'utf-8') do |xml|
      xml.tasks do
        Mdm::Workspace.find(report_config[:workspace_id]).tasks.each do |t|
          # TODO This should apparently be handled by AR just by
          # calling options:
          deserialized_options = MetasploitDataModels::Base64Serializer.new.load(t.options)
          options_string = deserialized_options.collect {|k,v| "#{k}: #{v}"}.join("\n")
          xml.task('id' => t.id) do
            xml.options do
              xml.cdata options_string
            end
            if self.report_config[:include_task_logs]
              xml.log_content do
                basename = File.basename(t.path)
                path = File.join(TASKS_DIR, basename)

                xml.cdata task_log_content(path)
              end
            end
          end
        end # each task
      end # tasks
    end
    section_generation_cleanup(xml_file, xml_content)
    xml_file.close
    self.activity_task_file = xml_path
    self.report_config[:activity_task_file] = self.activity_task_file
    temp_files << self.activity_task_file
  end

  # Create report files for all specified formats,
  # handles file cleanup and Artifact record creation.
  def generate_artifacts
    self.generate_artifacts!
    file_formats.each do |format|
      self.notification_message("Generating #{format.upcase}")
      # Comes back as string from DB in DJ context:
      ext = REPORT_FILE_EXTENSIONS[format.to_sym]
      artifact_name = "#{name}.#{ext}"
      verify_dir_created(pro_report_artifact_directory)
      file_path = File.join(pro_report_artifact_directory, artifact_name)

      # Verify that this file_path is not taken (artifact of report
      # with the same path+name as an existing artifact):
      file_path = unique_report_filename(file_path, name)

      # Formulate java call command, which differs for XML-based reports
      cmd = if [:pci, :fisma].member? report_type
        jasper_cmd_xml(file_path, compliance_test_file, report_type)
      else
        jasper_cmd(file_path)
      end

      # Run Java command
      begin
        logger.info "Calling Jasper to generate #{format.upcase} artifact for #{self.rtype.name} report"
        jasper_call(cmd)
      rescue JasperCallFailed, Errno::ENOMEM, IOError => e
        logger.error "Problem during artifact generation: #{e}"
        logger.error "Jasper command: #{cmd}"
        self.fail!
        return false
      end

      # HTML artifact: encode images and embed them
      # to keep the artifact self-contained:
      html_embed_images(file_path) if ext == 'html'

      # Create record of the file created with the parent report
      artifact_config = {:file_path => file_path, :report_id => self.id}
      artifact = ReportArtifact.create(artifact_config)
      artifact.save
      logger.info "Report artifact created: #{artifact.file_path}"
    end
  end

  # Forms the full string of the Jasper call
  # to generate report artifacts
  def jasper_cmd(outfile)
    self.report_template ||= template_file(report_type) # to call jasper a template must be set
    java = pro_java_executable
    # Log4J config, classpath, common options
    cmd  = shared_java_args(java_classpath)
    cmd << '-Xms128m -Xmx1024m'
    # Java class
    cmd << 'org.metasploit.GenerateReport'
    # JRXML parent template
    cmd << report_template
    # Path to final artifact
    cmd << outfile
    # DB config
    cmd << File.join(pro_config_directory, 'database.yml')
    # Report options
    cmd << yml_config
    # Temporary image and virtualization dirs
    verify_dir_created(pro_report_tmp_img_directory)
    verify_dir_created(pro_report_virt_directory)
    cmd << File.join(pro_report_tmp_img_directory, '')
    cmd << pro_report_virt_directory
    # The environment to use (to select from database.yml)
    cmd << report_config[:db_env]

    cmd.unshift java
    cmd = cmd.join(' ')
  end

  # The XmlJasperInterface uses options
  # vs GenerateReport which simply uses positional args
  # This type of report uses an XML file as a datasource,
  # generated from running compliance tests.
  def jasper_cmd_xml(outfile, xml_file, report_type)
    java = pro_java_executable
    # Log4J config, classpath, common options
    cmd  = shared_java_args(java_classpath)
    # Java class
    cmd << "org.metasploit.XmlJasperInterface"
    # Extension of final artifact
    cmd << "-o#{outfile.split('.')[-1]}"
    # Parent template jasper, unlike jrxml for non-xml
    # related reports (XmlJasperInterface assumption)
    report_jasper = jrxml_to_jasper(report_template)
    cmd << "-f#{report_jasper}"
    # Element in datasource XML
    xpath = case report_type
              when :pci
                '/MetasploitPCI32v1/requirements/requirement'
              when :fisma
                '/MetasploitFISMAr3v1/requirements/requirement'
            end
    cmd << "-x#{xpath}"
    # Temporary image and virtualization dirs
    verify_dir_created(pro_report_tmp_img_directory)
    verify_dir_created(pro_report_virt_directory)
    cmd << "-i#{File.join(pro_report_tmp_img_directory, '')}"
    cmd << "-v#{pro_report_virt_directory}"
    cmd << "< #{xml_file}"
    cmd << "> #{outfile}"

    cmd.unshift java
    cmd = cmd.join(' ')
  end

  # Generate and write YAML config that is
  # consumed by the Jasper report templates.
  # It's not needed after generation and is removed
  # during cleanup.
  def yml_config
    yml_file = Tempfile.new('jasper_config.yml')
    # Can sometimes be ASCII, resulting in binary escaping in the
    # resultant yaml, so make sure everything is a UTF-8 string where possible:
    config_hash = sanitize_hash(report_config)
    # Psych is adding quotation marks to some strings and not others,
    # this drops them all. Didn't find an option to configure this:
    yml = config_hash.to_yaml.gsub('"', '')
    yml_file.write(yml)
    yml_file.close
    temp_files << yml_file
    yml_file.path
  end

  # Array of files to be removed during cleanup.
  def temp_files
    unless instance_variable_defined? :@temp_files
      @temp_files = []
    end
    @temp_files
  end

  # Convenience to get path for .jasper (binary compiled report file)
  # for .jrxml file.
  # @param jrxml [String] path to .jrxml file
  def jrxml_to_jasper(jrxml)
    File.join(File.dirname(jrxml), (File.basename(jrxml).split('.')[0] + '.jasper'))
  end

  # Any needed cleanup operations after generation.
  # Removes temp_files and emails artifacts if requested.
  def report_cleanup
    self.cleanup!

    unless self.email_recipients.blank?
      unless self.delay.email_report(self.id, self.email_recipients)
        self.notification_message('Error emailing report.')
      end
    end

    logger.debug 'Cleaning up'

    # Remove temp files, including
    # * YAML config file
    # * Compliance testing XML files
    # * SE web page preview images
    # * HTML format images
    temp_files.each do |f|
      if f.respond_to? 'close' # Remove Tempfiles
        f.close ; f.unlink
      else                     # Remove normal Files
        FileUtils.rm_f(f)
      end
    end

    logger.debug 'Cleanup complete'
  end

  # Set parent report file formats based on related artifact files.
  # Handles case of generating additional formats for an existing report.
  def update_file_formats
    self.file_formats = self.report_artifacts.collect { |a| a.file_format }
    self.save
  end

end
