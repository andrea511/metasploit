require 'net/smtp'
class SmtpSettingsValidator
  SMTP_VALIDATION_TIMEOUT = 3

  def initialize(opts= {})
    @server      = opts[:server]
    @port        = opts[:port]
    @use_ssl     = opts[:ssl] || false
    @username    = opts[:username] || ''
    @password    = opts[:password] || ''
    @domain      = opts[:domain] || 'localhost'
    @auth        = opts[:auth].to_sym || :plain

    # Why?
    @domain = 'localhost' if @domain.blank?
  end

  def errors
    @errors ||= []
  end

  # @return [Boolean] if we are able to connect to the specified SMTP
  #   server. Adds error messages to the @errors array, a la AR.
  def valid?
    if @server.blank?
      errors << 'Invalid host'
    elsif @port.blank?
      errors << 'Invalid port'
    else
      begin
        smtp = [:high, :meduim, :default].reduce(nil) do |acc, level|
          acc || begin
                   s = smtp_connect(level)
                 rescue OpenSSL::SSL::SSLError => e
                   raise e if level == :default
                   nil
                 end
        end
      rescue OpenSSL::SSL::SSLError
        errors << 'Could not initiate SSL connection'
      rescue  Timeout::Error, IOError
        errors << 'Connection timeout error'
      rescue  Net::SMTPAuthenticationError
        errors << 'Authentication error'
      rescue SocketError, Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL
        errors << 'Could not connect to host'
      rescue => e
        errors << e.to_s
        Rails.logger.error("Error connecting to SMTP server #{e.class}: #{e.to_s}\n#{e.backtrace.join('\n')}")
      ensure
        smtp.finish if smtp && smtp.started?
      end
    end
    errors.empty?
  end

  def smtp_connect(level=:high)
    smtp = Net::SMTP.new(@server, @port)
    smtp.open_timeout = SMTP_VALIDATION_TIMEOUT
    smtp.read_timeout = SMTP_VALIDATION_TIMEOUT

    ctx = gen_ssl_ctx level

    if @use_ssl
      smtp.enable_ssl(context = ctx)
    else
      smtp.enable_starttls_auto(context = ctx)
    end

    if @username.blank? && @password.blank?
      smtp.start
    else
      smtp.start(@domain, @username, @password, @auth)
    end

    smtp
  end

  def gen_ssl_ctx(level=:high)
    ctx = case level
          when :high
            ctx = OpenSSL::SSL::SSLContext.new(:SSLv23)
            ctx.ciphers = "ALL:!ADH:!EXPORT:!SSLv2:!SSLv3:+HIGH:+MEDIUM"
            ctx
          when :meduim
            OpenSSL::SSL::SSLContext.new(:TLSv1)
          when :default
            OpenSSL::SSL::SSLContext.new
          end
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    ctx
  end
end
