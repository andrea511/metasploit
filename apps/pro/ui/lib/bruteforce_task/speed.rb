module BruteforceTask::Speed
  extend ActiveSupport::Concern

  include ActiveModel::Validations

  #
  # CONSTANTS
  #

  DEFAULT_SPEED = 5
  # Bruteforce speed labels (in order from slowest to fastest)
  SPEED_LABELS = [ 'Glacial', 'Slow', 'Stealthy', 'Normal', 'Fast', 'Turbo' ]
  # Corresponding speeds for {SPEED_LABELS}
  SPEEDS = (0 ... SPEED_LABELS.size).to_a

  included do
    #
    # Validations
    #

    validates :speed, :inclusion => { :in => SPEEDS }
  end

  #
  # Instance Methods
  #

  def speed
    @speed ||= DEFAULT_SPEED
  end

  def speed=(speed)
    @speed = speed || DEFAULT_SPEED
  end
end