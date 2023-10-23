class Web::Attack::CrossSiteScripting < ApplicationRecord  
  #
  # Attributes
  #

  # @!attribute [rw] encloser_type
  #   @return [String] the class name of the encloser

  # @!attribute [rw] escaper_type
  #   @return [String] the class name of the escaper

  # @!attribute [rw] evader_type
  #   @return [String] the class name of the evader

  # @!attribute [rw] executor_type
  #   @return [String] the class name of the executor
  
  #
  #
  # Associations
  #
  #
  
  # @!attribute [rw] requests
  #   @return [Array<Mdm::WebVuln>] the vulns identified by this request or that are being verified by this request.
  has_many :requests, :class_name => 'Web::Request'
  
  #
  # Validations
  #
  
  validates :encloser_type,
            :inclusion => {
                :in => Web::RequestEngine.part_class_names(:encloser)
            }
  validates :escaper_type,
            :inclusion => {
                :in => Web::RequestEngine.part_class_names(:escaper)
            }
  validates :evader_type,
            :inclusion => {
                :in => Web::RequestEngine.part_class_names(:evader)
            }
  validates :executor_type,
            :inclusion => {
                :in => Web::RequestEngine.part_class_names(:executor)
            }
  
end
