require 'bundler/extensions'

# Change relative paths to real paths as debuggers and coverage tools expect realpaths and breakpoints won't work
# on non-real paths, such as those that contain symlinks and coverage tools will miss report the coverage numbers
# as they won't be able to match the loaded feature's path to the path on disk.
Bundler.definition.dependencies.each do |dependency|
  source = dependency.source

  if source.is_a?(Bundler::Source::Path) && source.path.relative?
    # fix symlink paths to be realpaths to ensure that debuggers and coverage tools agree with the load path
    # while only writing back relative paths to lock file.
    source.instance_eval do
      original_relative_path = @path

      # relative_path is used to write the lock file
      define_singleton_method(:relative_path) do
        original_relative_path
      end

      # to_s is used to sort the source.  This needs to use original_relative_path so the sorting is stable with
      # this patch and when `bundle install` is used without the patch
      define_singleton_method(:to_s) do
        "source at #{original_relative_path}"
      end

      # path is used for the load_path
      @path = @path.realpath(Bundler.root)

      # invalidate memoized @expanded_path since we changed @path
      @expanded_path = nil
    end
  end
end

Bundler.setup