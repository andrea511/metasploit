# Entry-point for requiring this engine.

# Declare the Apps::Domino namespace
module Apps; module Domino

  def self.table_name_prefix
    'mm_domino_'
  end

end; end

# Load the actual engine
require 'apps/domino'
require 'apps/domino/engine'
