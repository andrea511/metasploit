module Metasploit::Credential::Login::DominoEdges

  extend ActiveSupport::Concern

  included do

    # @!attribute domino_edges
    #   The {Apps::Domino::Edge} instances that are linked to this
    #   Login.
    #
    #   @return [ActiveRecord::Relation<Apps::Domino::Edge>]
    has_many :domino_edges, class_name: 'Apps::Domino::Edge'

  end

end
