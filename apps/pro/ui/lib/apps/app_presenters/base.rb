# Apps::AppPresenters::Base enables you to write a Presenter subclass
# for AppRuns that is specific to the App type. It is used to list
# app-specific data that gets sent to the Findings/stats views, but
# NOT in the index JSON.
module Apps
module AppPresenters
  class Base
    attr_reader :app_run

    include Apps::AppPresenters::Status

    # @param app_run [Apps::AppRun] instance
    def initialize(app_run)
      @app_run = app_run  
    end

    # @return [Array] of key -> RunStat name (or an array of RunStat names), 
    # for rendering client side in the row in the AppRuns list view
    def self.row_stats; []; end

    # @return [Array] of key -> RunStat name (or a Hash with multiple RunStat names,
    # e.g. for rendering pie chart), for rendering the stats views
    def self.stats; []; end

    # @return [Array] of [numerator_stat_name, denominator_stat_name]
    # @return nil if percentage does not apply to your App
    def self.percentage; nil; end

    # @return [Hash] of keys -> returned values of above static methods.
    # If you want to return more static data about a specific app, override this
    # method and return super.merge(..extra data..)
    def self.metadata
      {
        :row_stats => row_stats,
        :stats => stats,
        :humanized_map => {},
        :percentage => percentage
      }
    end

    # any extra data you want to send back to the poll request
    def extra_data; {}; end

    # @return [Hash] of AppRun specific data. Override to pass more data back to the stats view.
    def as_json
      { :status => status_for_app_run(app_run) }.merge(extra_data)
    end

    def h(str)
      ERB::Util.h(str)
    end
  end
end
end
