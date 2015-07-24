class CreatePhoneMemoriesPhones < ActiveRecord::Migration
	def change
		create_table :phone_memories_phones, id: false do |t|
			t.belongs_to :phone, null: false
			t.belongs_to :memory, null: false
		end
	end
end
