# Seeds {Web::VulnCategory::Metasploit Web::VulnCategory::Metasploit's} web_vuln_category_metasploits table.
class SeedWebVulnCategoryMetasploits < ActiveRecord::Migration[4.2]

  def change
      Set.new(
        [
          {
            :name => 'CMDi',
            :summary => 'Command Injection'
          },
          {

            :name => 'LFI',
            :summary => 'Local File Inclusion'
          },
          {

            :name => 'Publicly-Writable-Directory',
            :summary => 'Publicly Writable Directory'
          },
          {
            :name => 'RFI',
            :summary => 'Remote File Inclusion'
          },
          {
            :name => 'SQLi',
            :summary => 'SQL Injection'
          },
          {

            :name => 'Version',
            :summary => 'Vulnerable Version'

          },
          {
            :name => 'XSS',
            :summary => 'Cross-site scripting'
          }
        ]
      ).each { |attrs| Web::VulnCategory::Metasploit.create attrs }
  end
end
