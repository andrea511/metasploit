module Metasploit
  module Pro
    # Modifies Msf::DBManager::ImportMsfXml so that it can handle Pro's export format for Mdm::WebVuln from
    # auxiliary/pro/report #extract_web_vuln_info.
    module ImportMsfXml
      MSF_WEB_VULN_TEXT_ELEMENT_NAMES = Msf::DBManager::Import::MetasploitFramework::XML::MSF_WEB_VULN_TEXT_ELEMENT_NAMES.reject { |element_name|
        # category and proof could either be in the old or the new format, so handle both
        ['category', 'proof'].include? element_name
      }

      def import_msf_web_vuln_element(element, options={}, &notifier)
        options.assert_valid_keys(:allow_yaml, :workspace)

        import_msf_web_element(element,
                               :allow_yaml => options[:allow_yaml],
                               :notifier => notifier,
                               :workspace => options[:workspace],
                               :type => :vuln) do |element, options|
          info = {}

          MSF_WEB_VULN_TEXT_ELEMENT_NAMES.each do |name|
            element_info = import_msf_text_element(element, name)
            info.merge!(element_info)
          end

          element_info = import_msf_web_vuln_category_element(element)
          info.merge!(element_info)

          confidence = info[:confidence]

          if confidence
            info[:confidence] = confidence.to_i
          end

          element_info = import_msf_web_vuln_params_element(
              element,
              :allow_yaml => options[:allow_yaml]
          )
          info.merge!(element_info)

          element_info = import_msf_web_vuln_proofs_element(element)
          info.merge!(element_info)

          risk = info[:risk]

          if risk
            info[:risk] = risk.to_i
          end

          info
        end
      end

      def import_msf_web_vuln_params_element(element, options)
        options.assert_valid_keys(:allow_yaml)

        element_info = {}
        params_element = element.at('params')

        params_element.xpath('param').each do |param_element|
          name = param_element.at('name').text.to_s.strip
          value = param_element.at('value').text.to_s.strip

          param = [name, value]
          element_info[:params] ||= []
          element_info[:params] << param
        end

        # no params/param elements, so must be 4.5 format
        if element_info[:params].nil?
          # FIXME https://www.pivotaltracker.com/story/show/46578647
          # FIXME https://www.pivotaltracker.com/story/show/47128407
          unserialized_params = unserialize_object(
              element.at('params'),
              options[:allow_yaml]
          )
          element_info[:params] = nils_for_nulls(unserialized_params)
        end

        element_info
      end

      private

      def import_msf_web_vuln_category_element(element)
        category_element = element.at('category')

        # could either be 4.5 format or 4.6 format
        if category_element
          # prefer category/name element
          element_info = import_msf_text_element(category_element, 'name')

          # if no category/name element then fall back to 4.5 format of
          # category containing text
          if element_info.empty?
            element_info = import_msf_text_element(element, 'category')
          else
            # map to correct attribute for report_web_vuln.
            element_info[:category] = element_info.delete(:name)
          end
        # 4.6 format, but with legacy_category instead of category.name
        else
          element_info = import_msf_text_element(element, 'legacy-category')
          element_info[:category] = element_info.delete(:legacy_category)
        end

        element_info
      end

      def import_msf_web_vuln_proofs_element(element)
        element_info = {}

        # 4.6 format
        # TODO https://www.pivotaltracker.com/story/show/43338629
        element.xpath('proofs/proof/text').each do |proof_text_element|
          proof_attributes = {}
          proof_attributes[:text] = proof_text_element.text.to_s.strip

          element_info[:proofs_attributes] ||= []
          element_info[:proofs_attributes] << proof_attributes
        end

        element_info
      end
    end
  end
end