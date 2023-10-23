class Sonar::Data::Fdns < ApplicationRecord
  include Metasploit::Model::Search
  
  # @!attribute import_run
  #   The logical container representing the discreet import this {Fdns} is part of
  #
  #   @return [Sonar::Data::ImportRun]
  belongs_to :import_run,
             class_name: "Sonar::Data::ImportRun"


  # Fields searched for the search scope
  SEARCH_FIELDS = [
    'address::text',
    'hostname'
  ]

  # Scopes
  scope :search,
        lambda { |*args|
          # @todo replace with AREL
          terms = SEARCH_FIELDS.collect { |field|
            "#{self.table_name}.#{field} ILIKE ?"
          }
          disjunction = terms.join(' OR ')
          formatted_parameter = "%#{args[0]}%"
          parameters = [formatted_parameter] * SEARCH_FIELDS.length
          conditions = [disjunction] + parameters

          {
            :conditions => conditions
          }
        }

  # Finds Fdnss that are attached to a given workspace
  #
  # @method workspace_id(id)
  # @scope Sonar:Data::Fdns
  # @param id [Integer] the workspace to look in
  # @return [ActiveRecord::Relation] scoped to the workspace
  scope :workspace_id, ->(id) {
    joins(:import_run).where('sonar_data_import_runs.workspace_id' => id)
  }

  # Finds Fdnss that are attached to a given import run
  #
  # @method by_import_run_id(id)
  # @scope Sonar:Data::Fdns
  # @param id [Integer] the import run to look in
  # @return [ActiveRecord::Relation] scoped to the import run
  scope :import_run_id, ->(id) {
    joins(:import_run).where('sonar_data_import_runs.id' => id)
  }


  #
  # Search Attributes
  #

  search_attribute :hostname,
                   type: :string


  search_with MetasploitDataModels::Search::Operator::IPAddress,
              attribute: :address

  #
  # Validations
  #
  
  validates :address, presence: true
  
  validates :hostname, presence: true
  
  validates :last_seen, presence: true

  validates_uniqueness_of :hostname, scope: [:address, :import_run_id]
  
end
