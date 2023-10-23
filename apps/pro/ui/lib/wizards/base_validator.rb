# Wizards::BaseValidator accepts an instance of a Wizards::BaseForm subclass
# and determines whether any of the pre-built TaskConfigs have errors. 
class Wizards::BaseValidator
  # @attr [Wizards::BaseForm] form instance to judge
  attr_accessor :form

  # @param [Wizards::BaseForm] form instance to judge
  def initialize(form)
    @form = form
  end

  # some metaprogramming niceness to make it easier to validate for a given step
  def step_is_valid?(step)
    self.send("#{step.to_s}_valid?")
  end

  # pass in an array of steps and it will check them all.
  # useful for running all validations at the end.
  # also populates #errors_hash
  # 
  # @param [Array<String>] steps the steps to judge
  # @return [Boolean] all provided steps are valid
  def steps_are_valid?(steps)
    steps.inject(true) { |snowball, step| snowball &= step_is_valid?(step) }
  end

  # should be overriden to return a Hash of steps (keys) and errors (values)
  def errors_hash
    raise ::NotImplementedError, "Override errors_hash in a subclass of BaseValidator."
  end
end
