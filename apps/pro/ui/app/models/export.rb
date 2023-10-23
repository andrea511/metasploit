# encoding: UTF-8

#
# Gems
#

require 'nokogiri'
require 'zip'

class Export < ApplicationRecord
  #
  # Includes
  #
  include Metasploit::Pro::AddressUtils
  include Metasploit::Pro::Export::Type::Pwdump
  include Metasploit::Pro::Export::Type::ReplayScripts
  include Metasploit::Pro::Export::Type::Xml
  include Metasploit::Pro::Export::Type::ZipWorkspace
  include Metasploit::Pro::Export::Utils
  include Metasploit::Pro::Report::Utils

  include Msf::Pro::Locations
  # Convenience reference to get common application locations:
  def self.locations
    @_locations ||= Object.new.extend(Msf::Pro::Locations)
  end

  #
  # Constants
  #
  VALID_TYPES      = [:pwdump, :replay_scripts, :xml, :zip_workspace]
  ENCODING         = 'utf-8'
  EXPORT_DIR       = File.join(locations.pro_export_directory, '') # Where exports are stored
  LOG_DIR          = File.join(locations.pro_ui_log_directory)
  LOG_FILE         = File.join(Export::LOG_DIR, 'exports.log')
  TYPES_EXTENSIONS = ActiveSupport::HashWithIndifferentAccess.new({
    :xml            => 'xml',
    :pwdump         => 'txt',
    :replay_scripts => 'zip',
    :zip_workspace  => 'zip'
  })
  EXPORT_TYPE_MAP  = ActiveSupport::HashWithIndifferentAccess.new({
    :pwdump         => Metasploit::Pro::Export::Type::Pwdump,
    :replay_scripts => Metasploit::Pro::Export::Type::ReplayScripts,
    :xml            => Metasploit::Pro::Export::Type::Xml,
    :zip_workspace  => Metasploit::Pro::Export::Type::ZipWorkspace
  })

  # Number of records to grab per batch
  COLLECTION_BATCH_SIZE = 10000
  # Used in masking credentials;
  # here to share with tests
  MASKED_CRED = '*MASKED*'
  EMPTY_CRED  = '*BLANK PASSWORD*'
  # Objects that can be exported which have aspects stored on the
  # filesystem in addition to the DB:
  FILESYSTEM_DEPENDENT = [:loots, :tasks, :reports]

  #
  # Associations
  #
  belongs_to :workspace, :class_name => 'Mdm::Workspace'

  #
  # Validations
  #
  validates_presence_of :created_by
  validates_presence_of :export_type
  validates :export_type, inclusion: { in: VALID_TYPES }, if: :export_type
  validates_presence_of :name
  validate :safe_filename
  validates_presence_of :workspace_id

  # TODO Would be nice to inform user what is problematic with entry
  def safe_filename
    unless self.name == sanitize_filename(self.name)
      errors.add :name, 'Filename contains disallowed characters'
    end
  end

  #
  # Callbacks
  #
  # Set full path for export based on the specified
  # export type and name
  after_initialize do
    self.name ||= default_export_name
  end

  before_save do
    self.name = sanitize_filename(self.name) # Ensure filename safety
    self.file_path = export_file_path
  end

  before_destroy :remove_export_file

  #
  # State machine
  #
  state_machine :state, :initial => :unstarted do

    # Available states:
    state :unstarted
    state :preparing
    state :generating
    state :cleaning
    state :complete
    state :failed
    state :aborted

    event :prepare! do
      transition :unstarted => :preparing
    end

    around_transition on: :prepare! do |export, transition, block|
      export.transaction do
        block.call
        export.update(:started_at => Time.now)
      end
    end

    event :generate! do
      transition :preparing => :generating
    end

    event :cleanup! do
      transition :generating => :cleaning
    end

    event :complete! do
      transition :cleaning => :complete
    end

    around_transition on: :complete! do |export, transition, block|
      export.transaction do
        block.call
        export.update(:completed_at => Time.now)
        # Don't need notification for API context:
        if Rails.application.respond_to? 'routes'
          export_index = Rails.application.routes.url_helpers.workspace_exports_path(export.workspace.id)
          export.notification_message('Generation complete.', export_index)
        end
      end
    end

    # Errors that stop setup or generating process
    event :fail! do
      transition all => :failed
    end

    # User or system cancels export process
    # TODO Needs to be called from the pertinent places
    event :abort! do
      transition all => :aborted
    end

  end


  #
  # Methods
  #

  def logger
    export_logger
  end

  def notification_message(content = '', url = nil)
    default_options = {
        :workspace => self.workspace,
        :title => "#{self.etype.pretty_name} Export",
        :kind => :export_notification
    }
    Notifications::Message.create(default_options.merge(
                                      :content => content,
                                      :url => url
                                  ))
  end

  # @return [String] Export with current datetime, no spaces
  def default_export_name
    "Export-#{Time.new.strftime("%Y%m%d%H%M%S")}"
  end

  # Convenience to disregard string vs symbol:
  def export_type
    export_type = read_attribute(:export_type)
    if export_type.nil?
      nil
    else
      export_type.to_sym
    end
  end

  # Populate list of address strings that are allowed in the export
  # @return [Array]
  def allowed_addresses
    unless instance_variable_defined? :@allowed_addresses
      @allowed_addresses = generate_allowed_addresses(self.included_addresses,
                                                      self.excluded_addresses,
                                                      true,
                                                      self.workspace.id)
    end
    @allowed_addresses
  end

  # Calls wrapper method per export type
  # @param delayed [Boolean] whether the export should be generated
  # via delayed_job or in a blocking manner.
  def run(delayed = false)
    if self.new_record?
      raise 'Export not ready for generation, save first'
    end

    # TODO Would be nice to append:
    # including #{allowed_addresses.size} host(s)
    # However, that ends up hitting AddressUtils to expand address
    # ranges, which implicates License. This will currently hang RPC
    # API calls due to its synchronous nature.
    logger.info("Generating #{self.etype.pretty_name} export")
    self.notification_message("Generating...")

    action = case self.export_type
               when :pwdump
                 'generate_pwdump_export'
               when :replay_scripts
                 'generate_replay_scripts_zip'
               when :xml
                 'generate_xml_export'
               when :zip_workspace
                 'generate_workspace_zip'
               else
                 return NotImplementedError
             end

    if delayed
      logger.info "Adding #{self.etype.pretty_name} export to delayed_job queue"
      self.delay.send(action)
    else
      logger.debug "Running #{self.etype.pretty_name} export without delayed_job"
      self.send(action)
    end
  end

  # Convenience to call with DJ
  def generate_delayed
    self.run(true)
  end

  # Delete export file from filesystem
  def remove_export_file
    begin
      FileUtils.rm_f(self.file_path)
      logger.debug("Export file deleted: #{self.file_path}")
    rescue SystemCallError => e
      logger.error("Unable to remove export file #{self.file_path}: #{e}")
    end
  end

  def etype
    Export::EXPORT_TYPE_MAP[export_type]
  end
end
