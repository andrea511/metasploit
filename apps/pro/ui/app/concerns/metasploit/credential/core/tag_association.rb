module Metasploit::Credential::Core::TagAssociation
  extend ActiveSupport::Concern

  included do
    #
    # Associations
    #

    # @!attribute credential_core_tags
    #   Joins this core credential to {#tags}.
    #
    #   @return [ActiveRecord::Relation<>]
    has_many :credential_core_tags,
             class_name: 'Metasploit::Credential::CoreTag',
             dependent: :destroy,
             foreign_key: 'core_id',
             inverse_of: :credential_core

    #
    # through: :credential_core_tags
    #

    # @!attribute tags
    #   Tags on this credential core.
    #
    #   @return [ActiveRecord::Relation<>]
    has_many :tags,
             class_name: 'Mdm::Tag',
             through: :credential_core_tags

    #
    # Search Associations
    #

    search_association :tags


    # add_tag_by_name accepts a tag_name and either finds a previous Tag object
    # or creates a new one, and assigns it to the current host
    def add_tag_by_name(tag_name)
      tag ||= Mdm::Tag.tags_by_workspace_and_name(workspace.id,tag_name).first
      unless tag.present?
        tag = Mdm::Tag.new(:name => tag_name)
        tag.save
      end
      add_tag tag
    end

    # add_tag examines a entities's existing tags and,
    #   if necessary, adds the current tag
    def add_tag(tag)
      tags << tag if tag.present? && tag.valid? && !tags.include?(tag)
      tag
    end

    def tag_names
      tags.map {|t| t.name}.join(", ")
    end


  end
end