module Emailable
	extend ActiveSupport::Concern

	included do
		validates :email, email_format: true, presence: true

		before_save { self.email.downcase! }
	end

end