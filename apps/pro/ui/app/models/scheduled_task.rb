require 'acts_as_list'

class ScheduledTask < ApplicationRecord
  #
  # CONSTANTS
  #

  VALID_TASK_KINDS = %w(bruteforce cleanup collect_evidence exploit import module_run scan_and_import report scan webscan metamodule rc_script nexpose_push)

  #
  # Associations
  #

  belongs_to :task_chain, optional: true

  #
  # File Uploads
  #
  mount_uploader :file_upload, ScheduledTaskUploader

  #
  # Skip CarrierWave Destroy Callback
  #
  skip_callback :commit, :after, :remove_file_upload!
  #
  # Serializations
  #

  serialize :config_hash # config for Task
  serialize :form_hash #task config form options
  serialize :report_hash #config for Report

  #
  # Validations
  #

  validates :kind, :inclusion => {:in => VALID_TASK_KINDS}
  validates :config_hash, :presence => true
  validates :form_hash, :presence => {:if => :validate_legacy?}

  acts_as_list :scope => :task_chain



  def validate_legacy?
    !task_chain.nil? && !task_chain.legacy?
  end

end
