# Enroller responsible for getting a valid email address and API Key
# from [Sonar](http://sonar.labs.rapid7.com/) and storing it as
# a {SonarAccount}
class Metasploit::Pro::Engine::Sonar::Enroller

  # @return [String] the Metasploit Product Key to enroll with
  attr_accessor :product_key

  # @return [SonarAccount] the Sonar Account Details
  attr_accessor :sonar_account

  def initialize(product_key)
    @product_key   = product_key.dup
    @sonar_account = SonarAccount.first
  end

  def enroll
    registration_hash = sonar_client.register_metasploit(product_key)
    if registration_hash[:valid] == true
      @sonar_account ||= SonarAccount.new
      sonar_account.email = registration_hash[:email]
      sonar_account.api_key = registration_hash[:api_key]
      sonar_account.save!
    elsif !(sonar_account.nil?)
      sonar_account.destroy!
      @sonar_account = nil
    end
    sonar_account
  end

  def sonar_client
    Sonar::Client.new(sonar_client_options)
  end

  private

  def sonar_client_options
    {
      access_token: '',
      api_url:      'https://sonar.labs.rapid7.com',
      api_version:  'v2',
      email:        ''
    }
  end
end