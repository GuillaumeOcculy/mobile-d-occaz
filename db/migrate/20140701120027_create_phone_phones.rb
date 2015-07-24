class CreatePhonePhones < ActiveRecord::Migration
	def change
		create_table :phone_phones do |t|
			t.belongs_to :brand, null: false
			t.belongs_to :os

			t.string :name, null: false
			t.float :camera

			t.integer :memory_storage

			t.boolean :have_3g #, null: false, default: false
			t.boolean :have_4g #, null: false, default: false
			t.boolean :have_gps #, null: false, default: false
			t.boolean :have_wifi #, null: false, default: false
			t.boolean :have_nfc #, null: false, default: false
			t.boolean :have_double_sim #, null: false, default: false
			t.boolean :have_external_memory #, null: false, default: false
			t.boolean :have_radio #, null: false, default: false
			t.boolean :have_tactile #, null: false, default: false
			t.boolean :have_keyboard #, null: false, default: false

			# INTERN

			t.string :remote_url

			t.timestamps
		end
	end
end
