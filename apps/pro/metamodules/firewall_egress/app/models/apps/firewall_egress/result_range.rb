class Apps::FirewallEgress::ResultRange < ApplicationRecord
  self.table_name = :egadz_result_ranges

  # @!attribute [rw] state
  #   State of the ports in the range (see VALID_PORT_STATES)
  #   @return [String]

  # @!attribute [rw] start_port
  #   @return [Integer]

  # @!attribute [rw] end_port
  #   @return [Integer]

  # @!attribute [rw] task
  #   State of the ports in the range
  #   @return [Boolean]
  belongs_to :task, :class_name => 'Mdm::Task', optional: true
  VALID_PORT_STATES = ["open", "closed", "filtered"]


  validates :target_host, :presence => true
  validates :state, :inclusion => {:in => VALID_PORT_STATES}
  validates :start_port, :numericality => {:only_integer => true,
                                           :greater_than_or_equal_to => 0,
                                           :less_than_or_equal_to => 65535}
  validates :end_port, :numericality => {:only_integer => true,
                                         :greater_than_or_equal_to => 0,
                                         :less_than_or_equal_to => 65535}
end
