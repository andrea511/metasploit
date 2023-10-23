#
# Global feature flag constants are set in this file.
# By default, all feature flags are TRUE in development mode,
#   unless the value parameter of the #define method is specified.
#

module FeatureFlags
  def self.define(name, value=Rails.env.development?)
    FeatureFlags.const_set(name.to_s, value)
  end
end

#FeatureFlags.define(:EXAMPLE_FEATURE)

