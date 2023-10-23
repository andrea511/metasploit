class Sonar::FdnssController < ApplicationController
  #
  # Before Filters
  #

  before_action :load_workspace

  include TableResponder
  include FilterResponder

  #
  # Scopes
  #
  has_scope :workspace_id
  has_scope :import_run_id, as: :import_id

  #
  # Actions
  #
  def index
    respond_to do |format|
      format.json{
        respond_with_table(
          Sonar::Data::Fdns,
          presenter_class: Sonar::Data::FdnsPresenter,
          selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
        )
      }
    end
  end

  def filter_values
    # TODO: Fix the n+1 here (check the logs) with the judicious use of joins
    values = filter_values_for_key(Sonar::Data::Fdns, params)
    render json: values.as_json
  end

  def search_operator_class
    Sonar::Data::Fdns
  end

end
