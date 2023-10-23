module Nexpose::Result::StateMachine
  extend ActiveSupport::Concern

  included do
    
    state_machine :state, initial: :unpushed do

      after_transition on: :reject do |obj, transition|
        obj.sent_to_nexpose = false
      end

      after_transition on: :attempt_later do |obj, transition|
        obj.sent_to_nexpose = false
      end

      after_transition on: :push do |obj, transition|
        obj.sent_to_nexpose = true
      end

      event :attempt_push do
        transition [:unpushed,:rejected,:pending] => :pushing
      end

      event :push do
        transition pushing: :pushed, if: lambda {|obj| obj.nexpose_response_set?}
      end

      event :reject do
        transition pushing: :rejected, if: lambda {|obj| obj.nexpose_response_set?}
      end

      event :attempt_later do
        transition pushing: :pending, if: lambda {|obj| obj.nexpose_response_set?}
      end

    end

    def initialize(attributes = nil, options = {})
      super(attributes, options)
    end


    def nexpose_response_set?
      !nexpose_response.nil?
    end

  end

end