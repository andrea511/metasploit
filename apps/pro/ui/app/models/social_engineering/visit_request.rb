
#
#
# Verifies and classifies HTTP traffic for tracking.
#
#
#
#
#
require 'cgi'

module SocialEngineering
class VisitRequest
  class InvalidQueryStringSize < Exception; end
  class InvalidQueryStringChecksum < Exception; end
  
  QUERY_STRING_DATA_PARAM_KEY = "d"
  VALID_BYTE_LENGTH = 12
  VALID_UUID_LENGTH = 36

  # Rex::HTTP::Request resource path that is reservedf or email tracking
  EMAIL_TRACKING_PATH = "/eot"

  attr_reader :rex_request, :uri_parts, :cookie_hash, :email_id, :human_target_id, :type, :req_address
  attr_accessor :human_target, :email, :web_page

  # Holder for memoizing the MD5 digested License.get.product_serial string
  @@_secret_encoding_string = nil

  # Holder for a framework instance if available
  @@_framework = nil

  def initialize(req, ip_address)
    verify_rex_request!(req)
    @rex_request   = req
    @uri_parts     = rex_request.uri_parts
    @cookie_hash   = parse_cookie_string(rex_request.headers['Cookie'])
    @req_address   = ip_address
  end

  # VisitRequest objects have a one-time-settable type derived
  # from the request, which a module can use to determine
  # whether it is interested in the traffic.

  # -- types --
  # :tracked_user -- a cookie exists for this known HumanTarget
  # :track_request -- a *new* Campaign hit - a known HumanTarget using a tracking link
  # :redirect -- a campaign has been redirected after creating a cookie for this HumanTarget
  # :landing_page -- a request for a campaign landing page based on a previous redirect
  # :unknown_user -- clean! - potential anonymous HumanTarget?
  # :untrackable -- something is weird - cookie exists but not proper format
  # :bogus_request -- someone is trying to spoof us - counter pwnage!
  # :favicon -- just a request for /favicon.ico
  # :email_open_request -- comes from HTML in an email sent out to a HumanTarget


  def type
    @type ||= lambda{
      return :favicon if uri_parts['Resource'] == "/favicon.ico"
      return type_from_uri_parts(true) if redirect?

      if uri_parts['Resource'].start_with? EMAIL_TRACKING_PATH
        return type_from_email
      end

      if complete_uri_parts?
        type_from_uri_parts
      else
        if rex_request.respond_to?(:web_page) && SocialEngineering::WebPage::AttackType::Phishing::PHISHING_REDIRECT_ORIGINS.include?(rex_request.web_page.phishing_redirect_origin)
          return :landing_page
        end
        :unknown_user
      end
    }.call
  end

  def create_visit!
    VisitCreator.new.create(human_target, email, req_address)
  end

  def create_email_opening!
    EmailOpening.create(:human_target_id => human_target.id, :email_id => email.id, :address => req_address)
  end

  # TODO: do we want to have some more interesting tracking stuff here for anonymous targets?
  # How will we know where they came from?
  def create_new_human_target
    HumanTarget.create_anonymous
  end

  def valid_cookie_hash?
    cookie_hash.has_key?(COOKIE_KEY)
    false
  end

  def redirect?
    uri_parts['QueryString']['Redirect']
  end

  def encoded_tracking_cookie_string
    fail "object is missing email or human target attribute" unless (email.present? && human_target.present?)
    # "#{COOKIE_KEY}=#{self.class.encoded_query_params(email.id, human_target.id)}"

    data_hash = {
      email_address: human_target.email_address,
      email_ids: [email.id]
    }
    self.class.crypt.encrypt_and_sign(data_hash)
  end


  # Secret string used to protect our generated values
  def self.secret
    @@_secret_encoding_string ||= Digest::MD5.digest(
      @@_framework ? @@_framework.esnecil_product_serial : ::License.get.product_serial
    )
  end
  
  # memoize the encryption key
  def self.crypt
    @crypt ||= lambda {
      key = ActiveSupport::KeyGenerator.new(self.secret).generate_key(::License.get.product_key)
      crypt = ActiveSupport::MessageEncryptor.new(key)
    }.call
  end
  
  # CGI escape the query string
  def self.encoded_query_params(email_id, human_target_id)
    CGI.escape self._generate_encoded_params(email_id, human_target_id)
  end

  # Create base64 version of query string
  # don't call directly -- use self.encoded_query_params instead
  def self._generate_encoded_params(email_id, human_target_id)
    xorv               = Digest::MD5.digest(self.secret).unpack("N").last
    email_value        = (email_id.to_i ^ xorv)
    human_target_value = (human_target_id.to_i ^ xorv)
    raw                = [email_value, human_target_value].pack("NN")
    chk                = Digest::MD5.digest(self.secret + raw).unpack("N").first
    raw << [ chk ].pack("N")

    [ raw ].pack("m*").gsub(/\s+/, '')
  end

  # Decode a hashed/encoded query string parameter
  def self.decoded_query_params(encoded)
    en_64 = encoded.to_s.unpack("m*").first rescue nil
    unless en_64 and en_64.length == VALID_BYTE_LENGTH
      raise InvalidQueryStringSize, "decoded length must be 12 bytes"
    end

    vrfy = Digest::MD5.digest(self.secret + en_64[0,8]).unpack("N").first

    email_encoded, human_target_encoded, cksm = en_64.unpack("NNN")
    if cksm != vrfy
      raise InvalidQueryStringChecksum, "checksum is not valid"
    end

    xorv = Digest::MD5.digest(self.secret).unpack("N").last
    [ ( email_encoded ^ xorv ), ( human_target_encoded ^ xorv ) ]
  end

  def self.framework=(framework)
    @@_framework = framework
  end

  def self.framework
    @@_framework
  end

  def trackable?
    (type != :bogus_request) && (type != :untrackable)
  end

private

  # Classify as an email open track
  def type_from_email
    data = uri_parts['QueryString'][QUERY_STRING_DATA_PARAM_KEY]
    unless data
      data = uri_parts['Resource'][EMAIL_TRACKING_PATH.length+1..-1]
    end
    type_from_data(data, :email_open_request) # modify to check url type & put the proper resource in data
  end


  # Derive one of the valid states from the uri_parts
  def type_from_uri_parts(redirect = false)
    type = type_from_data( uri_parts['QueryString'][QUERY_STRING_DATA_PARAM_KEY], :uri_parts)
    redirect ? :redirect : type
  end

  # Derive one of the valid states from the uri_parts
  def type_from_data(data, type)
    begin
      if data.length == VALID_UUID_LENGTH
        tracker = SocialEngineering::Tracking.where(uuid: data).first
        if tracker
          email_id = tracker.email.id
          human_id = tracker.human_target.id
        end
      else
        email_id, human_id = self.class.decoded_query_params(data)
      end
      if email_and_human_target_found_and_set?(email_id, human_id)
        case type
        when :uri_parts
          return :track_request # this request is from a tracking link
        when :email_open_request
          return :email_open_track
        end
      end
    rescue InvalidQueryStringSize
      return :bogus_request
    rescue InvalidQueryStringChecksum
      return :bogus_request
    end

    :bogus_request
  end

  # Side effects bad!  But sorta necessary here...
  def email_and_human_target_found_and_set?(email_id, human_id)
    if can_verify_and_set_email?(email_id) and can_verify_and_set_human_target?(human_id)
      @human_target_id = human_id
      @email_id = email_id
      true
    else
      false
    end
  end

  # Validates that the expected parameters are not blank
  def complete_uri_parts?
    not uri_parts['QueryString'][QUERY_STRING_DATA_PARAM_KEY].blank?
  end

  def can_verify_and_set_human_target?(human_target_id)
    begin
      self.human_target = HumanTarget.find(human_target_id)
      true
    rescue ActiveRecord::RecordNotFound
      false
    end
  end

  def can_verify_and_set_email?(email_id)
    begin
      self.email = Email.find(email_id)
      true
    rescue ActiveRecord::RecordNotFound
      false
    end
  end

  # Raise an exception unless the request conforms to expected class
  # and uri_parts has expected structure
  def verify_rex_request!(req)
    fail "unexpected argument - expected Rex::Proto::Http::Request" unless req.is_a?(Rex::Proto::Http::Request)
    unless req.uri_parts.has_key?('QueryString') && req.resource
      fail "Rex request URI hash has unexpected structure"
    end
  end

  # Handles unescaping
  def parse_cookie_string(string)
    CGI::Cookie.parse(string)
  end

end
end
