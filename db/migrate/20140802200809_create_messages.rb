class CreateMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|

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
