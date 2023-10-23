module Mdm
  class LootIndexPresenter < DelegateClass(Loot)
    include Mdm::AnalysisTabPresenter
    include Rails.application.routes.url_helpers
    include ERB::Util

    def as_json(opts={})
      super.merge!(
          'host.name'  => host_name_html,
          'size'       => ( size.to_s + " bytes" ),
          'data'       => loot_data_html
      )
    end

    private

    # Generate the markup for the Mdm::Loot data.
    #
    # @return [String] the markup html
    def loot_data_html
      data = if image?
               "<a href='#{h loot_path(self)}'><img src='#{h loot_path(self)}'' width='640' height='480' border='0'></a>"
             elsif binary?
               h sniff.to_s[0,32].unpack("C*").map{|x| "%.2x" % x}.join(" ")
             else
               h sniff
             end
      data_html = "<div class='loot-data invisible'>#{data}</div>"
      data_html += "<div style='float:left;'>"
      data_html += link_to("View", '#', :class => "loot-data-view report_view")
      data_html += "&nbsp;|&nbsp;"
      data_html += link_to("Download", loot_path(self, :disposition => 'attachment'), :class => "report_download")
      data_html
    end
  end
end
