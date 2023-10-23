host = @vuln.service.try(:host) || @vuln.host

json.id @vuln.id
json.workspace_id host.workspace_id
json.name @vuln.name
json.pushable @vuln.pushable
json.not_exploitable @vuln.not_exploitable
json.markable @vuln.markable
json.not_pushable_reason @vuln.not_pushable_reason
json.match_result_state MetasploitDataModels::AutomaticExploitation::MatchResult.for_vuln_id(@vuln.id).last.try(:state)
json.pushed @vuln.pushed

if @vuln.service
  json.service do
    json.name @vuln.service.name
    json.port @vuln.service.port
    json.proto @vuln.service.proto
    json.state @vuln.service.state
  end
end

json.host do
  json.id host.id
  json.name host.name
  json.address host.address
  json.os_icon_html host_os_icon_html(host, json: false)
  json.is_vm_guest host.is_vm_guest?
end

json.notes @vuln.notes do |note|
  json.comment note.data[:comment]
end

json.partial! 'vulns/vuln_refs', refs: @vuln.refs