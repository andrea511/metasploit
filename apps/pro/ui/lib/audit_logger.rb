# Make AuditLogger a Singleton so that the constant
# AuditLogger is available throughout the App and
# behaves exactly like an instance of Ruby Logger
class AuditLogger < Logger
  GROUPS = %w(AUTHENTICATION FILESYSTEM SETTINGS ADMIN APPLICATION SECURITY USER).freeze
  GROUP_MAX_LENGTH = GROUPS.max{|a,b| a.length <=> b.length}.length

  class << self
    attr_accessor :logger

    delegate :authentication, :filesystem, :settings, :admin, :application, :security, :user,
      to: :logger
  end

  def initialize(file)
    super(file)
    self.formatter    = formatter
    self.class.logger = self
  end

  def authentication(msg, prog_name=nil, &block)
    add(0, msg, prog_name, &block)
  end

  def filesystem(msg, prog_name=nil, &block)
    add(1, msg, prog_name, &block)
  end

  def settings(msg, prog_name=nil, &block)
    add(2, msg, prog_name, &block)
  end

  def admin(msg, prog_name=nil, &block)
    add(3, msg, prog_name, &block)
  end

  def application(msg, prog_name=nil, &block)
    add(4, msg, prog_name, &block)
  end

  def security(msg, prog_name=nil, &block)
    add(5, msg, prog_name, &block)
  end

  def user(msg, prog_name=nil, &block)
    add(6, msg, prog_name, &block)
  end

  def formatter
    Proc.new do |severity, time, progname, msg|
      formatted_group = severity.to_s.center(GROUP_MAX_LENGTH)
      formatted_time = time.getutc.strftime("%Y-%m-%d %H:%M:%S %Z")
      "[#{formatted_time} #{formatted_group}] #{msg}\n"
    end
  end

  def format_severity(group)
    GROUPS[group]
  end
end
