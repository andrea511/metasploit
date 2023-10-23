class MigrateTaskChainConfigToUseCredentials < ActiveRecord::Migration[4.2]
  include Metasploit::Credential::Creation
  include TasksSharedControllerMethods
  
  def up
    TaskChain.find_each do |task_chain|
      task_chain.scheduled_tasks.find_each do |scheduled_task|

        next if scheduled_task.form_hash.blank?
        
        if ["ssh_key","pass_the_hash","single_password"].include? scheduled_task.form_hash["mm_symbol"]
          
          user = Mdm::User.where(username: scheduled_task.config_hash["DS_PROUSER"]).first
          workspace = Mdm::Workspace.find(scheduled_task.form_hash["workspace_id"])
          args = scheduled_task.form_hash.with_indifferent_access
          
          scheduled_task.form_hash["core_id"] = ''
          scheduled_task.form_hash["current_user_id"] = user.id
        
          credential_data = {
            workspace_id: workspace.id,
            user_id: user.id,
            origin_type: :manual
          }
        
          case scheduled_task.form_hash["mm_symbol"]
          when "ssh_key"

            key_file = if scheduled_task.form_hash['key_file_stored'].present?
              scheduled_task.form_hash['key_file_stored']
            else
              scheduled_task.file_upload.try(:read)
            end

            credential_data.merge!(
              private_data: key_file,
              private_type: :ssh_key,
              username: args[:ssh_username]
            )
            
          when "pass_the_hash"
            credential_data.merge!(
              private_data: args[:hash],
              private_type: :ntlm_hash,
              username: args[:smb_username]
            )
        
            if args[:domain].present?
              credential_data.merge!({
                realm_key: Metasploit::Model::Realm::Key::ACTIVE_DIRECTORY_DOMAIN,
                realm_value: args[:domain]
              })
            end
                  
          when "single_password"
          
            credential_data.merge!(
              private_data: args[:password],
              private_type: :password,
              username: args[:auth_username]
            )
        
            if args[:domain].present?
              credential_data.merge!({
                realm_key: Metasploit::Model::Realm::Key::ACTIVE_DIRECTORY_DOMAIN,
                realm_value: args[:domain]
              })
            end
          
          end
        
          core = create_credential(credential_data)
          scheduled_task.form_hash["core_id"] = core.id
          scheduled_task.config_hash["DS_CRED_CORE_ID"] = core.id
          scheduled_task.save!
        end
        
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
