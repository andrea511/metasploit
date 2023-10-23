#
#
# Implements basic interface for Email serialized attack configuration
#
#


module SocialEngineering::EmailAttackConfigInterface
  def self.included(base)
    raise "must be included by ApplicationRecord descendent" unless base.ancestors.include? ApplicationRecord

    base.class_eval do
      extend MetasploitDataModels::SerializedPrefs

      #
      # Serialized attributes - ordered by attribute name
      #
      #-------- Attack type: attached_file -> *
      serialized_prefs_attr_accessor :attachment_file_name
      serialized_prefs_attr_accessor :file_generation_type
      serialized_prefs_attr_accessor :user_supplied_file
      serialized_prefs_attr_accessor :zip_attachment
      #-------- Attack type: attached_file -> file_format
      serialized_prefs_attr_accessor :exploit_module_config
      serialized_prefs_attr_accessor :exploit_module_path

      #
      # Validations - ordered by attribute name
      #
      # need a desired attachment file name when attack_type=attached_file
      validates :attachment_file_name, :presence => { :message => "can't be blank", :if => :file_attack? }
      # make sure exploit config is present during file format attack
      validates :exploit_module_config, :presence => true, :if => :file_format_attack?
      validates :exploit_module_path, :presence => true, :if => :file_format_attack?
      # need an uploaded file when attack_type=exe_agent or user_supplied
      validates :user_supplied_file, :presence => { :message => "can't be blank", :if => :user_supplied_attack? }
      validate  :validate_attachment_filename

      # Make sure we know what KIND of attack file we are doing
      with_options :if => :file_attack? do |attack|
        attack.validates :file_generation_type,
                            :presence => true,
                            :inclusion => {:in => SocialEngineering::WebPage::VALID_FILE_GENERATION_TYPES}
      end

      def validate_attachment_filename
        if attachment_file_name.present?
          invalid_chars = attachment_file_name.scan(/[^\w\.\-]/)
          errors.add(:attachment_file_name, "contained invalid characters(#{invalid_chars.uniq.join(',')})") unless invalid_chars.empty?
        end
      end

      # returns the MsfModule
      def exploit_module
        return nil unless file_format_attack?
        MsfModule.find_by_fullname exploit_module_path
      end

      def file_attack?
        attack_type == "file"
      end

      def exe_agent_attack?
        file_attack? && file_generation_type == "exe_agent"
      end

      def file_format_attack?
        file_attack? && file_generation_type == "file_format"
      end
      
      def user_supplied_attack?
        file_attack? && file_generation_type == "user_supplied"
      end

      def zip_attachment?
        zip_attachment == "1"
      end

    end
  end
end
