# RM_INFO is set when using Rubymine.  In Rubymine, starting SimpleCov is
# controlled by running with coverage, so don't explicitly start coverage (and
# therefore generate a report) when in Rubymine.  This _will_ generate a report
# whenever `rake spec` is run.
unless ENV['RM_INFO'] || SimpleCov.running
  SimpleCov.start
end

SimpleCov.configure do
  # ignore this file
  add_filter '.simplecov'

  # Rake tasks aren't tested with rspec
  add_filter 'Rakefile'
  add_filter 'lib/tasks'

  #
  # Changed Files in Git Group
  # @see http://fredwu.me/post/35625566267/simplecov-test-coverage-for-changed-files-only
  #

  untracked = `git ls-files --exclude-standard --others`
  unstaged = `git diff --name-only`
  staged = `git diff --name-only --cached`
  all = untracked + unstaged + staged
  changed_filenames = all.split("\n")

  add_group 'Changed' do |source_file|
    changed_filenames.detect { |changed_filename|
      source_file.filename.end_with?(changed_filename)
    }
  end

  add_group 'Libraries', 'lib'

  #
  # Specs are reported on to ensure that all examples are being run and all
  # lets, befores, afters, etc are being used.
  #

  add_group 'Specs', 'spec'
end
