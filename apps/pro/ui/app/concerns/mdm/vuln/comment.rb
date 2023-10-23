module Mdm::Vuln::Comment
  def latest_comment
    Mdm::Note.where(vuln_id: id).last
  end
end