# Methods for checking that the database is {migrated? migrated} or {wait_until_migrated waiting until it is migrated},
# which can be useful to coordinating the migrations between pro/ui's Rails application and pro/engine's prosvc's
# framework which does the actual migrations in production.
module Metasploit::Database
  #
  # CONSTANTS
  #

  MIGRATION_REGEXP = /\A(?<padded_version>\d+)_(?<underscored_name>.*?)\.rb\Z/

  module Migration
    def gather_engine_migration_paths
      paths = super
      Migration.ensure_migrations_paths(paths)
    end

    def self.ensure_migrations_paths(paths = ActiveRecord::Migrator.migrations_paths)
      current_migrations_realpath_set = Set.new

      if paths[0].kind_of?(Array)
        paths.each do |migration_path_set|
          migrations_realpath_set = realpath_set(migration_path_set)
          current_migrations_realpath_set.merge(migrations_realpath_set)
        end
      else
        current_migrations_realpath_set.merge(realpath_set(ActiveRecord::Migrator.migrations_paths))
      end

      desired_migrations_realpath_set = Set.new
      engines = [
          Rails.application,
          MetasploitDataModels::Engine.instance
      ]

      engines.each do |engine|
        realpaths = engine.paths['db/migrate'].to_a
        desired_migrations_realpath_set.merge(realpaths)
      end

      new_migrations_realpath_set = current_migrations_realpath_set.union(desired_migrations_realpath_set)
      new_migrations_realpath_set.to_a
    end

    private

    # Resolves the realpath of each path into a Set
    #
    # @param paths [Array, #each] List of paths
    # @return [Set<String>]
    def self.realpath_set(paths)
      realpath_set = Set.new

      paths.each do |path|
        pathname = Pathname.new(path)
        # expand relative paths with respect to the Rails.root so it works if script that loads the rails environment is
        # using a working directory other than pro/ui.
        expanded_pathname = pathname.expand_path(Rails.root)
        if File.exist?(expanded_pathname)
          real_pathname = expanded_pathname.realpath
          realpath = real_pathname.to_path
          realpath_set.add realpath
        end
      end

      realpath_set
    end
  end

  # Fails if in test environment and not migrated.
  #
  # @raise [RuntimeError]
  # @see migrated?
  def self.fail_fast_under_test!
    if Rails.env.test? && !migrated?
      fail "Run `RAILS_ENV=test rake db:migrate` before running tests"
    end
  end

  # Returns whether all the migrations have run.
  #
  # @return [Boolean]
  #
  # @see activerecord/lib/active_record/railties/database.rake for db:migrate:status
  def self.migrated?
    migrated = false
    migrated_version_set = self.migrated_version_set

    unless migrated_version_set.empty?
      migration_version_set = self.migration_version_set

      # migrated_version_set should be equal to or a proper superset of migration_version_set if the database contains
      # migrations that are now missing the migration file.
      if migrated_version_set.superset?(migration_version_set)
        migrated = true
      end
    end

    migrated
  end

  # Returns Set of ActiveRecord::Migration versions based on the migration versions found in the database.
  #
  # @return [Set] an empty Set if migrations have not been run.
  # @return [Set] a Set of version string.
  def self.migrated_version_set
    migrated_version_set = Set.new
    table_name = ActiveRecord::SchemaMigration.table_name

    if ActiveRecord::Base.connection.table_exists?(table_name)
      migrated_versions = ActiveRecord::Base.connection.select_values("SELECT version FROM #{table_name}")
      migrated_version_set = Set.new(migrated_versions)
    end

    migrated_version_set
  end

  # Returns Set of ActiveRecord::Migration versions based on the migrations found on
  # ActiveRecord::Migrator.migrations_paths.
  #
  # @return [Set<String>] a Set of version strings.
  def self.migration_version_set
    migration_version_set = Set.new

    # Rails 5 can now returning an array for each DatabaseConfig ( this may need more work to be assured stable )
    Migration.ensure_migrations_paths.each do |migrations_path_set|
      migrations_array = []
      if migrations_path_set.kind_of?(String)
        migrations_array << migrations_path_set
      else
        migrations_array |= migrations_path_set
      end
      migrations_array.each do |migrations_path|
        Dir.foreach(migrations_path) do |file|
          match = MIGRATION_REGEXP.match(file)

          if match
            # strip any leading zeroes from old-naming-style migration files
            version = match[:padded_version].to_i.to_s
            migration_version_set.add version
          end
        end
      end
    end

    migration_version_set
  end

  # Waits until {migrated?} is true or timeout seconds elapse.
  #
  # @param timeout [Integer, nil] The number of seconds to wait for {migrated?} to become true.  If `nil`, then waits
  #   forever.
  # @return [void]
  # @raise [Metasploit::Database::MigrationTimeoutError] if timeout expires
  #
  # @see Timeout.timeout
  def self.wait_until_migrated(timeout=nil)

    fail_fast_under_test!

    Timeout.timeout(timeout, Metasploit::Database::MigrationTimeoutError) do
      loop do
        if migrated?
          break
        end

        sleep(1.second)
      end
    end
  end
end
