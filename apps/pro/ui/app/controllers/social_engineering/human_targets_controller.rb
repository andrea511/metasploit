module SocialEngineering
class HumanTargetsController < ApplicationController
  before_action :load_workspace

  include TableResponder

  def index
    respond_to do |format|
      format.json{

        targets = as_table(
          SocialEngineering::TargetList.find(params[:target_list_id]).human_targets,
          selections: (params[:selections] || {}).merge(ignore_if_no_selections: true)
        )

        respond_with targets
      }
    end
  end

  def show
    @human_target     = HumanTarget.find(params[:id])
    @phishing_results = PhishingResult.for_human_target(@human_target)
    @visits           = Visit.for_human_target(@human_target)
    @openings         = EmailOpening.for_human_target(@human_target)
  end

  def destroy
    begin
      # Why yes, this is kludgy, but it is also more efficient that what AR
      # wants to do. It generates valid SQL queries to boot!

      list = SocialEngineering::TargetList.find(params[:target_list_id])
      target_ids = load_filtered_records(list.human_targets, params).select('se_human_targets.id').map &:id
      SocialEngineering::TargetListHumanTarget.where(human_target_id: target_ids, target_list_id: list.id).delete_all
      HumanTarget.destroy_orphans(target_ids)
      render json: { success: true }
    rescue
      render json: { success: false }
    end
  end

end
end
