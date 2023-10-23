# Seeds {Web::VulnCategory::Metasploit Web::VulnCategory::Metasploit's} web_vuln_category_metasploits table.
class SeedWebVulnCategoryMetasploitTls < ActiveRecord::Migration[4.2]
  def change
    [
      {
        :name => 'Transport-Layer-Encryption',
        :summary => 'Insufficient Transport Layer Security'
      },

    ].each { |attrs| Web::VulnCategory::Metasploit.create attrs }
  end

end
