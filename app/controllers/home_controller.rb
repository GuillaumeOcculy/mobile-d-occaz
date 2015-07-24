class HomeController < ApplicationController
	
	def index
		@posts = Post::Post.is_public.order_by_date.limit(6).with_images.includes(:brand, :color)

		if params[:place_lat] && params[:place_lng]
			@posts = @posts.order_by_distance_from(params[:place_lat], params[:place_lng])
		end

		@posts = @posts.to_a

		# fresh_when(@posts.first) if flash.empty? && !request.xhr? && @posts.size > 0
	end

	def search
		if !request.xhr? && params[:place] && (params[:place][:lat].blank? || params[:place][:lng].blank?) && !params[:place][:search].blank?
			geocoder = Graticule.service(:google).new(GOOGLE_API_KEY)
			begin
				geo_params = { address: params[:place][:search], components: 'country:fr' }
				response = geocoder.send('make_url', geo_params).open('User-Agent' => Graticule::Geocoder::Base::USER_AGENT).read
				json = JSON.parse(response)
				result = json['results'][0]

				params[:place][:lat] = result['geometry']['location']['lat']
				params[:place][:lng] = result['geometry']['location']['lng']

			    for data in result['address_components']
			    	if data['types'][0] == 'country'
			    		params[:place][:country] = data['long_name']
			    		params[:place][:country_code] = data['short_name']
			        elsif data['types'][0] == 'administrative_area_level_1'
			        	params[:place][:region] = data['long_name']
			        	params[:place][:region_code] = data['short_name']
			        elsif data['types'][0] == 'administrative_area_level_2'
			        	params[:place][:department] = data['long_name']
			        	params[:place][:department_code] = data['short_name']
			        elsif data['types'][0] == 'locality' || data['types'][0] == 'administrative_area3'
			        	params[:place][:city] = data['long_name']
			        elsif data['types'][0] == 'postal_code'
			        	params[:place][:zip_code] = data['long_name']
			        end
			    end		
			rescue
			end
		end

		if params[:radius].blank? || params[:radius].to_i < 1
			params[:radius] = 20
		end

		if params[:amount].blank? || params[:amount].to_i < 1
			params[:amount] = 800
		end

		@posts = Post::Post.is_public.includes(:color, :memory, :state, :medias, :carrier, phone: [:brand, :os])

		@posts = @posts.search_name(params[:q])

		@posts = @posts.where('amount <= ?', params[:amount]) if !params[:amount].blank? && params[:amount].to_i < SEARCH_AMOUNT_MAX

		@posts = @posts.where(brand_id: params[:brand_ids]) if !params[:brand_ids].blank?
		@posts = @posts.where(color_id: params[:color_ids]) if !params[:color_ids].blank?
		@posts = @posts.where(memory_id: params[:memory_ids]) if !params[:memory_ids].blank?
		@posts = @posts.where(state_id: params[:state_ids]) if !params[:state_ids].blank?
		@posts = @posts.where(carrier_id: params[:carrier_ids]) if !params[:carrier_ids].blank?

	
		if !params[:os_ids].blank? || !params[:features].blank?

			# 1st method, seems to be faster

			phones = Phone::Phone.select(:id)

			phones = phones.where(os_id: params[:os_ids]) if !params[:os_ids].blank?

			if !params[:features].blank?
				begin
					for feature in params[:features]
						if Phone::Phone::FEATURES.include?(feature.to_sym)
							phones = phones.where(feature => true)
						end
					end
				rescue
				end
			end

			@posts = @posts.where(phone_id: phones.to_a.map(&:id))

			## 2nd method

			# @posts = @posts.where(phone_phones: { os_id: params[:os_id] }) if !params[:os_id].blank?

			# if !params[:features].blank?
			# 	begin
			# 		for feature in parms[:features]
			# 			if Phone::Phone::FEATURES.include?(feature.to_sym)
			# 				@posts = @posts.where(phone_phones: { feature => true })
			# 			end
			# 		end
			# 	rescue
			# 	end
			# end

		end

		if params[:place] && !params[:place][:lat].blank? && !params[:place][:lng].blank?
			if params[:radius].to_i < SEARCH_RADIUS_MAX
				@posts = @posts.where_distance_is_less_than(params[:place][:lat], params[:place][:lng], params[:radius].to_i)
			else
				@posts = @posts.order_by_distance_from(params[:place][:lat], params[:place][:lng])
			end
		end

		@posts = @posts.order_by_date

		@posts_count = @posts.count
		@posts = @posts.page(params[:page])
	end

	def suggest
		posts = Post::Post.is_public.search_name(params[:q]).limit(10).select('DISTINCT(cached_name)').to_a

		render json: [
			params[:q],
			posts.map(&:cached_name)
		]
	end

	def contact
		if request.post? && params[:message]
			@message = Message.new(messages_params)
			@message.remote_ip = request.remote_ip
			
			if @message.save
				flash[:notice] = I18n.t('flash.message_sent')
				redirect_to root_url
			end
		else
			@message = Message.new
		end
	end

	def cgv
		@page = Page.find_by_str_key!('cgv')
		render_page
	end

	def faq
		@page = Page.find_by_str_key!('faq')
		render_page
	end

	def privacy
		@page = Page.find_by_str_key!('privacy')
		render_page
	end

	def cgu
		@page = Page.find_by_str_key!('cgu')
		render_page
	end

	def about
		@page = Page.find_by_str_key!('about')
		render_page
	end

private

	def messages_params
		params.require(:message).permit!
	end

	def render_page
		set_meta_title(title: @page.name, force: true)
		set_meta_keywords(@page.name)

		render :page # if stale?(@page)
	end

end
