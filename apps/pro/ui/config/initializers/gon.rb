# Workaround issue whereby url helpers aren't available to gon when rendering
# jbuilder templates: https://github.com/gazay/gon/issues/43
class Gon
  module Jbuilder
    class << self
      include Rails.application.routes.url_helpers
    end
  end
end