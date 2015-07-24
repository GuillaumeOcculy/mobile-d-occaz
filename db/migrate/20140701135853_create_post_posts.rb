class CreatePostPosts < ActiveRecord::Migration
	def change
		create_table :post_posts do |t|

			t.integer :uid, null: false

			# Localisation

			t.string :place_city
			t.string :place_zip_code
			t.string :place_department
			t.string :place_department_code
			t.string :place_region
			t.string :place_region_code
			t.string :place_country
			t.string :place_country_code
			t.float :place_lat
			t.float :place_lng

			t.boolean :is_sendable, null: false, default: false

			# Phone

			t.belongs_to :brand
			t.belongs_to :phone
			t.string :phone_name
			t.belongs_to :memory
			t.belongs_to :color
			t.belongs_to :carrier

			# Etat

			t.belongs_to :state
			t.boolean :have_charger
			t.boolean :is_warranty, null: false, default: false

			# Annonce

			# t.float :amount, precision: 10, scale: 2
			t.integer :amount
			t.boolean :amount_negotiable, null: false, default: false
			t.text :content

			# User

			t.belongs_to :user
			t.string :user_email
			t.string :user_name
			t.string :user_phone
		
			# INTERN

			t.string :cached_name
			t.boolean :is_valided_by_user, null: false, default: false
			t.string :remote_ip, null: false
			t.boolean :is_deleted, null: false, default: false

			# Parse

			t.string :remote_url
			t.boolean :is_parsed_complete, null: false, default: false
			t.boolean :is_admin_complete, null: false, default: false
			t.boolean :is_processed, null: false, default: false

			t.timestamps
		end
		add_index :post_posts, :uid, unique: true
	end
end
