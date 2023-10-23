class SocialEngineering::TargetListHumanTarget < ApplicationRecord
  self.table_name = :se_target_list_human_targets

  #
  # Associations
  #

  belongs_to :human_target, :class_name => 'SocialEngineering::HumanTarget'
  belongs_to :target_list, :class_name => 'SocialEngineering::TargetList'

  validates :human_target_id,
            :uniqueness => {
                :scope => :target_list_id
            }
end
