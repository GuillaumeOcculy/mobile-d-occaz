class CreatePhoneCarriers < ActiveRecord::Migration
	def change
		create_table :phone_carriers do |t|
			t.string :name, null: false
			t.timestamps
		end
	end
end
