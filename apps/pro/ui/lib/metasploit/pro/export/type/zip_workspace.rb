#
# -- Zip Workspace Export

#
module Metasploit::Pro::Export::Type::ZipWorkspace

  def description
    'A Zip archive of the project, suitable for importing into an
instance of Metasploit, backup purposes, etc. Includes an XML Export as
well as directories for filesystem-dependent objects (loot files, task
logs, report artifacts).'
  end
  module_function :description

  def pretty_name
    'Zip Workspace'
  end
  module_function :pretty_name

  # Wrapper for all steps of Zip Workspace export
  #
  def generate_workspace_zip
    self.prepare!
    zip_path = self.file_path
    zip_name = File.basename(zip_path, '.zip')
    zip_dir = File.join(File.dirname(zip_path), zip_name)
    FileUtils.rm_rf(zip_dir) && Dir.mkdir(zip_dir)
    logger.debug("Zip file #{zip_path} will be created from #{zip_dir}")

    # Same location and name for XML child file:
    xml_path = File.join(zip_dir, "#{zip_name}.xml")
    xml_file = File.open(xml_path, 'w')

    self.generate!
    # Generate XML file containing DB data and filesystem dependent
    # data, which will be copied into the directory to be zipped:
    generate_xml_export_file(xml_file, filesystem_data_dir = zip_dir)
    xml_file.close

    add_creds_dump(zip_dir)

    begin
      create_zip_file(zip_path, zip_dir)
    rescue SystemCallError
      self.abort!
      logger.error "Problem creating zip file."
    end

    self.cleanup!
    FileUtils.rm_rf(zip_dir)

    self.complete!
    logger.info "#{self.etype.pretty_name} export completed in #{export_duration.round(3)}s"
  end

  # Export a Creds dump if any exist in the workspace, copying the creds dump zip into the export dir
  # that itself gets zipped.
  def add_creds_dump(zip_dir)
    if workspace.core_credentials.present?
      exporter = Metasploit::Credential::Exporter::Core.new(workspace: workspace, mode: :core)
      exporter.export!
      FileUtils.cp_r(exporter.output_final_directory_path, zip_dir)
    end
  end

end
