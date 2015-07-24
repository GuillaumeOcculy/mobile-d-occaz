class Message < ActiveRecord::Base

	include Emailable

	validates :name, :content, presence: true

	after_create :send_mail

	def send_mail
		UserMailer.delay.contact(self.id)
		UserMailer.delay.contact_copy(self.id) if self.want_copy
	end

end
