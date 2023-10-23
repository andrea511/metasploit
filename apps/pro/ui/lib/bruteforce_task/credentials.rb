module BruteforceTask::Credentials
  extend ActiveSupport::Concern

  include ActiveModel::Validations
  include BruteforceTask::Credentials::Generation
  include BruteforceTask::Credentials::Mutation

  included do
    #
    # Validations
    #

    validates :smb_domains, :allow_blank => true, :smb_domains => true
  end

  #
  # Instance Methods
  #

  def db_names
    @db_names ||= ''
  end

  def db_names=(db_names)
    @db_names = db_names || ''
  end

  def quickmode_creds
    @quickmode_creds ||= ''
  end

  def quickmode_creds=(quickmode_creds)
    @quickmode_creds = quickmode_creds.to_s || ''
  end

  def smb_domains
    @smb_domains ||= ''
  end

  def smb_domains=(smb_domains)
    @smb_domains = smb_domains || ''
  end
end