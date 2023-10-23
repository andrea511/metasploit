module Metasploit::Pro::Engine::Rpc::Exports

  # Lists current exports in the workspace
  # @param workspace_name [String] to scope list to
  # @return [Hash] of exports in the workspace
  def rpc_export_list(workspace_name)
    workspace = _find_workspace(workspace_name)
    exports = {}

    workspace.exports.each do |export|
      exports[export.id] = _export_to_hash(export)
    end

    exports
  end

  # Downloads an export
  # @param export_id [Integer]
  # @return [Hash] of export attrs and file data
  def rpc_export_download(export_id)
    export = _find_export(export_id)
    export_hash = _export_to_hash(export)

    export_path = export.file_path

    if export_path and File.exist?(export_path)
      export_hash[:data] = IO.read(export_path)
    end

    export_hash
  end

  # Creates and runs an export with delayed_job
  # @param config [Hash] of export required attributes
  # @return [Hash] of generation status and supplementary info
  def rpc_start_export(config)
    # To support anyone who started passing ID when this
    # format was introduced in 4.9:
    unless config['workspace_id']
      workspace_name = config.delete('workspace')
      workspace = _find_workspace(workspace_name)
      config['workspace_id'] = workspace.id
    end
    export = Export.new(config)
    if export.save
      export.generate_delayed
      { status: 'success', export_id: export.id }
    else
      { status: 'failure', context: "Saving: #{export.errors.full_messages}" }
    end
  end

  private

  # Finds a export by ID
  # @param export_id [Integer]
  # @return Export
  def _find_export(export_id)
    ApplicationRecord.connection_pool.with_connection {
      export = Export.find(export_id)
      error(500, 'Invalid Export ID') if not export
      export
    }
  end

  # Forms hash representing an export
  # @param export [Export]
  # @return [Hash] of export attributes
  def _export_to_hash(export)
    export_hash = {}
    export.attributes.each do |attr, val|
      # Handle any date/time-like objects:
      val = val.to_i if val.respond_to? 'acts_like_time?'
      export_hash[attr.to_sym] = val
    end
    export_hash[:workspace_id] = export.workspace.id
    export_hash[:created_by]   = export.created_by
    export_hash[:export_type]  = export.export_type
    export_hash[:file_size]    = File.size(export.file_path) rescue 0
    export_hash
  end

end
