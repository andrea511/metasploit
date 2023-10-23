module Mdm
  class VulnIndexPresenter < DelegateClass(Vuln)
    include ApplicationHelper
    include RefHelper
    include Mdm::AnalysisTabPresenter

    def as_json(opts={})
      result = latest_nexpose_result
      comment = latest_comment
      super.merge!(
          'host.name' => host_name_html,
          'ref_link' => ref_link,
          'ref_names' => ref_names,
          'ref_count' => ref_count,
          'vuln.latest_nexpose_result' => {
              :type => result.try(:class),
              :sent_to_nexpose => result.try(:sent_to_nexpose)
          },
          'comment.id' => comment.try(:id),
          'comment.data' => comment.try(:data)
      )
    end

    private

    def ref_names
      ref_names_array.join(', ')
    end

    def ref_names_array
      # Note #pluck would actually be slower in this case since
      # vulns have already been loaded via joins/includes
      refs.map(&:name).uniq
    end

    def ref_count
      ref_names_array.size
    end

    def ref_link
      url_for_ref(*refs.first.link_info) if ref_count == 1
    end
  end

end
