# Deprecates Mdm::WebVuln#category in favor of unique {Web::VulnCategory::Metasploit#name categories} that can be
# assigned an id for use in Mdm::WebVuln#category_id.  With a unique category ID, the metasploit web scanner categories
# can be mapped to other categorization schemes, such as the OWASP Top Ten.
#
# @example Using Web::VulnCategory::Model to validate interface
#   class Web::VulnCategory::MyScanner < ApplicationRecord
#     include Web::VulnCategory::Model
#   end
#
# @example Using RSpec to test interface
#   describe Web::VulnCategory::MyScanner do
#     it_should_behave_like 'Web::VulnCategory::Model'
#   end
#
class Web::VulnCategory::Metasploit < ApplicationRecord
  include Web::VulnCategory::Model

  self.table_name = 'web_vuln_category_metasploits'

  #
  # CONSTANTS
  #

  # Maps old, non-conforming Mdm::WebVuln#category Strings to their new seeded {#name names}.
  NAME_BY_NON_CONFORMING_CATEGORY = {
      'TikiWiki' => 'Version',
      'awstats' => 'Version',
      'basilic' => 'Version',
      'cacti' => 'Version',
      'cmd' => 'CMDi',
      'coppermine' => 'Version',
      'eval' => 'CMDi',
      'http_put' => 'Publicly-Writable-Directory',
      'joomla' => 'Version',
      'lfi' => 'LFI',
      'mybb' => 'Version',
      'oscommerce' => 'Version',
      'php-xml-rpc' => 'Version',
      'rfi' => 'RFI',
      'sql' => 'SQLi',
      'sqli_blind' => 'SQLi',
      'sqli_blind_mysql' => 'SQLi',
      'sqli_blind_postgres' => 'SQLi',
      'tikiwiki1.9.8' => 'Version',
      'tikiwiki8.3' => 'Version',
      'wordpress' => 'Version',
      'xss' => 'XSS'
  }

  #
  # Associations
  #

  # @!attribute [rw] owasp_projections
  #   The join models that actually map pairs of {Web::VulnCategory::Metasploit} and {Web::VulnCategory::OWASP}.
  #
  #   @return [Array<Web::VulnCategory::Projection::MetasploitOWASP>]
  has_many :owasp_projections, :class_name => 'Web::VulnCategory::Projection::MetasploitOWASP', :dependent => :destroy

  # @!attribute [r] owasps
  #   The {Web::VulnCategory::OWASP} that {#owasp_projections map} to this Metasploit vulnerability category.
  #
  #   @return [Array<Web::VulnCategory::OWASP>]
  has_many :owasps, :class_name => 'Web::VulnCategory::OWASP', :through => :owasp_projections

  # @!attribute [rw] vulns
  #   The Mdm::WebVulns that use this record at their Mdm::WebVuln#category.
  #
  #   @return [Mdm::WebVuln]
  has_many :vulns, :class_name => 'Mdm::WebVuln', :dependent => :destroy, :foreign_key => :category_id

  #
  # Attributes
  #

  # @!attribute [r] id
  #   The ID used to refer to {#name}.
  #
  #   @return [Integer]

  # @!attribute [rw] name
  #   The category name used by the web scanner.
  #
  #   @return [String]

  # @!attribute [rw] summary
  #   A longer summary of the category {#name}.
  #
  #   @return [String]

  #
  # Validations
  #

  validates :name, :uniqueness => true
end
