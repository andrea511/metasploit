module BruteForce::Guess
  # The prefix on table name for models in this namespace
  #
  # @return [String] `'brute_force_reuse_'`
  def self.table_name_prefix
    'brute_force_guess_'
  end
end
