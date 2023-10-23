# The prevalence of Application-2013-2 and Application-2013-8 have changed since the first migration was created, so
# update the seed migration to match the changes.
class FixOwasp2013Prevalence < ActiveRecord::Migration[4.2]
  # Maps unique {Web::VulnCategory::OWASP} attributes ({Web::VulnCategory::OWASP#rank},
  # {Web::VulnCategory::OWASP#target}, and {Web::VulnCategory::OWASP#version}) to a map of the old
  # {Web::VulnCategory::OWASP#prevalence} to the new {Web::VulnCategory::OWASP#prevalence}.
  NEW_PREVALENCE_BY_OLD_PREVALENCE_BY_OWASP_ATTRIBUTES = {
      {
          :rank => 2,
          :target => 'Application',
          :version => '2013rc1'
      } => {
          'common' => 'widespread'
      },
      {
          :rank => 8,
          :target => 'Application',
          :version => '2013rc1'
      } => {
          'widespread' => 'common'
      }
  }

  # Yields each {Web::VulnCategory::OWASP} along with the old and new value of {Web::VulnCategory::OWASP#prevalence}.
  #
  # @yield [owasp, old, new]
  # @yieldparam owasp [Web::VulnCategory::OWASP] the record whose {Web::VulnCategory::OWASP#prevalence} to change
  # @yieldparam old [String] the old value of {Web::VulnCategory::OWASP#prevalence} before {#up} is run.
  # @yieldparam new [String] the new value of {Web::VulnCategory::OWASP#prevalence} after {#up} is run.
  # @yieldreturn [void]
  # @return [void]
  def each_change
    NEW_PREVALENCE_BY_OLD_PREVALENCE_BY_OWASP_ATTRIBUTES.each do |owasp_attributes, new_prevalence_by_old_prevalence|
      owasp = Web::VulnCategory::OWASP.where(owasp_attributes).first

      new_prevalence_by_old_prevalence.each do |old, new|
        yield owasp, old, new
      end
    end
  end

  # Changes Application-2013rc1-2 back to common prevalence and Application-2013rc1-8 back to widespread prevalence
  #
  # @return [void]
  def down
    each_change do |owasp, old, _|
      owasp.prevalence = old
      owasp.save!
    end
  end

  # Changes Application-2013rc1-2 to widespread prevalence and Application-2013rc1-8 to common prevalence
  #
  # @return [void]
  def up
    each_change do |owasp, _, new|
      owasp.prevalence = new
      owasp.save!
    end
  end
end
