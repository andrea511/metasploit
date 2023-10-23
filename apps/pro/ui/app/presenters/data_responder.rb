#
# DataResponder is the functionality shared between the TableResponder and
# FilterResponder modules for dealing with responses created for Carpenter tables.
module DataResponder
  #
  # Fetch the records for `klass` that are currently represented by the search parameters
  # and table selections.
  #
  # @param klass [Class] the model for which we are searching
  # @param params [Hash] the current value of `params` in the controller
  #
  # @return [ActiveRecord::Relation] the properly filtered records for `klass`
  def load_filtered_records(klass, params)
    relation = apply_search_scopes(
        klass,
        params.merge(klass: klass)
    )
    relation = apply_scopes(apply_sort(relation, params)) if current_scopes.empty?
    relation
  end

  # Apply scopes to the relation based on the search parameters.
  #
  # @param relation [ActiveRecord::Relation]
  # @return [ActiveRecord::Relation] the relation with proper scopes applied
  def apply_search_scopes(relation, opts)
    # For client-side search filter, see `Components.Filter`
    if params[:search] && params[:search].respond_to?(:keys) && !params[:search][:custom_query].blank?
      query = params[:search][:custom_query]

      relation = MetasploitDataModels::Search::Visitor::Relation.new(
          query: Metasploit::Model::Search::Query.new(
              formatted: query,
              klass: class_for_relation(relation)
          )
      ).visit

      relation = apply_base_scopes(relation, opts)
    # For client-side legacy search filter, see `Components.ProSearchFilter`
    elsif params[:search] && params[:search].respond_to?(:keys) && !params[:search][:pro_search_query].blank?
      relation = pro_search(params[:controller].to_sym, false, params[:search][:pro_search_query])
    else
      relation = apply_base_scopes(relation, opts)
    end

    relation = selected_records(relation,opts[:selections]) unless opts[:selections].nil?

    return relation

    # TODO
    # * be sure to add the includes, scope also when searching (put into helper method)
    # * support on-model attributes
    # * support associations
    # * support boolean searches
    # * support checkbox/textfield search (username/password)
    # * support select menu search
  end

  # TODO: the below helpers originally in table_responder.rb
  # and needed to get logins_controller_specs to pass
  # Probably don't need after integrating visual search on other pages

  # Apply the scopes common to every search.
  #
  # @param relation [ActiveRecord::Relation] the relation against which searches
  #   will be appended
  #
  # @return [ActiveRecord::Relation] the scoped relation
  def apply_base_scopes(relation, opts)
    # Ensure all query conditions of the original relation are applied to the response relation.
    if !@original_relation.nil? &&
      @original_relation.exists? &&
      @original_relation.is_a?(ActiveRecord::Relation) && search_params_present?
      # TODO: This should all live in a nice helper in the Mdm::...::Relation class

      # Merge our original conditions with the ones from our search
      relation = relation.merge(@original_relation)
    end

    # Not sure this really needs to be here either, but I'm leaving it for now
    # TODO: investigate wtf is going on with this later
    includes_opt = opts.fetch(:includes, [])
    relation = relation.includes(includes_opt).references(includes_opt)
    relation = opts[:scope].call(relation) if opts[:scope]

    relation
  end

  # @return [Boolean] true if there are any search parameters present, false otherwise
  def search_params_present?
    return false unless params[:search]

    return true if custom_search_params_present?

    return false
  end

  # @return [Boolean] true if there are any custom search params present, false otherwise
  def custom_search_params_present?
    params[:search].is_a?(Hash) && params[:search][:custom_query] &&
        !params[:search][:custom_query].blank?
  end

  # @param relation [ActiveRecord::Relation] the relation to sort
  # @param opts [Hash] @see #as_table opts
  # @return [ActiveRecord::Relation] a sorted relation
  def apply_sort(relation, opts={})
    sort = params[:sort_by]
    if sort.blank?
      sort = 'id DESC'
    end

    fqdn, dir = sort.split

    klass = class_for_relation(relation)

    domains = fqdn.split('.')
    domains[0...-1].each do |col|
      # re-map the reflections to use string keys
      reflections = Hash[klass.reflections.map {|k, v| [k.to_s, v] }]
      # that way we don't have to convert input to a symbol, which is a possible OOM DOS
      klass = reflections[col.to_s].try(:klass)
    end

    if ['asc', 'desc'].include?(dir.downcase)
      # We need to cast the column to lower case when sorting in order
      # to avoid platform-specific case differences, but we can only
      # do that on certain column types:
      sortable_types = ["text", "character"]
      # TODO Raise something useful/handle these not being present:
      if klass.present? and klass.columns_hash.has_key?(domains.last)
        table_sort = "#{klass.table_name}.#{domains.last}"
        # See if the field type we want to sort on is something that allows
        # lower() to be called on it. Split is to not have to worry
        # about "character varying(X)":
        column_allows_lower = sortable_types.include? klass.columns_hash[domains.last].sql_type.split[0]
        # The FilterResponder module already applies lower() in order,
        # so if we don't guard that out we will get an SQL error:
        not_a_filter_responder = !(self.class.ancestors.include? FilterResponder)

        table_sort = if column_allows_lower && not_a_filter_responder
                       Arel.sql("lower(#{table_sort}) #{dir}")
                     else
                       Arel.sql("#{table_sort} #{dir}")
                     end

        relation = relation.order(table_sort)
      end
    end

    relation
  end
end
