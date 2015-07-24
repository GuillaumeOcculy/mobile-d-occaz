class CreatePostStates < ActiveRecord::Migration
	def change
		create_table :post_states do |t|
			t.string :name, null: false
			t.timestamps
		end
	end
end
