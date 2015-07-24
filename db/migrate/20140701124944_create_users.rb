class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|

			t.string :email, null: false
			t.string :password_digest

			# Last info for post

			t.string :last_name
			t.string :last_phone

			t.string :last_place_city
			t.string :last_place_zip_code
			t.string :last_place_department
			t.string :last_place_department_code
			t.string :last_place_region
			t.string :last_place_region_code
			t.string :last_place_country
			t.string :last_place_country_code
			t.float :last_place_lat
			t.float :last_place_lng

			# Stats

			t.datetime :last_login_at, null: false, default: Time.now
			t.string :last_login_remote_ip
			t.integer :login_count, null: false, default: 0

			t.timestamps
		end

		add_index :users, :email, unique: true
	end
end
