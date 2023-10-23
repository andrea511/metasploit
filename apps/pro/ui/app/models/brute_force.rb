# Namespace for all brute-force use of `Metasploit::Credential::Core`, or its components (
# `Metasploit::Credential::Private`, `Metasploit::Credential::Public`, and `Metasploit::Credential::Realm`).
#
# {BruteForce::Reuse} covers the reuse of pre-existing `Metasploit::Credential::Core` to login to different
# `Mdm::Service`.
module BruteForce
  # The prefix on table name for models in this namespace
  #
  # @return [String] `'brute_force_'`
  def self.table_name_prefix
    'brute_force_'
  end
end
