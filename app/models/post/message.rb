class Post::Message < ActiveRecord::Base

	include Emailable

	belongs_to :post

	validates :post_id, presence: true

	validates :name, :content, presence: true

	after_create :send_mail

	def send_mail
		UserMailer.delay.post_contact(self.id)
		UserMailer.delay.post_contact_copy(self.id) if self.want_copy
	end

end
