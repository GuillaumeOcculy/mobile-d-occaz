class CreatePhoneMedia < ActiveRecord::Migration
	def change
		create_table :phone_media do |t|
			t.belongs_to :phone, null: false
			t.attachment :image
			t.string :image_fingerprint
			t.timestamps
		end
	end
end
