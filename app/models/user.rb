class User < ActiveRecord::Base

	include Tokenable
	include Emailable
	include Accountable

	has_many :posts, dependent: :destroy, class_name: 'Post::Post'

	has_secure_password(validations: false)

	validates :email, uniqueness: { case_sensitive: false }

	def self.find_with_email_or_create_with_auth_hash(email, auth_hash)
		User.find_or_create_by!(email: email)
	end

	def increment_login_stats!(remote_ip)
		attributes = {
			last_login_at: Time.now,
			last_login_remote_ip: remote_ip,
			login_count: self.login_count + 1
		}

		self.update_columns(attributes)
	end

	def update_last_post_infos!(post)
		attributes = {
			last_name: post.user_name
		}

		attributes[:last_phone] = post.user_phone if !post.user_phone.blank?

		for attr in Localizable::FIELDS
			attributes['last_place_' + attr.to_s] = post['place_' + attr.to_s]
		end

		self.update_columns(attributes)
	end

end
