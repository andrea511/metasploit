module TableResponder::UiScopes

  def self.included(klass)
    klass.scope :with_ids, -> ids { klass.where(id: ids.split(',')) }
    klass.scope :ids_only, -> { klass.select(klass.arel_table[:id]) }
  end

end