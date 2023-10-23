#!/usr/bin/env ruby

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
# rails/all must be required explicitly to get the railties that pro/ui/config/application.rb uses
require 'rails/all'
require APP_PATH
Rails.application.require_environment!

class Activator
  include ::Pro::License::Product

  def initialize(path)
    esnecil_init(path)
  end

  def activate(conf)
    esnecil_activate(conf)
  end

  def activated?
    esnecil_activated?
  end
end

input_filenames = {
  'install.pem': 'certs',
  'product.key': 'license',
  'product.lic': 'license',
  'product.ser': 'license'
}

license_base = ::File.expand_path(::File.join("..", ".."))
tkey = ARGV.shift || "help"

if tkey == "help"
  $stdout.puts "[*] Usage: lic_offline.rb <product_key>"
  exit
end

input_filenames.each_pair do |filename, filepath|
  check_file = ::File.join(license_base, 'engine', filepath, filename.to_s)
  ::File.delete(check_file) if ::File.exist?(check_file)
end

key_file = ::File.new(::File.join(license_base, 'engine', input_filenames[:"product.key"], 'product.key'), "w")
key_file.write(tkey)
key_file.flush
key_file.close

if ! Pro::License.validate_key(tkey)
  $stderr.puts "[*] Failed to valid #{tkey}"
  exit 1
end


worker = Activator.new(::File.join("..", "..", "engine", "license"))
worker.activate({ product_key: tkey })

if !worker.activated?
  $stderr.puts "[*] Failed to obtain license for #{tkey}"
  exit 1
end

zipfile_name = "user_license.zip"

Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
  input_filenames.each_pair do |filename, filepath|
    zipfile.add(filename.to_s, ::File.join(license_base, 'engine', filepath, filename.to_s))
  end
end


$stdout.puts "[*] License key generation and validation complete"
