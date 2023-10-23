class Wizards::PayloadGenerator::FormController < Wizards::BaseController
  include Wizards::TaskHelpers

  # Wicked gem autogenerates the routes for each step of the wizard
  steps :payload_options,
        :encoding,
        :output_options

  MAX_UPLOAD_SIZE = 10.megabytes

  def show
    @payload = GeneratedPayload.new
  end

  def validate
    @payload = GeneratedPayload.new(payload_params)
    unless @payload.valid?
      render_errors(@payload.errors.messages)
    else
      render_success
    end
  end

  def launch
    created_files = process_form_uploads
    params[:payload]['options'] ||= {}
    params[:payload]['options'].merge!('created_files' => created_files)

    @payload = GeneratedPayload.new(payload_params)
    unless @payload.save
      created_files.each { |k, sf| File.unlink(sf) }
      render_errors(@payload.errors.messages)
    else
      @payload.generate!

      # cucumber runs with delayed_jobs set to exec immediately in the rails thread
      unless Rails.env.test?
        @payload.schedule_destruction
      end

      ev = Mdm::Event.new(:name => "generate_payload",
                          :info => { :dynamic => @payload.dynamic_stager? })
      ev.save!
      render_success(@payload.as_json)
    end
  end

  def poll
    @payload = GeneratedPayload.find(params[:payload_id])
    render :json => @payload
  end

  def download
    @payload = GeneratedPayload.find(params[:payload_id])
    send_data @payload.file.read,
      :type => "application/x-octet-stream",
      :disposition => "attachment",
      :filename => File.basename(@payload.file.to_s)
  end

  def upsell
    render :partial => 'generic/upsell/payload_generator'
  end

  private

  # File inputs are sometimes present. The HTML controller needs
  # to deal with ActionDispatch::Http::UploadedFiles.
  # This method "fixes up" the params object
  # @return [Array<String>] filenames  created
  def process_form_uploads(hash=params['payload'])
    created_files = []
    hash.each do |k,v|
      if v.kind_of?(Hash)
        created_files += process_form_uploads(v)
      elsif v.kind_of?(ActionDispatch::Http::UploadedFile)
        path = write_file_param_to_quickfile(v)
        hash[k] = path
        created_files << path
      end
    end
    created_files
  end

  def payload_params
    params.fetch(:payload, {}).permit!

  end
end
