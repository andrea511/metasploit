class Apps::Domino::TaskConfigController < Apps::BaseController

  include TableResponder
  include FilterResponder

  before_action :load_workspace

  skip_before_action :setup_wizard, only: :hosts_table

  def hosts_table
    relation = hosts_table_relation

    if params.has_key?(:id)
      relation = relation.where(id: params[:id])
    end

    respond_with_table(relation)
  end

  def logins_table
    host_id = params[:host_id].to_i
    relation =
      Metasploit::Credential::Login.select([
        Metasploit::Credential::Core[:id].as('id'), # confusing!
        Metasploit::Credential::Login[:id].as('login_id'),
        Metasploit::Credential::Public[:username].as('public'),
        Metasploit::Credential::Private[:data].as('private'),
        Metasploit::Credential::Realm[:value].as('realm'),
        Metasploit::Credential::Realm[:key].as('realm_key'),
        Mdm::Service[:name].as('service_name'),
        Mdm::Service[:port].as('service_port')
      ]).joins([
        Metasploit::Credential::Login.join_association(:core),
        Metasploit::Credential::Login.join_association(:service),
        Mdm::Service.join_association(:host),
        Metasploit::Credential::Core.join_association(:public),
        Metasploit::Credential::Core.join_association(:private),
        Metasploit::Credential::Core.join_association(:realm, Arel::Nodes::OuterJoin),
        Mdm::Host.join_association(:workspace)
      ]).where(
        Mdm::Workspace[:id].eq(@workspace.id).and(
          Mdm::Service[:name].in(['ssh', 'smb'])
        )
      )

    if params.has_key?(:id)
      relation = relation.where(id: params[:id])
    else
      relation = relation.where(Mdm::Host[:id].eq(host_id))
    end

    respond_with_table(relation,
      options: {
        as_json: ->(record) {
          record.as_json.merge!({
            'public' => record['public'],
            'private' => record['private'],
            'private_type' => record['private_type'],
            'realm' => record['realm'],
            'realm_key' => record['realm_key'],
          })
        }
      }
    )
  end

  def sessions_table
    host_id = params[:host_id].to_i
    relation =
      Mdm::Session.select([
        Mdm::Session[:id]
      ]).joins([
        Mdm::Session.join_association(:host),
        Mdm::Host.join_association(:workspace)
      ]).where(
        hosts: { workspace_id: @workspace.id },
        closed_at: nil
      )

    if params.has_key?(:id)
      relation = relation.where(id: params[:id])
    else
      relation = relation.where(hosts: { id: host_id })
    end

    respond_with_table(relation)
  end

  def services_subtable
    host_id = params[:host_id].to_i
    render json: Mdm::Service.where(
      host_id: host_id
    ).where(
      Mdm::Service[:name].in(['ssh', 'smb'])
    ).as_json(only: [:name, :id, :port])
  end

  def logins_subtable
    host_id = params[:host_id].to_i
    render json: Metasploit::Credential::Login.select([
        Metasploit::Credential::Public[:username].as('public'),
        Metasploit::Credential::Private[:data].as('private'),
      ]).joins([
        Metasploit::Credential::Login.join_association(:service),
        Metasploit::Credential::Login.join_association(:core),
        Metasploit::Credential::Core.join_association(:public),
        Metasploit::Credential::Core.join_association(:private),
        Mdm::Service.join_association(:host)
      ]).where(Mdm::Host[:id].eq(host_id))
  end

  def tags_subtable
    host_id = params[:host_id].to_i
    render json: Mdm::Host.where(id: host_id).first.tags
  end

  def set_report_type
    @report_type = Apps::Domino::TaskConfig::REPORT_TYPE
  end

  def hosts_table_relation
    distinct = true
    relation =  # The ActiveRecord::Relation query object
      Mdm::Host.select([
        Mdm::Host[:id].as('id'),
        Mdm::Host[:address],
        Mdm::Host[:name],
        Mdm::Host[:os_name],
        Mdm::Service[:id].count(distinct).as('services_count'),
        Metasploit::Credential::Login[:id].count(distinct).as('logins_count'),
        Mdm::Session[:id].count(distinct).as('sessions_count'),
        Mdm::Tag[:id].count(distinct).as('tags_count')
      ]).joins([
        'LEFT OUTER JOIN "services" ON "services"."host_id" = "hosts"."id" AND "services"."name" IN (\'ssh\', \'smb\')',
        'LEFT OUTER JOIN "metasploit_credential_logins" ON "metasploit_credential_logins"."service_id" = "services"."id"',
        'LEFT OUTER JOIN "sessions" ON "sessions"."host_id" = "hosts"."id" AND "sessions"."closed_at" IS NULL',
        Mdm::Host.join_association(:tags, Arel::Nodes::OuterJoin)
      ]).group(
        Mdm::Host[:id]
      ).where(
        Mdm::Service[:name].in(['ssh', 'smb']).and(
          Mdm::Host[:workspace_id].eq(@workspace.id)
        ).and(
          Mdm::Session[:closed_at].eq(nil)
        )
      ).having(Mdm::Session[:id].count(distinct).gt(0).or(
        Metasploit::Credential::Login[:id].count(distinct).gt(0)
      ))
  end

  def filter_values
    values = filter_values_for_key(hosts_table_relation, params)
    render json: values.as_json
  end

  def search_operator_class
    Mdm::Host
  end

end
