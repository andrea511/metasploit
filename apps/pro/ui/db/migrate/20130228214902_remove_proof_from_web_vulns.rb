# Removes the proof column from the web_vulns table because a single binary/text proof is being replace with a
# `has_many :proofs, :class_name => 'Web::Proof'`, which supports both {Web::Proof#text textual} and
# {Web::Proof#image graphical} proof.
class RemoveProofFromWebVulns < ActiveRecord::Migration[4.2]
  TABLE_NAME = :web_vulns

  def down
    # add old proof column back in
    change_table TABLE_NAME do |t|
      t.binary :proof
    end

    # Copy the textual proof into old column
    execute "UPDATE web_vulns " \
            "SET proof = decode(web_proofs.text, 'escape') " \
            "FROM web_proofs " \
            "WHERE web_proofs.vuln_id = web_vulns.id"
  end

  def up
    # Turn the proof column into a textual web proof
    execute "INSERT INTO web_proofs (vuln_id, text) " \
            "(" \
             "SELECT web_vulns.id, " \
                 "encode(web_vulns.proof, 'escape') " \
             "FROM web_vulns" \
            ")"

    # drop column now that its been translated
    change_table TABLE_NAME do |t|
      t.remove :proof
    end
  end
end
