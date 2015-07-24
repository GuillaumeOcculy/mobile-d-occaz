module Accountable
	extend ActiveSupport::Concern

	included do
		has_many :accounts, dependent: :destroy
	end

	module ClassMethods

		def create_or_update_from_auth_hash(auth_hash)
			# Search existing account
			account = Account.where(provider_name: auth_hash['provider']).where(provider_uid: auth_hash['uid'].to_s).first
			if account
				account.token = auth_hash['credentials']['token']
				account.refresh_token = auth_hash['credentials']['refresh_token']
				account.expires_at = Time.at(auth_hash['credentials']['expires_at'])
				account.save!
				return account.user
			end
			
			email = auth_hash['info']['email'].to_s.downcase
			user = self.find_with_email_or_create_with_auth_hash(email, auth_hash)

			user.accounts.create!(
				provider_name: auth_hash['provider'],
				provider_uid: auth_hash['uid'].to_s,
				token: auth_hash['credentials']['token'],
				refresh_token: auth_hash['credentials']['refresh_token'],
				expires_at: Time.at(auth_hash['credentials']['expires_at'])
			)

			user
		end

	end

end