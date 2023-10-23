module Metasploit::Pro::Report::Type::MM_Domino

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'domino', '')
  end

  def self.template_file
    File.join(self.report_dir, 'main.jrxml')
  end

  def self.sections
    {
      cover_page:       'Cover Page',
      exec_summary:     'Executive Summary',
      proj_summary:     'Project Summary',
      run_selections:   'Run Selections',
      findings_summary: 'Findings Summary',
      summary_charts:   'Summary Charts',
      comp_hv_hosts:    'Compromised High Value Hosts',
      uncomp_hv_hosts:  'Uncompromised High Value Hosts',
      all_comp_hosts:   'All Compromised Hosts',
      all_uncomp_hosts: 'All Uncompromised Hosts',
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

  def self.options
    [:include_charts]
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
    'Credentials Domino MetaModule'
  end

  # For help display
  def self.description
    'Summarizes findings from a single Credentials Domino MetaModule run'
  end

  # TODO Should likely require AppRun of correct App type
  def self.required_data
    []
  end

  # Used in UI to determine if address settings apply to this type
  def self.addresses_included?
    true
  end
end