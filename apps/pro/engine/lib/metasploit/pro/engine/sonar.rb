module Metasploit::Pro::Engine::Sonar
  extend ActiveSupport::Autoload
  autoload :Error
  autoload :Enroller
  autoload :HostFinder
  autoload :Importer

  # Imposes a limit of 5 results per batch on the Sonar search.
  # This is to ensure that we are always returned a RequestIterator.
  QUERY_LIMIT = 5
end