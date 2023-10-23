# Seeds {Web::VulnCategory::Projection::MetasploitOWASP} between {Web::VulnCategory::Metasploit} and
# {Web::VulnCategory::OWASP}.
class SeedWebVulnCategoryProjectionMetasploitOwasps2013 < ActiveRecord::Migration[4.2]

    #
    # CONSTANTS
    #

    # The {Web::VulnCategory::OWASP#target} is the same for all {Web::VulnCategory::OWASP} seeds in this migration, so
    # make it a constant.
    TARGET = 'Application'
    # The {Web::VulnCategory::OWASP#version} is the same for all {Web::VulnCategory::OWASP} seeds in this migration, so
    # make it a constant.
    VERSION = '2013rc1'

    def change
        Web::VulnCategory::Metasploit.where(:summary =>  'Command Injection').each do |ms_web_vuln|
            Web::VulnCategory::OWASP.where(:summary => 'Injection', :target => TARGET, :version => VERSION ).each do |owasp|
                Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
            end
        end

        Web::VulnCategory::Metasploit.where(:summary =>  'SQL Injection').each do |ms_web_vuln|
            Web::VulnCategory::OWASP.where(:summary => 'Injection', :target => TARGET, :version => VERSION ).each do |owasp|
                Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
            end
        end

        Web::VulnCategory::Metasploit.where(:summary =>  'Publicly Writable Directory').each do |ms_web_vuln|
            Web::VulnCategory::OWASP.where(:summary => 'Security Misconfiguration', :target => TARGET, :version => VERSION ).each do |owasp|
                Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
            end
        end

        Web::VulnCategory::Metasploit.where(:summary =>  'Vulnerable Version').each do |ms_web_vuln|
            Web::VulnCategory::OWASP.where(:summary => 'Security Misconfiguration', :target => TARGET, :version => VERSION ).each do |owasp|
                Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
            end
        end

        Web::VulnCategory::Metasploit.where(:summary =>  'Cross-site scripting').each do |ms_web_vuln|
            Web::VulnCategory::OWASP.where(:summary => 'Cross-Site Scripting (XSS)', :target => TARGET, :version => VERSION ).each do |owasp|
                Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
            end
        end

        Web::VulnCategory::Metasploit.where(:summary =>  'Insufficient Transport Layer Security').each do |ms_web_vuln|
            Web::VulnCategory::OWASP.where(:summary => 'Sensitive Data Exposure', :target => TARGET, :version => VERSION ).each do |owasp|
                Web::VulnCategory::Projection::MetasploitOWASP.create!(metasploit: ms_web_vuln, owasp: owasp)
            end
        end
    end
end
