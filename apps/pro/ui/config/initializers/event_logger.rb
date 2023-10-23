Rails.application.reloader.to_prepare do
  AuditLogger.new(File.join(Rails.root, 'log', 'audit.log'))
end

