namespace :db do
  namespace :test do
    # Seeds database for testing so it matches development/production seeds
    task prepare: :environment do
      Rake::Task['db:seed'].invoke
    end
  end
end