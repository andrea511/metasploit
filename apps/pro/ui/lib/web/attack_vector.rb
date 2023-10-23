# Attack vectors are any parts of the {Web::Request} which can be manipulated to form an attack, such as changing the
# {Web::Parameter#value value} of a {Web::Parameter} to cause a XSS attack.  When the {Web::Parameter#value} is
# manipulated, then the {Web::Parameter#attack_vector} should be set to `true`.
module Web::AttackVector
  extend ActiveSupport::Concern

  included do
    #
    # Validations
    #
    validates :attack_vector,
              :inclusion => {
                  :in => [
                      false,
                      true
                  ]
              }
  end
end