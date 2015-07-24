class CreatePhoneOs < ActiveRecord::Migration
	def change
		create_table :phone_os do |t|
			t.string :name, null: false
			t.timestamps
		end
	end
end
