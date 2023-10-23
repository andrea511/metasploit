# Represents the OWASP Top Ten projects,vulnerability categorization schemes for both the original
# {https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project Application} and the newer
# {https://www.owasp.org/index.php/OWASP_Mobile_Security_Project#tab=Top_Ten_Mobile_Risks Mobile} {#target targets}.
#
# The OWASP categories are updated every few years, so the {#version} of the list is maintained for each record.  As of
# 2013-02-19, the application target's list was last updated in `2010` and the mobile target's list is still a release
# candidate, `RC1`.
#
# @see https://www.owasp.org/index.php/Top_10_2010-Main
class Web::VulnCategory::OWASP < ApplicationRecord
  include Web::VulnCategory::Model

  self.table_name = 'web_vuln_category_owasps'

  #
  # CONSTANTS
  #

  # Either how hard it is it {#detectability detect} or {#exploitability exploit} a vulnerability.  Ordered from easiest
  # to hardest.
  DIFFICULTIES = [
      'easy',
      'average',
      'difficult'
  ]

  # The {#impact impact} of a vulnerability being {#exploitability exploited}.  Ordered from most to least severe.
  # Using
  IMPACTS = [
      'severe',
      'moderate',
      'minor'
  ]

  # The {#prevalence prevalance} of a vulnerability across organizations.  Let's you know if you're in good company if
  # your application has this category of vulnerability.  Ordered from most to least prevalent.
  PREVALENCES = [
      'very widespread',
      'widespread',
      'common',
      'uncommon'
  ]

  # The ranks assigned to a category by OWASP.  `1` is the top rank and `10` the lowest for any given {#target} and
  # {#version}.
  RANK_RANGE = 1 .. 10

  # OWASP maintains two Top Ten lists, the original `'Application'` list, and the new `'Mobile'` list.
  TARGETS = [
      'Application',
      'Mobile'
  ]

  #
  # Associations
  #

  # @!attribute [rw] metasploit_projections
  #   The join models that actually map pairs of {Web::VulnCategory::OWASP} and {Web::VulnCategory::Metasploit}.
  #
  #   @return [Array<Web::VulnCategory::Projection::MetasploitOWASP>]
  has_many :metasploit_projections,
           :class_name => 'Web::VulnCategory::Projection::MetasploitOWASP',
           :dependent => :destroy

  # @!attribute [r] metasploits
  #   The {Web::VulnCategory::Metasploit} that {#metasploit_projections map} to this OWASP vulnerability category.
  #
  #   @return [Array<Web::VulnCategory::Metasploit>]
  has_many :metasploits, :class_name => 'Web::VulnCategory::Metasploit', :through => :metasploit_projections

  #
  # Attributes
  #

  # @!attribute [rw] detectability
  #   The {DIFFICULTIES difficulty} of detecting this category of vulnerability.
  #
  #   @return [String]

  # @!attribute [rw] exploitability
  #   The {DIFFICULTIES difficulty} of exploiting this category of vulnerability.
  #
  #   @return [String]

  # @!attribute [rw] impact
  #   The {IMPACTS impact} of this category of vulnerability being {#exploitability exploited}.
  #
  #   @return [String]

  # @!attribute [rw] name
  #   The name of a category is the first letter of the {#target} with the {#rank}
  #
  #   @example name of top Application vulnerability category
  #     'A1'
  #
  #   @return [String]

  # @!attribute [rw] prevalence
  #   The {PREVALENCES prevalence} of this vulnerability in the wild.
  #
  #   @return [String]
  #   @see http://www.despair.com/tradition.html

  # @!attribute [rw] rank
  #   The OWASP assigned-rank for this category for the given {#target} and {#version}.  A higher position in the list
  #   (and a lower rank) is a greater risk according to OWASP.
  #
  #   @return [Integer]

  # @!attribute [rw] summary
  #   A short summary using fully expanded acronyms and abbreviation.  For OWASP, this is the more descriptive field
  #   over {#name} since {#name} will just be something like '`A1`' while {#summary} will be something like
  #   `'Injection'` that is (potentially) understandable without looking at the {https://www.owasp.org/index.php
  #   OWASP wiki}.
  #
  #  @return [String]

  # @!attribute [rw] target
  #   The target of the vulnerability on this list.  Used to distinguish between the original `'Application'` security
  #   OWASP Top Ten and the newer `'Mobile'` security OWASP Top Ten.
  #
  #   @return [String]

  # @!attribute [rw] version
  #   The version of the {#target} list.  For the `'Application'` target this will usually be the full year, such as
  #   `'2010'`, but for the `'Mobile'` target it could be something like `'RC1'` since the `'Mobile'` list hasn't been
  #   finalized for any year yet.
  #
  #   @return [String]

  #
  # Callbacks
  #

  before_validation :derive_name

  #
  # Validations
  #

  validates :detectability,
            :inclusion => {
                :in => DIFFICULTIES
            }
  validates :exploitability,
            :inclusion => {
                :in => DIFFICULTIES
            }
  validates :impact,
            :inclusion => {
                :in => IMPACTS
            }
  validate :name_format
  validates :prevalence,
            :inclusion => {
                :in => PREVALENCES
            }
  validates :rank,
            :inclusion => {
                :in => RANK_RANGE
            },
            :uniqueness => {
                :scope => [
                    :target,
                    :version
                ]
            }
  validates :target,
            :inclusion => {
                :in => TARGETS
            }
  validates :version, :presence => true

  private

  # Derives {#name} from {#target} and {#rank} to be valid under {#name_format}.
  #
  # @return [void]
  def derive_name
    if name.blank? and target.present? and rank.present?
      self.name = "#{target.first}#{rank}"
    end
  end

  # Validates that name is derived from first letter of {#target} and {#rank}
  #
  # @return [void]
  def name_format
    if name and target and rank and name != "#{target.first}#{rank}"
      errors.add(:name, "does not match OWASP format (<target prefix><rank>)")
    end
  end
end
