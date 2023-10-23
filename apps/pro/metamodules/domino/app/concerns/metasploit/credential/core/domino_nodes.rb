module Metasploit::Credential::Core::DominoNodes

  extend ActiveSupport::Concern

  included do

    # @!attribute domino_edges
    #   The {Apps::Domino::Edge} instances that are linked to this
    #   Core. These designate links in the graph between *compromised*
    #   hosts.
    #
    #   @return [ActiveRecord::Relation<Apps::Domino::Edge>]
    has_and_belongs_to_many :domino_nodes,
      class_name: 'Apps::Domino::Node',
      join_table: 'mm_domino_nodes_cores'
  end

end
