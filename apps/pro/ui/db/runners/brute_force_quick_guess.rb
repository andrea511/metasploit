
# After BruteForce Guess runs, there is a few originating credentials
# and lots of logins.

SPEED = ENV['SPEED'] || 0

puts "Running at SPEED #{SPEED}"

def _sleep(n)
  sleep n*SPEED
end

workspace = Mdm::Workspace.where(name: "BruteForceGuessTesting").first_or_create(owner_id: Mdm::User.first.id)
workspace.hosts.destroy_all
Metasploit::Credential::Core.where(workspace_id: workspace.id).destroy_all

task = Mdm::Task.create(
  workspace_id: workspace.id,
  path:         '/tmp/dat_brute_force_guess_test',
  progress:     100,
  completed_at: nil,
  info:         'Credential Guess',
  description:  'Credential Guess'
)
task.update(presenter: :brute_force_guess_quick)

puts "Running task #{task.id} in workspace #{workspace.id}"
puts "http://localhost:3000/workspaces/#{workspace.id}/tasks/#{task.id}"

hosts = FactoryBot.create_list(:mdm_host, 10, workspace: workspace)
services = hosts.map { |host| FactoryBot.create_list(:mdm_service, 5, host: host) }.flatten
origin = FactoryBot.create(:metasploit_credential_origin_service, service: services.sample)
guess_cores = 10.times.map {
  guess = BruteForce::Guess::Core.create
  guess.workspace = workspace
  guess.public = Metasploit::Credential::Username.create(username: Faker::Internet.user_name)
  guess.private = Metasploit::Credential::Password.create(data: Faker::Internet.password)
  guess.realm = Metasploit::Credential::Realm.create(
    value: Faker::Internet.domain_word,
    key: (Metasploit::Model::Realm::Key::ALL).sample
  )
  guess.save!
  guess
}

# hurr we go
brute_force_run = BruteForce::Run.create!(config: {blah: 'blah'})
brute_force_run.task = task
brute_force_run.save!
puts "BruteForce Run ID #{brute_force_run.id}"

run_stats = {
  "Logins Attempted" => 0,
  "Maximum Login Attempts" => 0,
  "Successful Login Attempts" => 0 ,
  "Maximum Targets Compromised" => 0,
  "Targets Compromised" => 0
}.map do |key, val|
  [key, RunStat.create(name: key, task: task, data: val)]
end
run_stats = Hash[run_stats]

compromised_targets = []


attempts = guess_cores.map do |guess_core|
  services.map do |service|
    attempt = BruteForce::Guess::Attempt.new
    attempt.brute_force_run = brute_force_run
    attempt.brute_force_guess_core = guess_core
    attempt.service = service
    attempt.attempted_at = nil
    attempt.save!
    attempt
  end
end.flatten

idx = 0


run_stats["Maximum Login Attempts"].data = attempts.length
run_stats["Maximum Login Attempts"].save


guess_cores.each do |guess_core|

  _sleep 4

  core =  Metasploit::Credential::Core.create(
    origin_type: 'Metasploit::Credential::Origin::Service',
    origin: origin,
    workspace: guess_core.workspace
  )

  core.public_id = guess_core.public.id
  core.private_id = guess_core.private.id
  core.realm_id =  guess_core.realm.id
  core.save!


  run_stats["Maximum Targets Compromised"].data = services.length
  run_stats["Maximum Targets Compromised"].save

  services.each do |service|

    attempt = attempts[idx]
    attempt.attempted_at = Time.now
    attempt.status = BruteForce::AttemptStatus::UNTRIED
    attempt.save!

    idx += 1



    _sleep 2

    if rand(3).zero?
      login = Metasploit::Credential::Login.new(
        access_level: %w(admin readonly).sample,
        status: (Metasploit::Model::Login::Status::ALL - [Metasploit::Model::Login::Status::UNTRIED]).sample
      )

      _sleep 2


      login.core = core
      login.service = service
      login.last_attempted_at = Time.now
      login.tasks << task
      login.save!

      #TODO: Refactor this mapping out of the module.
      case login.status
        when Metasploit::Model::Login::Status::SUCCESSFUL
          attempt.status = BruteForce::AttemptStatus::SUCCESSFUL
        when Metasploit::Model::Login::Status::UNABLE_TO_CONNECT
          attempt.status = BruteForce::AttemptStatus::FAILED
        when Metasploit::Model::Login::Status::INCORRECT
          attempt.status = BruteForce::AttemptStatus::FAILED
        else
          attempt.status = BruteForce::AttemptStatus::FAILED
      end

      attempt.save!

      unless compromised_targets.include?(service.host.id)
        compromised_targets << service.host.id
        run_stats["Targets Compromised"].data += 1
        run_stats["Targets Compromised"].save
      end

      run_stats["Successful Login Attempts"].data += 1
      run_stats["Successful Login Attempts"].save
    end

    run_stats["Logins Attempted"].data += 1
    run_stats["Logins Attempted"].save
  end
end

task.update(completed_at: Time.now)
