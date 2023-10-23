#
# -- Password Dump Export (PWDump)

#
module Metasploit::Pro::Export::Type::Pwdump
  def description
    'A text file dump of credentials suitable for offline cracking. It can
also be imported into a Metasploit instance. Contains comment-delimited
sections covering SMB hashes and plaintext credentials.'
  end
  module_function :description

  def pretty_name
    'Password Dump'
  end
  module_function :pretty_name


  def generate_pwdump_export
    prepare!
    exporter = Metasploit::Credential::Exporter::Pwdump.new(workspace: workspace)
    exporter.output = File.open(file_path, 'w')
    logger.debug "Exporting pwdump of credentials in #{workspace.name} to file path: #{exporter.output.path}"
    generate!
    exporter.output << exporter.rendered_output
    exporter.output.close
    cleanup!
    complete!
    logger.info "#{etype.pretty_name} export completed in #{export_duration.round(3)}s"
  end
end
