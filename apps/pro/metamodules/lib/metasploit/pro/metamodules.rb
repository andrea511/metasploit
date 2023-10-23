module Metasploit
  module Pro
    module Metamodules
      def self.add_runtime_dependency(gem_specification)
        names.each do |name|
          gem_specification.add_runtime_dependency name
        end
      end

      def self.gems(context, root)
        # calculate a relative path so the Gemfile.lock is not tied to the absolute path of the git repository on any
        # developer's machine.
        roots.each do |metamodule_root|
          name = metamodule_root.basename.to_s
          path = metamodule_root.relative_path_from(root).to_path

          context.gem name, path: path
        end
      end

      def self.gemspecs(context)
        roots.each do |metamodule_root|
          context.gemspec path: metamodule_root.relative_path_from(project_root)
        end
      end

      # The project root
      #
      # @return [Pathname]
      def self.project_root
        @project_root ||= root.parent
      end

      def self.names
        @names ||= roots.collect { |root|
          root.basename.to_s
        }
      end

      def self.require
        names.each do |name|
          super 'apps/'+name
        end
      end

      # The root of all metamodules.
      #
      # @return [Pathname]
      def self.root
        @root ||= Pathname.new(__FILE__).parent.parent.parent.parent
      end

      # The roots of each individual metamodule.
      #
      # @return [Array<Pathname>]
      def self.roots
        unless @roots
          @roots = []

          root.each_child do |child|
            if child.directory?
              name = child.basename.to_s
              gemspec_pathname = child.join("#{name}.gemspec")

              if gemspec_pathname.file?
                @roots << child
              end
            end
          end
        end

        @roots
      end
    end
  end
end
