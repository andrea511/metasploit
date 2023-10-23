# Monkey patch to fix "NoMethodError: undefined method `gsub' for #<Arel::Nodes::Ascending:...>" in rails 3.2.
# This problem is fixed in Rails 4.
#
# @see https://github.com/rails/rails/issues/5868
module Metasploit::Pro::ConnectionAdapters::PostgreSQLAdapter
  extend ActiveSupport::Concern

  included do
    # remove distinct so super method is used
    # remove_method :distinct
  end

  # Returns an array of columns for a SELECT DISTINCT clause representing a given set of columns and a given ORDER BY clause.
  #
  # PostgreSQL requires the ORDER BY columns in the select list for distinct queries, and
  # requires that the ORDER BY include the distinct column.
  #
  #   distinct_columns("posts.id", ["posts.created_at desc"])
  #   # => ["posts.id", "posts.created_at AS alias_0"]
  # @see https://github.com/Empact/rails/blob/dbe40957bceffb04fb5b6e4dc7c8239b0c36eee6/activerecord/lib/active_record/connection_adapters/postgresql/schema_statements.rb#L476
  def distinct_columns(columns, orders) #:nodoc:
    order_columns = orders.map{ |s|
      # Convert Arel node to string
      s = s.to_sql unless s.is_a?(String)
      # Remove any ASC/DESC modifiers
      s.gsub(/\s+(ASC|DESC)\s*(NULLS\s+(FIRST|LAST)\s*)?/i, '')
    }.reject(&:blank?).map.with_index { |column, i| "#{column} AS alias_#{i}" }

    super.concat(order_columns)
  end
end