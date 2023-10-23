module TaskChains
  class WeeklySchedule
    include ActiveModel::Validations

    attr_accessor :start_date, :start_time, :interval, :schedule, :days

    validates_presence_of :start_date, :start_time, :interval
    validates_presence_of :days, message: "must select at least one day of the week"
    validates_inclusion_of :interval, in: (1..52).to_a.map!{|num| num.to_s}, message: "must be a value between 1 and 52"

    # TODO In Rails 4 include ActiveModel::Model handles this
    # Includes ActiveModel's nice initialize() method for auto assignment.
    def initialize(params={})
      params.each do |attr, value|
        method = "#{attr}="
        if self.respond_to?(method)
          self.public_send(method, value)
        end
      end if params
    end

  end
end