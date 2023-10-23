class ReportCustomResource < ApplicationRecord

  include Metasploit::Pro::Report::Utils

  ALLOWED_LOGO_TYPES     = ['gif', 'png', 'jpg', 'jpeg']
  ALLOWED_TEMPLATE_TYPES = ['jasper', 'jrxml']
  ALLOWED_FILE_TYPES     = ALLOWED_LOGO_TYPES + ALLOWED_TEMPLATE_TYPES

  scope :logos,     -> { where("resource_type = 'logo'") }
  scope :templates, -> { where("resource_type = 'template'") }

  belongs_to :workspace, :class_name => 'Mdm::Workspace'

  validates_presence_of :name
  validates_presence_of :workspace_id
  # Temporary file data, to be saved to final location:
  validates_presence_of :file_data
  validate              :verify_extension, if: :file_data
  # TODO For logo types, need to verify max dimensions

  attr_accessor :file_data

  before_save do
    if file_data.present?
      save_resource_file
      # Determine and set resource_type
      self.resource_type = if (ALLOWED_LOGO_TYPES.member? file_extension)
                             'logo'
                           elsif (ALLOWED_TEMPLATE_TYPES.member? file_extension)
                             'template'
                           end
    end
  end

  before_destroy :delete_file

  #
  # Methods
  #
  # The extension of the resource file, sans period
  def file_extension
    path = case
             when file_path
               file_path
             # Before save, only temporary file data:
             else
               file_data.original_filename
           end
    File.extname(path)[1..-1]
  end

  # Make sure that the resource file extension is allowed for the
  # given type.
  def verify_extension
    unless ALLOWED_FILE_TYPES.member? file_extension
      errors[:file_data] << "File type #{file_extension} is not allowed. Please use one of: #{ALLOWED_FILE_TYPES.join(', ')}"
    end
  end

  # Deletes related artifact file from filesystem
  def delete_file
    FileUtils.rm_f(file_path)
    logger.debug "Removed #{file_path}"
  end

  # Write file data to proper location
  def save_resource_file
    original_filename = sanitize_filename(file_data.original_filename)
    resource_dir = Report::CUSTOM_RES_DIR
    verify_dir_created(resource_dir)
    resource_path = File.join(resource_dir, original_filename)
    FileUtils.cp(file_data.tempfile, resource_path)
    self.file_path = resource_path
  end

end
