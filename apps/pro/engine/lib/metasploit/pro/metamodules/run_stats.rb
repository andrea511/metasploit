###
#
# A small module for instantiating and replacing RunStats in a given module.
#
###

module Metasploit::Pro::Metamodules::RunStats

  attr_reader :run_stats

  # Call this method to ensure that all the RunStats are persisted in the database
  # and are accessible from the private @run_stats ivar
  # @param [Array<String, Symbol>] names of run stats
  def initialize_run_stats(names)
    @run_stats = names.each_with_object({}) do |stat, obj|
      obj[stat] = {
        model: RunStat.where(name: stat, task_id: mdm_task.id).first_or_create!,
        mutex: Mutex.new
      }
      if obj[stat][:model].data.nil?
        obj[stat][:model].data = 0
      end
    end
  end

  # This method updates a specific RunStat to a given value
  # @param name [Symbol] the name of the RunStat to update
  # @param value [Integer] the value to save the RunStat as
  def update_stat(name, value)
    stat = run_stats.fetch(name)
    stat[:mutex].synchronize do
      stat[:model].data = value
      stat[:model].save!
    end
  end

  # This method increments a specific RunStat
  # @param name [Symbol] the name of the RunStat to update
  # @param value [Integer] the value to save the RunStat as
  def increment_stat(name, incrementor=1)
    stat = run_stats.fetch(name)
    stat[:mutex].synchronize do
      stat[:model].data += incrementor
      stat[:model].save!
    end
  end

end
