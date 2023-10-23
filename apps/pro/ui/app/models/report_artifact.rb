class ReportArtifact < ApplicationRecord

  include Metasploit::Pro::Report::Utils

  belongs_to :report


  #
  # Validations
  #
  validates_presence_of :file_path
  validate              :artifact_file_exists
  validates_presence_of :report_id
  validates_presence_of :report

  #
  # Callbacks
  #
  before_create :set_format
  before_destroy :remove_file

  #
  # Methods
  #

  def artifact_file_exists
    # If there is a file path
    if errors[:file_path].blank?
      unless File.exist? file_path
        errors.add(:artifact_file_path, "Artifact file not found at #{file_path}")
        return false
      end
      return true
    end
  end

  def logger
    report_logger
  end

  # Delete artifact file from filesystem
  def remove_file
    begin
      FileUtils.rm_f(file_path)
      logger.info("Artifact file deleted: #{file_path}")
    rescue SystemCallError => e
      logger.error("Unable to remove artifact file #{file_path}: #{e}")
    end
  end
	
  def set_format
    self.format = file_format
  end

  # @return [String] the format of the artifact file
  def file_format
    f_format = File.extname(self.file_path).gsub('.', '')
    ['doc', 'docx'].include?(f_format) ? 'word' : f_format
  end
end
