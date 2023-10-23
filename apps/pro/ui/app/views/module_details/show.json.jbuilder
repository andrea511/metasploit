json.refs @refs do |ref|
  json.html_link link_for_ref(*ref.link_info)
end