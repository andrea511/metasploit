module Apps::AppPresenters::Status

  # @return [Symbol] status of the AppRun ([:preparing, :running, :finished, :aborted, :failed])
  def status_for_app_run(app_run)
    if Apps::AppRun::STOPPED_STATES.include?(app_run['state'].to_sym)
      state = app_run['state'].to_sym # rewrite completed -> finished to match SE
      translations = {
        :completed => :finished,
        :aborted => :stopped
      }
      state = translations[state] || state
    elsif app_run['started_at'].nil?
      :preparing
    else
      :running
    end
  end

end
