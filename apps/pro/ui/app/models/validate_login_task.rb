class ValidateLoginTask < TaskConfig
  attr_reader :login

  def initialize(attributes)
    @login = attributes.fetch(:login)
    super attributes
  end

  def rpc_call
    client.start_validate_login(
      'workspace'   => workspace.name,
      'username'    => username,
      'DS_LOGIN_ID' => login.id
    )
  end
end