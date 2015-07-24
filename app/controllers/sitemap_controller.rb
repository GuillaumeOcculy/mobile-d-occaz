class SitemapController < ApplicationController

	def index
		@pages = Page.all
		@posts = Post::Post.is_public.order_by_date.to_a
	end

end