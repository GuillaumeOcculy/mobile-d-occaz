class CreatePhoneMemories < ActiveRecord::Migration
	def change
		create_table :phone_memories do |t|
			t.string :name, null: false
			t.timestamps
		end
	end
end
