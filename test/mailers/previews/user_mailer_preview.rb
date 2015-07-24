class UserMailerPreview < ActionMailer::Preview

	def post_valided_by_user
		UserMailer.post_valided_by_user(Post::Post.is_public.first.id)
	end

end