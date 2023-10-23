class Tasks::BruteForceReusePresenter < Tasks::BasePresenter

  def login_attempts
    {
      # this needs to be fixed with a sql presenter
      relation: BruteForce::Reuse::Attempt.select([
            BruteForce::Reuse::Attempt[Arel.star],
            Metasploit::Credential::Login[:id].count.as('login_count'),
            Mdm::Host[:address].as('address'),
            Mdm::Host[:name].as('host_name'),
            Mdm::Host[:id].as('host_id'),
            Metasploit::Credential::Public[:username].as('public'),
            Metasploit::Credential::Private[:data].as('private'),
            Metasploit::Credential::Realm[:value].as('realm'),
            Mdm::Service[:name].as('service_name'),
            Metasploit::Credential::Core[:id].as('core_id')
          ]).group(
            BruteForce::Reuse::Attempt[:id],
            Mdm::Host[:address],
            Mdm::Host[:name],
            Mdm::Host[:id],
            Metasploit::Credential::Public[:username],
            Metasploit::Credential::Private[:data],
            Metasploit::Credential::Realm[:value],
            Mdm::Service[:name],
            Metasploit::Credential::Core[:id]
          ).joins(
            BruteForce::Reuse::Attempt.join_association(:brute_force_run),
            BruteForce::Reuse::Attempt.join_association(:metasploit_credential_core),
            Metasploit::Credential::Core.join_association(:private),
            Metasploit::Credential::Core.join_association(:public),
            Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
            Metasploit::Credential::Core.join_association(:logins, Arel::Nodes::OuterJoin) do |assoc_name, join_conditions|
              join_conditions.and(Metasploit::Credential::Login[:service_id].eq(BruteForce::Reuse::Attempt[:service_id]))
            end,
            Metasploit::Credential::Login.join_association(:tasks, Arel::Nodes::OuterJoin),
            BruteForce::Reuse::Attempt.join_association(:service),
            Mdm::Service.join_association(:host)
          ).where(
            BruteForce::Reuse::Attempt[:brute_force_run_id].eq(brute_force_run.id)
          ).where(
            Mdm::Task[:id].eq(nil).or(Mdm::Task[:id].eq(BruteForce::Run[:task_id]))
          ),

      options: {
        presenter_class: BruteForce::Reuse::AttemptPresenter,
        total_count: brute_force_run.brute_force_reuse_attempts.count
      }
    }
  end

  def validated_credentials
    {
      relation:
        Metasploit::Credential::Core.select([
          Metasploit::Credential::Core[:id],
          Metasploit::Credential::Public[:username].as('public'),
          Metasploit::Credential::Private[:data].as('private'),
          Metasploit::Credential::Realm[:value].as('realm')
        ]).joins(
          Metasploit::Credential::Core.join_association(:public),
          Metasploit::Credential::Core.join_association(:private),
          Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
          Metasploit::Credential::Core.join_association(:logins),
          Metasploit::Credential::Login.join_association(:tasks)
        ).where(tasks: {id: @task.id}).distinct,

      options: {
        presenter_class: BruteForce::Reuse::ValidatedCredentialPresenter
      }
    }
  end

  def validated_targets
    {
      relation: Mdm::Service.select([
                  Mdm::Service[:id],
                  Mdm::Service[:name],
                  Mdm::Service[:port],
                  Mdm::Service[:proto],
                  Mdm::Service[:state],
                  Mdm::Host[:address].as('address'),
                  Mdm::Host[:id].as('host_id'),
                  Mdm::Host[:name].as('host_name')
                ]).joins(
                  Mdm::Service.join_association(:host),
                  Mdm::Service.join_association(:logins),
                  Metasploit::Credential::Login.join_association(:tasks)
                ).where(tasks: {id: @task.id})
    }
  end

  def successful_logins
    {
      relation: Metasploit::Credential::Login.select([
                  Metasploit::Credential::Login[:id],
                  Metasploit::Credential::Public[:username].as('public'),
                  Metasploit::Credential::Private[:data].as('private'),
                  Metasploit::Credential::Realm[:value].as('realm'),
                  Mdm::Service[:name].as('service_name'),
                  Mdm::Service[:port].as('port'),
                  Mdm::Service[:proto].as('proto'),
                  Mdm::Host[:address].as('address'),
                  Mdm::Host[:id].as('host_id'),
                  Mdm::Host[:name].as('host_name'),
                  Metasploit::Credential::Core[:id].as('core_id')
                ]).joins(
                  Metasploit::Credential::Login.join_association(:core),
                  Metasploit::Credential::Login.join_association(:tasks),
                  Metasploit::Credential::Login.join_association(:service),
                  Metasploit::Credential::Core.join_association(:public),       
                  Metasploit::Credential::Core.join_association(:private),
                  Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
                  Mdm::Service.join_association(:host)
                ).where(tasks: {id: @task.id})
    }
  end

  private

  def brute_force_run
    @run ||= BruteForce::Run.find_by_task_id(@task.id)
  end

end
