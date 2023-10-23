# Seeds {Web::VulnCategory::Projection::MetasploitOWASP} between {Web::VulnCategory::Metasploit} and
# {Web::VulnCategory::OWASP}.
class SeedWebVulnCategoryProjectionMetasploitOwaspsMissingSeeds < ActiveRecord::Migration[4.2]
  #
  # CONSTANT
  #

  # The {Web::VulnCategory::OWASP#target} is the same for all {Web::VulnCategory::OWASP} seeds in this migration, so
  # make it a constant.
  TARGET = 'Application'
  # The {Web::VulnCategory::OWASP#version} is the same for all {Web::VulnCategory::OWASP} seeds in this migration, so
  # make it a constant.
  VERSION = '2010'

  def change

    Web::VulnCategory::Metasploit.where(:summary =>  'Cross-Site Request Forgery (CSRF)').each do |ms_web_vuln|
      Web::VulnCategory::OWASP.where(:summary => 'Cross-Site Request Forgery (CSRF)', :target => TARGET, :version => VERSION ).each do |owasp|
        Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
      end
    end

    Web::VulnCategory::Metasploit.where(:summary =>  'Direct Object Reference').each do |ms_web_vuln|
      Web::VulnCategory::OWASP.where(:summary => 'Insecure Direct Object References', :target => TARGET, :version => VERSION ).each do |owasp|
        Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
      end
    end

    Web::VulnCategory::Metasploit.where(:summary =>  'Session fixation').each do |ms_web_vuln|
      Web::VulnCategory::OWASP.where(:summary => 'Broken Authentication and Session Management', :target => TARGET, :version => VERSION ).each do |owasp|
        Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
      end
    end

    Web::VulnCategory::Metasploit.where(:summary =>  'Unvalidated redirect').each do |ms_web_vuln|
      Web::VulnCategory::OWASP.where(:summary => 'Unvalidated Redirect and Forwards', :target => TARGET, :version => VERSION ).each do |owasp|
        Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
      end
    end

    Web::VulnCategory::Metasploit.where(:summary =>  'Unauthorized access').each do |ms_web_vuln|
      Web::VulnCategory::OWASP.where(:summary => 'Failure to Restrict URL Access', :target => TARGET, :version => VERSION ).each do |owasp|
        Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
      end
    end

  end

end
