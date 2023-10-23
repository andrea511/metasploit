module Metasploit::Pro::FinderMethods
  extend ActiveSupport::Concern

  # @see https://github.com/Empact/rails/blob/dbe40957bceffb04fb5b6e4dc7c8239b0c36eee6/activerecord/lib/active_record/relation/finder_methods.rb#L246
  def construct_limited_ids_condition_with_distinct_columns(relation)
    orders = relation.order_values.map { |val| val.presence }.compact
    values = @klass.connection.distinct_columns("#{quoted_table_name}.#{quoted_primary_key}", orders)

    relation = relation.dup.select(values).distinct

    id_rows = @klass.connection.select_all(relation.arel, 'SQL', relation.bind_values)
    ids_array = id_rows.map {|row| row[primary_key]}

    ids_array.empty? ? raise(ActiveRecord::ThrowResult) : table[primary_key].in(ids_array)
  end
end
