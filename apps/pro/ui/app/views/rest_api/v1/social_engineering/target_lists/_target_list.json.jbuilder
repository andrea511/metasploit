json.id target_list.id
json.workspace_id target_list.workspace_id
json.created_at target_list.created_at
json.updated_at target_list.updated_at

json.human_targets target_list.human_targets, partial:'/rest_api/v1/social_engineering/human_targets/human_target', formats: [:json], as: :human_target
