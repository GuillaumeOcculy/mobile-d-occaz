class PostsController < ApplicationController

	before_action :find_public_post, only: [:show]
	before_action :find_post_for_user, only: [:edit, :update, :upload, :remove_media]

	def show
		@medias = @post.medias.to_a

		set_meta_title(name: @post.meta_title)
		set_meta_description(content: @post.content)
		set_meta_cannonical_url(post_url(@post))
		set_meta_keywords(@post.meta_keywords)
		set_meta_image_url(@medias.first.image.url) if @medias.size > 0

		# fresh_when(@post) if flash.empty?
	end
		
	def new
		post = Post::Post.create_post_with_user(current_user, request.remote_ip)
		redirect_to edit_post_url(post)
	end

	def edit		
		@post.carrier_id ||= Phone::Carrier.first.id
		@post.state_id ||= Post::State.find(3).id
		@post.have_charger = true if @post.have_charger.nil?

		@post.medias.build while @post.medias.size < 3

		set_meta_dont_index
	end
	
	def update
		if !params[:is_admin].blank?
			@post.update(posts_params)
			redirect_to root_url
			return
		end

		@post.is_valided_by_user = true
		@post.remote_ip = request.remote_ip

		if @post.update(posts_params)
			# set_current_user(@post.user) if !current_user
			flash[:notice] = I18n.t('flash.post_created')
			redirect_to post_url(@post)

			UserMailer.delay.post_valided_by_user(@post.id)
		else
			@post.medias.new while @post.medias.size < 3
			render :edit
		end
	end

	def upload
		if @post.medias.count >= 3
	 		render nothing: true
	 		return
		end

		media = @post.medias.create(image: params[:file])
		render json: { id: media.id, url: media.image.url(:thumb) }
	end

	def remove_media
		@post.medias.destroy(params[:media_id])

		render nothing: true
	end

	def contact
		@post = Post::Post.is_public.find_by_uid!(params[:id])
		
		if request.post? && params[:post_message]
			@post_message = @post.messages.new(post_messages_params)
			@post_message.remote_ip = request.remote_ip
			if @post_message.save
				flash[:notice] = I18n.t('flash.message_sent')
				redirect_to post_url(@post)
			end
		else
			@post_message = @post.messages.new
		end

		set_meta_dont_index

		set_meta_title(name: @post.meta_title)
		set_meta_description(content: @post.content)
		set_meta_cannonical_url(post_url(@post))
		set_meta_keywords(@post.meta_keywords)
	end

	def delete
		post = Post::Post.is_public.find_by_token! params[:token]
		post.destroy

		flash[:notice] = I18n.t('flash.post_removed')
		redirect_to root_url
	end

	# AJAX

	def phones
		brand = Phone::Brand.find(params[:id])
		render json: brand.phones.select(:id, :name).order(:name).to_a.map {|x| [x.id, x.name] }
	end

private

	def find_public_post
		@post = Post::Post.is_public.find_by_uid(params[:id])
		if !@post
			raise ActionController::RoutingError.new I18n.t('flash.post_expired')
		end
	end

	def find_post_for_user
		if params[:is_admin]
			@post = Post::Post.find_by_uid!(params[:id])
		else
			@post = Post::Post.is_not_valided_by_user.find_by_uid!(params[:id])
		end
	end

	def posts_params
		params.require(:post_post).permit!
	end

	def post_messages_params
		params.require(:post_message).permit!
	end

	def default_url_options(options = {})
		options[:is_admin] = params[:is_admin]
		options
	end

end
