#
# Provides auto-complete endpoint for client-side `Components.Table` filtering, `Components.Filter`
# Allows returning a limited set of auto-complete results when provided a 'key:value' pair
# Note this is different then an actual search endpoint, which is handled by {DataResponder#apply_search_scopes}.
#
module FilterResponder
  extend ActiveSupport::Concern

  class ArgumentError < ::ArgumentError
  end

  # TODO: split shared methods into their own module
  include DataResponder

  #
  # Provided key/value pair (params['prefix'] and params['column'], respectively), returns
  # the auto-complete values for the relation
  #
  # @param [ActionController::Parameters] params, the params hash passed from controller
  #   note that params['column'] is required
  #
  # @return [Array<string>] the collection of auto-complete strings found
  #
  def filter_values_for_key(relation, params, opts = {})
    # TODO: It's not clear but params['sort_by'] must be present otherwise PG::InvalidColumnReference ordering error
    # Moreover, the TableResponder#apply_sort defaults sort to 'id asc' which doesn't work in this case
    # Not sure how to deal with this
    validate_filter_params!(relation, params)

    @prefix = params['prefix'].blank? ? nil : params['prefix'].to_sym
    @column = params['column'].to_sym

    load_records(relation, params)
  end

  # Renders a JSON blob of metadata about available search operators for this controller
  # Needed to provide help endpoint for client-side help modal. See `Components.Filter#displayHelpModal`
  def search_operators
    ops = search_operator_class.search_operator_by_name
    metadata = ops.each_with_object({}) do |op, obj|
      obj[op[1].name] = op[1].help
    end

    respond_with metadata
  end

  private
  def load_records(relation, params)
    attribute_to_pluck = attribute_to_pluck(relation)
    if attribute_to_pluck.kind_of? Arel::Attributes::Attribute
      attribute_to_pluck = attribute_to_pluck.name
    end
    filtered_records = load_filtered_records(relation, params)
    filtered_records
      .joins(@prefix)
      .limit(10)
      .distinct
      .unscope(:order)
      .pluck(attribute_to_pluck)
      .map(&:to_s)
      .sort
  end

  #
  # Get the attribute to pluck based on @prefix and @column
  #
  # @example
  #   relation = Metasploit::Credential::Core.all
  #   prefix = 'public'
  #   column = 'username'
  #   attribute_to_pluck(relation) #=> <Arel::Attributes::Attribute> for 'username' in 'metasploit_credential_publics'
  #
  # @example
  #   relation = Mdm::Host.all
  #   prefix = nil
  #   column = :os_name
  #   attribute_to_pluck(relation) #=> :os_name
  #
  # @param [ActiveRecord::Relation] relation
  #
  # @return [Arel::Attributes::Attribute or Symbol] attribute to pluck
  #
  def attribute_to_pluck(relation)
    if @prefix
      association_class_name = association_class_name(relation.name.constantize, @prefix)
      association_class_name[@column]
    else
      @column
    end
  end

  #
  # Get the class name of a Model's association
  #
  # @example association_class_name(Mdm::Host, :tags) #=> Mdm::Tag
  #
  # @param [ApplicationRecord] parent_class ex. Mdm::Host
  # @param [Symbol] association ex. :tags
  #
  # @return [ApplicationRecord] the association's class name ex Mdm::Tag
  #
  def association_class_name(parent_class, association)
    parent_class.reflect_on_association(association).class_name.constantize
  end


  def validate_filter_params!(relation, params)
    raise ArgumentError, "method requires a relation argument " if relation.nil?
    raise ArgumentError, "params hash requires a 'column'" if params['column'].nil?
  end

end
