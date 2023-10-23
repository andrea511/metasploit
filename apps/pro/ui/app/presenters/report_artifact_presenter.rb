class ReportArtifactPresenter < DelegateClass(ReportArtifact)
  include ActionView::Helpers

  def pretty_created_at
    l(created_at, format: :short_datetime)
  end

  def pretty_accessed_at
    l(accessed_at, format: :short_datetime) if accessed_at
  end
end