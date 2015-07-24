module MetaHelper

	def print_meta_title
		if @meta[:title]
			"#{@meta[:title]} - #{t('meta.title.global')}"
		else
			t('meta.title.global')
		end
	end

	def print_meta_description
		if @meta[:description]
			@meta[:description]
		else
			t('meta.description.global')
		end
	end

	def print_meta_keywords
		if @meta[:keywords]
			@meta[:keywords].to_s + ', ' + t('meta.keywords.global')
		else
			t('meta.keywords.global')
		end
	end

	def print_meta_image_url
		if @meta[:image_url]
			@meta[:image_url]
		else
			image_url 'application/logo-full.png'
		end
	end

end