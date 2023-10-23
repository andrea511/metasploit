# Seeds {Web::VulnCategory::Metasploit Web::VulnCategory::Metasploit's} web_vuln_category_metasploits table.
class SeedWebVulnCategoryMetasploitMissingSeeds < ActiveRecord::Migration[4.2]
  def change
    [
      {
        :name => 'CSRF',
        :summary => 'Cross-Site Request Forgery (CSRF)'
      },
      {
        :name => 'Direct-Object-Reference',
        :summary => 'Direct Object Reference'
      },
      {
        :name => 'Session-Fixation',
        :summary => 'Session fixation'
      },
      {
        :name => 'Unauthorized-Access',
        :summary => 'Unauthorized access'
      },
      {
        :name => 'Unvalidated-Redirect',
        :summary => 'Unvalidated redirect'
      }
    ].each { |attrs| Web::VulnCategory::Metasploit.create attrs }
  end

end
