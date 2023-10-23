# `config` settings shared between {Metasploit::Pro::UI::Engine} and {Pro::Application}
module Metasploit::Pro::UI::CommonConfiguration
  extend ActiveSupport::Concern

  included do
    #
    # config
    #

    # Use sql format to preserve implementation-specific items such
    # as stored procedures, which we need:
    config.active_record.schema_format = :sql

    config.paths.add 'app/concerns', autoload: true
    config.paths.add 'lib', autoload: true

    #
    # `initializer`s
    #

    initializer 'metasploit_pro_ui.rails_6792', after: 'active_record.initialize_database' do
      Rails.application.reloader.to_prepare do
        # @see https://github.com/rails/rails/pull/6792
        require 'metasploit/pro/connection_adapters/postgresql_adapter'

        # ActiveRecord::ConnectionAdapters::SchemaStatements is not an ActiveSupport::Concern, so including the 6792 patch
        # will not be propagated to ActiveRecord::ConnectionAdapters::AbstractAdapter.  Therefore, include directly into
        # AbstractAdapter.
        ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, Metasploit::Pro::ConnectionAdapters::SchemaStatements)
        ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, Metasploit::Pro::ConnectionAdapters::PostgreSQLAdapter)
        ActiveRecord::FinderMethods.send(:include, Metasploit::Pro::FinderMethods)
      end
    end
  end

  #
  # Instance Methods
  #

  private

  # Initialize the default profile if necessary
  #
  # @todo This should be happening inside the Profile model.
  # @return [void]
  def default_profile
    if Mdm::Profile.find_by_name("default").blank?
      dp = Mdm::Profile.new
      dp.active = true
      dp.name = "default"
      dp.owner = "<system>"
      dp.save!
    end
  end

end
