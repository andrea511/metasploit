json.phishing_result do |json|
  json.id phishing_result.id
  json.web_page_id phishing_result.web_page_id
  json.human_target_id phishing_result.human_target_id
  json.address phishing_result.address
  json.data phishing_result.data
  json.browser_name phishing_result.browser_name
  json.browser_version phishing_result.browser_version
  json.os_name phishing_result.os_name
  json.os_version phishing_result.os_version
  json.created_at phishing_result.created_at
  json.updated_at phishing_result.updated_at
end
