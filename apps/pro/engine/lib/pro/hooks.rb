module Pro
module Hooks
class Loader

  @@hooks = []
  
  def self.add_hook(hook)
    @@hooks << hook
  end

  def self.start(framework)
    @@hooks.each { |hook| hook.new(framework) }
  end

end
end
end


# Add behavior for DynamicStagers to Exe mixin, if the license allows it
require 'pro/hooks/dynamic_stager_hook'
require 'pro/hooks/vpn_pivot_hook'