# Creates hosts, services and loot for load testing.
#
# With no options, a single host is created with a small number of
# services. Each host also has several sample loot files attached,
# including screenshot images and text files.
#
# Options:
#  --host-count: Number of hosts to create (default 1)
#  --service-count: Number of services to add per host (default random 0-20)
#  --loot-count: Number of loots to add per host (default random 0-5)
#  --workspace-id: ID of workspace to create hosts in (default makes new one)
#
# TODO: Error handling (IPs might conflict); consider adding sessions,
# services, vulndetail

require 'base64'
require 'fileutils'
require 'optparse'

include Metasploit::Credential::Creation

def create_host(workspace_id)
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

  host = Mdm::Host.create!(:address => address,
                       :mac => mac,
                       :name => name,
                       :state => state,
                       :os_name => os_name,
                       :os_flavor => os_flavor,
                       :os_lang => os_lang,
                       :workspace_id => workspace_id,
                       :purpose => purpose
                      )
  host.id
end

def create_task(workspace_id)
  tmp_file = "/tmp/#{Time.now.to_i}"
  FileUtils.touch(tmp_file)

  FactoryBot.create(:mdm_task,
                     workspace_id: workspace_id,
                     created_by: Mdm::User.first,
                     completed_at: Time.now,
                     progress: 100,
                     path: tmp_file,
                     info: 'Complete (New Hosts)',
                     description: 'Importing'
  ).id
end

def create_service(host_id)
  services = ["21|ftp|tcp|vsFTPd 2.3.4",
              "22|ssh|tcp|SSH-2.0-Sun_SSH_1.3",
              "23|telnet|tcp|_ _ _ _ _ _ ____ \x0a _ __ ___ ___| |_ __ _ ___ _ __ | | ___ (_) |_ __ _| |__ | | ___|___ \ \x0a| '_ ` _ \ / _ \ __/ _` / __| '_ \| |/ _ \| | __/ _` | '_ \| |/ _ \ __) |\x0a| | | | | | __/ || (_| \__ \ |_) | | (_) | | || (_| | |_) | | __// __/ \x0a|_| |_| |_|\___|\__\__,_|___/ .__/|_|\___/|_|\__\__,_|_.__/|_|\___|_____|\x0a |_| \x0a\x0a\x0aWarning: Never expose this VM to an untrusted network!\x0a\x0aContact: msfdev[at]metasploit.com\x0a\x0aLogin with msfadmin/msfadmin to get started\x0a\x0a\x0ametasploitable login:",
              "25|smtp|tcp|Sendmail 8.13.8",
              "53|dns|tcp|BIND 9.4.2",
              "53|dns|udp|Microsoft DNS",
              "80|http|tcp|Web Server",
              "110|pop|tcp|E-mail Services",
              "111|portmapper|udp|100000 v2 TCP(111), 100000 v2 UDP(111), 100024 v1 UDP(59172), 100024 v1 TCP(39698), 100003 v2 UDP(2049), 100003 v3 UDP(2049), 100003 v4 UDP(2049), 100021 v1 UDP(34069), 100021 v3 UDP(34069), 100021 v4 UDP(34069), 100003 v2 TCP(2049), 100003 v3 TCP(2049), 100003 v4 TCP(2049), 100021 v1 TCP(54223), 100021 v3 TCP(54223), 100021 v4 TCP(54223), 100005 v1 UDP(41465), 100005 v1 TCP(39537), 100005 v2 UDP(41465), 100005 v2 TCP(39537), 100005 v3 UDP(41465), 100005 v3 TCP(39537)",
              "111|portmapper|tcp|100000 v2",
              "123|ntp|udp|NTP v4 (unsynchronized)",
              "135|dcerpc|tcp|5a7b91f8-ff00-11d0-a9b2-00c04fb6e6fc v1.0 Messenger Service",
              "137|netbios|udp|WORKGROUP:<00>:G :W28S21-6-MSW1:<00>:U :W28S21-6-MSW1:<20>:U :00:50:56:b3:5e:ef",
              "139|smb|tcp|Windows XP Service Pack 3 (language: English) (name:VULNET004XPSP3) (domain:WORKGROUP)",
              "389|ldap|tcp|ldap",
              "443|https|tcp|HTTPD 2.2.22",
              "445|smb|tcp|Windows XP Service Pack 3 (language: English) (name:VULNET004XPSP3) (domain:WORKGROUP)",
              "512|rexec|tcp|rexec",
              "513|login|tcp|login",
              "514|shell|tcp|shell"
  ]
  states = ['open', 'closed', 'filtered', 'unknown']


  serv_arr = services[rand(services.size)].split('|')
  port  = serv_arr[0]
  proto = serv_arr[2]

  # Reduce the chances of hitting port/proto dupe:
  while port_taken?(port, proto, host_id) do
    port = port.to_i + rand(10000)
  end
  service = Mdm::Service.create!(:host_id => host_id,
                                 :port    => port,
                                 :proto   => proto,
                                 :state   => states[rand(4)],
                                 :name    => serv_arr[1],
                                 :info    => serv_arr[3]
  )
  service.id

end

def port_taken?(port, proto, host_id)
  !Mdm::Service.where(host_id: host_id, port: port, proto: proto).none?
end

def group_file_data
  %Q|root:x:0:
  daemon:x:1:
  bin:x:2:
  sys:x:3:
  adm:x:4:msfadmin
  tty:x:5:
  disk:x:6:
  lp:x:7:
  mail:x:8:
  news:x:9:
  uucp:x:10:
  man:x:12:
  proxy:x:13:
  kmem:x:15:
  dialout:x:20:msfadmin
  fax:x:21:
  voice:x:22:
  cdrom:x:24:msfadmin
  floppy:x:25:msfadmin
  tape:x:26:
  sudo:x:27:
  audio:x:29:msfadmin
  dip:x:30:msfadmin
  www-data:x:33:
  backup:x:34:
  operator:x:37:
  list:x:38:
  irc:x:39:
  src:x:40:
  gnats:x:41:
  shadow:x:42:
  utmp:x:43:telnetd
  video:x:44:msfadmin
  sasl:x:45:
  plugdev:x:46:msfadmin
  staff:x:50:
  games:x:60:
  users:x:100:
  nogroup:x:65534:
  libuuid:x:101:
  dhcp:x:102:
  syslog:x:103:
  klog:x:104:
  scanner:x:105:
  nvram:x:106:
  fuse:x:107:msfadmin
  crontab:x:108:
  mlocate:x:109:
  ssh:x:110:
  msfadmin:x:1000:
  lpadmin:x:111:msfadmin
  admin:x:112:msfadmin
  bind:x:113:
  ssl-cert:x:114:postgres
  postfix:x:115:
  postdrop:x:116:
  postgres:x:117:
  mysql:x:118:
  sambashare:x:119:msfadmin
  user:x:1001:
  service:x:1002:
  telnetd:x:120:|
end

def passwd_file_data
  %Q|root:x:0:0:root:/root:/bin/bash
  daemon:x:1:1:daemon:/usr/sbin:/bin/sh
  bin:x:2:2:bin:/bin:/bin/sh
  sys:x:3:3:sys:/dev:/bin/sh
  sync:x:4:65534:sync:/bin:/bin/sync
  games:x:5:60:games:/usr/games:/bin/sh
  man:x:6:12:man:/var/cache/man:/bin/sh
  lp:x:7:7:lp:/var/spool/lpd:/bin/sh
  mail:x:8:8:mail:/var/mail:/bin/sh
  news:x:9:9:news:/var/spool/news:/bin/sh
  uucp:x:10:10:uucp:/var/spool/uucp:/bin/sh
  proxy:x:13:13:proxy:/bin:/bin/sh
  www-data:x:33:33:www-data:/var/www:/bin/sh
  libuuid:x:100:101::/var/lib/libuuid:/bin/sh
  dhcp:x:101:102::/nonexistent:/bin/false
  syslog:x:102:103::/home/syslog:/bin/false
  klog:x:103:104::/home/klog:/bin/false
  sshd:x:104:65534::/var/run/sshd:/usr/sbin/nologin
  msfadmin:x:1000:1000:msfadmin,,,:/home/msfadmin:/bin/bash
  bind:x:105:113::/var/cache/bind:/bin/false
  postfix:x:106:115::/var/spool/postfix:/bin/false
  ftp:x:107:65534::/home/ftp:/bin/false
  postgres:x:108:117:PostgreSQL
  administrator,,,:/var/lib/postgresql:/bin/bash
  mysql:x:109:118:MySQL
  Server,,,:/var/lib/mysql:/bin/false
  tomcat55:x:110:65534::/usr/share/tomcat5.5:/bin/false
  distccd:x:111:65534::/:/bin/false
  service:x:1002:1002:,,,:/home/service:/bin/bash
  telnetd:x:112:120::/nonexistent:/bin/false
  proftpd:x:113:65534::/var/run/proftpd:/bin/false
  statd:x:114:65534::/var/lib/nfs:/bin/false|
end

def save_text_file(path,data)
  unless File.exist? path
    file = File.new(path, 'w+')
    file.write(data)
    file.close
  end
end

def copy_image_file(orig_file, path)
  unless File.exist? path
    FileUtils.cp(orig_file, path)
  end
end

# Loot files are removed from FS when host is deleted.
# Reports and web UI uses path to load file, not data. Including that as
# well in case somewhere actually uses it.
# Note that the file path the files are copied to is the same for all
# hosts. This still works in the UI and has the added benefit of not
# wasting FS space!
def create_loot(loot_count, host_id, workspace_id)
  loots = ["host_screenshot|image/png|An Image|image.png",
           "host.unix.group|text/plain|/etc/group|group",
           "host.unix.passwd|text/plain|/etc/passwd|passwd"]

  # For each loot to add, pick a random type:
  loot_count.times do |l|
    loot_arr = loots[rand(3)].split('|')
    ltype, content_type = loot_arr[0], loot_arr[1]
    info, name = loot_arr[2], loot_arr[3]

    case ltype
    when 'host_screenshot'
      images = {:small => 'small_image.png',
                :large => 'large_image.png'}
      name = images[images.keys[rand(images.size)]]
      orig_file = File.dirname(__FILE__) + '/' + name
      # Leaving out for now to save DB space; not needed?
      # data = Base64.encode64(File.open(orig_file).read)
      path = '/tmp/' + name
      copy_image_file(orig_file, path)
    when /host.unix\.*/
      # Leaving out for now to save DB space; not needed?
      data = group_file_data
      case ltype
      when /.*group/
        path = '/tmp/group_file.txt'
      when /.*passwd/
        path = '/tmp/passwd_file.txt'
      end
      save_text_file(path,data)
    end

    loot = Mdm::Loot.create!(:workspace_id => workspace_id,
                             :host_id => host_id,
                             :ltype => ltype,
                             :path => path,
                             :content_type => content_type,
                             :name => name,
                             :info => info)
  end
end

def add_ref
  ref = Mdm::Ref.create!(:name => 'URL-http://www.metasploit.com')
  ref.id
end

# TODO: Real vulns are usually connected to services,
# can have attempts.
def create_vulns(vuln_count, host_id, workspace_id)
  host = Mdm::Host.where("workspace_id = #{workspace_id} and id = #{host_id}")
  vuln_count.times do |v|
    vuln = Mdm::Vuln.create!(:host_id => host_id,
                             :name    => "Stochastic M-brane instability",
                             :exploited_at => Time.now,
                             :info    => "Your flux capacitor is subject to a time traveller in the middle attack."
    )
    #
    # TODO Mdm::VulnDetail
    # Random reference:
    ref_id = Mdm::Ref.count > 0 ? Mdm::Ref.first.id : add_ref
    Mdm::VulnRef.create!(:ref_id => ref_id, :vuln_id => vuln.id)
  end
end

def create_web_service(host_id)
  states    = ['open', 'closed', 'filtered', 'unknown']
  ports     = [80, 443, 8080]
  protocol  = 'tcp'
  names     = ['http', 'https']

  web_service = Mdm::Service.create!(:host_id => host_id,
                                     :port => ports[rand(ports.size)],
                                     :proto => protocol,
                                     :state => states[rand(states.size)],
                                     :name => names[rand(names.size)]
                                    )
  web_service.id
end

def create_web_site(service_id)
  host_address = Mdm::Service.find(service_id).host.address
  site = Mdm::WebSite.create(:service_id => service_id,
                             :vhost => host_address)
  # If they are unrealistically close in creation time graphs will look incorrect:
  site.created_at -= (rand(15)).minute
  site.save!
  site.id
end

def create_page_form_vuln(web_site_id, count)
  count.times do |c|
    codes = [200, 302, 403, 404]
    methods = ["GET", "POST"]
    pieces = ["coolapp", "superdir", "pictures", "users", "sekrets", "things"]
    path = "/" + (pieces[1..rand(pieces.size)]).join("/") + "/"
    query = "a=1&b=2&c=3"
    page = Mdm::WebPage.create(:web_site_id => web_site_id,
                               :path => path,
                               :query => query,
                               :code => codes[rand(codes.size)]
    )
    page.created_at -= (rand(15)).minute
    page.save!
    page.id
    form = Mdm::WebForm.create(:web_site_id => web_site_id,
                               :path => path,
                               :method => methods[rand(methods.size)]
    )
    form.created_at -= (rand(15)).minute
    form.save!
    confidences = (1..100).to_a
    risks = (0..5).to_a
    blames = ['App Developer', '']
    category_id = Web::VulnCategory::Metasploit.order("RANDOM()").first.id

    name = 'SuperName'
    web_vuln = Mdm::WebVuln.create(:web_site_id => web_site_id,
                                   :path => path,
                                   :method => methods[rand(methods.size)],
                                   :risk => risks[rand(risks.size)],
                                   :confidence => confidences[rand(confidences.size)],
                                   :category_id => category_id,
                                   :name => name,
                                   :blame => blames[rand(blames.size)],
                                   :query => 'page=admin',
                                   :pname => 'fake'
    )
    web_vuln.created_at -= (rand(15)).minute
    web_vuln.save!
    FactoryBot.create(:textual_web_proof, :vuln_id => web_vuln.id)
    FactoryBot.create(:graphical_web_proof, :vuln_id => web_vuln.id)
    web_vuln.id
  end
end

def create_web_task(workspace_id, count)
  count.times do |c|
    web_modules = ['pro/webscan', 'pro/webaudit', 'pro/websploit']
    task = Mdm::Task.create(:workspace_id => workspace_id,
                            :module => web_modules[rand(web_modules.size)],
                            :completed_at => Time.now(),
                            :path => '/tmp/no-wai-this-file-exists-sousaphone.txt',
                            :progress => 100
    )
    task.created_at -= (rand(30)).minute
    task.save!
  end
end

def generate_web_data(workspace_id, service_id)
  site_id = create_web_site(service_id)
  create_page_form_vuln(site_id, rand(50))
  create_web_task(workspace_id, rand(10))
end

def create_public
  username = Faker::Internet.user_name
  Metasploit::Credential::Public.find_by_username(username) ||
    FactoryBot.create(:metasploit_credential_username, username: username)
end

def create_private(private_type)
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

def create_cred(opts = {})
  type = opts[:type]
  workspace = Mdm::Workspace.find(opts[:workspace_id])
  host = Mdm::Host.find(opts[:host_id]) if opts[:host_id]

  # Context-appropriate origin
  case type
  when 'imported'
    task_id = opts[:task_id]
    task = Mdm::Task.find(task_id)
    origin = FactoryBot.create(:metasploit_credential_origin_import,
                                task: task)
  when 'manual'
    user = Mdm::User.first
    origin = FactoryBot.create(:metasploit_credential_origin_manual,
                                user: user)
  when 'service'
    service = host.services.first
    return nil unless service
    origin = FactoryBot.create(:metasploit_credential_origin_service,
                                service: service)
  when 'session'
    session = host.sessions.first
    origin = FactoryBot.create(:metasploit_credential_origin_session,
                                session: session)
  end

  # Public
  # A more realistic value, but not guaranteed to be unique:
  username = create_public

  # Private
  private_types = [
    :metasploit_credential_password,
    :metasploit_credential_nonreplayable_hash,
    :metasploit_credential_ntlm_hash,
    :metasploit_credential_dsa_key,
    :metasploit_credential_rsa_key,
    :metasploit_credential_ssh_key
  ]
  private_type = private_types.sample
  # Realm applies to particular privates, and these same types also
  # need to be unique values
  realm_applicable = !(private_type =~ /password|hash/).nil?

  # Realm
  if realm_applicable
    # A more realistic value, but not guaranteed to be unique:
    realm_val = Faker::Internet.domain_word
    realm = Metasploit::Credential::Realm.find_by_value(realm_val) ||
      FactoryBot.create(:metasploit_credential_realm, value: realm_val)
  else
    realm = nil
  end

  # Core
  # On rare occasion, create a core without a public or a private
  no_private = (rand(11) == 1)
  private = if no_private
              nil
            else
              create_private(private_type)
            end
  # Public is needed if there is no private or if the private is SSH,
  # otherwise make one randomly:
  public = if no_private
             create_public
           elsif private.type == 'Metasploit::Credential::SSHKey'
             create_public
           else
             if (rand(6) == 1)
               nil
             else
               create_public
             end
           end

  core = FactoryBot.create(:metasploit_credential_core,
                            origin:    origin,
                            realm:     realm,
                            private:   private,
                            public:    public,
                            workspace: workspace
  )

  # Simulate several creds being looted from session
  looted_cores = rand(20)
  if type == 'session'
    looted_cores.times do
      FactoryBot.create(:metasploit_credential_core,
                         origin:    origin,
                         realm:     realm,
                         private:   create_private(private_type),
                         public:    create_public,
                         workspace: workspace
      )
    end
  end

  # Login
  if type =~ /session|service/
    service = host.services.first
    # Add some randomness
    if service && (Time.now.to_i).even?
      FactoryBot.create(:metasploit_credential_login,
                         core: core,
                         service: service,
                         access_level: %w|admin|.sample
      )
    end
  end
  core.id
end

# Various conditions that will result in a failure for particular
# FISMA controls.
def generate_fisma_failures(workspace_id)
  workspace = Mdm::Workspace.find(workspace_id)
  host      = workspace.hosts.where('service_count > 0').last
  service   = host.services.last
  origin    = FactoryBot.create(:metasploit_credential_origin_service,
                                  service: service)


  # Make AC-7 fail
  public = create_public
  10.times {
    core = FactoryBot.create(:metasploit_credential_core,
                              workspace: workspace,
                              public: public,
                              private: create_private(:metasploit_credential_password),
                              origin: origin)
    FactoryBot.create(:metasploit_credential_login,
                       core: core,
                       service: service,
                       status: Metasploit::Model::Login::Status::INCORRECT
    )
  }

  # Make AT-2 fail
  vuln = FactoryBot.create(:mdm_vuln,
                            host: host,
                            exploited_at: Time.now,
                            service: service)
  FactoryBot.create(:mdm_vuln_attempt,
                     vuln: vuln,
                     exploited: true,
                     module: 'exploit/windows/smb/ms08_067_netapi')

  # Make IA-2 fail
  core = Metasploit::Credential::Login.where(status: 'Successful').try(:last).try(:core)
  root = Metasploit::Credential::Public.where(username: 'root').last
  # If there is no public then the test already fails
  if core.present? && core.public.present?
    # If there is one let's make it generic to also fail:
    if root
      core.public = root; core.save
    else
      core.public.update_attribute(:username, 'root')
    end
  end
end

# Simulate a public/private pair shared between hosts
def create_shared_credentials(workspace_id)
  workspace = Mdm::Workspace.find(workspace_id)
  host      = workspace.hosts.where('service_count > 0').sample
  service   = host.services.sample
  core      = Metasploit::Credential::Core.where('public_id is not null and private_id is not null').sample
  public    = core.public
  private   = core.private
  module_full_name = Metasploit::Credential::Origin::Service.last.module_full_name + "_#{Time.now.to_i}"
  origin    = Metasploit::Credential::Origin::Service.create(module_full_name: module_full_name)
  origin.service   = service
  origin.save!

  create_credential_core(
    origin: origin,
    public: public,
    private: private,
    workspace_id: workspace.id
  )
end

def create_sniffed_credentials(workspace_id, task_id)
  task = Mdm::Task.find(task_id)
  sniffed_count = rand(5)
  workspace = Mdm::Workspace.find(workspace_id)
  host = workspace.hosts.last
  service = Mdm::Service.create!(:host_id => host.id,
                                 :port => 80,
                                 :proto => 'tcp',
                                 :state => 'open',
                                 :name => 'http')

  sniffed_count.times do |c|
    public = create_public
    no_private = (rand(5) == 1)
    private    = no_private ? nil : create_private(:metasploit_credential_password)
    origin = Metasploit::Credential::Origin::Import.new(filename: "/tmp/fake/pnd_001-00#{c}.pcap")
    origin.task_id = task_id
    origin.save!
    core = Metasploit::Credential::Core.create!(origin_type: 'Metasploit::Credential::Origin::Import',
                                                origin_id: origin.id,
                                                public: public,
                                                private: private,
                                                workspace: workspace
    )
    core.tasks << task
    login = FactoryBot.create(:metasploit_credential_login,
                               core: core,
                               service: service
    )
    login.tasks << task
  end
end

def create_session(opts = {})
  workspace = Mdm::Workspace.find(opts[:workspace_id])
  host      = Mdm::Host.find(opts[:host_id])
  stype     = %w|shell meterpreter|.sample
  # Random selection of open and closed sessions:
  closed    = (Time.now - 5) if (Time.now.to_i.even?)
  exploit   = ['auxiliary/scanner/ssh/ssh_login_pubkey',
               'exploit/multi/samba/usermap_script',
               'exploit/windows/smb/psexec'
              ].sample

  # TODO Add desc, port
  session = FactoryBot.create(:mdm_session,
                               host: host,
                               stype: stype,
                               opened_at: Time.now - 10,
                               closed_at: closed,
                               last_seen: Time.now - 5,
                               via_exploit: exploit
  )
  session.id
end

def mm_config(mm_type)
  configs = {'Single Credentials Testing'     => '{"app":{"DS_WHITELIST_HOSTS":"[]","DS_BLACKLIST_HOSTS":"[]","DS_USERNAME":"supertestusa","DS_PASSWORD":"ermagerd\"sekret\"passwd","DS_DOMAIN":"mydomain","DS_SERVICES":"AFP,DB2,EXEC,FTP,HTTP,HTTPS,LOGIN,MSSQL,MySQL,Oracle,PCAnywhere_Data,POP3,Postgres,SHELL,SMB,SNMP,SSH,SSH_PUBKEY,Telnet,VMAuthd,VNC,WinRM","DS_APP_RUN_ID":null,"workspace":"default"},"report":{}}',
             'Segmentation and Firewall Testing' => '{"scan_task":{"nmap_start_port":"2","nmap_stop_port":"59","dst_host":"egadz-dev.metasploit.com"},"report_task":{"DS_WHITELIST_HOSTS":"","DS_BLACKLIST_HOSTS":"","workspace":"AppTesting","username":"shuckins","DS_MaskPasswords":false,"DS_IncludeTaskLog":true,"DS_JasperDisplaySession":false,"DS_JasperDisplayCharts":true,"DS_JasperDisplayPageCode":false,"DS_JasperShowFullLoot":false,"DS_JasperOrderVulnsBy":"","DS_LootExcludeScreenshots":true,"DS_LootExcludePasswords":true,"DS_JasperTemplate":"firewall_egress/main.jrxml","DS_REPORT_TYPE":"app_segment_fw-pdf","DS_REPORT_NAME":"testery","DS_CAMPAIGN_ID":"","DS_UseJasper":true,"DS_UseCustomReporting":true,"DS_JasperProductName":"Metasploit Pro","DS_JasperDbEnv":"development","DS_JasperLogo":"","DS_JasperDisplaySections":"1,2,3,4,5,6,7,8","DS_EnablePCIReport":true,"DS_EnableFISMAReport":true,"DS_JasperDisplayWeb":true,"DS_ADDITIONAL_PARAMS":null}}',
             'Pass the Hash'               => '{"DS_WHITELIST_HOSTS":"10.6.201.184","DS_BLACKLIST_HOSTS":"","DS_USERNAME":"msfadmin","DS_HASH":"aad3b435b51404eeaad3b435b51404ee:27c433245e4763d074d30a05aae0af2c","DS_DOMAIN":"WORKGROUP","workspace":"App-Hash-Verif","report_task":{"DS_WHITELIST_HOSTS":"","DS_BLACKLIST_HOSTS":"","workspace":"App-Hash-Verif","username":"shuckins","DS_MaskPasswords":false,"DS_IncludeTaskLog":true,"DS_JasperDisplaySession":false,"DS_JasperDisplayCharts":true,"DS_JasperDisplayPageCode":false,"DS_JasperShowFullLoot":false,"DS_JasperOrderVulnsBy":"","DS_LootExcludeScreenshots":true,"DS_LootExcludePasswords":false,"DS_JasperTemplate":"auth_apps/main.jrxml","DS_REPORT_TYPE":"APP_PW-PDF","DS_REPORT_NAME":"ForRealExisting","DS_CAMPAIGN_ID":"","DS_UseJasper":true,"DS_UseCustomReporting":true,"DS_JasperProductName":"Metasploit Pro","DS_JasperDbEnv":"development","DS_JasperLogo":"","DS_JasperDisplaySections":"1,2,3,4,5,6","DS_EnablePCIReport":true,"DS_EnableFISMAReport":true,"DS_JasperDisplayWeb":true,"DS_ADDITIONAL_PARAMS":{"workspace_name":null,"workspace_created":"2013-06-18 22:26:05 UTC","workspace_updated":"","user":"shuckins"}}}',
             'Passive Network Discovery'   => '{"DS_BPF" => "", "DS_INTERFACE" => "en2", "DS_MAX_FILE_SIZE" => 67108864, "DS_MAX_TOTAL_SIZE" => 268435456, "DS_SNAPLENGTH" => 65535, "DS_TIMEOUT" => 600}',
             'Known Credentials Intrusion' => '{"DS_WHITELIST_HOSTS":"10.6.201.184 10.6.201.148","DS_BLACKLIST_HOSTS":"","DS_LIMIT_SESSIONS":true,"DS_PAYLOAD_METHOD":"Bind","DS_PAYLOAD_TYPE":"Command shell","DS_PAYLOAD_PORTS":"1024-65535","DS_PAYLOAD_LHOST":null,"workspace":"AuthApps","report_task":{"DS_WHITELIST_HOSTS":"","DS_BLACKLIST_HOSTS":"10.6.201.184","workspace":"AuthApps","username":"shuckins","DS_MaskPasswords":false,"DS_IncludeTaskLog":true,"DS_JasperDisplaySession":false,"DS_JasperDisplayCharts":true,"DS_JasperDisplayPageCode":false,"DS_JasperShowFullLoot":false,"DS_JasperOrderVulnsBy":"","DS_LootExcludeScreenshots":true,"DS_LootExcludePasswords":false,"DS_JasperTemplate":"auth_apps/main.jrxml","DS_REPORT_TYPE":"APP_AUTH-PDF","DS_REPORT_NAME":"BothTarg_BlackWin","DS_CAMPAIGN_ID":"","DS_UseJasper":true,"DS_UseCustomReporting":true,"DS_JasperProductName":"Metasploit Pro","DS_JasperDbEnv":"development","DS_JasperLogo":"","DS_JasperDisplaySections":"1,2,3,4,5,6","DS_EnablePCIReport":true,"DS_EnableFISMAReport":true,"DS_JasperDisplayWeb":true,"DS_ADDITIONAL_PARAMS":{"workspace_name":null,"workspace_created":"2013-06-21 15:08:12 UTC","workspace_updated":"","user":"shuckins"}}}',
             'SSH Key Testing'             => '{"DS_WHITELIST_HOSTS":"10.6.201.148","DS_BLACKLIST_HOSTS":"","DS_USERNAME":"root","DS_KEY_FILE":"/Users/shuckins/rapid7/pro/loot/20130621095516_AuthApps_10.6.201.148_host.unix.ssh.ro_569166.key","workspace":"AuthApps","report_task":{"DS_WHITELIST_HOSTS":"","DS_BLACKLIST_HOSTS":"","workspace":"AuthApps","username":"shuckins","DS_MaskPasswords":false,"DS_IncludeTaskLog":true,"DS_JasperDisplaySession":false,"DS_JasperDisplayCharts":true,"DS_JasperDisplayPageCode":false,"DS_JasperShowFullLoot":false,"DS_JasperOrderVulnsBy":"","DS_LootExcludeScreenshots":true,"DS_LootExcludePasswords":false,"DS_JasperTemplate":"auth_apps/main.jrxml","DS_REPORT_TYPE":"APP_AUTH-PDF","DS_REPORT_NAME":"WithUpdate","DS_CAMPAIGN_ID":"","DS_UseJasper":true,"DS_UseCustomReporting":true,"DS_JasperProductName":"Metasploit Pro","DS_JasperDbEnv":"development","DS_JasperLogo":"","DS_JasperDisplaySections":"1,2,3,4,5,6","DS_EnablePCIReport":true,"DS_EnableFISMAReport":true,"DS_JasperDisplayWeb":true,"DS_ADDITIONAL_PARAMS":{"workspace_name":null,"workspace_created":"2013-06-21 17:01:02 UTC","workspace_updated":"","user":"shuckins"}}}'
  }
  return configs[mm_type] || 'TODO'
end

def create_mm_run(mm_type, workspace_id)
  mm_run = Apps::AppRun.create(:app_id       => Apps::App.find_by_name(mm_type).id,
                               :started_at   => Time.now + (60*1),
                               :stopped_at   => Time.now + (60*3),
                               :config       => mm_config(mm_type),
                               :workspace_id => workspace_id,
                               :state        => 'completed'
                              )
  mm_run.save!
  mm_run.id
end

def create_egadz_result_range(task_id, start_port, end_port, state)
  res = Apps::FirewallEgress::ResultRange.create!(
    :task_id => task_id,
    :start_port => start_port,
    :end_port => end_port,
    :state => state,
    :target_host => 'fake-host.egress'
  )
end

def create_fw_egress_records(mm_run_id)
  task_id = Mdm::Task.find_by_app_run_id(mm_run_id).id
  results = [
    {:start_port => 1, :end_port => 21, :state => 'filtered'},
    {:start_port => 22, :end_port => 35, :state => 'open'},
    {:start_port => 36, :end_port => 1811, :state => 'filtered'},
    {:start_port => 1812, :end_port => 1813, :state => 'open'},
    {:start_port => 1814, :end_port => 1899, :state => 'filtered'},
    {:start_port => 1900, :end_port => 1900, :state => 'open'},
    {:start_port => 1901, :end_port => 50000, :state => 'filtered'},
    {:start_port => 50001, :end_port => 50005, :state => 'open'},
    {:start_port => 50006, :end_port => 62110, :state => 'filtered'},
    {:start_port => 62111, :end_port => 62120, :state => 'open'},
    {:start_port => 62121, :end_port => 65535, :state => 'filtered'}
  ]
  results.each do |res|
    create_egadz_result_range(task_id, res[:start_port], res[:end_port], res[:state])
  end
  puts "FW egress result ranges created"
end

def get_opts
  options = {}
  optparse = OptionParser.new do |opt|
    opt.on("--host-count=COUNT", "How many hosts to create") do |host_count|
      options[:host_count] = host_count
    end
    opt.on("--service-count=COUNT", "How many services to add on each host") do |service_count|
      options[:service_count] = service_count
    end
    opt.on("--loot-count=COUNT", "How many loot files to add to each host") do |loot_count|
      options[:loot_count] = loot_count
    end
    opt.on("--vuln-count=COUNT", "How many vulnerabilities to add to each host") do |vuln_count|
      options[:vuln_count] = vuln_count
    end
    opt.on("--workspace-id=ID", "ID of workspace to use (default new is created)") do |workspace_id|
      options[:workspace_id] = workspace_id
    end
    opt.on("--web-data", "Add web application data") do |web_data|
      options[:web_data] = web_data
    end
    opt.on("--metamodule-type=['Passive Network Discovery',
                               'Single Credentials Testing',
                               'SSH Key Testing',
                               'Pass the Hash',
                               'Known Credentials Intrusion',
                               'Segmentation and Firewall Testing']", "Type of MetaModule to generate data for") do |mm_type|
      options[:metamodule_type] = mm_type
    end

  end
  optparse.parse!
  options
end

def verify_assumptions
  unless Mdm::User.first
    puts "You need to create a user!"
    abort
  end
end

def generate_dataset
  opts = get_opts
  start_time = Time.now
  host_count = opts[:host_count] ? opts[:host_count].to_i : 1
  mm_type    = opts[:metamodule_type]
  verify_assumptions

  unless opts[:workspace_id]
    ws = Mdm::Workspace.where(name: "LoadTesting").first_or_create(owner_id: Mdm::User.first.id)
    workspace_id = ws.id
  else
    workspace_id = opts[:workspace_id].to_i
  end
  workspace_name = Mdm::Workspace.find(workspace_id).name

  # For activity report and credentials:
  task_id = create_task(workspace_id)
  # Imported credential
  create_cred(type: 'imported', task_id: task_id, workspace_id: workspace_id)
  # Manually-added credential
  create_cred(type: 'manual', workspace_id: workspace_id)

  puts "Creating #{host_count} hosts in workspace #{workspace_name}...\n"

  if mm_type
    mm_run_id = create_mm_run(mm_type, workspace_id)
    task = Mdm::Task.create(:workspace_id => workspace_id,
                            :app_run_id => mm_run_id,
                            :path => '/tmp/totallyfakehere',
                            :progress => 100
    )
    task.save!
    task_id = task.id
    if mm_type == 'Segmentation and Firewall Testing'
      create_fw_egress_records(mm_run_id)
    end
  end

  host_count.times do |h|
    service_count = opts[:service_count] ? opts[:service_count].to_i : rand(20)
    loot_count = opts[:loot_count] ? opts[:loot_count].to_i : rand(5)
    vuln_count = opts[:vuln_count] ? opts[:vuln_count].to_i : rand(10)

    host_id = create_host(workspace_id)

    if mm_type
      Mdm::TaskHost.create!(:task_id => task_id, :host_id => host_id)
    end

    if opts[:web_data]
      service_id = create_web_service(host_id)
      generate_web_data(workspace_id, service_id)
    end

    service_count.times do |s|
      service_id = create_service(host_id)
      if mm_type
        Mdm::TaskService.create!(:task_id => task_id, :service_id => service_id)
      end
    end
    if mm_type
      rs_ss = RunStat.where(name: 'Services Selected', task_id: task_id).first_or_create(data: 0)
      rs_ss.data += service_count; rs_ss.save
    end
    core_id = create_cred(type: 'service', host_id: host_id, workspace_id: workspace_id)

    create_loot(loot_count, host_id, workspace_id)
    create_vulns(vuln_count, host_id, workspace_id)
    session_id = create_session(host_id: host_id, workspace_id: workspace_id)
    session_core_id = create_cred(type: 'session', host_id: host_id, workspace_id: workspace_id)
    # TODO Create data for Auth MMs
    # Mdm::TaskSession.create(:task_id => task_id, :session_id => session_id)
    # rs_s = RunStat.where(name: 'Sessions Opened', task_id: task_id).first_or_create(data: 0)
    # TODO
    # rs_a = RunStat.where(name: 'Successful Auths', task_id: task_id).first_or_create(data: 0)
    # rs_a.data += 1; rs_a.save
  end

  if mm_type == 'Passive Network Discovery'
    create_sniffed_credentials(workspace_id, task_id)
    RunStat.where(name: 'Packets Captured', task_id: task_id).first_or_create(data: rand(50000))
    RunStat.where(name: 'Bytes Captured', task_id: task_id).first_or_create(data: rand(500000))
    RunStat.where(name: 'Files Created', task_id: task_id).first_or_create(data: 3)
  else
    create_shared_credentials(workspace_id)
  end

  if mm_type
    RunStat.where(name: 'Hosts Selected', task_id: task_id).first_or_create(data: host_count)
  end
  create_shared_credentials(workspace_id)
  generate_fisma_failures(workspace_id)

  duration = (Time.now - start_time).round(4)
  web_status = opts[:web_data] ? 'websites, webpages with forms and vulns, ' : nil
  other_data = "services, loot, credentials, #{web_status}and vulns"

  puts "#{host_count} hosts, as well as #{other_data} created in #{duration}s."
  puts "View workspace #{workspace_name} (ID: #{workspace_id})!"
end

generate_dataset
