# Generates some data models for the Domino Visualization

SPEED = ENV.fetch('SPEED', 1).to_f
ITERATIONS = ENV.fetch('ITERATIONS', 5).to_i
WORKSPACE = ENV.fetch('WORKSPACE', 'DominoTesting')
TOTAL_HOSTS = 2**ITERATIONS

def _sleep(n)
  sleep n*SPEED
end

def node_for_host(host, run, depth)
  opts = { run_id: run.id, host_id: host.id }
  node = Apps::Domino::Node.where(opts).first
  unless node
    node = FactoryBot.create(:apps_domino_node, run: run, host: host, high_value: $high_value.include?(host), depth: depth)
  end
  node
end

def create_session(host)
  stype     = %w|shell meterpreter|.sample
  # Random selection of open and closed sessions:
  closed    = (Time.now - 5) if (Time.now.to_i.even?)
  exploit   = ['auxiliary/scanner/ssh/ssh_login_pubkey',
               'exploit/multi/samba/usermap_script',
               'exploit/windows/smb/psexec'
              ].sample
  FactoryBot.create(:mdm_session,
    host: host,
    stype: stype,
    opened_at: Time.now - 10,
    closed_at: closed,
    last_seen: Time.now - 5,
    via_exploit: exploit
  )
end

def create_private
  private_types = [
    :metasploit_credential_password,
    :metasploit_credential_nonreplayable_hash,
    :metasploit_credential_ntlm_hash,
    :metasploit_credential_dsa_key,
    :metasploit_credential_rsa_key,
    :metasploit_credential_ssh_key
  ]
  private_type = private_types.sample

  case private_type
  when /key/
    FactoryBot.create(private_type)
  when /hash/
    hash = FactoryBot.build(private_type, password_data: Faker::Internet.password)
    until hash.valid?
      hash = FactoryBot.build(private_type, password_data: Faker::Internet.password)
    end
    hash.save
    hash
  else # password
    data = Faker::Internet.password
    pass = Metasploit::Credential::Password.find_by_data(data) ||
      FactoryBot.create(private_type, data: data)
    pass
  end
end

def create_hosts(n, workspace)
  n.times.map {
    address = Faker::Internet.ip_v4_address
    mac = "00:0c:29:8d:ec:99"
    name = "HostName-#{rand(100000)}"
    state = "alive"
    os_list = ["Linux", "Windows", "Mac OS X"]
    os_name = os_list[rand(3)]
    flavors = { "Linux" => ["Debian", "Ubuntu", "CentOS"],
                "Windows" => ["NT", "7", "2008"],
                "Mac OS X" => ["", "", ""]
    }
    os_flavor = flavors[os_name][rand(3)]
    os_lang = "English"
    purpose = "server"

    Mdm::Host.create!(
      :address => address,
      :mac => mac,
      :name => name,
      :state => state,
      :os_name => os_name,
      :os_flavor => os_flavor,
      :os_lang => os_lang,
      :workspace_id => workspace.id,
      :purpose => purpose
    )
  }
end

def random_subset(arr)
  space = 2+rand(4)
  arr.select { rand(space).zero? }
end

user = Mdm::User.first
raise "You must create a user first" if user.nil?
workspace = Mdm::Workspace.where(name: WORKSPACE).first_or_create(owner_id: user.id)

if workspace.hosts.empty?
  hosts = create_hosts(TOTAL_HOSTS, workspace)
  services = hosts.map { |host| FactoryBot.create_list(:mdm_service, 5, host: host) }.flatten
else
  hosts = workspace.hosts.to_a
  services = workspace.services
end

task = Mdm::Task.create(
  workspace_id: workspace.id,
  path:         '/tmp/dat_domino_tester',
  progress:     100,
  completed_at: nil,
  info:         'Domino Metamodule',
  description:  'Domino Metamodule'
)
task.presenter = 'domino'
task.save!

puts "Running task #{task.id} in workspace #{workspace.id}"
puts "http://localhost:3000/workspaces/#{workspace.id}/tasks/#{task.id}"

working_group = [hosts.pop]
tags = random_subset(%w(Bridge ControlRoom HVAC AlarmRoom BankValue JoesDesk))
$high_value = random_subset(hosts)
original_high_value = $high_value.dup
high_value_tagged = random_subset(hosts)
high_value_tagged.each do |host|
  host.tags << Mdm::Tag.first_or_create(name: tags.sample)
  host.save!
  $high_value << host
end
$high_value.uniq!

app_run = Apps::AppRun.new(app: Apps::App.find_by_symbol('domino'), workspace: workspace)
app_run.tasks << task
attack_type = %w(session login).sample
app_run.config = {
  'initial_attack_type' => attack_type,
  'initial_host_id' => working_group.first.id,
  'initial_session_id' => 1,
  'initial_login_id' => 1,
  'target_addresses' => hosts.collect { |h| h.address },
  'excluded_addresses' => rand(10).times.map { Faker::Internet.ip_v4_address },
  'high_value_addresses' => original_high_value.collect { |h| h.address },
  'high_value_tags' => tags,
  'payload' => {
    'payload_type' => 'meterpreter',
    'connection' => 'auto',
    'payload_ports' => '1.1.1.1',
    'payload_lhost' => '4444',
    'DynamicStager' => false
  },
  'cleanup_sessions' => false,
  'max_iterations' => nil, #unlimited
  'overall_timeout' => 600 + rand(500), #seconds
  'service_timeout' => 600 + rand(500)  # seconds
}
app_run.save!
app_run.start!
puts "App Run ID #{app_run.id}"

app_run.run!

run_stats = {
  :iterations => 0,
  :iterations_total => ITERATIONS,
  :creds_captured => 0,
  :hosts_compromised => 0,
  :hosts_total => TOTAL_HOSTS
}.map do |key, val|
  [key, RunStat.create(name: key, task: task, data: val)]
end
run_stats = Hash[run_stats]

next_working_group = []
nodes = [node_for_host(working_group.first, app_run, 0)]

ITERATIONS.times do |i|

  working_group.each do |start_host|

    start_node = node_for_host(start_host, app_run, i)
    start_node
    puts "Building nodes off of base #{start_host.id}"

    if rand(2) # we logged in and collected some creds
      (rand(7)).times do
        origin = FactoryBot.create(:metasploit_credential_origin_session, session: create_session(start_host))
        pub  = Metasploit::Credential::Username.where(username: Rex::Text.rand_text_alpha(10)).first_or_create
        pass = create_private

        realm_id = nil

        if (rand(2))
          # A more realistic value, but not guaranteed to be unique:
          realm_val = Faker::Internet.domain_word
          realm = Metasploit::Credential::Realm.find_by_value(realm_val) ||
            FactoryBot.create(:metasploit_credential_realm, value: realm_val)
          realm_id = realm.id
        end

        core = Metasploit::Credential::Core.where(
          public_id: pub.id,
          private_id: pass.id,
          origin_id: origin.id,
          workspace_id: workspace.id,
          realm_id: realm_id,
          origin_type: 'Metasploit::Credential::Origin::Session'
        ).first_or_create!

        task.credential_cores << core
        task.save!

        run_stats[:creds_captured].data += 1
        run_stats[:creds_captured].save!

        start_node.captured_creds_count += 1
        start_node.save!

        start_node.captured_creds << core
        start_node.save!
      end
    end

    # take a random number of hosts and build edges
    (1+rand(15)).times do |i2|

      unless hosts.empty?
        _sleep 1
        puts "Adding node to iteration #{i}...."

        host = hosts.pop
        next_working_group << host
        node = node_for_host(host, app_run, i+1)

        origin = FactoryBot.create(:metasploit_credential_origin_session, session: create_session(start_host))
        pub  = Metasploit::Credential::Username.where(username: Rex::Text.rand_text_alpha(10)).first_or_create
        pass = create_private

        realm_id = nil

        if (rand(2))
          # A more realistic value, but not guaranteed to be unique:
          realm_val = Faker::Internet.domain_word
          realm = Metasploit::Credential::Realm.find_by_value(realm_val) ||
            FactoryBot.create(:metasploit_credential_realm, value: realm_val)
          realm_id = realm.id
        end

        core = Metasploit::Credential::Core.where(
          public_id: pub.id,
          private_id: pass.id,
          origin_id: origin.id,
          workspace_id: workspace.id,
          realm_id: nil,
          origin_type: 'Metasploit::Credential::Origin::Session',
        ).first_or_create!

        task.credential_cores << core
        task.save!

        run_stats[:creds_captured].data += 1
        run_stats[:creds_captured].save!

        start_node.captured_creds_count += 1
        start_node.save!

        edge = Apps::Domino::Edge.new
        edge.source_node = start_node
        edge.dest_node   = node
        edge.run         = app_run

        edge.login       = FactoryBot.build(:metasploit_credential_login,
                            workspace: workspace,
                            host: node.host,
                            core: core)
        edge.login.core_id = core.id
        edge.login.save!
        edge.save!

        run_stats[:hosts_compromised].data += 1
        run_stats[:hosts_compromised].save!

        start_node.captured_creds << core
        start_node.save!

        nodes << node
      end

    end

  end

  old_count = working_group.count
  working_group = next_working_group
  next_working_group = []
  puts "Working group now sized #{working_group.count}, old size was #{old_count}"


  run_stats[:iterations].data += 1
  run_stats[:iterations].save!
end

# EL FIN
app_run.complete!
task.update(completed_at: Time.now)
