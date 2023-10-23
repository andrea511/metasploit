class AttemptSessionTask < TaskConfig
  attr_reader :login

  def initialize(attributes)
    @login = attributes.fetch(:login)
    super attributes
  end

  def rpc_call
    client.start_attempt_session(
      'workspace'   => workspace.name,
      'username'    => username,
      'DS_LOGIN_ID' => login.id,
      'DS_PAYLOAD_METHOD' => 'bind'
    )
  end
end