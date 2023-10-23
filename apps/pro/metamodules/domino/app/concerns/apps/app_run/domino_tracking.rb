module Apps::AppRun::DominoTracking

  extend ActiveSupport::Concern

  included do

    # @!attribute domino_nodes
    #   The {Apps::Domino::Node} instances that are linked to this
    #   App Run, if the App Run is of type `domino`.
    #
    #   @return [ActiveRecord::Relation<Apps::Domino::Node>]
    has_many :domino_nodes,
      class_name: 'Apps::Domino::Node',
      # Use delete_all so we don't trigger the Node's destroy callbacks
      # and end up in a recursive nightmare scenario
      dependent: :delete_all,
      foreign_key: 'run_id'

    # @!attribute domino_edges
    #   The {Apps::Domino::Edge} instances that are linked to this
    #   App Run, if the App Run is of type `domino`.
    #
    #   @return [ActiveRecord::Relation<Apps::Domino::Edge>]
    has_many :domino_edges,
      class_name: 'Apps::Domino::Edge',
      # Use delete_all so we don't trigger the Edge's destroy callbacks
      # and end up in a recursive nightmare scenario
      dependent: :delete_all,
      foreign_key: 'run_id'

  end

end
