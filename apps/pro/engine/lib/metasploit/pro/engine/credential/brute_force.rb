module Metasploit
  module Pro
    module Engine
      module Credential

        # Provides mixin methods for common code between various flavours
        # of BruteForce
        module BruteForce

          # This method is responsible for building the login scanners for the run
          # and placing them in the {Queue} for worker threads to use.
          #
          # @param :attempts_by_service [ActiveRecord::Relation] the attempts for this run, grouped by service_id
          # @return [void] This is not the return value you are looking for.
          def build_scan_queue(attempts_by_service, config, max_threads)

            attempts_by_service.each do |service_id, attempts|
              target_service = Mdm::Service.find(service_id)
              next if target_service.port == 139

              attempt_queue  = ::Pro::BruteForce::AttemptQueue.new(attempts: attempts)
              login_scanners = Metasploit::Framework::LoginScanner.classes_for_service(target_service)

              login_scanners.each do |scanner_class|

                # Check if this is Tomcat. If so use that specific scanner instead of trying all
                # of the HTTP compatible scanners.
                if target_service.name =~ /http/ && target_service.info =~ /Coyote/
                  next unless scanner_class == Metasploit::Framework::LoginScanner::Tomcat
                end

                scanner = scanner_class.new(
                  bruteforce_speed: 5,
                  cred_details: attempt_queue,
                  host: target_service.host.address,
                  port: target_service.port,
                  stop_on_success: config['stop_on_success']
                )

                case target_service.name
                  when /https/
                    scanner.ssl = true
                  when /http(?!s)/
                    scanner.ssl = false
                end

                @scan_queue << [scanner, target_service]
              end
            end

            max_threads.times do
              @scan_queue << 'KillSignal'
            end
          end

          # This method takes a configured msf module and checks whether we already have a session open on
          # that host from the same module with the same user.
          #
          # @param [Msf::Module] the configured metasploit module to check against
          # @return [TrueClass] if a matching session already exists
          # @return [FalseClass] if a matching session does not already exist
          def existing_sessions?(mod)
            session_exists = false
            address = mod.datastore['RHOST'] || mod.datastore['RHOSTS']
            fullname = mod.fullname
            host = myworkspace.hosts.where(address: address).first
            if host
              sessions = host.sessions.where(closed_at: nil, via_exploit: fullname)
              sessions.each do |session|
                if mod.datastore['SMBUser'] && mod.datastore['SMBUser'] == session.datastore['SMBUser']
                  session_exists = true
                elsif mod.datastore['USERNAME'] && mod.datastore['USERNAME'] == session.datastore['USERNAME']
                  session_exists = true
                elsif mod.datastore['CRED_CORE_ID'] && mod.datastore['CRED_CORE_ID'].to_s == session.datastore['CRED_CORE_ID']
                  session_exists = true
                end
              end
            end
            session_exists
          end

        end
      end
    end
  end
end