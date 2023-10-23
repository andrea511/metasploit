# Destroy all delayed jobs after logging them to a file.
if Rails.env.production?
  Rails.application.configure do
    config.after_initialize do
      if Delayed::Job.table_exists?
        logger =  Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
        Delayed::Job.find_each do |job|
          logger.error job.to_yaml
        end
        Delayed::Job.destroy_all
      end
    end
  end
end
