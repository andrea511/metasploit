# Defines a {#platform} method that acts similarly to `Rails.env`: it is a an `ActiveSupport::StringInquirer`.
module Metasploit::Pro::UI::Platform
  # The current platform, include bits.
  #
  # @return [ActiveSupport::StringInquirer] `'linux32'`, `'linux64'`, `'unknown'`, `'win64'` or `'win32'`
  def platform
    unless @platform
      platform = 'unknown'

      case RUBY_PLATFORM
        when /x86_64-linux/
          platform = 'linux64'
        when /i[3456]86-linux/
          platform = 'linux32'
        when /x64-mingw32/
          platform = 'win64'
        when /i386-mingw32/
          platform = 'win32'
      end

      @platform = ActiveSupport::StringInquirer.new(platform)
    end

    @platform
  end
  module_function :platform
  # module_function makes instance method private by default
  public :platform
end
