# Wraps `Msf::Module::UI::Message` so that it responds to API needed for
# `ProgressBar#output`.
class Metasploit::Pro::Engine::ModuleUIProgressBarOutput
  #
  # Attributes
  #

  # @return [Msf::Module::UI::Message]
  attr_reader :metasploit_module_instance

  #
  # Initialize
  #

  # @param metasploit_module_instance
  def initialize(metasploit_module_instance)
    self.buffer = ''
    self.metasploit_module_instance = metasploit_module_instance
  end

  #
  # Instance Methods
  #

  # Writes {#buffer} to {#metasploit_module_instance} by printing status, then
  # resets {#buffer}.
  def flush
    metasploit_module_instance.print_status(buffer)
    buffer.clear
  end

  # @note Call {#flush} to print `string` as status to
  #   {#metasploit_module_instance}.
  #
  # Buffer `string` until {#flush} is called.
  #
  # @param string [String] message to log.  Blank strings and "\r" are ignored.
  # @return [void]
  # @see #flush
  def print(string)
    # ignore the `ProgressBar::Outputs::Tty#clear` because we're not really a
    # tty
    unless string.blank? || string == "\r"
      buffer << string
    end
  end

  # Pretend to be a TTY so that full Ruby ProgressBar features are used,
  # including that want to rewrite screen.
  #
  # @return [true]
  def tty?
    true
  end

  private

  # @return [String]
  attr_accessor :buffer

  attr_writer :metasploit_module_instance
end