module Metasploit::Credential::Login::ValidateAuthentication
  extend ActiveSupport::Concern

  # @return [Integer] the id of the task we just kicked off
  # @return nil if no task was kicked off
  def validate_authentication
    task = ValidateLoginTask.new(workspace: self.service.host.workspace, login: self)
    result = task.rpc_call
 
    if result.present?
      result['task_id'].to_i
    end
  end

end
