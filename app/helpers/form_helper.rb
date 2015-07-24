module FormHelper

	def custom_form_for(record_or_name_or_array, *args, &block)
		args[0] ||= {}
		args[0].deep_merge!({ builder: CustomFormBuilder, is_admin: !params[:is_admin].blank? })

		form_for(record_or_name_or_array, *args, &block)
	end

	def options_for_select_boolean(value = nil)
		options_for_select([['Oui', true], ['Non', false]], value)
	end

	class CustomFormBuilder < ActionView::Helpers::FormBuilder

		alias :old_text_field :text_field

		def is_admin?
			self.options[:is_admin]
		end

		def email_field(method, options = {})
			options[:class] = (options[:class].blank? ? 'jt-validation-email' : options[:class].to_s + ' jt-validation-email')

			placeholder = placeholder(method)
			options[:placeholder] = placeholder if placeholder
			options[:required] = true if options[:required].nil? && !is_admin?

			custom_field(method, options[:info]) do
				super(method, options)
			end
		end

		# non utilisé car quand on utilise la roulette de la souris fait defiler les nombres
		# du coup pas top sur pc quand on scroll
		def number_field(method, options = {})
			options[:class] = (options[:class].blank? ? 'jt-validation-number' : options[:class].to_s + ' jt-validation-number')

			options[:min] = 1
			if options[:max]
				options[:maxlength] = options[:max].to_s.size
			end

			return text_field(method, options)

			placeholder = placeholder(method)
			options[:placeholder] = placeholder if placeholder
			options[:required] = true if options[:required].nil? && !is_admin?

			custom_field(method, options[:info]) do
				super(method, options)
			end
		end

		def text_field(method, options = {})
			placeholder = placeholder(method)
			options[:placeholder] = placeholder if placeholder
			options[:required] = true if options[:required].nil? && !is_admin?

			custom_field(method, options[:info]) do
				super(method, options)
			end
		end	

		def place_field(method, options = {})
			options[:class] = (options[:class].blank? ? 'jt-validation-autocomplete' : options[:class].to_s + ' jt-validation-autocomplete')

			placeholder = placeholder(method)
			options[:placeholder] = placeholder if placeholder
			options[:required] = true if options[:required].nil? && !is_admin?

			output = old_text_field(method.to_s + '_search', options)

			for attr in Localizable::FIELDS
				output += hidden_field(method.to_s + "_#{attr}")
			end

			custom_field(method, options[:info]) do
				output
			end
		end
	
		def text_area(method, options = {})
			placeholder = placeholder(method)
			options[:placeholder] = placeholder if placeholder
			options[:required] = true if options[:required].nil? && !is_admin?

			custom_field(method, options[:info]) do
				super(method, options)
			end			
		end

		def select(method, choices, options = {}, html_options = {})
			placeholder = placeholder(method)
			options[:prompt] = placeholder if placeholder
			html_options[:required] = true if html_options[:required].nil? && !is_admin?

			custom_field(method) do
				super(method, choices, options, html_options)
			end
		end				

		def fields_for(record_name, record_object = nil, options = {}, &block)
			custom_field(record_name) do
				"#{super(record_name, record_object, options, &block)}<div class=\"clear\"></div>"
			end
		end

		# def date_select(method, options = {}, html_options = {})
		# 	custom_field(method) do
		# 		"#{super(method, options, html_options)}#{error_field(method)}".html_safe
		# 	end
		# end		

		# def datetime_select(method, options = {}, html_options = {})
		# 	custom_field(method) do
		# 		"#{super(method, options, html_options)}".html_safe
		# 	end
		# end				

		# def file_field(method, options = {})
		# 	custom_field(method) do
		# 		"#{super(method, options)}#{error_field(method)}"
		# 	end
		# end			

		# def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
		# 	custom_field(method) do
		# 		"<label class='checkbox'>#{super(method, options, checked_value, unchecked_value)}#{options[:text]}</label>#{error_field(method)}".html_safe
		# 	end			
		# end		

		def submit(value = nil, options = {})
			value ||= "Terminer"
			
			"<div class=\"row\">
				<div class=\"cl-10\">
				</div>
				<div class=\"cl-2\">
					<button class=\"button orange\">#{value}</button>
				</div>
			</div>".html_safe
		end

		private

		def custom_field(method, info = nil, &block)
			"<div class=\"row\">
				<div class=\"cl-3\">
					<div class=\"right\">
						#{label method}
					</div>
				</div>
				<div class=\"cl-6\">
					<div class=\"input#{have_error?(method) ? ' error' : ' '}\">
						#{yield(block)}
						#{info ? "<div class=\"info\">#{info}</div>" : ''}
					</div>
				</div>
				<div class=\"cl-3\">
					#{error_field(method)}
				</div>
			</div>".html_safe
		end

		def have_error?(method)
			@object.errors[method].size > 0
		end

		def error_field(method)
			if @object.errors[method].size > 0
				"<div class=\"error-message\">
					<p>#{@object.errors[method].join(', ')}</p>
				</div>".html_safe
			end			
		end

		def placeholder(method)
			placeholder = I18n.t("activerecord.attributes.#{@object.class.to_s.underscore}.#{method}_placeholder")
			placeholder = nil if placeholder.start_with?('translation missing')
			placeholder
		end

	end

end