# This class holds the record of a successful exploitation attempt against a vulnerability
# sourced from Nexpose.
class ::Nexpose::Result::Validation < ApplicationRecord

  include Nexpose::Result::StateMachine

  #
  # Associations
  #

  # @!attribute export_run
  #   The {Nexpose::Result::ExportRun} associated with this {Validation}
  #
  #   @return [Nexpose::Result::ExportRun]
  belongs_to :export_run,
             class_name: "::Nexpose::Result::ExportRun",
             optional: true, # only exists after an export back to nexpose?
             foreign_key: :nexpose_result_export_run_id

  # @!attribute match_result
  #   Metasploit's record of the outcome of an exploitation attempt
  #
  #   @return [MetasploitDataModels::AutomaticExploitation::MatchResult]
  belongs_to :match_result,
             class_name: 'MetasploitDataModels::AutomaticExploitation::MatchResult',
             foreign_key: :automatic_exploitation_match_result_id

  # @!attribute nx_asset
  #   The Nexpose asset this {Validation} applies to
  #
  #   @return [Nexpose::Data::Asset]
  belongs_to :nx_asset,
             class_name: "::Nexpose::Data::Asset",
             foreign_key: :nexpose_data_asset_id

  # @!attribute user
  #   The Metasploit user responsible for this {Validation}
  #
  #   @return [Mdm::User]
  belongs_to :user,
             class_name: "Mdm::User"

  delegate  :module_detail, to: 'match_result.match'

  delegate  :vulnerability_definition_id, to: "match_result.match.matchable.nexpose_vulnerability_definition"
  alias_method :vulnerability_id, :vulnerability_definition_id

  def vuln
    match_result.match.matchable
  end

  def nexpose_site
    nx_asset.site
  end

  def nexpose_data
    {
      module: "metasploit",
      exploit_id: module_detail.fullname,
      verified_date: verified_at.strftime("%Y%m%dT%H%M%S%L"),
      asset_id: nx_asset.asset_id
    }
  end

end
