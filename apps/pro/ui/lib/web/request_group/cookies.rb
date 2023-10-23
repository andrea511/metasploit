# the majority of the implementation was taken from 
#   https://github.com/dwaite/cookiejar/blob/master/lib/cookiejar/cookie.rb
# it has been modified to use active record objects for a persistant store
# this should be refactored in the near future

module Web::RequestGroup::Cookies
  extend ActiveSupport::Concern
  
  included do

    #
    # Associations
    #
    
    # @!attribute [rw] cookies
    #   @return [Array<Web::Cookie>] cookies sent with this request in the Cookie header.
    has_many :cookies, :class_name => 'Web::Cookie', :dependent => :destroy, :foreign_key => :request_group_id

  end
  
  # Given a request URI and a literal Set-Cookie header value, attempt to
  # add the cookie(s) to the cookie store.
  # 
  # @param [String, URI] request_uri the resource returning the header
  # @param [String] cookie_header_values the contents of the Set-Cookie
  # @return [Cookie] which was created and stored
  # @raise [InvalidCookieError] if the cookie header did not validate
  def set_cookie(request_uri, cookie_header_values)
    cookie_header_values.split(/, (?=[\w]+=)/).each do |cookie_header_value|
      cookie = Web::Cookie.from_set_cookie request_uri, cookie_header_value
      add_cookie cookie
    end
  end

  # Given a request URI and a literal Set-Cookie2 header value, attempt to
  # add the cookie to the cookie store.
  # 
  # @param [String, URI] request_uri the resource returning the header
  # @param [String] cookie_header_value the contents of the Set-Cookie2
  # @return [Cookie] which was created and stored
  # @raise [InvalidCookieError] if the cookie header did not validate
  def set_cookie2(request_uri, cookie_header_value)
    cookie = Web::Cookie.from_set_cookie2 request_uri, cookie_header_value
    add_cookie cookie
  end

  # Given a request URI and some HTTP headers, attempt to add the cookie(s)
  # (from Set-Cookie or Set-Cookie2 headers) to the cookie store. If a
  # cookie is defined (by equivalent name, domain, and path) via Set-Cookie 
  # and Set-Cookie2, the Set-Cookie version is ignored.
  #
  # @param [String, URI] request_uri the resource returning the header
  # @param [Hash<String,[String,Array<String>]>] http_headers a Hash 
  #   which may have a key of "Set-Cookie" or "Set-Cookie2", and values of
  #   either strings or arrays of strings
  # @return [Array<Cookie>,nil] the cookies created, or nil if none found.
  # @raise [InvalidCookieError] if one of the cookie headers contained
  #   invalid formatting or data
  def set_cookies_from_headers(request_uri, http_headers)
    set_cookie_key = http_headers.keys.detect { |k| /\ASet-Cookie\Z/i.match k }
    gather_header_values http_headers[set_cookie_key] do |value|
      begin
        tmp_cookie = Web::Cookie.from_set_cookie request_uri, value
        cookie = cookies.where(:name => tmp_cookie.name, :domain => tmp_cookie.domain).first_or_initialize
        cookie.attributes = tmp_cookie.attributes.except("id","request_group_id", "created_at", "updated_at")
        cookie.save
      rescue CookieJar::InvalidCookieError
      end
    end

    set_cookie2_key = http_headers.keys.detect { |k| /\ASet-Cookie2\Z/i.match k }
    gather_header_values(http_headers[set_cookie2_key]) do |value|
      begin
        tmp_cookie = Web::Cookie.from_set_cookie2 request_uri, value
        cookie = cookies.where(:name => tmp_cookie.name, :domain => tmp_cookie.domain).first_or_initialize
        cookie.attributes = tmp_cookie.attributes.except("id","request_group_id", "created_at", "updated_at")
        cookie.save
      rescue CookieJar::InvalidCookieError
      end
    end

    cookies
  end

  # Add a pre-existing cookie object to the jar.
  #
  # @param [Cookie] cookie a pre-existing cookie object
  # @return [Cookie] the cookie added to the store
  def add_cookie(cookie)
    cookies << cookie
    cookie
  end

  # Return an array of all cookie objects in the jar
  #
  # @return [Array<Cookie>] all cookies. Includes any expired cookies
  # which have not yet been removed with expire_cookies
  def to_a
    result = []
    cookies.order(:domain).find_each do |cookie|
      result << [cookie.name, cookie.value]
    end

    result
  end


  # Look through the jar for any cookies which have passed their expiration
  # date, or session cookies from a previous session
  #
  # @param session [Boolean] whether session cookies should be expired,
  #   or just cookies past their expiration date.
  def expire_cookies(session = false)
    cookies.find_each do |cookie|
      cookie.destroy if cookie.expired? || (session && cookie.session?)
    end
  end

  # Given a request URI, return a sorted list of Cookie objects. Cookies
  # will be in order per RFC 2965 - sorted by longest path length, but
  # otherwise unordered.
  #
  # @param [String, URI] request_uri the address the HTTP request will be
  #   sent to
  # @param [Hash] opts options controlling returned cookies
  # @option opts [Boolean] :script (false) Cookies marked HTTP-only will be ignored
  #   if true
  # @return [Array<Cookie>] cookies which should be sent in the HTTP request
  def get_cookies(request_uri, opts = { })
    uri = to_uri request_uri
    hosts = Web::Cookie.compute_search_domains uri

    results = []

    hosts.each do |host|
      cookies.where(domain: host).each do |cookie|
        if uri.path.start_with? cookie.path
          results << cookie if cookie.should_send? uri, opts[:script]
        end
      end
    end
    #Sort by path length, longest first
    results.sort do |lhs, rhs|
      rhs.path.length <=> lhs.path.length
    end
  end

  # Given a request URI, return a string Cookie header.Cookies will be in
  # order per RFC 2965 - sorted by longest path length, but otherwise
  # unordered.
  #
  # @param [String, URI] request_uri the address the HTTP request will be
  #   sent to
  # @param [Hash] opts options controlling returned cookies
  # @option opts [Boolean] :script (false) Cookies marked HTTP-only will be ignored
  #   if true
  # @return String value of the Cookie header which should be sent on the
  #   HTTP request
  def get_cookie_header(request_uri, opts = { })
    cookies = get_cookies request_uri, opts
    version = 0
    ver = [[],[]]
    cookies.each do |cookie|
      ver[cookie.version] << cookie
    end
    if (ver[1].empty?)
      # can do a netscape-style cookie header, relish the opportunity
      cookies.map do |cookie|
        cookie.to_s
      end.join ";"
    else
      # build a RFC 2965-style cookie header. Split the cookies into
      # version 0 and 1 groups so that we can reuse the '$Version' header
      result = ''
      unless ver[0].empty?
        result << '$Version=0;'
        result << ver[0].map do |cookie|
          (cookie.to_s 1,false)
        end.join(';')
        # separate version 0 and 1 with a comma
        result << ','
      end
      result << '$Version=1;'
      ver[1].map do |cookie|
        result << (cookie.to_s 1,false)
      end
      result
    end
  end

  protected  

  def gather_header_values(http_header_value, &block)
    result = []
    if http_header_value.is_a? Array
      http_header_value.each do |value| 
        result << block.call(value)
      end
    elsif http_header_value.is_a? String
      result << block.call(http_header_value)
    end
    result.compact
  end

  def to_uri request_uri
    (request_uri.is_a? URI)? request_uri : (URI.parse request_uri)
  end
  
end