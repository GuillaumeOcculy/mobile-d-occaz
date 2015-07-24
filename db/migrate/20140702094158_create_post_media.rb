class CreatePostMedia < ActiveRecord::Migration
	def change
		create_table :post_media do |t|
			t.belongs_to :post, null: false
			t.attachment :image
			t.string :image_fingerprint
			t.timestamps
		end
	end
end
