require 'cgi'

class EscapeHtmlInVulns < ActiveRecord::Migration[4.2]
  # Nexpose sends us pre-escaped VulnDefs, and we shipped without sanitizing them
  # So if user already has some VulnDefs at this point, we need to sanitize their
  # descriptions and their associated Vulnerabilities' descriptions
  def up
    Nexpose::Data::VulnerabilityDefinition.find_each do |nexpose_vuln|
      # sanitize the description on the nexpose vuln def
      nexpose_vuln.sanitize_description
      nexpose_vuln.save
      # now apply the new description to associated mdm vuln defs
      Mdm::Vuln.where(:nexpose_data_vuln_def_id => nexpose_vuln).
        update_all(info: nexpose_vuln.description)
    end
  end

  def down
    # to ensure that we don't run this migration twice on the same data, which
    # could result in HTML entities being doubly-decoded (e.g. "&amp;amp;" -> "&amp;" -> "&")
    raise ActiveRecord::IrreversibleMigration
  end
end
