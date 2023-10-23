# This class is the record of an attempt to exploit a Nexpose-sourced vulnerability and
# *failing*. An {Exception} is therefore created, meaning that the vulnerability could *not*
# be remotely exploited. (When a vulnerability *can* be remotely exploited, it is recorded
# as having a {Nexpose::Result::Validation})
#
# Each {Exception} has an {MetasploitDataModels::AutomaticExploitation::MatchResult} representing the actual attempt
# to perform the exploitation.
class ::Nexpose::Result::Exception < ApplicationRecord
  include Nexpose::Result::StateMachine

  REASON = {
    false_positive: "False Positive",
    compensating_control: "Compensating Control",
    acceptable_risk: "Acceptable Risk",
    acceptible_use: "Acceptable Use",
    other: "Other"
  }


  def add_invalid_date_error
    errors.add(:expiration_date, "Invalid Date")
  end

  #
  # ASSOCIATIONS
  #
  belongs_to :user,
             optional: true, # this is never set by code
             class_name: "Mdm::User"

  belongs_to :nx_scope,
             polymorphic: true

  belongs_to :match_result,
             class_name: 'MetasploitDataModels::AutomaticExploitation::MatchResult',
             foreign_key: :automatic_exploitation_match_result_id

  belongs_to :export_run,
             class_name: "::Nexpose::Result::ExportRun",
             foreign_key: :nexpose_result_export_run_id,
             optional: true # only exists after an export back to nexpose?

  validates :match_result,    associated: true
  validates :reason,  inclusion: { in: REASON.keys.map(&:to_s) }, presence:true
  validate :expiration_date_in_future, if: :expiration_date

  #alias nx_asset to nx_scope to be consistent with Nexpose::Result::Validation, required for ExportRuns
  alias_method :nx_asset, :nx_scope

  def vuln
    match_result.match.matchable
  end

  def nexpose_site
    nx_asset.site
  end

  delegate :port, to: 'match_result.match.matchable.service'

  delegate  :vulnerability_definition_id, to: "match_result.match.matchable.nexpose_vulnerability_definition"
  alias_method :vulnerability_id, :vulnerability_definition_id

  def expiration_date_in_future
    if expiration_date
      unless expiration_date > Time.now
        errors.add(:expiration_date, "Date must be in future")
      end
    end
  end

  def action
    "Submit#{' and Approve' if approve?}"
  end

  def nexpose_data
    hsh = {
      reason: REASON[reason.to_sym],
      comments: comments,
      key: nil,
      action: action,
      port: port
    }
    hsh[:expiration_date] = expiration_date.strftime("%Y%m%dT%H%M%S%L") if expiration_date

    case nx_scope
    when ::Nexpose::Data::Asset
      hsh.merge!({
        site_id: nil,
        asset_id: nx_scope.asset_id,
        scope: "Asset"
      })
    when ::Nexpose::Data::Site
      hsh.merge!({
        site_id: nx_scope.site_id,
        asset_id: nil,
        scope: "Site"
      })
    end
  end

end
