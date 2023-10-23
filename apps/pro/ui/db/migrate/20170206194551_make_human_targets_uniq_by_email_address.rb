class MakeHumanTargetsUniqByEmailAddress < ActiveRecord::Migration[4.2]
  def change
    execute 'DROP INDEX se_human_targets_compound_idx'
    
    SocialEngineering::HumanTarget.
      group('trim(lower(se_human_targets.email_address))', :workspace_id).
      having("count(*) > 1").
      minimum(:id).each do |attrs, min_id|
        
      human_targets = SocialEngineering::HumanTarget.where(workspace_id: attrs[1]).where('email_address ilike ?',"%#{attrs[0]}%")
      
      puts "Migrating Bad Data For #{attrs[0]}"
      
      SocialEngineering::TargetList.find_each do |target_list|
        puts "\tMigrating #{target_list.name} fixing entries for #{attrs[0]}"
        unless target_list.target_list_targets.where(human_target_id: min_id).any?
          if target_list.target_list_targets.where(human_target_id: human_targets.ids).where.not(human_target_id: min_id).any?
            target_list.target_list_targets.where(human_target_id: human_targets.ids).where.not(human_target_id: min_id).first.update(human_target_id: min_id)
          end
        end
        target_list.target_list_targets.where(human_target_id: human_targets.ids).where.not(human_target_id: min_id).destroy_all
      end
      SocialEngineering::PhishingResult.where(human_target_id: human_targets.ids).update_all(human_target_id: min_id)

      human_targets.where.not(id: min_id).destroy_all
    end
    
    execute 'CREATE UNIQUE INDEX se_human_targets_compound_idx ON se_human_targets USING btree (workspace_id, TRIM(LOWER(email_address)))'
  end
end
