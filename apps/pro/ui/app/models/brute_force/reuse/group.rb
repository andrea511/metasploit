# Groups together multiple {#brute_force_reuse_cores `BruteForce::Reuse::Core`s} so they can be added collectively to
# different {BruteForce::Run BruteForce::Runs}.
class BruteForce::Reuse::Group < ApplicationRecord
  #
  # Associations
  #

  # @!attribute metasploit_credential_cores
  #   The {Metasploit::Credential::Core Metasploit::Credential::Cores} in this group.
  #
  #   @return [ActiveRecord::Relation<Metasploit::Credential::Core>]
  has_and_belongs_to_many :metasploit_credential_cores,
                          association_foreign_key: :metasploit_credential_core_id,
                          class_name: 'Metasploit::Credential::Core',
                          foreign_key: :brute_force_reuse_group_id,
                          join_table: :brute_force_reuse_groups_metasploit_credential_cores

  # @!attribute workspace
  #   The workspace to which this group is scoped.
  #
  #   @return [Mdm::Workspace]
  belongs_to :workspace,
             class_name: 'Mdm::Workspace',
             inverse_of: :brute_force_reuse_groups

  #
  # Attributes
  #

  # @!attribute name
  #   The name of this group.
  #
  #   @return [String]

  #
  # Scopes
  #

  scope :empty,
        ->{
          reflection = reflect_on_association(:metasploit_credential_cores)
          join_table = reflection.options[:join_table]
          association_foreign_key = reflection.options[:association_foreign_key]
          foreign_key = reflection.options[:foreign_key]

          relation = joins(
              "LEFT OUTER JOIN #{join_table} " \
              "ON #{join_table}.#{foreign_key} = #{table_name}.#{primary_key}"
          ).joins(
              "LEFT OUTER JOIN #{reflection.table_name} " \
              "ON #{reflection.table_name}.#{reflection.klass.primary_key} = #{join_table}.#{association_foreign_key}"
          ).group(
              arel_table[:id]
          ).having(
              reflection.klass.arel_table[reflection.klass.primary_key].count.eq(0)
          )
        }

  #
  #
  # Validations
  #
  #

  #
  # Method Validations
  #

  validate :consistent_workspaces

  #
  # Attribute Validations
  #

  validates :metasploit_credential_cores,
            length: {
                minimum: 1
            }
  validates :name,
            presence: true,
            uniqueness: {
                scope: :workspace_id
            }
  validates :workspace,
            presence: true

  #
  # Instance Methods
  #

  private

  # Validates that {#workspace} matches the `Metasploit::Credential::Core#workspace` for all
  # {#metaploit_credential_cores}.
  #
  # @return [void]
  def consistent_workspaces
    metasploit_credential_cores.each do |metasploit_credential_core|
      unless metasploit_credential_core.workspace == workspace
        errors.add(:workspace, :inconsistent)

        # only report the error once even if there are multiple workspaces across the metasploit_credential_cores as
        # there isn't a good way to highlight which one has the error
        break
      end
    end
  end
end
