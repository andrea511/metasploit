class Tasks::BruteForceGuessQuickSessionPresenter < Tasks::BasePresenter

  def login_attempts
    {
      # this needs to be fixed with a sql presenter
      relation: BruteForce::Guess::Attempt.select([
                                                    BruteForce::Guess::Attempt[Arel.star],
                                                    Mdm::Host[:address].as('address'),
                                                    Mdm::Host[:name].as('host_name'),
                                                    Mdm::Host[:id].as('host_id'),
                                                    Metasploit::Credential::Public[:username].as('public'),
                                                    Metasploit::Credential::Private[:data].as('private'),
                                                    Metasploit::Credential::Private[:type].as('private_type'),
                                                    Metasploit::Credential::Realm[:value].as('realm'),
                                                    Metasploit::Credential::Realm[:key].as('realm_key'),
                                                    Mdm::Service[:name].as('service_name'),
                                                    Mdm::Service[:port].as('service_port'),
                                                    Metasploit::Credential::Core[:id].as('core_id')
                                                  ]).group(
        BruteForce::Guess::Attempt[:id],
        Mdm::Host[:address],
        Mdm::Host[:name],
        Mdm::Host[:id],
        Metasploit::Credential::Public[:username],
        Metasploit::Credential::Private[:data],
        Metasploit::Credential::Private[:type],
        Metasploit::Credential::Realm[:value],
        Metasploit::Credential::Realm[:key],
        Mdm::Service[:name],
        Mdm::Service[:port],
        Metasploit::Credential::Core[:id]
      ).joins(
        BruteForce::Guess::Attempt.join_association(:brute_force_run),
        BruteForce::Guess::Attempt.join_association(:brute_force_guess_core),
        BruteForce::Guess::Core.join_association(:private),
        BruteForce::Guess::Core.join_association(:public),
        BruteForce::Guess::Core.join_association(:realm, Arel::Nodes::OuterJoin),
        BruteForce::Guess::Attempt.join_association(:service),
        BruteForce::Guess::Attempt.join_association(:login, Arel::Nodes::OuterJoin),
        Metasploit::Credential::Login.join_association(:core, Arel::Nodes::OuterJoin),
        Mdm::Service.join_association(:host)
      ).where(
        BruteForce::Guess::Attempt[:brute_force_run_id].eq(brute_force_run.id)
      ),
      options: {
        presenter_class: BruteForce::Guess::AttemptPresenter,
        total_count: brute_force_run.brute_force_guess_attempts.count
      }
    }
  end

  def targets_compromised
    {
      relation: BruteForce::Guess::Attempt.select([
                                      Mdm::Service[:id].as('service_id'),
                                      Mdm::Service[:name],
                                      Mdm::Service[:port],
                                      Metasploit::Credential::Login[:id].count.as('successful_logins'),
                                      Mdm::Host[:address].as('address'),
                                      Mdm::Host[:id].as('host_id'),
                                      Mdm::Host[:name].as('host_name'),
                                      Mdm::Host[:os_name].as('host_os_name'),
                                      Mdm::Session[:id].count.as('session_count'),
                                      'array_to_json(array_agg(brute_force_guess_attempts.id)) as attempt_ids'
                                                  ]
      ).group(
        Mdm::Service[:id],
        Mdm::Host[:id],
      ).joins(
        BruteForce::Guess::Attempt.join_association(:brute_force_run),
        BruteForce::Guess::Attempt.join_association(:service),
        Mdm::Service.join_association(:host),
        BruteForce::Guess::Attempt.join_association(:login, Arel::Nodes::OuterJoin),
        BruteForce::Guess::Attempt.join_association(:session, Arel::Nodes::OuterJoin)
      ).where(brute_force_runs: {task_id: @task.id},
              metasploit_credential_logins: {status: Metasploit::Model::Login::Status::SUCCESSFUL}
      )
    }
  end

  def successful_logins
    {
      relation: BruteForce::Guess::Attempt.select([
                                                    BruteForce::Guess::Attempt[:id],
                                                    BruteForce::Guess::Attempt[:session_id].as('session_id'),
                                                    Metasploit::Credential::Login[:id],
                                                    Metasploit::Credential::Public[:username].as('public'),
                                                    Metasploit::Credential::Private[:data].as('private'),
                                                    Metasploit::Credential::Private[:type].as('private_type'),
                                                    Metasploit::Credential::Realm[:value].as('realm'),
                                                    Metasploit::Credential::Realm[:key].as('realm_key'),
                                                    Mdm::Service[:id].as('service_id'),
                                                    Mdm::Service[:name].as('service_name'),
                                                    Mdm::Service[:port].as('port'),
                                                    Mdm::Service[:proto].as('proto'),
                                                    Mdm::Host[:address].as('address'),
                                                    Mdm::Host[:id].as('host_id'),
                                                    Mdm::Host[:name].as('host_name'),
                                                    Mdm::Host[:os_name].as('host_os_name'),
                                                    Metasploit::Credential::Core[:id].as('core_id')
                                                  ]).joins(
        BruteForce::Guess::Attempt.join_association(:login),
        BruteForce::Guess::Attempt.join_association(:service),
        BruteForce::Guess::Attempt.join_association(:brute_force_run),
        BruteForce::Run.join_association(:task),
        Metasploit::Credential::Login.join_association(:core),
        Metasploit::Credential::Core.join_association(:public),
        Metasploit::Credential::Core.join_association(:private),
        Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
        Mdm::Service.join_association(:host)
      ).where(tasks: {id: @task.id}),
      options: {
        as_json: ->(record){
          record.as_json.merge!({
                                  'private_type_humanized' => record['private_type'].demodulize,
                                  'private_show_modal' =>  record['private_type'].constantize != Metasploit::Credential::Password,
                                  'full_fingerprint' => (record['private_type'].demodulize == 'SSHKey' ? Metasploit::Credential::SSHKey.new(data:record['private']).to_s : nil)
                                })
        }
      }
    }
  end

  def successful_logins_hover
    attempt_ids = JSON.parse(@params[:service_id])
    {
      relation: BruteForce::Guess::Attempt.select([
                                                    Metasploit::Credential::Core[:id],
                                                    Metasploit::Credential::Public[:username].as('public_username'),
                                                    Metasploit::Credential::Private[:data].as('private_data'),
                                                    Metasploit::Credential::Private[:type].as('private_type'),
                                                    Metasploit::Credential::Realm[:key].as('realm_key')
                                                  ]).joins(
        BruteForce::Guess::Attempt.join_association(:login),
        Metasploit::Credential::Login.join_association(:core),
        Metasploit::Credential::Core.join_association(:public),
        Metasploit::Credential::Core.join_association(:private),
        Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin)
      ).where(
        id: attempt_ids,
        metasploit_credential_cores: {workspace_id:@task.workspace_id}
      ),
      options:{
        as_json: ->(record){
          record.as_json.merge!({
                                  'private_type' => record['private_type'].demodulize
                                })
        }
      }

    }
  end

  def sessions_hover
    attempt_ids = JSON.parse(@params[:service_id])
    {
      relation: BruteForce::Guess::Attempt.select([Mdm::Session[:id]]).joins(
        BruteForce::Guess::Attempt.join_association(:session)
      ).where(
        id: attempt_ids
      )
    }
  end

  private

  def brute_force_run
    @run ||= BruteForce::Run.find_by_task_id(@task.id)
  end

end
