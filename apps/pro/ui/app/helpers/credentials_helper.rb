module CredentialsHelper
  def import_credentials(params)
    import_type = params[:import][:type]
    cred_file_input = import_type == 'csv' || import_type == 'pwdump'

    if params[:file_input].nil? or import_type.nil?
      #Need to set partial format to HTML and Content Type manually because we are in a JSON format block. Needed for iframe Transport
      render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => false, :error => {file_input: {data: 'File Required', username: 'File Required', password: 'File Required'}} }}, formats: [:html], content_type: 'text/html'
    elsif cred_file_input && params[:file_input][:data].blank?
      render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => false, :error => {file_input: {data: 'File Required'}} }}, formats: [:html], content_type: 'text/html'
    elsif !cred_file_input && (params[:file_input][:username].blank? || params[:file_input][:password].blank?)
      file_input_error = {
        username: ('File Required' if params[:file_input][:username].blank?),
        password: ('File Required' if params[:file_input][:password].blank?)}.compact
      render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => false, :error => {file_input: file_input_error } }}, formats: [:html], content_type: 'text/html'
    else
      backgrounded_import_task(params)
      render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => true } }, formats: [:html], content_type: 'text/html'
    end
  end

  def delete_credentials(params)
    backgrounded_deletion_task(params)
    render json: { success: true }
  end

  private

  def backgrounded_import_task(params)
    unless params[:file_input][:data].blank?
      cred_file = create_cred_file read_file(params[:file_input][:data].tempfile)
      original_filename = params[:file_input][:data].original_filename
    else
      user_csv = read_file(params[:file_input][:username].tempfile)
      pass_csv = read_file(params[:file_input][:password].tempfile)
      cred_file = create_user_pass_file user_csv, pass_csv
      user_filename = params[:file_input][:username].original_filename
      pass_filename = params[:file_input][:password].original_filename
      original_filename = "#{File.basename(user_filename, File.extname(user_filename))}_#{pass_filename}"
    end

    importer = Rex::ThreadFactory.spawn("CoresController::Credential Importer", true, params, cred_file, original_filename) do |params, cred_file, original_filename|
      import_type = params[:import][:type]

      import_options = {
        input:     cred_file,
        origin:    Metasploit::Credential::Origin::Import.create!(filename: original_filename),
        workspace: @workspace
      }

      # Create a new importer based on the selected import type.
      if import_type == 'pwdump'
        cred_import = Metasploit::Credential::Importer::Pwdump.new(import_options)
        cred_import.filename = import_options[:origin].filename
      else
        cred_import = Metasploit::Credential::Importer::Multi.new(import_options)
        if cred_import.selected_importer.present?
          if cred_import.selected_importer.try(:class) != Metasploit::Credential::Importer::Zip
            cred_import.selected_importer.private_credential_type =
              case params[:import][:password_type]
              when 'plaintext'
                Metasploit::Credential::Password.name
              when 'ntlm'
                Metasploit::Credential::NTLMHash.name
              when 'non-replayable'
                Metasploit::Credential::NonreplayableHash.name
              end
          end
        end
      end


      # Could be checking the Importer class selected by Multi
      importer_to_check = if cred_import.respond_to?(:selected_importer)
                            cred_import.selected_importer
                          else
                            cred_import
                          end

      if importer_to_check.present? and importer_to_check.valid?

        result = importer_to_check.import!

        cores = Metasploit::Credential::Origin::Import.where(filename: original_filename).last.cores.select(:id)
        if params[:import][:password_type] == 'ntlm'
          Metasploit::Credential::NTLMHash.where(id: Metasploit::Credential::Core.where(id: cores).pluck(:private_id)).update({jtr_format: 'netntlm'})
        end

        tag_params = params[:tags].dup
        tag_params[:entity_ids] = cores.map{|core| core.id}
        TagCreator.build(tag_params, Metasploit::Credential::Core)

        #Need to set partial format to HTML and Content Type manually because we are in a JSON format block. Needed for iframe Transport
        if result
          # Add success event
          successful_notification_message("imported")
        else
          failed_notification_message "import", "One or more credentials were invalid."
        end
      elsif importer_to_check.blank?
        failed_notification_message "import", "Invalid import format"
      else
        #Need to set partial format to HTML and Content Type manually because we are in a JSON format block. Needed for iframe Transport
        # I will probably have to change the error response?
        failed_notification_message "import", importer_to_check.errors.as_json
      end
    rescue => e
      failed_notification_message "import", e.message
    end

    # Might want to change the priority on this to get it to run properly?
    importer.priority = -10
  end

  def backgrounded_deletion_task(params)
    deleter = Rex::ThreadFactory.spawn("CoresController::Credential Deleter", true, params) do |params|
      begin
        load_filtered_records(Metasploit::Credential::Core, params).delete_all
        successful_notification_message "deleted"
      rescue
        failed_notification_message "deletion", "There was a problem deleting the selected credentials"
      end
    end
    deleter.priority = -10
  end

  def successful_notification_message(function)
    default_options = {
      :workspace => @workspace,
      :title => "Credentials #{function.capitalize} Successfully",
      :kind => :credential_notification
    }
    Notifications::Message.create(default_options.merge(
      :content => "Credentials have been #{function}",
      :url => workspace_credentials_path(@workspace) + "#creds"
    ))
  end

  def failed_notification_message(function, content)
    default_options = {
      :workspace => @workspace,
      :title => "Credential #{function.capitalize} Failed",
      :kind => :failed_notification
    }
    Notifications::Message.create(default_options.merge(
      :content => content,
      :url => workspace_credentials_path(@workspace) + "#creds"
    ))
  end

  def create_user_pass_file(usernames, passwords)
    core_file = Tempfile.new("core_file.txt")
    core_file.write("#{Metasploit::Credential::Importer::Core::VALID_SHORT_CSV_HEADERS.join(",")}\n")

    usernames.product(passwords).collect { |user, password| core_file.write("#{user},#{password}\n") }

    core_file.rewind
    core_file
  end

  def create_cred_file(credential_file)
    core_file = Tempfile.new("core_file.txt")
    credential_file.each do |credential|
      core_file.write("#{credential}\n")
    end
    core_file.rewind
    core_file
  end

  def read_file(file)
    file.read.split("\n")
  end
end
