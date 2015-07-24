class CreatePhoneBrands < ActiveRecord::Migration
	def change
		create_table :phone_brands do |t|
			t.string :name, null: false
			t.timestamps
		end
	end
end
