path = File.read(Rails.root.parent.join('metamodules/<%=file_name%>/config/config.yml'))

begin
  yaml = YAML.load(path)
  Apps::App.register_metamodule(yaml)

rescue Psych::SyntaxError
  puts "Metamodule Config Malformed: #{path}"
  raise

rescue Errno::ENOENT
  puts "Metamodule Config Missing: #{path}"
  raise

end

