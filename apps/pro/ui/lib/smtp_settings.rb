class SmtpSettings
  #
  # CONSTANTS
  #

  PASSWORD_KEY = 'smtp_password'
  # Used to indicate that the password is not blank, and it should remain unchanged, so that the user can't get the real
  # password from the input value attribute and the input is not shown as blank when the password is not blank.
  PASSWORD_UNCHANGED = 'password unchanged'

  def initialize(values={})
    set_default_values(values)
  end

  def address
    @values['smtp_address']
  end

  def port
    @values['smtp_port']
  end

  def domain
    @values['smtp_domain']
  end

  def username
    @values['smtp_username']
  end

  def password
    @values[PASSWORD_KEY]
  end

  def authentication
    @values['smtp_authentication'].to_sym
  end

  def ssl
    @values['smtp_ssl']
  end

  def apply_to(target)
    @values.each do |key, value|
      unless key == PASSWORD_KEY and value == PASSWORD_UNCHANGED
        target[key] = value
      end
    end
  end

  def to_mailer
    configuration = {
      :address              => address,
      :port                 => port.to_i,
      :domain               => domain,
      :enable_starttls_auto => true
    }

    configuration.merge!({ 
      :user_name      => username,
      :password       => password,
      :authentication => authentication
    }) unless using_no_auth?

   configuration.merge!({
     :ssl => ssl
   }) if ssl

    configuration
  end

  private

  DEFAULT_VALUES = {
    'smtp_address'        => 'localhost', 
    'smtp_port'           => 25, 
    'smtp_domain'         => 'localhost.localdomain',
    'smtp_ssl'            => false,
    'smtp_username'       => '', 
    'smtp_password'       => '', 
    'smtp_authentication' => 'plain'
  }

  def set_default_values(initial_values)
    smtp_values = find_smtp_values(initial_values)
    @values = DEFAULT_VALUES.merge(smtp_values)
  end

  def find_smtp_values(hash)
    hash.select { |k| k.to_s.starts_with? 'smtp' }
  end

  def using_no_auth?
    username.blank?
  end
end
