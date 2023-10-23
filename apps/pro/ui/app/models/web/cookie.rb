# the majority of the implementation was taken from 
#   https://github.com/dwaite/cookiejar/blob/master/lib/cookiejar/cookie.rb
# it has been modified to use active record objects for a persistant store
# this should be refactored in the near future

class Web::Cookie < ApplicationRecord
  
  #
  # Associations
  #

  belongs_to :request_group, :class_name => 'Web::RequestGroup'

  #
  # Validations
  #

  validates :name,  :presence => true,
                    :uniqueness => true
  
  validates :request_group, :presence => true
  validates :value, :presence => true

  # Create a cookie based on an absolute URI and the string value of a
  # 'Set-Cookie' header.
  #
  # @param request_uri [String, URI] HTTP/HTTPS absolute URI of request.
  # This is used to fill in domain and port if missing from the cookie,
  # and to perform appropriate validation.
  # @param set_cookie_value [String] HTTP value for the Set-Cookie header.
  # @return [Cookie] created from the header string and request URI
  # @raise [InvalidCookieError] on validation failure(s)
  def self.from_set_cookie(request_uri, set_cookie_value)
    args = CookieJar::CookieValidation.parse_set_cookie set_cookie_value
    args[:domain] = CookieJar::CookieValidation.determine_cookie_domain request_uri, args[:domain]
    args[:path] = CookieJar::CookieValidation.determine_cookie_path request_uri, args[:path]
    cookie = Web::Cookie.new args
    CookieJar::CookieValidation.validate_cookie request_uri, cookie
    cookie
  end

  # Create a cookie based on an absolute URI and the string value of a
  # 'Set-Cookie2' header.
  #
  # @param request_uri [String, URI] HTTP/HTTPS absolute URI of request.
  # This is used to fill in domain and port if missing from the cookie,
  # and to perform appropriate validation.
  # @param set_cookie_value [String] HTTP value for the Set-Cookie2 header.
  # @return [Cookie] created from the header string and request URI
  # @raise [InvalidCookieError] on validation failure(s)
  def self.from_set_cookie2( request_uri, set_cookie_value )
    args = CookieJar::CookieValidation.parse_set_cookie2 set_cookie_value
    args[:domain] = CookieJar::CookieValidation.determine_cookie_domain request_uri, args[:domain]
    args[:path] = CookieJar::CookieValidation.determine_cookie_path request_uri, args[:path]
    cookie = Web::Cookie.new args
    CookieJar::CookieValidation.validate_cookie request_uri, cookie
    cookie
  end

  # Indicates whether the cookie is currently considered valid
  #
  # @param [Time] time to compare against, or 'now' if omitted
  # @return [Boolean]
  def expired?(time = Time.now)
    expires_at != nil && time > expires_at
  end

  # Indicates whether the cookie will be considered invalid after the end
  # of the current user session
  # @return [Boolean] 
  def session?
    expiry == nil || discard
  end

  def expiry
    max_age || expires_at
  end
  
  # Returns cookie in a format appropriate to send to a server.
  #
  # @param ver [Integer] 0 version, 0 for Netscape-style cookies, 1 for
  #   RFC2965-style.
  # @param prefix [Boolean] true prefix, for RFC2965, whether to prefix with
  # "$Version=<version>;". Ignored for Netscape-style cookies
  def to_s(ver=0, prefix=true)
    case ver
    when 0
      "#{name}=#{value}"
    when 1
      # we do not need to encode path; the only characters required to be
      # quoted must be escaped in URI
      str = prefix ? "$Version=#{version};" : ""
      str << "#{name}=#{value};$Path=\"#{path}\""
      if domain.start_with? '.'
        str << ";$Domain=#{domain}"
      end
      if ports
        str << ";$Port=\"#{ports.join ','}\""
      end
      str
    end
  end

  # Determine if a cookie should be sent given a request URI along with
  # other options.
  #
  # This currently ignores domain.
  #
  # @param request_uri [String, URI] the requested page which may need to receive
  # this cookie
  # @param script [Boolean] indicates that cookies with the 'httponly'
  # extension should be ignored
  # @return [Boolean] whether this cookie should be sent to the server
  def should_send?(request_uri, script)
    uri = CookieJar::CookieValidation.to_uri request_uri
    # cookie path must start with the uri, it must not be a secure cookie
    # being sent over http, and it must not be a http_only cookie sent to
    # a script
    path_match   = uri.path.start_with? path
    secure_match = !(secure && uri.scheme == 'http') 
    script_match = !(script && http_only)
    expiry_match = !expired?
    ports_match = ports.nil? || (ports.include? uri.port)
    path_match && secure_match && script_match && expiry_match && ports_match
  end
  
  # Compute the cookie search domains for a given request URI
  # This will be the effective host of the request uri, along with any
  # possibly matching dot-prefixed domains
  #
  # @param request_uri [String, URI] address being requested
  # @return [Array<String>] String domain matches
  def self.compute_search_domains(request_uri)
   CookieJar::CookieValidation.compute_search_domains request_uri
  end

end
