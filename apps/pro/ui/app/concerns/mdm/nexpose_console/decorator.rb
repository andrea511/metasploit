module Mdm::NexposeConsole::Decorator
  extend ActiveSupport::Concern

  included do
    #
    # ASSOCIATIONS
    #

    # @!attribute console
    #   The Nexpose console that this {ImportRun} is retrieving data from
    #
    #   @return [Mdm::NexposeConsole]
    has_many :import_runs,
             class_name: "Nexpose::Data::ImportRun",
             foreign_key: :nx_console_id

    scope :for_vuln_id,
          ->(vuln_id){
            self.joins(:import_runs => :mdm_vulns).where(Mdm::Vuln[:id].in(vuln_id))
          }

  end

end
