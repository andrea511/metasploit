require 'csv'

#
# The TableResponder wraps a JSON collection response in a hash that includes
# some metadata useful for rendering various UI table components.
#
# When the :ui param is present in the request, the wrapper hash is added.
# Otherwise the collection (with available scopes applied) is rendered as
# a JSON array.
#
module TableResponder
  extend ActiveSupport::Concern

  include DataResponder

  # Called when the TableResponder module is mixed into a controller
  def self.included(base)
    # using TableResponder implies that we will be responding to json
    if base.respond_to? :respond_to
      base.respond_to :csv
      base.respond_to :json
    end

    # ensure that the controller has some default scopes for paginating
    if base.respond_to? :has_scope
      base.has_scope :page, default: 1, if: :should_apply_pagination?
      base.has_scope :per, as: :per_page, default: 20, if: :should_apply_pagination?
    end
  end

  # Applies scopes and wraps the collection in a hash if necessary
  #
  # This method does Too Much (TM).
  #
  # @param relation [ActiveRecord::Relation] the collection to render
  # @param opts [Hash] @see #as_json opts
  # @option opts :presenter_class [Class] a presenter class to use for json generation
  # @option opts :as_json [Lambda] an as_json callback that accepts the Record as an
  #   argument and returns a Hash. To be used for one-off row presenters. Setting this
  #   option AND the `:presenter_class` option is undefined.
  #
  # @return [Hash] wrapped response if the :ui key is present in the HTTP request
  # @return relation if the :ui key is not present
  def as_table(relation, opts={})
    @original_relation = relation
    relation = apply_search_scopes(relation, opts)

    # Only apply scopes if they have not already been applied
    # current_scopes method defined in has_scope gem
    #
    # TODO: We should refactor table_responder and data_responder to insure we are not invoking apply_scopes multiple times
    # Too many convuluted code paths to refactor right now See MS- 1606
    #
    relation = apply_scopes(relation) if current_scopes.empty?

    if params.has_key?(:ui) && request.format.json?
      as_table_json(
        apply_sort(relation,opts),
        opts
      )
    else
      relation = apply_sort(relation)
      if params[:ids_only]
        relation.pluck(:id).as_json(opts)
      elsif request.format.csv?
        to_csv(flatten_hashes(present_relation(relation, opts)))
      else
        flatten_hashes(present_relation(relation, opts))
      end
    end
  end

  def respond_with_table(relation, opts={})
    begin
      respond_with as_table(relation, opts)
    rescue Exception => e
      respond_with({ message: e.message }, status: :error)
    end
  end

  def is_table?
    params.has_key?(:ui) && request.format.json?
  end

  # Select records based on the selection data from the UI table.
  #
  # @param opts [Hash] options containing the selection data
  # @option opts [Array<String>] :selected_ids the IDs of currently selected records
  #   in the UI table
  # @option opts [Array<String>] :deselected_ids the IDs of currently deselected records
  #   in the UI table
  # @option opts [Boolean] :select_all_state the current state of the select all
  #   checkbox in the UI table
  # @option opts [Boolean] :ignore_if_no_selections if nothing is selected, return the full
  #   {ActiveRecord::Relation}, rather than returning an empty relation (default :false)
  #
  # @return [ActiveRecord::Relation] the records currently selected in the UI table
  def selected_records(relation, opts={})
    opts.reject! { |key, value| value.to_s.empty? }
    opts.reverse_merge! ignore_if_no_selections: false

    klass = class_for_relation(relation)

    # Only apply scopes if they have not already been applied
    # current_scopes method defined in has_scope gem
    relation = apply_scopes(relation) if current_scopes.empty?

    if opts[:select_all_state] == "true"
      # Some records deselected.
      if opts[:deselected_ids].try(:any?)
        relation.where("#{klass.table_name}.id NOT IN (?)", opts[:deselected_ids])
      # All records selected.
      else
        relation
      end
    else
      # Some records selected.
      if opts[:selected_ids].try(:any?)
        relation.where("#{klass.table_name}.id IN (?)", opts[:selected_ids])
      # No records selected.
      else
        if opts[:ignore_if_no_selections]
          relation
        else
          relation.none
        end
      end
    end
  end

  # Fetch records based on the selection params. For use in analysis tabs (which
  # is why we're including hosts).
  #
  # @example Fetch records for an analysis tab
  #    records_from_selection_params( params[:class], params[:selections] )
  #
  # @param klass [String] the downcased name of the class to fetch, sans namespace
  # @param selection_params [Hash] the raw params[:selections]
  #
  # @return [ActiveRecord::Relation] the selected records
  def records_from_selection_params(klass, selection_params)
    relation = case klass
               when 'host'
                 Mdm::Host
               when 'note'
                 Mdm::Note
               when 'service'
                 Mdm::Service
               when 'vuln'
                 Mdm::Vuln
               when 'web_vuln'
                 Mdm::WebVuln
               when 'loot'
                 Mdm::Loot
               when 'module_detail'
                 Mdm::Module::Detail
               end

    selections = selected_records(relation, selection_options(selection_params))

    unless relation == Mdm::Host
      selections = selections.includes(:host)
    end

    if relation == Mdm::WebVuln
      selections = selections.includes(:web_site, :service)
    end

    selections
  end

  private

  # Generate a properly formatted object of table selection state options based
  # on the passed selection state parameters.
  #
  # @param selection_params [Hash] the raw params[:selections]
  #
  # @return [Hash] the properly formatted selection state options
  def selection_options(selection_params)
    {
        select_all_state: (selection_params[:select_all_state] == 'true' ? true : false),
        selected_ids:     selection_params[:selected_ids].split(','),
        deselected_ids:   selection_params[:deselected_ids].split(',')
    }
  end

  # Override to pass a custom
  # @return [ApplicationRecord] model to use for applying search filters
  def search_operator_class
    controller_path.classify.constantize
  end

  # Run the objects in the relation collection through the provided presenter class.
  #
  # @param relation [ActiveRecord::Relation] the collection to be presented
  # @param opts [Hash] @see #as_table opts
  # @option opts [Class] :presenter_class a presenter class to use for json generation
  #
  # @return [Array<Hash>]
  def present_relation(relation, opts)
    unless opts.has_key?(:presenter_class) or opts.has_key?(:as_json)
      relation.as_json(opts)
    else
      if opts.has_key? :as_json
        relation.collect do |record|
          opts[:as_json].call(record)
        end
      else
        presenter_class = opts.delete(:presenter_class)
        relation.collect do |record|
          presenter_class.new(record).as_json(opts)
        end
      end
    end
  end

  # Wraps the data up in a metadata hash
  #
  # @param relation [ActiveRecord::Relation] the collection to render
  # @param opts [Hash] @see #as_table opts
  # @option opts [Class] :presenter_class a presenter class to use for json generation
  # @option opts [Class] :total_count a static count to use as "total count" in the table
  #
  # @return [Hash] a wrapped hash containing the original collection
  def as_table_json(relation, opts={})
    total_pages = if opts.has_key? :total_count
                    (opts[:total_count].to_f/params[:per_page].to_f).ceil
                  else
                    begin
                      relation.page.total_pages
                    rescue => e
                      if relation.count >= params[:per_page].to_i
                        (relation.count.to_f/params[:per_page].to_f).ceil
                      else
                        1
                      end
                    end
                  end
    total_count = begin
                    relation.page.total_count
                  rescue => e
                    relation.count
                  end
    {
      collection: flatten_hashes(present_relation(relation, opts)),
      total_pages: total_pages,
      total_count: opts[:total_count] || total_count
    }
  end

  # Converts nested subhashes into top-level "dot" accessors
  #  (so {a: {b: 1}} becomes {'a.b': 1})
  #
  # XXX: looking back, I should not have done this. I should have set up
  #  the client to do the nested unwinding, instead of doing potentially
  #  hundreds of gsubs server-side. For now we live with this. I'm sorry.
  #
  # @param array [Array<Hash>] an array of hashes to encode
  # @return [Hash] where nested subhash keys have been expanded to dot
  #   accessors
  def flatten_hashes(array)
    array.map do |hash|
      hash.to_param.split('&').each_with_object({}) do |str, obj|
        key, val = str.split('=').map { |str| CGI::unescape(str) }
        unless key.nil?
          key.gsub!('[]', '') # collapses many-to-many associations, sorry.
          key.gsub!('[', '.')
          key.gsub!(']', '')
          obj[key] = val
        end
      end
    end
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

  def should_apply_pagination?
    not (params.has_key?(:ids_only) || params.has_key?(:ignore_pagination) || request.format.csv?)
  end

  def to_csv(collection=[])
    CSV.generate do |csv|
      csv << params[:columns]
      collection.each do |result|
        csv << params[:columns].collect { |col| result[col] }
      end
    end
  end

end
