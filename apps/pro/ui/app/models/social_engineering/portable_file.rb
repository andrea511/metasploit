class SocialEngineering::PortableFile < ApplicationRecord
  self.table_name = :se_portable_files
  VALID_FILE_GENERATION_TYPES = ["file_format", "exe_agent"]
  VALID_PAYLOAD_TYPES = ["reverse_tcp", "reverse_http", "reverse_https"]
  
  serialize :prefs # TODO: use JSON to serialize after upgrading to Rails 3.2.5

  include SocialEngineering::PortableFileAttackConfigInterface
  include Metasploit::Pro::AttrAccessor::Boolean

  belongs_to :campaign, :class_name => "SocialEngineering::Campaign", :touch => true
  has_many :files, :as => :attachable, :class_name => "SocialEngineering::CampaignFile"

  validates :file_name, :presence => { :message => "can't be blank"}
  validate :validate_filename
  validates :exploit_module_path, :presence => true, :if => :file_format_attack?
  
  # @!attribute [r] dynamic_stagers
  #   @return [Boolean] use the DynamicStager randomization for windows payloads
 
  def initialize(attrs={})
    super
    if attrs
      self.dynamic_stagers = set_default_boolean(
        attrs[:dynamic_stagers],
        License.get.supports_dynamic_stagers?
      )
    end
  end

  def validate_filename
    if file_name.present?
      invalid_chars = file_name.scan(/[^\w\.\-]/)
      errors.add(:file_name, "contained invalid characters (#{invalid_chars.uniq.join(',')})") unless invalid_chars.empty?
    end
  end

  def to_hash
    rethash = {
      name: name,
      attack_type: 'N/A',
      status: 'N/A',
      type: 'portable_file',
      id: id
    }

    unless files.first.nil?
      rethash[:download] = files.first.attachment_url
    end

    rethash
  end
end
