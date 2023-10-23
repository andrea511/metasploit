#
# Configure the process environment variables to work with java and other tools
#

if Rails.application.platform.win32?
  # TODO determine whether this is a workaround for mingw32 or if File::PATH_SEPARATOR will work
  path_separator = ';'
else
  path_separator = File::PATH_SEPARATOR
end

bins = %W{ common/bin ruby/bin nmap/bin postgresql/bin apache2/bin java/bin jruby/bin }
pathparts = ENV['PATH'].split(path_separator)
bin_root_pathname = Rails.root.parent.parent.parent

bins.each do |bin_path|
  bin_pathname = bin_root_pathname.join(bin_path)
  bin_path = bin_pathname.to_s

  pathparts.unshift bin_path
end

ENV['PATH'] = pathparts.uniq.join(path_separator)

java_home_path = bin_root_pathname.join('java').to_s
ENV['JAVA_HOME'] = java_home_path

terminfo_path = bin_root_pathname.join('common', 'share', 'terminfo').to_s
ENV['TERMINFO'] = terminfo_path

ENV['DISPLAY'] = nil

# Convert path delimiters for Windows
if Rails.application.platform.win32?
  ENV['PATH']      = ENV['PATH'].gsub("/", "\\")
  ENV['JAVA_HOME'] = ENV['JAVA_HOME'].gsub("/", "\\")
end
