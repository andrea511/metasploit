class AddLastFailReasonToVulnAttempt < ActiveRecord::Migration[4.2]
  def change
    add_column :vuln_attempts, :last_fail_reason, :string
  end
end
