module SocialEngineering::WebPage::AttackType::File
  extend ActiveSupport::Concern

  #
  # CONSTANTS
  #

  VALID_FILE_GENERATION_TYPES = ["exe_agent", "file_format", "user_supplied"]

  included do
    extend MetasploitDataModels::SerializedPrefs

    #
    # Associations
    #

    has_many :files, :as => :attachable, :class_name => 'SocialEngineering::CampaignFile'

    #
    # Serialized Preferences
    #

    serialized_prefs_attr_accessor :file_generation_type
    serialized_prefs_attr_accessor :user_supplied_file

    #
    # Validations
    #

    # Make sure we know what KIND of attack file we are doing
    validates :file_generation_type,
              :if => :file_attack?,
              :inclusion => {
                  :in => SocialEngineering::WebPage::VALID_FILE_GENERATION_TYPES
              },
              :presence => true
    # need an uploaded file when attack_type=exe_agent or user_supplied
    validates :user_supplied_file,
              :presence => {
                  :if => :user_supplied_attack?,
                  :message => "can't be blank"
              }
  end

  #
  # Instance Methods - sorted by name
  #

  def exe_agent_attack?
    file_attack? && file_generation_type == 'exe_agent'
  end

  def file_attack?
    attack_type == "file"
  end

  def file_format_attack?
    file_attack? && file_generation_type == "file_format"
  end

  def user_supplied_attack?
    file_attack? && file_generation_type == "user_supplied"
  end
end