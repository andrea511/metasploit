module Custom
	class SemanticFormBuilder < Formtastic::FormBuilder
		def commit_button(*args)
			options = args.extract_options!
			text = options.delete(:label) || args.shift

			if @object && (@object.respond_to?(:persisted?) || @object.respond_to?(:new_record?))
				if @object.respond_to?(:persisted?) # ActiveModel
					key = @object.persisted? ? :update : :create
				else # Rails 2
					key = @object.new_record? ? :create : :update
				end

				# Deal with some complications with ApplicationRecord.human_name and two name models (eg UserPost)
				# ApplicationRecord.human_name falls back to ApplicationRecord.name.humanize ("Userpost")
				# if there's no i18n, which is pretty crappy.  In this circumstance we want to detect this
				# fall back (human_name == name.humanize) and do our own thing name.underscore.humanize ("Mdm::User Post")
				if @object.class.model_name.respond_to?(:human)
					object_name = @object.class.model_name.human
				else
					object_human_name = @object.class.human_name                # default is UserPost => "Userpost", but i18n may do better ("Mdm::User post")
					crappy_human_name = @object.class.name.humanize             # UserPost => "Userpost"
					decent_human_name = @object.class.name.underscore.humanize  # UserPost => "Mdm::User post"
					object_name = (object_human_name == crappy_human_name) ? decent_human_name : object_human_name
				end
			else
				key = :submit
				object_name = @object_name.to_s.send(label_str_method)
			end

			text = (localized_string(key, text, :action, :model => object_name) ||
					::Formtastic::I18n.t(key, :model => object_name)) unless text.is_a?(::String)

			button_html = options.delete(:button_html) || {}
			button_html.merge!(:class => [button_html[:class], key].compact.join(' '))

			wrapper_html_class = ['commit'] # TODO: Add class reflecting on form action.
			wrapper_html = options.delete(:wrapper_html) || {}
			wrapper_html[:class] = (wrapper_html_class << wrapper_html[:class]).flatten.compact.join(' ')

			accesskey = (options.delete(:accesskey) || default_commit_button_accesskey) unless button_html.has_key?(:accesskey)
			button_html = button_html.merge(:accesskey => accesskey) if accesskey
			template.content_tag(:li, ("<span class='btn'>"+submit(text, button_html)+"</span>").html_safe, wrapper_html)
		end

		# Generates the markup for an input inline-help link.
		#
		# @param method [String] the method name of the input to associate this help
    #   link with
		#
		# @return [String] the help link markup
		def help_link(method, &block)
			data_field = "#{object_name}_#{method.to_s}_input"
			help_content = template.capture(&block)
			template.content_tag(:div, :class => "inline-help", 'data-field' => data_field) do
				template.link_to(template.icon('silky/information'), '',
					:target => '_blank',
					:class => 'help',
					:'data-field' => data_field,
					:tabIndex => "-1"
				) + help_content
			end
		end
	end
end
