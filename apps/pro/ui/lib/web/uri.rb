# An enhancement to standard ruby's URI that assumes a scheme of 'http' if none is given.
module Web::URI
  #
  # CONSTANTS
  #

  # The default scheme to use in {parse} when the uri string does not have a scheme.
  DEFAULT_SCHEME = 'http'

  # Converts the given URI to a URI object, uses {parse} instead of {URI.parse}.
  #
  # @param uri [URI::Generic, #to_str] a pre-existing URI object or a uri string.
  # @return [Generic::URI]
  # @raise [ArgumentError] if `uri` is neither a URI::Generic nor responds to `to_str`.
  #
  # @see URI::Parser#convert_to_uri
  # @see Web::URI#parse
  def self.convert(uri)
    if uri.is_a? URI::Generic
      converted = uri
    else
      uri_string = String.try_convert(uri)

      if uri_string
        converted = parse(uri_string)
      else
        raise ArgumentError, 'bad argument (expected URI object or URI string)'
      end
    end

    converted
  end

  # Attempts to parse the uri with URI.parse.  If the returned's URI::Generic's scheme is nil, then prepends the
  # {DEFAULT_SCHEME} to the uri (along with '://') and reparses this new uri with URI.parse.
  #
  # @param uri [#to_s] The uri string to parse
  # @return [URI::Generic]
  # @raise [URI::InvalidURIError] (see URI::Parser#split)
  #
  # @see URI.parse
  def self.parse(uri)
    parsed_uri = ::URI.parse(uri)

    unless parsed_uri.scheme
      schemed_uri = "#{DEFAULT_SCHEME}://#{uri}"

      parsed_uri = ::URI.parse(schemed_uri)
    end

    parsed_uri
  end
end