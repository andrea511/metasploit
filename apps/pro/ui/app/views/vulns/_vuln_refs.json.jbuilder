refs = refs.to_a.sort_by! { |r| r.name || '' }
# Need to drop the empty ref created by build_ref in the controller.
refs.select! { |r| !r.new_record? }
refs.uniq!

json.refs refs do |ref|
  json.html_link link_for_ref(*ref.link_info)
end
  