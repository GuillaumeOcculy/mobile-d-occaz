class CreatePhoneColors < ActiveRecord::Migration
	def change
		create_table :phone_colors do |t|
			t.string :name, null: false
			t.timestamps
		end
	end
end
