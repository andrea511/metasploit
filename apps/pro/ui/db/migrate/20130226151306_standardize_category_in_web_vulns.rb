class StandardizeCategoryInWebVulns < ActiveRecord::Migration[4.2]
  TABLE_NAME = :web_vulns

  def up
#    engine = Mdm::WebVuln.arel_engine
    table = Mdm::WebVuln.arel_table
    column = table[:category]

    # map old Mdm::WebVuln#category values to new, standardized names
    Web::VulnCategory::Metasploit::NAME_BY_NON_CONFORMING_CATEGORY.each do |old_category, new_category|
      # check that new_category will be able to map to Web::VulnCategory::Metasploit#name in next migration
      unless Web::VulnCategory::Metasploit.where(:name => new_category).exists?
        raise ArgumentError,
              "#{old_category.inspect} cannot map to #{new_category.inspect} " \
              "because #{new_category.inspect} is not a Web::VulnCategory::Metasploit#name"
      end

      # need a new update_manager in each loop because where is additive
#      update_manager = Arel::UpdateManager.new(engine)

      # table, set and where are all mutators, so no need to chain
#      update_manager.table(table)
#      update_manager.set(column => new_category)
#      update_manager.where(
#          column.eq(old_category)
#      )

       # cannot use `update` because migrator only allows execute to pass through unmangled.
#      execute update_manager.to_sql
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
