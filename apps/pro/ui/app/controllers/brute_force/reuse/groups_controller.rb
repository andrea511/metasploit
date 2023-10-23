# Used by the UI to manage groups of credentials that are used as
# a cred set for bruteforcing.
class BruteForce::Reuse::GroupsController < ApplicationController
  respond_to :json

  before_action :load_workspace
  before_action :load_group, except: :index

  has_scope :page, default: 1
  has_scope :per, as: :per_page, default: 20
  has_scope :with_ids
  has_scope :ids_only, type: :boolean


  def index
    render json: @workspace.brute_force_reuse_groups
  end

  def show
    respond_with @group
  end

  def destroy
    @group.destroy
    render json: { success: true }
  end

  private

  def load_group
    @group ||= BruteForce::Reuse::Group.find(params[:id])
  end

  def load_workspace
    if params.has_key? :id
      if load_group.workspace_id != params[:workspace_id].to_i
        raise ActiveRecord::RecordNotFound
      end
    end

    super
  end

end
