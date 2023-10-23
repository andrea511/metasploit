module Apps
  class AppRunPresenter < Struct.new(:relation, :params)
    include ActionView::Helpers::DateHelper
    include Apps::AppPresenters::Status

    # @return [String] containing JSON data
    def to_json
      # allow us to pass both a single model and a relation!
      if relation.is_a? Apps::AppRun and params[:collection].present?
        presenter = get_specific_app_presenter(relation.app.symbol, relation.id)
        data = presenter.new(relation).collection(params[:collection].to_sym)
        DataTableQueryResponse.build(params, data)
      else
        runs = [relation.as_json(
          :include => [:app, :tasks, :run_stats]
        )].flatten

        # modify the result Array of Hashes
        runs.map! do |app_run|
          # Alleviate problems with using symbols vs. strings as keys
          app_run = ActiveSupport::HashWithIndifferentAccess.new(app_run)

          humanize_started_at!(app_run)

          presenter = get_specific_app_presenter(app_run[:app]['symbol'], app_run['id'])
          if presenter
            app_run[:app].merge!(presenter.metadata)

            app_run_presentation = presenter.new(app_run)

            app_run.merge!(app_run_presentation.as_json)

            # Be sure to use the status from the AppRun's presenter, if it's overridden.
            app_run[:status] = app_run_presentation.status_for_app_run(app_run)
          else
            app_run[:status] = status_for_app_run(app_run)
          end

          app_run[:tasks].map! { |t| ({ :id => t['id'], :presenter => t['presenter'] }) }
          app_run[:config] = nil
          statcols = ['name', 'data']
          app_run[:run_stats].map!{ |rs| rs.select! { |k,v| statcols.include?(k) } }

          app_run
        end

        if relation.is_a? Apps::AppRun
          runs[0]
        else
          runs
        end
      end.to_json(:except => :config)
    end

    private

    # @return [Class] of specific Presenter for that Run's App
    def get_specific_app_presenter(sym, app_run_id)
      begin
        "Apps::AppPresenters::#{sym.camelize}".constantize
      rescue NameError
        # look at the task to see if we use the TaskPresenter paradigm
        nil
      end
    end

    # Humanizes the started_at timestamp on an Apps::AppRun
    # @param [Apps::AppRun] app_run
    def humanize_started_at!(app_run)
      app_run["started_at"] = if app_run["started_at"].present?
        "#{distance_of_time_in_words_to_now(app_run["started_at"])} ago"
      else
        nil
      end
    end
  end
end
