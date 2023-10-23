# Namespace for brute force models that reuse pre-existing `Metasploit::Credential::Core` against a different
# `Mdm::Service`
module BruteForce::Reuse
  # The prefix on table name for models in this namespace
  #
  # @return [String] `'brute_force_reuse_'`
  def self.table_name_prefix
    'brute_force_reuse_'
  end
end
