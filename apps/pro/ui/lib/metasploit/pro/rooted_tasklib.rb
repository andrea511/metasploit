module Metasploit
  module Pro
    class RootedTasklib < Rake::TaskLib
      def initialize(root_pathname)
        @root_pathname = root_pathname
      end

      attr_reader :root_pathname
    end
  end
end