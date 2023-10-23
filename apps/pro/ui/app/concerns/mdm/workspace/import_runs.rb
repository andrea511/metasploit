module Mdm::Workspace::ImportRuns
  extend ActiveSupport::Concern

  included do
    # @!attribute sonar_data_import_runs
    #   {ImportRun} is a way to group results from Sonar
    #
    #   @return [ActiveRecord::Relation<Sonar::Data::ImportRun>]
    has_many :sonar_data_import_runs,
             class_name: "Sonar::Data::ImportRun",
             foreign_key: :workspace_id,
             dependent: :destroy
  end
end
