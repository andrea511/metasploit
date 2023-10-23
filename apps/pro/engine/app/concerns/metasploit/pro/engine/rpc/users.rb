module Metasploit::Pro::Engine::Rpc::Users

  def rpc_users
    ::ApplicationRecord.connection_pool.with_connection {
      res = {}
      ::Mdm::User.all.each do |user|
        res[user.username] = {
          'username' => user.username,
          'admin'    => user.admin,
          'fullname' => user.fullname.to_s,
          'email'    => user.email.to_s,
          'phone'    => user.phone.to_s,
          'company'  => user.company.to_s
        }
      end
      { 'users' => res }
    }
  end

end
