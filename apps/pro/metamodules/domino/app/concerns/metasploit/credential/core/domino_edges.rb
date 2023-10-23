module Metasploit::Credential::Core::DominoEdges

  extend ActiveSupport::Concern

  included do

    # @!attribute domino_edges
    #   The {Apps::Domino::Edge} instances that are linked to this
    #   Core. These designate links in the graph between *compromised*
    #   hosts.
    #
    #   @return [ActiveRecord::Relation<Apps::Domino::Edge>]
    has_many :domino_edges, through: :logins
  end

end
