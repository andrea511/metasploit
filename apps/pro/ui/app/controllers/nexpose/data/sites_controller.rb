class ::Nexpose::Data::SitesController < ApplicationController
  before_action :load_workspace

  include TableResponder
  include FilterResponder

  has_scope :ids
  has_scope :ids_only, type: :boolean

  def index
    relation = ::Nexpose::Data::Site.where(
      nexpose_data_import_run_id: params[:nexpose_import_run_id]
    )

    render json: as_table(
      relation,
      search: params[:search],
      selections: (params[:selections] || {}).reverse_merge!(ignore_if_no_selections: true)
    )
  end

  def filter_values
    values = filter_values_for_key(Nexpose::Data::Site, params)
    render json: values.as_json
  end

end
