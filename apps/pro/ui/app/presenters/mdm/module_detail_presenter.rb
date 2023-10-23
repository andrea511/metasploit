module Mdm
  class ModuleDetailPresenter < DelegateClass(Mdm::Module::Detail)

    include Presenters::OsIcons
    include Presenters::Rating

    def as_json(opts={})
      response_json = super(except:[:platform_names, :target_names, :action_names])
      response_json.merge!(
        'ref_count' => ref_count,
        'rating' => rating(rank),
        # Because table responder flattens hashes :-(
        'module_icons' => module_icons(
          platform_names,
          target_names,
          action_names
        ).to_json
      )

      # The scope selects "fullname" as "module", so we have to use that instead of "fullname"
      match_id = MetasploitDataModels::AutomaticExploitation::Match.for_vuln_and_module_fullname(opts[:vuln], __getobj__.module).pluck(:id).first
      if match_id.present?
        response_json.merge!({'match_id' => match_id})
      end

      response_json
    end

    def ref_count
      ref_names.uniq.size
    end

  end
end
