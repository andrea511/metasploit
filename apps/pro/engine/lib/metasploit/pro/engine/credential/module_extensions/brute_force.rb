# This module is intended to be used as an argument to Msf::Module#register_extensions
# in order to override automatically called methods on MSF modules.
module Metasploit::Pro::Engine::Credential::ModuleExtensions::BruteForce

  # Overrides a method called upon session establishment in exploit modules
  def on_new_session(session)
    attempt = BruteForce::Guess::Attempt.find(datastore['ATTEMPT_ID'])
    attempt.session_id = session.db_record.id
    attempt.save!
    super(session)
  end

  # Overrides a method called upon session establishment in auxiliary modules
  def start_session(obj, info, ds_merge, crlf = false, sock = nil, sess = nil)
    session = super(obj, info, ds_merge, crlf, sock, sess)
    attempt = BruteForce::Guess::Attempt.find(datastore['ATTEMPT_ID'])
    attempt.session_id = session.db_record.id
    attempt.save!
    session
  end
end
