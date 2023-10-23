class UpdatePthDesc < ActiveRecord::Migration[4.2]
  def change
    app = Apps::App.where(:name => 'Pass the Hash').first
    app.description = 'Attempts to log in to hosts with a recovered Windows SMB hash or Postgres MD5 hash and reports the hosts that were successfully authenticated. You must provide a user name, the hash, and the range of hosts you want to test.'
    app.save!
  end
end
