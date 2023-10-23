class RemoveUnuniqueHumanTargets < ActiveRecord::Migration[4.2]
  def change
    SocialEngineering::HumanTarget.all
        .group('lower(se_human_targets.email_address)', :first_name, :last_name, :workspace_id)
        .minimum(:id).each do |attrs, min_id|

      human_targets = SocialEngineering::HumanTarget.where(email_address: attrs[0],
                                                           first_name: attrs[1],
                                                           last_name: attrs[2],
                                                           workspace_id: attrs[3])

      SocialEngineering::TargetListHumanTarget.where(human_target_id: human_targets.ids)
          .update_all(human_target_id: min_id)
      SocialEngineering::PhishingResult.where(human_target_id: human_targets.ids)
          .update_all(human_target_id: min_id)

      human_targets.where.not(id: min_id).destroy_all
    end
  end
end
