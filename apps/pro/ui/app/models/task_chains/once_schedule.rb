module TaskChains
  class OnceSchedule
    include ActiveModel::Validations

    attr_accessor :start_date, :start_time, :schedule

    validates_presence_of :start_date, :start_time


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