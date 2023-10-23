#
# A Node represents a Host on the Domino Metamodule Findings Graph.
#
class Apps::Domino::Node < ApplicationRecord

  #
  # Attributes
  #

  # @!attribute captured_creds_count
  #   The number of creds that were captured from this Node.
  #
  #   @return [Integer]

  # @!attribute created_at
  #   When this Node was created.
  #
  #   @return [DateTime]

  # @!attribute depth
  #   The iteration of the `run` at which this node was compromised
  #
  #   @return [Integer]

  # @!attribute high_value
  #   This host was specified as high-value by the user
  #
  #   @return [Boolean]

  # @!attribute updated_at
  #   The last time this private credential was updated.
  #
  #   @return [DateTime]

  #
  # Associations
  #

  # @!attribute edges
  #   The {Apps::Domino::Edge} instances that have this Node as their
  #   `source_node_id`.
  #
  #   @return [ActiveRecord::Relation<Apps::Domino::Edge>]
  has_many :edges,
    foreign_key: 'source_node_id',
    class_name: 'Apps::Domino::Edge',
    dependent: :destroy

  # @!attribute captured_creds
  #   The {Metasploit::Credential::Core} models that were captured on this Node
  #   during this App Run.
  #
  #   @return [ActiveRecord::Relation<Metasploit::Credential::Cores>]
  has_and_belongs_to_many :captured_creds,
    ->{ distinct },
    class_name: 'Metasploit::Credential::Core',
    join_table: 'mm_domino_nodes_cores'

  # @!attribute host
  #   The {Mdm::Host host} that this node represents in the Graph
  #
  #   @return [ActiveRecord::Relation<Mdm::Host>]
  belongs_to :host, class_name: 'Mdm::Host'

  # @!attribute source_edge
  #    The {Apps::Domino::Edge} instance that is connected to this node
  #    from the left.
  #
  #    @return [ActiveRecord::Relation<Apps::Domino::Edge>]
  has_one :source_edge,
    foreign_key: 'dest_node_id',
    class_name: 'Apps::Domino::Edge',
    dependent: :destroy

  # @!attribute run
  #   The {Apps::AppRun} that this node was created for
  #
  #   @return [ActiveRecord::Relation<Apps::AppRun>]
  belongs_to :run, class_name: 'Apps::AppRun'

  #
  # Validations
  #

  validates :host, presence: true
  validates :depth, numericality: { only_integer: true, greater_than: -1 }
  validates :host_id, uniqueness: { scope: :run_id }
  validates :run,  presence: true
  validate  :consistent_workspaces
  validate  :attached_to_domino_metamodule

  private

  # Validates that the #host and #run associations belong to the
  # same Mdm::Workspace, to prevent crazy situations.
  def consistent_workspaces
    if host.present? and run.present? and host.workspace.id != run.workspace.id
      errors.add(:host, 'workspace does not match the Run\'s workspace')
    end
  end

  # Ensures the {Apps::AppRun} we are attached to is of the type :domino
  def attached_to_domino_metamodule
    if run.present? and run.app.symbol.to_s != 'domino'
      errors.add(:run, 'must be a Domino MetaModule run')
    end
  end

end
