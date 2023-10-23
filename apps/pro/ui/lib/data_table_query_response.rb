# DataTableQueryResponse is used to "wrap" an ActiveRecord::Relation of results
# and automatically apply the pagination and filtering logic that DataTables expects.
#
# The first way to use DataTableQueryResponse is to pass the Relation and params in
# one call to #build. You can also specify post-mutation logic of the JSON records:
#
# ... in your controller ...
# render :json => DataTableQueryResponse.build(params, {
#   :collection => @workspace.opened_emails.active,
#   :columns => ['name', 'sender', 'created_at'],
#   :search_cols => ['name', 'sender'],
#   :render_row => lambda { |record| { 'receiver' => 'Unknown' } }
# })
#
# The :render_row option allows you to pass in a lambda, which is called on every row
# of the table, is passed the Hash representation of the row, and optionally returns a Hash
# that is merge()'d into the final JSON output of that row. This lets you "wrap" rows
# with view helpers and other formatting logic.
#
# The second way to use DataTableQueryResponse is to follow the delegate pattern.
# You create a *Finder class, like OpenedEmailsFinder, which responds to the following
# delegate methods:
#
# class OpenedEmailsFinder < Struct.new(:workspace)
#   def find; @workspace.opened_emails.active; end
#   def datatable_columns; ['name', 'sender', 'created_at']; end
#   def datatable_search_columns; ['name', 'sender']; end
#   def render_row(record); { 'receiver' => 'Unknown' }; end
# end
#
# You can pass the Finder instance to DataTableQueryResponse's constructor:
#
# ... in your controller ...
# render :json => DataTableQueryResponse.new(params, OpenedEmailsFinder.new(@workspace))
#
require 'csv'

class DataTableQueryResponse < Struct.new(:finder, :params)

  # Allows you to define and build a DataTableQueryResponse on-the-fly.
  # @param params [Hash] the GET params on the request
  # @option opts [ActiveRecord::Relation] :collection the base collection
  # @option opts [Array] :columns of column names to include. These must match the
  #   attr names selected in the base collection
  # @option opts [Array] :search_cols optional list of column names that any
  #   search filters specified in the params should be applied to
  # @option opts [Hash<String, String>] :sort_map of column names -> database column names,
  #   used to handle sorting
  # @option opts [Lambda] :render_row optional lambda for mutating the JSON row representation
  #   this is useful for reusing Rails helpers
  # @return [DataTableQueryResponse] scoped to the right collection, to call .to_json on
  def self.build(params, opts={})
    collection   = opts.fetch(:collection)
    cols         = opts.fetch(:columns)
    search_cols  = opts.fetch(:search_cols, [])
    virtual_cols = opts.fetch(:virtual_cols, [])
    sort_map     = opts.fetch(:sort_map, {})
    render_fn    = opts.fetch(:render_row, lambda{ |row| nil })
    # dynamically build a Finder class based on the opts
    klass = Class.new(Struct.new(:collection, :cols, :search_cols, :sort_map, :render_fn)) do
      def find; collection; end
      def datatable_columns; cols; end
      def datatable_search_columns; search_cols; end
      def datatable_sort_map; sort_map; end
      def render_row(model); render_fn.call(model); end
    end
    # instantiate and pass required data to the instance
    instance = klass.new(collection, cols, search_cols, sort_map, render_fn)
    # return initialized DataTableQueryResponse object, for as_json'ing
    DataTableQueryResponse.new(instance, params)
  end

  def columns
    finder.datatable_columns
  end

  def search_columns
    finder.datatable_search_columns
  end

  # use this method to describe columns that don't belong to the
  # actual table we are query (e.g. columns renamed with an AS)
  def virtual_columns
    begin
      finder.datatable_virtual_columns
    rescue NoMethodError
      []
    end
  end

  def sort_map
    begin
      finder.datatable_sort_map
    rescue NoMethodError
      {}
    end
  end

  # override to modify the JSON data on-the-fly
  # @return [Hash] to be merged into the row if you want to override row JSON data
  # @return nil if you don't want to modify the row's JSON data
  def render_row(record)
    if finder.respond_to?(:render_row)
      finder.render_row(record)
    end
  end

  def current_page
    start = params[:iDisplayStart].to_i
    start / per_page + 1
  end

  def per_page
    display_len = params[:iDisplayLength].to_i
    if display_len > 0
      display_len
    else
      20
    end
  end

  # @return [ActiveRecord::Relation] and memoize the results of the .find
  def collection
    @collection ||= finder.find
  end

  # @return [Array] of conditions checking every field
  # e.g. ["name ILIKE ? OR email ILIKE ?", '%joe%', '%joe%']
  def conditions
    return "" unless params[:sSearch].present?
    statements = search_columns.collect { |col| "#{col} ILIKE ?" }
    values = Array.new(statements.size) { "%#{params[:sSearch]}%" }
    [statements.join(' OR '), *values]
  end

  # @return [String] direction of SQL ORDER: 'ASC' or 'DESC'
  def order_direction
    dir = (params[:sSortDir_0] || 'ASC').upcase
    return 'ASC' unless ['ASC', 'DESC'].include? dir
    dir
  end

  # @return [String] SQL's ORDER clause e.g. "email_address ASC"
  def order_string
    return "" unless params[:iSortCol_0].present?
    col_num = params[:iSortCol_0].to_i
    col_name = columns.at(col_num) || columns.first
    klass = begin
      collection.klass 
    rescue NoMethodError
      collection
    end
    col_attrs = klass.columns_hash[col_name.to_s]
    if col_attrs && col_attrs.type == :string && col_attrs.sql_type != 'inet'
      # (LOWER() is required for case-insensitive compares in psql)
      "LOWER(#{klass.table_name}.#{col_name}) #{order_direction}"
    else
      # if we have specified that this is a renamed column, DONT include table name
      if virtual_columns.include? col_name
        "#{col_name} #{order_direction}"
      else
        if col_attrs.present?
          # column matches a column in the current table
          "#{klass.table_name}.#{col_name} #{order_direction}"
        elsif sort_map.present? and sort_map.has_key? col_name
          # this is to help prevent ambiguous matches on the ORDER column
          "#{sort_map[col_name]} #{order_direction}"
        else
          # no matching columns in the current table
          "#{col_name} #{order_direction}"
        end
      end
    end
  end

  # @return [Integer] size of the entire collection we're paginating
  def total_count
    collection.length
  end

  # @return [Integer] size of the *filtered* collection we're paginating
  def scoped_count
    collection.where(conditions).length
  end

  # @return [ActiveRecord::Relation] the scoped AR query
  def find
    collection.where(conditions)
              .reorder(Arel.sql(order_string))
              .page(current_page)
              .per(per_page)
  end

  # @return [Array<Hash>] an array of Hashes, each representing a row
  def rows_json
    records = find
    data_rows = records.as_json(:only => columns)
    records.each_with_index do |record, i|
      data_rows[i].merge!(render_row(record) || {})
    end
    data_rows
  end

  # @return [Hash] formatted JSON output data
  def as_json(options={})
    {
      :iTotalRecords => total_count,
      :iTotalDisplayRecords => scoped_count,
      :sEcho => params[:sEcho].to_i,
      :sColumns => columns.join(','),
      :aaData => rows_json
    }
  end

  # @return [String] formatted CSV output data
  def to_csv
    CSV.generate do |csv|
       csv << columns
       collection.each do |result|
         csv << columns.collect { |col| result[col] }
       end
    end
  end
end
