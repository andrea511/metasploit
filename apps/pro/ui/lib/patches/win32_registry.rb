#
# This patches out a buggy call that converts error messages to the local character map
#

module Win32
class Registry

    #
    # Error
    #
    class Error < ::StandardError
      module Kernel32
        extend Importer
        dlload "kernel32.dll"
      end

      def initialize(code)
        @code = code
        msg = "\0".force_encoding(Encoding::ASCII_8BIT) * 1024
        len = FormatMessageA.call(0x1200, 0, code, 0, msg, 1024, 0)
        msg = msg[0, len]
        super msg.tr("\r", '').chomp
      end
      attr_reader :code
    end

end
end
