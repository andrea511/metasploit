json.id campaign.id
json.workspace_id campaign.workspace_id
json.name campaign.name
json.state campaign.state
json.created_at campaign.created_at
json.updated_at campaign.updated_at
json.last_target_interaction_at campaign.last_target_interaction_at

json.web_pages campaign.web_pages, partial: '/rest_api/v2/social_engineering/web_pages/web_page', as: :web_page
json.emails campaign.emails, partial: '/rest_api/v2/social_engineering/emails/email', as: :email
