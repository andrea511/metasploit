module Mdm::Task::PresenterClass

  # Returns the Ruby class for the Presenter that renders the JSON
  # statistics for this task's data and related table collections.
  #
  # @return [Tasks::BasePresenter] task-specific subclass of Tasks::BasePresenter
  def presenter_class
    if presenter.present?
      begin
        "Tasks::#{presenter.camelize}Presenter".constantize
      rescue NameError
        nil
      end
    end
  end

end
