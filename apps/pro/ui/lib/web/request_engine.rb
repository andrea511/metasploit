module Web::RequestEngine
  require 'web/request_engine/parts'
  extend Web::RequestEngine::Parts

  uses :enclosers
  uses :escapers
  uses :evaders
  uses :executors
end
