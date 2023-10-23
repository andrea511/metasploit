module Mdm::Macro::Defaults
  extend ActiveSupport::Concern

  included do
    after_initialize :set_defaults
  end

  def set_defaults
    return if not self.new_record?
    self.prefs   ||= {}
    self.actions ||= []
    self.max_time = 900
  end
end