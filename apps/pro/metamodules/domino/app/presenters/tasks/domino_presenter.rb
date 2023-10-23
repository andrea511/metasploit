#
# Handles serialization of findings data into JSON-able blobs for
# consumption by the UI. The visualization graph is shoved
# in here during polling (only the unknown parts are sent).
#
class Tasks::DominoPresenter < Tasks::BasePresenter
  # The `as_json` method is polled for the lifetime of the Task and
  #
  # We override this to stuff up-to-date information about the nodes
  # and edges into the per-run presenter JSON.
  #
  # This depends on the client setting the :since parameter in each
  # subsequent request to the :now parameter in the previous response.
  # Without the :since parameter, the entire graph will be sent back to
  # every request.
  def as_json(opts={})
    nodes = Apps::Domino::Node.select([
      Apps::Domino::Node[:id],
      Apps::Domino::Node[:high_value],
      Apps::Domino::Node[:captured_creds_count],
      Mdm::Host[:address].as('address'),
      Mdm::Host[:name].as('host_name'),
      Mdm::Host[:id].as('host_id')
    ]).joins(
      Apps::Domino::Node.join_association(:run),
      Apps::Domino::Node.join_association(:host),
      Apps::AppRun.join_association(:tasks),
    ).where(tasks: { id: @task.id })

    edges = Apps::Domino::Edge.select([
      Apps::Domino::Edge[:id],
      Apps::Domino::Edge[:source_node_id],
      Apps::Domino::Edge[:dest_node_id],
      Metasploit::Credential::Public[:username].as('public'),
      Metasploit::Credential::Private[:data].as('private'),
      Metasploit::Credential::Realm[:value].as('realm'),
      Mdm::Service[:name].as('service_name'),
      Mdm::Service[:port].as('service_port')
    ]).joins(
      Apps::Domino::Edge.join_association(:run),
      Apps::Domino::Edge.join_association(:login),
      Metasploit::Credential::Login.join_association(:service),
      Metasploit::Credential::Login.join_association(:core),
      Metasploit::Credential::Core.join_association(:private),
      Metasploit::Credential::Core.join_association(:public),
      Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
      Apps::AppRun.join_association(:tasks)
    ).where(tasks: { id: @task.id })

    # Repeated polling requests set 'since' to prevent duplication
    # in the response data.
    all_nodes = nodes
    if @params[:since].present?
      time = Time.at(@params[:since].to_i).utc.to_datetime
      nodes = all_nodes.where(Apps::Domino::Node[:created_at].gt(time))
      edges = edges.where(Apps::Domino::Edge[:created_at].gt(time))
    end

    super(except: :options).merge!(
      nodes: nodes,
      edges: edges,
      high_values: Apps::Domino::Node.joins(
          Apps::Domino::Node.join_association(:run),
          Apps::Domino::Node.join_association(:host),
          Apps::AppRun.join_association(:tasks),
          Mdm::Host.join_association(:sessions, Arel::Nodes::OuterJoin),
          'LEFT OUTER JOIN "task_sessions" ON "task_sessions"."session_id" = "sessions"."id"',
          'LEFT OUTER JOIN "tasks" AS "my_tasks" ON "my_tasks"."id" = "task_sessions"."task_id" AND "my_tasks"."id" = '+@task.id.to_i.to_s
        ).where(
          Apps::Domino::Node[:high_value].eq(true).and(
            Mdm::Task[:id].eq(@task.id)
          )
        ).having(
          'COUNT("my_tasks"."id") > 0'
        ).group(
          Apps::Domino::Node[:id]
        ).length,

      now: Time.new.utc.to_i
    )
  end


  #
  # Collection data - for rendering findings tables
  #

  # Creates the ActiveRecord::Relation for rendering the Hosts Compromised table
  def hosts_compromised
    distinct = true
    {
      relation: Apps::Domino::Node.select([
          Mdm::Host[:id].as('host_id'),
          Mdm::Host[:address],
          Mdm::Host[:name],
          Mdm::Host[:os_name],
          Apps::Domino::Node[:captured_creds_count],
          Apps::Domino::Node[:high_value],
          Mdm::Service[:name].as('service_name'),
          Mdm::Service[:port].as('service_port'),
          Metasploit::Credential::Core[:id].as('core_id'),
          Metasploit::Credential::Public[:username].as('public'),
          Metasploit::Credential::Private[:data].as('private'),
          Metasploit::Credential::Private[:type].as('private_type'),
          Metasploit::Credential::Realm[:value].as('realm'),
          Metasploit::Credential::Realm[:key].as('realm_key'),
          'COUNT("my_tasks"."id") as sessions_count',
          Mdm::Task[:id].as('task_id'),
          Apps::Domino::Node[:id].as('node_id'),
          Mdm::Workspace[:id].as('workspace_id')
        ]).group(
          Mdm::Host[:id],
          Mdm::Host[:address],
          Mdm::Host[:name],
          Mdm::Host[:os_name],
          Apps::Domino::Node[:captured_creds_count],
          Apps::Domino::Node[:high_value],
          Mdm::Service[:name],
          Mdm::Service[:port],
          Metasploit::Credential::Core[:id],
          Metasploit::Credential::Public[:username],
          Metasploit::Credential::Private[:data],
          Metasploit::Credential::Private[:type],
          Metasploit::Credential::Realm[:value],
          Metasploit::Credential::Realm[:key],
          Mdm::Task[:id],
          Apps::Domino::Node[:id],
          Mdm::Workspace[:id]
        ).joins(
          Apps::Domino::Node.join_association(:host),
          Apps::Domino::Node.join_association(:run),
          Apps::AppRun.join_association(:tasks),
          Apps::AppRun.join_association(:workspace),
          Apps::Domino::Node.join_association(:source_edge, Arel::Nodes::OuterJoin),
          Apps::Domino::Edge.join_association(:login, Arel::Nodes::OuterJoin),
          Metasploit::Credential::Login.join_association(:service, Arel::Nodes::OuterJoin),
          Metasploit::Credential::Login.join_association(:core, Arel::Nodes::OuterJoin),
          Metasploit::Credential::Core.join_association(:public, Arel::Nodes::OuterJoin),
          Metasploit::Credential::Core.join_association(:private, Arel::Nodes::OuterJoin),
          Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
          Mdm::Host.join_association(:sessions, Arel::Nodes::OuterJoin),
          'LEFT OUTER JOIN "task_sessions" ON "task_sessions"."session_id" = "sessions"."id"',
          'LEFT OUTER JOIN "tasks" AS "my_tasks" ON "my_tasks"."id" = "task_sessions"."task_id" AND "my_tasks"."id" = '+@task.id.to_i.to_s
        ).where(
          Mdm::Task[:id].eq(@task.id)
        ).having(
          'COUNT("my_tasks"."id") > 0'
        ),

      options: {
        as_json: ->(record) {
          record.as_json.merge!({
            'public' => record['public'],
            'private' => record['private'],
            'private_type' => record['private_type'],
            'realm' => record['realm'],
            'realm_key' => record['realm_key'],
            'service_name' => record['service_name'],
            'service_port' => record['service_port'],
            'host_id'      => record['host_id'],
            'node_id'      => record['node_id'],
            'session_id'   => record['session_id'],
            'workspace_id' => record['workspace_id']
          })
        }
      }
    }
  end

  # A clone of the previous table, but only high_value Nodes
  def high_value_hosts_compromised
    result = hosts_compromised
    result[:relation] = result[:relation].where(
      Apps::Domino::Node[:high_value].eq(true)
    )
    result
  end

  # The Unique Credentials table
  def unique_credentials_captured
    app_run = Apps::AppRun.joins(:tasks).where(tasks: { id: @task.id }).first
    compromise_edges = Apps::Domino::Edge.arel_table.alias('compromise_edges')

    {
      relation: Metasploit::Credential::Core.select([
          Metasploit::Credential::Core[:id].as('core_id'),
          Metasploit::Credential::Core[:workspace_id].as('workspace_id'),
          Metasploit::Credential::Core[:origin_id],
          Metasploit::Credential::Core[:origin_type],
          Metasploit::Credential::Core[:private_id].as('private_id'),
          Metasploit::Credential::Core[:realm_id].as('realm_id'),
          Metasploit::Credential::Public[:username].as('public'),
          Metasploit::Credential::Public[:id].as('public_id'),
          Metasploit::Credential::Private[:data].as('private'),
          Metasploit::Credential::Private[:type].as('private_type'),
          Metasploit::Credential::Realm[:value].as('realm'),
          Metasploit::Credential::Realm[:key].as('realm_key'),
          Mdm::Host[:address].as('captured_from_address'),
          Mdm::Host[:name].as('captured_from_name'),
          Mdm::Host[:id].as('host_id'),
          compromise_edges[:id].count(true).as('compromised_hosts')
        ]).group(
          Metasploit::Credential::Core[:id],
          Metasploit::Credential::Public[:id],
          Metasploit::Credential::Private[:id],
          Metasploit::Credential::Realm[:id],
          Mdm::Host[:id],
          Apps::Domino::Node[:id],
        ).joins(
          Metasploit::Credential::Core.join_association(:public),
          Metasploit::Credential::Core.join_association(:private),
          Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
          Metasploit::Credential::Core.join_association(:domino_nodes),
          Apps::Domino::Node.join_association(:host),
          'LEFT OUTER JOIN "metasploit_credential_logins" ON "metasploit_credential_logins"."core_id" = "metasploit_credential_cores"."id"',
          'LEFT OUTER JOIN "mm_domino_edges" AS "compromise_edges" ON "compromise_edges"."login_id" = "metasploit_credential_logins"."id" AND "compromise_edges"."run_id" = '+app_run.id.to_i.to_s
        ).where(
          Apps::Domino::Node[:run_id].eq(app_run.id)
        ),

      options: {
        as_json: ->(record) {
          record.as_json.merge!({
            'public' => record['public'],
            'private' => record['private'],
            'realm' => record['realm'],
            'realm_key' => record['realm_key'],
            'private_type' => record['private_type'],
            'task_id' => @task.id,
            'workspace_id' => record['workspace_id']
          })
        }
      }
    }
  end

  def creds_captured_from
    node_id = @params[:node_id].to_i
    {
      relation: Metasploit::Credential::Core.select([
          Metasploit::Credential::Core[:id],
          Metasploit::Credential::Public[:username].as('public'),
          Metasploit::Credential::Public[:id].as('public_id'),
          Metasploit::Credential::Private[:data].as('private'),
          Metasploit::Credential::Private[:type].as('private_type'),
          Metasploit::Credential::Private[:type].as('private_id')
        ]).joins(
          Metasploit::Credential::Core.join_association(:public),
          Metasploit::Credential::Core.join_association(:private),
          Metasploit::Credential::Core.join_association(:domino_nodes)
        ).where(
          Apps::Domino::Node[:id].eq(node_id)
        ),
      options: {
        as_json: ->(record) {
          record.as_json.merge!({
            'public' => record['public'],
            'public_id' => record['public_id'],
            'private_id' => record['private_id'],
            'private' => record['private'],
            'private_type' => record['private_type']
          })
        }
      }
    }
  end

  def hosts_compromised_from
    core_id = @params[:core_id].to_i
    app_run = Apps::AppRun.joins(:tasks).where(tasks: { id: @task.id }).first

    {
      relation: Apps::Domino::Node.select([
          Mdm::Host[:id],
          Mdm::Host[:name].as('host_name'),
          Mdm::Host[:address].as('host_address')
        ]).group(
          Mdm::Host[:id],
          Mdm::Host[:name],
          Mdm::Host[:address],
          Apps::Domino::Node[:id]
        ).joins(
          Apps::Domino::Node.join_association(:source_edge),
          Apps::Domino::Node.join_association(:host),
          Apps::Domino::Edge.join_association(:login),
          Metasploit::Credential::Login.join_association(:core)
        ).where(
          Metasploit::Credential::Core[:id].eq(core_id).and(
            Apps::Domino::Node[:run_id].eq(app_run.id)
          )
        ),
      options: {
        as_json: ->(record) {
          record.as_json.merge!({
            'host_name' => record['host_name'],
            'host_address' => record['host_address']
          })
        }
      }
    }
  end


  def node
    {
      relation: Apps::Domino::Node.select([
                                          Apps::Domino::Node[:id],
                                          Apps::Domino::Node[:high_value],
                                          Apps::Domino::Node[:captured_creds_count],
                                          Mdm::Host[:address].as('address'),
                                          Mdm::Host[:name].as('host_name'),
                                          Mdm::Host[:id].as('host_id')
                                        ]).joins(
        Apps::Domino::Node.join_association(:run),
        Apps::Domino::Node.join_association(:host),
        Apps::AppRun.join_association(:tasks),
      ).where(tasks: { id: @task.id }, id: @params[:node_id])
    }
  end

end
