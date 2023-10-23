# This class holds the record of a push of {Nexpose::Result::Exception} or {Nexpose::Result::Validation}
# objects to an associated {Mdm::NexposeConsole} representing an active instance of Nexpose.
class ::Nexpose::Result::ExportRun < ApplicationRecord

  #
  # Associations
  #

  # @!attribute user
  #   The Metasploit user responsible for initiating this export
  #
  #   @return [Mdm::User]
  belongs_to :user,
             :class_name => "Mdm::User",
             :foreign_key => "user_id"

  # @!attribute workspace
  #   The Metasploit workspace that this export is scoped to
  #
  #   @return [Mdm::Workspace]
  belongs_to :workspace,
             class_name: "Mdm::Workspace",
             foreign_key: "workspace_id"

  # @!attribute exceptions
  #   The {Nexpose::Result::Exception} objects being exported
  #
  #   @return [ActiveRecord::Relation<Nexpose::Result::Exception>]
  has_many :exceptions,
           class_name: "::Nexpose::Result::Exception",
           foreign_key: :nexpose_result_export_run_id

  # @!attribute validations
  #   The {Nexpose::Result::Validation} objects being exported
  #
  #   @return [ActiveRecord::Relation<Nexpose::Result::Validation>]
  has_many :validations,
           class_name: "::Nexpose::Result::Validation",
           foreign_key: :nexpose_result_export_run_id

  delegate :post, to: :console, prefix: true

  # Push the {Nexpose::Result::Exception} to the associated Nexpose console and update it if successful
  # @return [void]
  def post_exceptions
    post_results(exceptions,:exception)
  end

  # Push the {Nexpose::Result::Validation} to the associated Nexpose console and update it if successful
  # @return [void]
  def post_validations
    post_results(validations, :validation)
  end

  # Push the {Nexpose::Result::Exception} or {Nexpose::Result::Validation} to the associated Nexpose console and update it if successful
  # @return [void]
  def post_results(results,type)
    results.find_each do |result|
      type = result.class.name.demodulize
      post_result(result)
    end
  end

  def post_result(result)
    type = result.class.name.demodulize.downcase
    result.sent_at = Time.current
    nexpose_url = "/vulnerabilities/#{result.vulnerability_id}/#{type}s"
    begin
      result.attempt_push!
      response = result.match_result.nexpose_console.post(nexpose_url, result.nexpose_data.to_json)
      result.nexpose_response = response
      result.push!
      yield(type, response) if block_given?
    rescue ::Nexpose::APIError => e
      result.nexpose_response = e.req.error
      result.attempt_later!
      yield(:error, e) if block_given?
    rescue RestClient::ResourceNotFound => e
      result.nexpose_response = "404 error, #{nexpose_url}"
      result.attempt_later!
      yield(:error, e) if block_given?
    rescue Exception => e
      result.nexpose_response = e.response
      result.reject!
      yield(:error, e) if block_given?
    end

    result.save
  end
  
end
