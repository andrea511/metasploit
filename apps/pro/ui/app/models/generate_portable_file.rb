class GeneratePortableFile < TaskConfig
  attr_accessor :campaign

  def initialize(attributes)
    super(attributes)
    @portable_file = attributes[:portable_file]
    @username = attributes[:username]
  end

  def valid?
    if @portable_file.file_generation_type == "file_format"
      unless @portable_file.exploit_module_config
        @error = "An attack config is required!"
        return false
      end
    end
    @error = nil
    return true
  end

  def rpc_call
    client.portable_file_generate({
      'workspace' => @portable_file.campaign.workspace.name,
      'username'  => @username,
      'DS_PORTABLE_FILE_ID' => @portable_file.id,
    })
  end
end
