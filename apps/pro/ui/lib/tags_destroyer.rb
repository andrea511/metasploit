class TagsDestroyer
  attr_reader :listener

  def initialize(listener)
    @listener = listener
  end

  def destroy(ids)
    if ids.blank?
      listener.destroy_without_tags_failed
    else
      Mdm::Tag.destroy(ids)
      listener.destroy_tags_successful(ids.size)
    end
  end
end
