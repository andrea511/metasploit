module Metasploit::Pro::ConnectionAdapters::SchemaStatements
  # @see https://github.com/Empact/rails/blob/dbe40957bceffb04fb5b6e4dc7c8239b0c36eee6/activerecord/lib/active_record/connection_adapters/abstract/schema_statements.rb#L713
  def distinct
    "DISTINCT #{distinct_columns(columns, order_by).join(', ')}"
  end

  # @see https://github.com/Empact/rails/blob/dbe40957bceffb04fb5b6e4dc7c8239b0c36eee6/activerecord/lib/active_record/connection_adapters/abstract/schema_statements.rb#L721
  def distinct_columns(columns, order_by)
    [columns]
  end
end