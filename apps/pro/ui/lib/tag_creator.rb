class TagCreator < Struct.new(:klass)

  def self.build(params,klass,opts = {})
    # YUP! This is terrible. But it's mostly going to need to be rewritten, anyway.
    tagCreator = TagCreator.new(klass)

    if !params[:tag_single] and opts.has_key?(:relation)
      relation = opts[:relation]
      selected_ids = relation.pluck(:id)
    else
      selected_ids = params[:entity_ids]
    end

    tagCreator.quick_multi_tag(params, selected_ids)
    tagCreator
  end


  # Given an ActiveRecord::Relation, returns the base class (the model that is projected)
  # @param relation [ActiveRecord::Relation] the relation
  # @return [ApplicationRecord] the Model class on which the query projects
  def class_for_relation(relation)
    begin
      relation.klass
    rescue NoMethodError
      relation
    end
  end

  # Handles creating/associating Tag records with a :klass model in the workspace
  # params:
  #   :entity_ids => an array of ids of entities to tag
  #   :new_entity_tags => a comma-separate list of tags
  #   :preserve_existing => true to keep existing tags on a single host. defaults to false.
  #   :workspace_id => id of the workspace
  def quick_multi_tag(params, selected_ids)
    #todo: make this a .where
    entities = selected_ids.collect { |id| klass.find(id.to_i) }
    tags_invalid = false
    saved_tags = {} # save a tag after you add it, and reuse on next host
    if params[:new_entity_tags] && selected_ids
      if selected_ids.size == 1
        # if only one entity specified, make entity.tags an *exact* replica of new_entity_tags,
        # so clear host.tags before appending
        unless params[:preserve_existing]
          entities.first.tags.clear
        end
      end
      entities.each do |entity|
        names = params[:new_entity_tags].split(',').uniq
        names.each { |name|
          if saved_tags[name].present?
            entity.add_tag saved_tags[name]
          else
            saved_tags[name] = entity.add_tag_by_name name
          end
          tags_invalid = true unless saved_tags[name].valid?
        }
      end
    end

    @error_msg = if tags_invalid
                  # convert name=>tag hash to array of tags
                  tags = saved_tags.flatten.select { |t| t.class <= Mdm::Tag }
                  # generate an error message for it
                  tags.select { |t| !t.valid? }.first.errors.full_messages.join ', '
                end

  end


  def as_json(options={})
    {
        error: @error_msg
    }

  end
end
