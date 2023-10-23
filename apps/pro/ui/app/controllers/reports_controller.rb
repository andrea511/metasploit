class ReportsController < ApplicationController
  include ReportsSharedControllerMethods
  include Metasploit::Pro::Report::Exceptions
  include Metasploit::Pro::Report::Utils
  include ReportsHelper

  before_action :load_workspace, :except => [:form_for_tabbed_modal]
  before_action :load_report, :only => [:show, :generate_format, :format_generation_status]

  before_action :collect_report_custom_resources, :except => [:form_for_tabbed_modal]
  before_action :collect_license

  def index
    # Only show reports that have one or more artifacts:
    @reports = Report.group('reports.id').joins(:report_artifacts).where(:workspace_id => @workspace.id)

    respond_to do |format|
      format.html do
        render :action => 'index', :layout => 'application'
      end
      format.json do
        render :json => DataTableQueryResponse.build(params, {
          :collection => @reports,
          :search_cols => [:name, :created_by,
                           :report_type, :file_formats],
          :columns => [:id, :name, :report_type, :file_formats,
                       :created_by, :created_at, :updated_at],
          :render_row => lambda { |report|
            {
              :report_type => report.rtype.name,
              :file_formats => wrapped_artifact_list(linked_artifact_list(report))
            }
          }
        })
      end
    end
  end

  def show
    @report = present(@report)
    set_javascript_vars_for_show

    render action: 'show'
  end

  def new
    @custom = true if custom?

    # If the campaign ID is present (from SE campaign findings,
    # Generate Report), set proper type and ID:
    @report ||= if params['campaign_id']
                  if xvfb_not_found
                    flash[:warning] = Metasploit::Pro::Report::Utils::LINUX_XVFB_DEPENDENCY
                  end

                  config = {:se_campaign_id => params['campaign_id'],
                            :report_type    => :social_engineering}
                  build_default_report(config)
                else
                  build_default_report
                end
    @report.workspace = @workspace
    unless @report.data_present?
      flash[:warning] ||= required_data_message(@report.rtype)
    end
    render layout: !request.xhr?
  end

  def create
    @report = build_sanitized_report(report_params)

    unless @report.save
      render :partial => 'report_wrapper_form',
             :layout => nil,
             :locals => {:report => @report,
                         :error => @report.errors.full_messages.join('<br/>')
             },
             :status => :bad_request
      return
    end

    unless @report.data_present?
      @report.destroy
      render :partial => 'report_wrapper_form',
             :layout => nil,
             :locals => {:report => @report,
                         :error  => 'Report not ready for artifact generation, required data missing.'
             },
             :status => :bad_request
      return
    end

    # Adds artifact generation process to DJ queue:
    @report.generate_delayed
    flash[:notice] = 'Report creation queued. Table will refresh shortly...'
    head :ok
  end

  # Create a new report based on settings of an existing one
  def clone
    report_id = params[:id]
    existing = Report.find(report_id)
    @report = existing.clone_report

    render :action => 'new',
           :locals => {:report => @report}
  end

  # Generate a selected additional format on a report that already
  # has artifacts
  def generate_format
    validate_format

    if @error_message
      render json: { errors: @error_message }, status: 422
    else
      @report.generate_additional_format(params[:file_format].to_sym)
      render json: {}, status: :ok
    end
  end

  def format_generation_status
    validate_format

    @report_artifact = @report.report_artifacts.select { |artifact| artifact.file_format == params[:file_format] }.first

    if @error_message
      render json: { error: @error_message }, status: 422
    elsif @report_artifact
      @report_artifact = present(@report_artifact)
      render template: 'reports/format_generation_status.json'
    else
      render json: { status: 'regenerating' }
    end
  end

  def destroy_multiple
    reports = Report.where(id: params[:report_ids],
                           workspace_id: @workspace.id).destroy_all
    removed = view_context.pluralize(reports.size, 'report')

    respond_to do |format|
      format.any(:html, :js) do
        # TODO Not showing:
        flash.now[:notice] = "Deleted #{removed}."
      end
      format.json {
        render :json => { success: true }
      }
    end
  end

  # @return html form for a specific report type
  def form_for_type
    @report = build_default_report(report_params)
    if @report['report_type'] == 'social_engineering'
      if xvfb_not_found
        flash[:warning] = Metasploit::Pro::Report::Utils::LINUX_XVFB_DEPENDENCY
        set_dependency = true
      end
      if SocialEngineering::Campaign.where(workspace_id: @workspace.id).finished.count < 1
        flash[:warning] = "#{Metasploit::Pro::Report::Utils::REQUIRED_DATA} A completed campaign is required."
      end
    else
      flash[:warning] = nil
    end
    @report.workspace = @workspace
    unless @report.data_present?
      flash[:warning] = required_data_message(@report.rtype)
    end
    render :partial => 'report_wrapper_form', :layout => nil,
           :locals => {:report => @report, :set_dependency => set_dependency}
  end

  # @return html form for a specific report type
  def form_for_tabbed_modal
    @report = build_default_report(report_params)
    render :layout => false
  end

  # Hard link to download an example Jasper report template
  def download_simple_sample
    mime_type      = 'application/xml'
    simple_dir     = 'simple_sample'
    sample_templ   = 'msfx-simple.jrxml'
    full_file_path = File.join(pro_report_directory, simple_dir, sample_templ)
    file_data = File.open(full_file_path, 'rb') { |f| f.read }
    send_data(file_data,
              :type => mime_type,
              :disposition => 'attachment',
              :filename => sample_templ)
  end

  #
  # Validation for Task Chains
  #
  def validate_report
    @report = build_sanitized_report(report_params)
    @report.skip_data_check = true

    if @report.valid?
      render :json => {success: true, errors: @report.errors}
    else
      render :json => {success: false, errors: @report.errors.to_hash.flatten[1]}
    end

  end

  private

  def set_javascript_vars_for_show
    # TODO: Wrap the gon object so we can have a prettier DSL for this.
    gon.report = gon.jbuilder
    gon.report_artifacts_path = @report.artifacts_path
    gon.email_report_artifacts_path = @report.email_path
    gon.regeneration_status_path = @report.regeneration_status_path
    gon.regenerate_format_path =  @report.regenerate_format_path
  end

  def collect_license
    @custom_licensed = License.get.supports_custom_reporting?
    @licensed = License.get.supports_reports?
  end

  #
  # Determine if xvfb is installed on linux for report images and graph
  #
  def xvfb_not_found
    current_platform =~ /linux/i && !xvfb_installed?
  end

  #
  # Custom reports
  #

  def collect_report_custom_resources
    @report_custom_resources = @workspace.report_custom_resources
    @report_custom_templates = @report_custom_resources.templates
    @report_custom_logos     = @report_custom_resources.logos
  end


  # Builds default report of Audit type and PDF format. Sets boolean
  # options that should be enabled by default.
  # @param report_params [Hash]
  def build_default_report(report_params = {})
    file_format = [Report::DEFAULT_FILE_FORMAT]
    if @custom
      defaults = {
          'report_type'  => :custom,
          'file_formats' => file_format,
      }
    else
      default_checked = Report::DEFAULT_OPTIONS
      defaults = {
          'report_type'    => :audit,
          'file_formats'   => file_format,
          'options'        => default_checked.map(&:to_s),
          'order_vulns_by' => Report::Type::WebappAssessment::DEFAULT_ORDER
      }
    end
    Report.new(defaults.merge(report_params))
  end

  def custom?
    !!(request.env['PATH_INFO'] =~ /custom_report/)
  end

  def load_report
    @report = @workspace.reports.find params[:id]
  end

  def validate_format
    @format = params[:file_format]

    if @report
      # Verify format
      unless @report.rtype.formats.member? @format
        @error_message = "#{@format} is not an allowed file format."
      end
    else
      @error_message = "Report #{report_id} not found"
    end
  end

  def report_params
    params.fetch(:report, {}).permit!
  end
end
