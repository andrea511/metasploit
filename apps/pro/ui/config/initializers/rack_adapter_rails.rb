#
# Monkey-patch Thin to avoid a DoS with reserved file names
#
module Rack
  module Adapter
    class Rails

      def file_exist?(path)
        full_path = ::File.join(@file_app.root, Utils.unescape(path))
        if full_path =~ /\/(CON|PRN|AUX|NUL|COM1|COM2|COM3|COM4|COM5|COM6|COM7|COM8|COM9|LPT1|LPT2|LPT3|LPT4|LPT5|LPT6|LPT7|LPT8|LPT9)([\.\/]|$)/i
          return false
        end
        ::File.file?(full_path) && ::File.readable_real?(full_path)
      end

    end
  end
end
