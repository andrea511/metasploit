class MigrateReuseAttemptStatuses < ActiveRecord::Migration[4.2]
  def change
    change_table :brute_force_reuse_attempts do |t|
      BruteForce::Reuse::Attempt.all.each do |attempt|
        if attempt.skipped?
          attempt.status = "Skipped"
          # If we have logins, check to see if any match and were successful
        elsif attempt.metasploit_credential_core.logins_count > 0
          relevant_login = false
          # Only look at Logins that are for the same service as this attempt
          attempt.metasploit_credential_core.logins.where(service_id: attempt.service_id).each do |login|
            # Did this come from the same task and was it successful?
            if login.status == "Successful" and login.task_ids.include? attempt.brute_force_run.task_id
            # This is a matching login
            relevant_login = true
            end
          end
          if relevant_login
            attempt.status = "Successful"
          else
            attempt.status = "Failed"
          end
        else
          attempt.status = "Failed"
        end
        attempt.save!
      end
    end
  end
end
