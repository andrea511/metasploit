class Fuzzing::RequestGroupsController < ApplicationController
  before_action :load_workspace, :only => [ :index ]

  def index
    @request_groups =  Web::RequestGroup.all

    respond_to do |format|
      format.json {render :json => @request_groups.to_json, :status => :success}
    end 
  end


  def create
    rg = Web::RequestGroup.new
    rg.workspace = Mdm::Workspace.first#@workspace
    rg.user = Mdm::User.first#@current_user
    r = Web::Request.create_by_uri! URI.parse(params[:request_group][:proxy_url]) , :workspace_id => Mdm::Workspace.first.id , :method => "GET"

    rg.requests << r
    rg.save

    respond_to do |format|
      format.json {render :json => r.to_json}
    end
  end


end
