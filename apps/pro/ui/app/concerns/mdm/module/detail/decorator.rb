module Mdm::Module::Detail::Decorator
  # true if the MSF module is designated to be "active" stance
  # @return[Boolean]
  def aggressive?
    stance == "aggressive" # This should probably be a constant
  end

  # true if the MSF module is designated to be "passive" stance
  # @return[Boolean]
  def passive?
    stance == "passive" # This should probably be a constant
  end
end