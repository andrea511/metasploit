module TaskChains
  class HourlySchedule
    include ActiveModel::Validations

    attr_accessor :minute, :schedule

    validates_presence_of :minute
    validates_inclusion_of :minute, in: (1..59).to_a.map!{|num| num.to_s}, message: "must be a value between 1 and 59"

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