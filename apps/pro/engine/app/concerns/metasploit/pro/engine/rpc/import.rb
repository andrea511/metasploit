module Metasploit::Pro::Engine::Rpc::Import

  # This stub depends on the Tasks stub

  def rpc_validate_import_data(data)
    self.framework.db.validate_import_file(data)
  end

  # Import a file that already exists on the file system, this
  # kicks off a new task and returns the task_id
  def rpc_import_file(wspace, path, opts = {})
    conf = {
      'workspace' => wspace,
      'username'  => _find_rpc_user,
      'DS_PATH'   => path,
      'DS_BLACKLIST_HOSTS'  => opts['blacklist_hosts'] || '',
      'DS_PRESERVE_HOSTS'   => opts['preserve_hosts'] ? true : false,
      'DS_REMOVE_FILE'      => opts['remove_file'] ? true : false,
      'DS_ImportTags'       => true
    }
    _start_module_task(conf, "pro/import", "Importing")
  end

  # Import one of the supported import formats as raw data using
  # rpc_import_file
  def rpc_import_data(wspace, data, opts = {})
    # Store the data in a temporary file
    path = ::Rex::Quickfile.new("import")
    path.write(data)
    # Tell the import task to delete it when its done
    opts['remove_file'] = true
    rpc_import_file(wspace, path.path, opts)
  end


end
