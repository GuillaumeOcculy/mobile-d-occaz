class UserMailer < ActionMailer::Base

	def post_valided_by_user(post_id)
	 	@post = Post::Post.find(post_id)
		mail(to: @post.user_email, subject: "Votre annonce #{@post.cached_name}")
	end

	def post_contact(post_message_id)
		@message = Post::Message.find(post_message_id)
		@post = @message.post
		mail(to: @post.user_email, subject: "Vous avez reçu un message pour votre annonce #{@post.cached_name}")
	end

	def post_contact_copy(post_message_id)
		@message = Post::Message.find(post_message_id)
		@post = @message.post
		mail(to: @message.email, subject: "Copie de votre message pour l'annonce #{@post.cached_name}")
	end

	def contact(message_id)
		@message = Message.find(message_id)
		mail(to: "contact@mobile-d-occaz.fr", subject: "[MOBILE-D-OCCAZ][CONTACT] Nouveau message")
	end

	def contact_copy(message_id)
		@message = Message.find(message_id)
		mail(to: @message.email, subject: "Copie de votre message")
	end

end
