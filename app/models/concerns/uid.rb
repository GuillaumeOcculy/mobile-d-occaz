module UID
	extend ActiveSupport::Concern

	included do
		before_create :generate_uid
	end

	def generate_uid
		self.uid = loop do
			random_token = SecureRandom.random_number(99999999).to_s
			break random_token unless self.class.exists?(uid: random_token)
		end
	end
end