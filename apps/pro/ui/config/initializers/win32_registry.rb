if Rails.application.platform.win32?
  require 'win32/registry'
  require 'patches/win32_registry'
end
