module Metasploit::Pro::Engine::Rpc::Reports

  # Lists reports, with child artifacts, in workspace
  # @param wspace [String] name of workspace to scope report list to
  # @return [Hash] {report1.id => [artifact1_hash, artifact2_hash]}
  def rpc_report_list(wspace)
    workspace = _find_workspace(wspace)
    reports_hash = {}

    workspace.reports.each do |report|
      reports_hash[report.id] = []
      report.report_artifacts.each do |artifact|
        reports_hash[report.id] << _report_artifact_to_hash(artifact)
      end
    end

    reports_hash
  end

  # Downloads a report artifact
  # @param report_artifact_id [Integer]
  # @return [Hash] of report artifact attrs, including data of
  # artifact file
  def rpc_report_artifact_download(report_artifact_id)
    artifact = _find_report_artifact(report_artifact_id)
    artifact_hash = _report_artifact_to_hash(artifact)
    artifact_path = artifact.file_path

    if artifact_path and ::File.exist?(artifact_path)
      artifact_hash[:data] = ::IO.read(artifact_path)
    end

    artifact_hash
  end

  # Downloads a single report with all child report artifacts, including
  # data of artifact files
  # @param report_id [Integer]
  # @return [Hash] of report attrs and child artifact(s)
  def rpc_report_download(report_id)
    report = _find_report(report_id)
    report_hash = _report_to_hash(report)

    report_hash[:report_artifacts] = []
    report.report_artifacts.each do |artifact|
      artifact_hash = rpc_report_artifact_download(artifact.id)
      report_hash[:report_artifacts] << artifact_hash
    end

    report_hash
  end

  # Creates a new report, initiates generation with delayed_job
  # @param config [Hash] of report required attributes
  # @return [Hash] of generation status and supplementary info
  def rpc_start_report(config)

    if config['workspace'].is_a?(String)
      workspace_name = config['workspace']
      config['workspace'] = _find_workspace(config['workspace'])
    end
    config['workspace_id'] = config['workspace'].id

    report = Report.new(config)
    if report.save
      report.generate_delayed
      config['workspace'] = workspace_name unless workspace_name.nil?
      { status: 'success', report_id: report.id, state: report.state }
    else
      config['workspace'] = workspace_name unless workspace_name.nil?
      { status: 'failure', context: "Saving: #{report.errors.full_messages}" }
    end
  end

  # Lists supported report types with their required data, file
  # formats, options, sections, template directory, and parent
  # template file. Useful for debugging API issues.
  # @return [Hash]
  def rpc_list_report_types
    types_hash = {}

    Report::VALID_TYPES.each do |report_type|
      t = Report::REPORT_TYPE_MAP[report_type]
      next if report_type == :custom # Best to know about this via docs

      type_hash = {}
      type_hash['required_data'] = t.required_data.join(', ')
      type_hash['file_formats'] = t.formats.join(', ')
      type_hash['options'] = t.options.join(', ')
      type_hash['sections'] = t.sections.keys.join(', ')
      type_hash['report_directory'] = t.report_dir
      type_hash['parent_template_file'] = t.template_file

      types_hash[report_type] = type_hash
    end

    types_hash
  end

private

  # Finds a report by ID
  # @param report_id [Integer]
  # @return Report
  def _find_report(report_id)
    ::ApplicationRecord.connection_pool.with_connection {
      report = ::Report.find(report_id)
      error(500, 'Invalid Report ID') if not report
      report
    }
  end

  # Finds a report artifact by ID
  # @param report_artifact_id [Integer]
  # @return ReportArtifact
  def _find_report_artifact(report_artifact_id)
     ::ApplicationRecord.connection_pool.with_connection {
      artifact = ::ReportArtifact.find(report_artifact_id)
      error(500, 'Invalid Report Artifact ID') if not artifact
      artifact
    }
  end

  # Forms a hash representing a report artifact
  # @param report_artifact [ReportArtifact]
  # @return [Hash] of artifact attributes
  def _report_artifact_to_hash(report_artifact)
    parent_report = report_artifact.report
    artifact_hash = _object_to_hash(report_artifact)

    artifact_hash[:workspace_id] = parent_report.workspace.id
    artifact_hash[:created_by]   = parent_report.created_by
    artifact_hash[:report_type]  = parent_report.report_type
    artifact_hash[:file_size]    = File.size(report_artifact.file_path) rescue 0

    artifact_hash
  end

  def _report_to_hash(report)
    report_hash = _object_to_hash(report)
  end

  # Forms a hash of the attributes of the passed object, converts
  # datetime-like attrs to safe format for transfer.
  # @return [Hash]
  def _object_to_hash(object)
    attr_hash = {}
    object.attributes.each do |attr, val|
      # Handle any date/time-like objects:
      val = val.to_i if val.respond_to? 'acts_like_time?'
      attr_hash[attr.to_sym] = val
    end
    attr_hash
  end

end
