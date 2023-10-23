module Mdm
  class ServiceIndexPresenter < DelegateClass(Service)
    include Mdm::AnalysisTabPresenter

    def as_json(opts={})
      super.merge!(
        'host.name'  => host_name_html,
        'updated_at' => service_updated_at_html
      )
    end

    private

    # Generate the markup for the Mdm::Service's updated_at date.
    #
    # Returns the String markup html
    def service_updated_at_html
      updated_at.to_fs(:long)
    end
  end
end
