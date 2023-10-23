module Metasploit::Pro::Report::Type::Credentials

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'credentials', '')
  end

  def self.template_file
    File.join(self.report_dir, 'main.jrxml')
  end

  def self.sections
    {
      cover_page: 'Cover Page',
      proj_summ: 'Project Summary',
      creds_summary: 'Credentials Summary',
      plaintext_passwords: 'Plaintext Passwords',
      hashes: 'Hashes',
      ssh_keys: 'SSH Keys',
      logins: 'Login Details',
      hosts: 'Host Details',
      modules: 'Module Details',
      appendix_options: 'Appendix: Report Options'
    }
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  # TODO
  def self.options
    [:include_charts, :mask_credentials]
  end

  def self.options_labeled
    options.collect do |option|
      [Report::OPTIONS_NAMES[option], option]
    end
  end

  def self.formats
    ['pdf', 'html', 'word', 'rtf']
  end

  def self.formats_labeled
    formats.collect do |format|
      [format.upcase, format]
    end
  end

  def self.name
    'Credentials'
  end

  # For help display
  def self.description
    'Summarizes credentials and related data within the project'
  end

  def self.required_data
    [:hosts, :core_credentials]
  end

  # Used in UI to determine if address settings apply to this type
  def self.addresses_included?
    true
  end
end