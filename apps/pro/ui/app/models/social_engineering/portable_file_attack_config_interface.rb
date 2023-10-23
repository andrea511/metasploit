# 
# Implements a common interface for SocialEngineering components
# to use when connecting back to the running Metasploit instance
#

module SocialEngineering::PortableFileAttackConfigInterface
  def self.included(base)
    raise "must be included by ApplicationRecord descendent" unless base.ancestors.include? ApplicationRecord

    base.class_eval do

      extend MetasploitDataModels::SerializedPrefs

      serialized_prefs_attr_accessor :file_generation_type
      serialized_prefs_attr_accessor :exploit_module_config
      serialized_prefs_attr_accessor :lport
      serialized_prefs_attr_accessor :payload_type
      serialized_prefs_attr_accessor :lhost

      validates :payload_type, :presence => true,
        :inclusion => {:in => SocialEngineering::PortableFile::VALID_PAYLOAD_TYPES}
      validates :lport, :presence => true, :inclusion => { :in => 0..65535, :message => 'must be between 0 and 65535' },
                           :numericality => { :only_integer => true },
                           :allow_blank => true
      validate :validate_lport

      # make sure exploit config is present during file format attack
      validates :exploit_module_config, :presence => true, :if => :file_format_attack?

      def validate_lport  
        errors.add(:lport, "can't be the same as Server Web Port") if campaign.web_campaign? and lport == campaign.web_port 
        errors.add(:lport, "can't be the same as Server Web BAP Port") if campaign.web_campaign? and lport == campaign.web_port 
        SocialEngineering::PortableFile.where(:campaign_id => campaign.id).each do |pf|
          next if pf.id == id
          errors.add(:lport, "can't be the same as another Portable File") if lport ==  pf.lport
        end
      end

      def file_format_attack?
        file_generation_type == "file_format"
      end

      def exploit_module
        return nil unless file_format_attack?
        MsfModule.find_by_fullname exploit_module_path
      end

    end
  end
  
end
