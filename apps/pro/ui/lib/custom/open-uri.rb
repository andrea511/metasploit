require 'open-uri'

module Custom::OpenURI
  # Overriding to allow for http -> https redirects during website cloning.
  def OpenURI.redirectable?(uri1, uri2) # :nodoc:
    uri1.scheme.downcase == uri2.scheme.downcase ||
  (/\A(?:http|ftp|https)\z/i =~ uri1.scheme && /\A(?:http|ftp|https)\z/i =~ uri2.scheme)
  end
end

OpenURI.send(:prepend, Custom::OpenURI)
