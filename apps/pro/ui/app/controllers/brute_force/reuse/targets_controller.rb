#
# Used by the UI to query services. XXX this should eventually
# replace the ServicesController implementation.
#
class BruteForce::Reuse::TargetsController < ApplicationController

  include TableResponder
  include FilterResponder

  has_scope :with_ids
  has_scope :ids_only, type: :boolean
  has_scope :workspace_id

  def index
    if License.get.supports_bruteforce?
      respond_with_table(
        Mdm::Service,
        include: [:host],
        includes: [:host],
        search: params[:search],
        selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
      )
    end
  end

  def filter_values
    values = filter_values_for_key(Mdm::Service, params)
    render json: values.as_json
  end

  def search_operator_class
    Mdm::Service
  end

end
