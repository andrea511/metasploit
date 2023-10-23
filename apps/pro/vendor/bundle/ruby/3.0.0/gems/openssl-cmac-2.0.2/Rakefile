require './lib/openssl/cmac/version'
require "bundler/gem_tasks"
require 'rake/testtask'

task :default => :build

desc "Run tests"
Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Create documentation"
task :doc do
  sh "gem rdoc --rdoc openssl-cmac"
  sh "yardoc"
end

desc "Uninstall and clean documentation"
task :clean do
  sh "gem uninstall openssl-cmac"
  begin; sh "rm -R ./coverage"; rescue; end
  begin; sh "rm -R ./.yardoc";  rescue; end
  begin; sh "rm -R ./doc";      rescue; end
end

desc "Development Dependencies"
task (:devinst) { sh "gem install --dev ./pkg/openssl-cmac-#{OpenSSL::CMAC::VERSION}.gem" }

desc "Bundle install"
task (:bundle) { sh "bundle install" }

