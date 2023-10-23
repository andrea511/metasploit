module SocialEngineering::SmtpInterface
  def self.included(base)

    raise "must be included by ApplicationRecord descendent" unless base.ancestors.include? ApplicationRecord
    
    # Create the interface getters/setters
    base.class_eval do
      extend MetasploitDataModels::SerializedPrefs

      serialized_prefs_attr_accessor :ssl

      serialized_prefs_attr_accessor :smtp_server
      serialized_prefs_attr_accessor :smtp_port
      serialized_prefs_attr_accessor :smtp_username
      serialized_prefs_attr_accessor :smtp_password
    end
  end
end
