module Mdm
  class ModuleDetailIndexPresenter < DelegateClass(Mdm::Module::Detail)

    include ApplicationHelper
    include RefHelper
    include Mdm::AnalysisTabPresenter

    include Presenters::OsIcons
    include Presenters::Rating

    def as_json(opts={})
      @opts = opts
      response_json = super(except:[:platform_names, :target_names, :action_names])
      module_vulns = module_vulns_attributes
      module_hosts = module_hosts_attributes
      response_json.merge!(
          'ref_count' => ref_count,
          'rating' => rating(rank),
          # Because table responder flattens hashes :-(
          'module_icons' => module_icons(
              platform_names,
              target_names,
              action_names
          ).to_json,
          'ref_link' => ref_link,
          'ref_names' => ref_names,
          'module_vulns' => module_vulns.to_json,
          'module_vulns_count' => module_vulns.count,
          'hosts' => module_hosts.to_json,
          'module_hosts_count' => module_hosts.count,
          'disclosure_date' => disclosure_date.strftime('%B %d, %Y'),
          'info' => info
      )

      # The scope selects "fullname" as "module", so we have to use that instead of "fullname"
      # match_id = MetasploitDataModels::AutomaticExploitation::Match.for_vuln_and_module_fullname(opts[:vuln], __getobj__.module).pluck(:id).first
      # if match_id.present?
      #   response_json.merge!({'match_id' => match_id})
      # end

      response_json
    end

    def ref_count
      ref_names.uniq.size
    end

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

    def workspace_vuln_ids
      @opts[:vulns].pluck(:id)
    end

    def module_vulns
      Mdm::Vuln.for_module(__getobj__.module).where(id: workspace_vuln_ids)
    end

    def module_vulns_attributes
      module_vulns.map(&:attributes)
    end

    def module_hosts_attributes
      module_vulns.map do |vuln|
        host_id = vuln.host.id
        host = Mdm::Host.find(host_id)
        {
            id: host_id,
            address: host.address,
            name: host.name || host.address,
            service_names: host.services.map(&:name).uniq
        }
      end.uniq
    end

  end
end
