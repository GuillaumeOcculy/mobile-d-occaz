class CreatePostMessages < ActiveRecord::Migration
	def change
		create_table :post_messages do |t|
			t.belongs_to :post, null: false

			t.string :name, null: false
			t.string :email, null: false
			t.string :phone
			t.text :content, null: false

			t.boolean :want_copy, null: false, default: false

			# INTERN

			t.string :remote_ip, null: false

			t.timestamps
		end
	end
end
