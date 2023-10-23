# For each wizard we subclass BaseProcedure and
#   insert the wizard's logic into before_ and
#   after_transition blocks in the Procedure's state_machine
# A basic BaseProcedure starts in the :ready state, and
#   ends in either :finished or :error.
class Wizards::BaseProcedure < ApplicationRecord
  self.table_name = 'wizard_procedures'

  #
  # Associations
  #
  belongs_to :user, :class_name => 'Mdm::User'
  belongs_to :workspace, :class_name => 'Mdm::Workspace'

  #
  # Attributes
  #
  attr_accessor :commander # holds the prosvc module that can run submodules

  #
  # Serializations
  #
  serialize :config_hash

  ###
  # State Machine
  # BaseProcedure logic is implemented here. The :next
  #   event needs to be overriden so that transitions are defined
  #   on each state:
  #
  #   event :next do
  #     transition :ready => :scanning, :if => ...
  #     transition :ready => :importing, :if => ...
  #     ...
  #   end
  #
  # Then we add the logic (kicking off tasks, etc) as before_transition
  #   or after_transition hooks:
  #
  #   after_transition any => :exploiting do
  #     ... run exploit submodule! ...
  #   end
  #
  # state_machine :state, initial: :ready, use_transactions: false do
  #   event :next # override in subclass and pass it a transition map block

  #   # if we notice an error, we call error_occurred! and jump to state :error
  #   event :error_occurred do |error_str|
  #     transition any => :error
  #   end
  # end


  # Steps through the BaseProcedure's entire state
  #   machine, taking transitions based on user-defined options,
  #   which causes subtasks to execute in a specific sequence.
  #
  # @param comm [Class<Msf::Module>] commander module
  def execute_with_commander(comm)
    self.commander = comm
    next! while can_next?
  end

  # We need to override #save to ensure that the workspace gets
  #   saved before any of the task configs, so that the task configs
  #   can have valid WORKSPACE_IDs and whatnot.
  # @return [Boolean] success of save operation
  def save
    workspace.save if workspace.new_record?
    # Add the workspace ID to the report now that it's saved,
    # save the report, persist the report ID in the config:
    if config_hash[:report].present?
      report = config_hash[:report]
      # Don't try to save an ActiveRecord::Base object.
      config_hash.delete :report
      config_hash[:report_id] = report.id
    end

    super
  end

  # Determines when the BaseProcedure has
  #   no more states to transition to.
  #
  # @return [Boolean] the BaseProcedure has reached
  #   the :finished or :error states
  def done?
    finished? || error?
  end

  # Change running config to target open sessions in the workspace
  # @param [Hash] config the config object which will be passed to the tasks
  def filter_sessions_in_config(config)
    return unless config.present?
    workspace.sessions.alive.each do |session|
      config['DS_SESSIONS'] << "#{session.local_id.to_s} "
    end
  end
end
