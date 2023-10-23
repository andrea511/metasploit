module Metasploit::Pro::Report::Type::WebappAssessment

  LOCATIONS = Metasploit::Pro::Report::Type::Base.locations
  ORDERING_OPTIONS = ['Host', 'Category', 'Path',
                      'Risk', 'Vhost', 'OWASP']
  DEFAULT_ORDER = 'Risk'

  def self.report_dir
    File.join(LOCATIONS.pro_report_directory, 'webapp_assessment', '')
  end

  def self.template_file
    File.join(self.report_dir, 'main.jrxml')
  end

  def self.sections
    {:cover        => 'Cover Page',
     :exec_summ    => 'Executive Summary',
     :engage_scope => 'Engagement Scope',
     :owasp_status => 'OWASP Status',
     :summ_graphs  => 'Summary Graphs',
     :vuln_details => 'Vulnerability Details',
     :appendices   => 'Appendices'}
  end

  def self.sections_labeled
    labeled = []
    sections.each_pair do |k,v|
      labeled << [v,k]
    end
    labeled
  end

  def self.options
    []
  end

  def self.options_labeled
    options.collect do |option|
      [Report::OPTIONS_NAMES[option], option]
    end
  end

  def self.formats
    ['pdf', 'html', 'rtf']
  end

  def self.formats_labeled
    formats.collect do |format|
      [format.upcase, format]
    end
  end

  def self.name
    'Web Application Assessment'
  end

  # For help display
  def self.description
    'Findings from web application crawls, audits and exploits.'
  end

  def self.required_data
    [:hosts, :web_sites]
  end

  def self.addresses_included?
    true
  end
end