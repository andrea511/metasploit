class Hosts::ModuleDetailPresenter < DelegateClass(Mdm::Module::Detail)

  include ActionView::Helpers::AssetTagHelper

  def as_json(opts={})
    response_json = super
    response_json.merge!(
        'module_star_icons' => module_star_icons,
        'readiness_state' => readiness_state
    )
  end

  def module_star_icons
    stars  = [(rank - 100), 0].max / 100
    ( (image_tag ActionController::Base.helpers.image_path('icons/star.png')) * stars ).html_safe
  end

  def analysis(analyze_result)
    @analyze_result = analyze_result
  end

  def readiness_state
    readiness.as_div
  end

  def readiness
    @analyze_result ||= AnalyzeResultPresenter.new()
  end
end
