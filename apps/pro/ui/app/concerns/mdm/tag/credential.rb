module Mdm::Tag::Credential
  extend ActiveSupport::Concern

  included do
    has_many :credential_core_tags,
             class_name: 'Metasploit::Credential::CoreTag',
             dependent: :destroy,
             inverse_of: :tag

    has_many :credential_login_tags,
             class_name: 'Metasploit::Credential::LoginTag',
             dependent: :destroy,
             inverse_of: :tag

    #
    # through: :credential_core_tags
    #

    has_many :credential_cores,  :class_name => 'Metasploit::Credential::Core' , :through => :credential_core_tags

    #
    # through: :credential_login_tags
    #

    has_many :credential_logins, :class_name => 'Metasploit::Credential::Login', :through => :credential_login_tags


    # Gets all associations belong to a tags join table
    #
    # @return [Symbol]
    def tag_association_names
      self.class.reflect_on_all_associations.each_with_object([]) { |reflection, tag_association_names|
        name = reflection.name

        if name.to_s.ends_with? '_tags'
          tag_association_names << name
        end
      }
    end

    # Checks whether tag is referenced in any of the join tables
    #
    # @return [false] if it does not exist in any of the tag join tables
    # @return [true] if it exists in any of the tag join tables
    def all_empty?
      tag_association_names.all? { |name|
        # using ".count" to avoid serialization of objects
        send(name).count == 0
      }
    end


    redefine_method :destroy_if_orphaned do
      self.class.transaction do
        if all_empty?
          destroy
        end
      end
    end

    scope :tag_ids_by_host, lambda {|workspace_id|
      Mdm::Tag.select(
          Mdm::Tag[:id]
      ).joins(
          Mdm::Tag.join_association(:hosts_tags, Arel::Nodes::OuterJoin),
          Mdm::HostTag.join_association(:host,Arel::Nodes::OuterJoin)
      ).where(
          Mdm::Host[:workspace_id].eq(workspace_id)
      )
    }

    scope :tag_ids_by_core, lambda {|workspace_id|
      Mdm::Tag.select(
          Mdm::Tag[:id]
      ).joins(
          Mdm::Tag.join_association(:credential_core_tags, Arel::Nodes::OuterJoin),
          Metasploit::Credential::CoreTag.join_association(:credential_core, Arel::Nodes::OuterJoin)
      ).where(
          Metasploit::Credential::Core[:workspace_id].eq(workspace_id)
      )
    }

    scope :tag_ids_by_login, lambda {|workspace_id|
      Mdm::Tag.select(
          Mdm::Tag[:id]
      ).joins(
          Mdm::Tag.join_association(:credential_login_tags, Arel::Nodes::OuterJoin),
          Metasploit::Credential::LoginTag.join_association(:credential_login, Arel::Nodes::OuterJoin),
          Metasploit::Credential::Login.join_association(:core, Arel::Nodes::OuterJoin)
      ).where(
          Metasploit::Credential::Core[:workspace_id].eq(workspace_id)
      )
    }

    scope :tags_by_workspace_and_name, lambda {|workspace_id, name_string|
      Mdm::Tag.joins(
        Mdm::Tag.join_association(:credential_core_tags, Arel::Nodes::OuterJoin),
        Metasploit::Credential::CoreTag.join_association(:credential_core, Arel::Nodes::OuterJoin)
      ).where(
       Metasploit::Credential::Core[:workspace_id].eq(workspace_id).and(Mdm::Tag[:name].eq(name_string))
      )
    }

  end
end
