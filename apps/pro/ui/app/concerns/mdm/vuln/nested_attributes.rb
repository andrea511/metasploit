module Mdm::Vuln::NestedAttributes
  extend ActiveSupport::Concern

  included do
    accepts_nested_attributes_for :notes
  end

end