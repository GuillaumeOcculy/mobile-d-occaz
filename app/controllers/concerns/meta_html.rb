module MetaHTML
	extend ActiveSupport::Concern
	
	included do
		before_action :set_meta
		before_action :set_meta_title
		before_action :set_meta_description
	end

	def set_meta
		@meta = {
		}
	end

	def set_meta_dont_index
		@meta[:no_index] = true
	end

	def set_meta_title(extra_params = {})
		if extra_params && extra_params[:force]
			@meta[:title] = extra_params[:title]
			return
		end

		page_title = I18n.translate('meta.title.' + params[:controller] + '.' + params[:action], extra_params)
		if page_title.class == String && !page_title.start_with?("translation missing")
			@meta[:title] = page_title
		else
			page_title = I18n.translate('meta.title.' + params[:controller], extra_params)
			if page_title.class == String && !page_title.start_with?('translation missing')
				@meta[:title] = page_title
			end
		end
	end

	def set_meta_description(extra_params = {})
		page_title = I18n.translate('meta.description.' + params[:controller] + '.' + params[:action], extra_params)
		if page_title.class == String && !page_title.start_with?("translation missing")
			@meta[:description] = page_title
		else
			page_title = I18n.translate('meta.description.' + params[:controller], extra_params)
			if page_title.class == String && !page_title.start_with?('translation missing')
				@meta[:description] = page_title
			end
		end
	end

	def set_meta_keywords(value)
		@meta[:keywords] = value
	end

	def set_meta_cannonical_url(url)
		@meta[:cannonical_url] = url
	end

	def set_meta_image_url(image_url)
		@meta[:image_url] = image_url
	end

end