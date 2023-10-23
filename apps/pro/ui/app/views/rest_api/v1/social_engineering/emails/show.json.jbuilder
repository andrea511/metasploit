json.partial! 'email', email: @email
json.content @email.render_body_for_send(::SocialEngineering::HumanTarget.dummy, false)