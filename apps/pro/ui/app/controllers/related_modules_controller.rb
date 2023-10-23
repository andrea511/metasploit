class RelatedModulesController < ApplicationController
  include AnalysisSearchMethods

  before_action :find_workspace, :only => [:new, :edit, :show, :details, :attempts, :exploits ]
  before_action :load_workspace, :only => [:index]
  before_action :application_backbone, only: [:index]

  include TableResponder
  include FilterResponder

  has_scope :workspace_id, only: [:index]

  def index
    session[:return_to] = workspace_related_modules_path(@workspace)

    respond_to do |format|
      format.html
      format.json{
        render json: as_table(Mdm::Module::Detail.with_table_data.distinct,{
          presenter_class: Mdm::ModuleDetailIndexPresenter,
          vulns: @workspace.vulns
        })
      }
    end
  end

  # TODO: For the moment, we're only searching by related hosts in the single
  # vuln view, so we don't need to mess with the base search_operators method.
  # In the future, if we want to search across vulns, we'll need to fix this,
  # because att that point search_operator_class should return Mdm::Vuln.
  def search_operator_class
    Mdm::Module::Detail
  end
end
