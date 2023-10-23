module Mdm::WebVulnsHelper
  def mdm_web_vuln_risk_class(options={})
    options.assert_valid_keys(:risk, :web_vuln)

    classes = [
        'mdm-web-vuln-risk'
    ]

    risk = options[:risk]

    if risk
      risk_label = Mdm::WebVuln.risk_label(risk)
    end

    unless risk_label
      web_vuln = options[:web_vuln]

      if web_vuln
        risk_label = web_vuln.risk_label
      else
        raise ArgumentError, 'Either set :risk explictly or pass :web_vuln to use its risk_label'
      end
    end

    risk_label_class = risk_label.underscore.gsub('_', '-')
    classes << risk_label_class
    risk_class = classes.join(' ')

    risk_class
  end


  def mdm_web_vuln_risk_tag(options={})
    options.assert_valid_keys(:content, :risk, :web_vuln)

    klass = mdm_web_vuln_risk_class(
        :risk => options[:risk],
        :web_vuln => options[:web_vuln]
    )
    tag = content_tag(
        :div,
        options[:content],
        :class => klass
    )

    tag
  end
end
