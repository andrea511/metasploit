require 'ruby_smb/server/share/provider/virtual_disk/virtual_pathname'
require 'ruby_smb/server/share/provider/virtual_disk/virtual_stat'

module RubySMB
  class Server
    module Share
      module Provider
        class VirtualDisk < Disk
          # A dynamic file is one whose contents are generated by the specified
          # block.
          class VirtualDynamicFile < VirtualPathname
            # @param [Hash] disk The mapping of paths to objects representing the virtual file system.
            # @param [String] path The path of this entry.
            # @param [File::Stat] stat An explicit stat object describing the file.
            def initialize(disk, path, stat: nil, &block)
              raise ArgumentError.new('a generation block must be specified') if block.nil?

              @content_generator = block
              super(disk, path)
              @stat = stat
            end

            def generate(server_client, session)
              content = @content_generator.call(server_client, session)
              VirtualStaticFile.new(@virtual_disk, @path, content, stat: @stat)
            end
          end

          # A static file is one whose contents are known at creation time and
          # do not change.
          class VirtualStaticFile < VirtualPathname
            # @param [Hash] disk The mapping of paths to objects representing the virtual file system.
            # @param [String] path The path of this entry.
            # @param [String] content The static content of this file.
            # @param [File::Stat] stat An explicit stat object describing the file.
            def initialize(disk, path, content, stat: nil)
              stat = stat || VirtualStat.new(file?: true, size: content.size)
              raise ArgumentError.new('stat is not a file') unless stat.file?

              @content = content
              super(disk, path, stat: stat)
            end

            def open(mode = 'r', &block)
              file = StringIO.new(@content)
              block_given? ? block.call(file) : file
            end

            attr_reader :content
          end

          # A mapped file is one who is backed by an entry on disk. The path
          # need not be present, but if it does exist, it must be a file.
          class VirtualMappedFile < VirtualPathname
            # @param [Hash] disk The mapping of paths to objects representing the virtual file system.
            # @param [String] path The path of this entry.
            # @param [String, Pathname] mapped_path The path on the local file system to map into the virtual file system.
            def initialize(disk, path, mapped_path)
              mapped_path = Pathname.new(File.expand_path(mapped_path)) if mapped_path.is_a?(String)
              raise ArgumentError.new('mapped_path must be absolute') unless mapped_path.absolute? # it needs to be absolute so it is independent of the cwd

              @virtual_disk = disk
              @path = path
              @mapped_path = mapped_path
            end

            def exist?
              # filter out anything that's not a directory but allow the file to be missing, this prevents exposing
              # directories which could yield path confusion errors
              @mapped_path.exist? && @mapped_path.file?
            end

            def stat
              @mapped_path.stat
            end

            def open(mode = 'r', &block)
              @mapped_path.open(mode, &block)
            end
          end
        end
      end
    end
  end
end
