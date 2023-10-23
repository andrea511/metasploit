#
# An Edge represents a Login and connects two Hosts on the Domino Metamodule
# Findings Graph.
#
class Apps::Domino::Edge < ApplicationRecord

  #
  # Associations
  #

  # @!attribute created_at
  #   When this Node was created.
  #
  #   @return [DateTime]

  # @!attribute dest_node
  #   The {Apps::Domino::Node node} that this edge points to
  #
  #   @return [Apps::Domino::Node]
  belongs_to :dest_node, class_name: 'Apps::Domino::Node'

  # @!attribute login
  #   The {Metasploit::Credential::Login login} that this edge represents
  #
  #   @return [Metasploit::Credential::Login]
  belongs_to :login, class_name: 'Metasploit::Credential::Login'

  # @!attribute run
  #   The {Apps::AppRun Metamodule Run} that this node was created for
  #
  #   @return [ActiveRecord::Relation<Apps::AppRun>]
  belongs_to :run, class_name: 'Apps::AppRun'

  # @!attribute source_node
  #   The {Apps::Domino::Node node} that this edge starts from
  #
  #   @return [Apps::Domino::Node]
  belongs_to :source_node, class_name: 'Apps::Domino::Node'

  # @!attribute updated_at
  #   The last time this private credential was updated.
  #
  #   @return [DateTime]

  #
  # Validations
  #

  validates :dest_node,    presence: true
  validates :dest_node_id, uniqueness: { scope: :run_id }
  validates :login,        presence: true
  validates :login_id,     uniqueness: { scope: :run_id }
  validates :run,          presence: true
  validates :source_node,  presence: true

  validate  :consistent_run_ids
  validate  :consistent_workspaces
  validate  :source_does_not_equal_dest
  validate  :attached_to_domino_metamodule

  private

  # Validates that the #login and #run associations belong to the
  # same Mdm::Workspace, to prevent crazy situations.
  def consistent_workspaces
    if login.present? and run.present?
      if login.core.workspace_id != run.workspace_id
        errors.add(:login, 'workspace does not match the Run\'s workspace')
      end

      if login.service.host.workspace_id != run.workspace_id
        errors.add(:login, 'workspace of the target service does not match the Run\'s workspace')
      end
    end
  end

  # Validates that the dest_ and source_nodes are attached to our AppRun
  def consistent_run_ids
    if dest_node.present? and dest_node.run_id != run_id
      errors.add(:dest_node, 'run_id does not match the Edge\'s run_id')
    end

    if source_node.present? and source_node.run_id != run_id
      errors.add(:source_node, 'run_id does not match the Edge\'s run_id')
    end
  end

  # Ensures the {Apps::AppRun} we are attached to is of the type :domino
  def attached_to_domino_metamodule
    if run.present? and run.app.symbol.to_s != 'domino'
      errors.add(:run, 'must be a Domino MetaModule run')
    end
  end

  def source_does_not_equal_dest
    if source_node.present? and dest_node.present? and source_node_id == dest_node_id
      errors.add(:dest_node, 'cannot equal source_node')
    end
  end

end
