# Translates between {Web::VulnCategory::Metasploit} and {Web::VulnCategory::OWASP} categories.  This translation can be
# useful as Mdm::WebVuln#category_id points to a {Web::VulnCategory::Metasploit} only, but for reporting, a developer or
# user may want to report using the OWASP Top Ten, which is in {Web::VulnCategory::OWASP}.
class Web::VulnCategory::Projection::MetasploitOWASP < ApplicationRecord
  self.table_name = 'web_vuln_category_projection_metasploit_owasps'

  #
  # Associations
  #

  # @!attribute [rw] metasploit
  #   The {Web::VulnCategory::Metasploit} that maps to the {#owasp}.
  #
  #   @return [Web::VulnCategory::Metasploit]
  belongs_to :metasploit, :class_name => 'Web::VulnCategory::Metasploit'

  # @!attribute [rw] owasp
  #   The {Web::VulnCategory::OWASP} that maps to the {#metasploit}.
  #
  #   @return [Web::VulnCategory::OWASP]
  belongs_to :owasp, :class_name => 'Web::VulnCategory::OWASP'

  #
  # Validations
  #

  validates :metasploit,
            :presence => true
  validates :metasploit_id,
            :uniqueness => {
                :scope => :owasp_id
            }
  validates :owasp, :presence => true
end
