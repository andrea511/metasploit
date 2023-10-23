module Mdm::Task::States
  extend ActiveSupport::Concern

  # Ran from start to finish normally
  COMPLETED   = :completed
  # Had runtime errors
  FAILED      = :failed
  # Was in RUNNING state when prosvc died/was rebooted
  INTERRUPTED = :interrupted
  # Paused manually by MSPro user (can be resumed)
  PAUSED      = :paused
  # Performing work normally
  RUNNING     = :running
  # Stopped manually by MSPro (cannot be resumed)
  STOPPED     = :stopped
  # Initialized but not yet started
  UNSTARTED   = :unstarted


  included do
    state_machine :state, :initial => :unstarted do
      # Available states:
      state COMPLETED
      state FAILED
      state INTERRUPTED
      state PAUSED
      state RUNNING
      state STOPPED
      state UNSTARTED

      event :start! do
        transition :unstarted => :running
      end

      event :complete! do
        transition :running => :completed
      end

      # Set completed_at timestamp for any change away from running
      after_transition :running => [:completed, :failed, :interrupted, :stopped] do |task|
        task.update_attribute(:completed_at, Time.now.utc)
      end

      event :stop! do
        transition [:running, :paused] => :stopped
      end

      event :interrupt! do
        transition :running => :interrupted
      end

      event :fail! do
        transition :running => :failed
      end

      event :pause! do
        transition :running => :paused
      end

      event :resume! do
        transition :paused => :running
      end

      # Unset the completed_at timestamp when resuming
      after_transition :paused => :running do |task|
        task.update_attribute(:completed_at, nil)
      end
    end


    #
    # Scopes
    #

    scope :running, -> { where(state: RUNNING) }
  end
end
