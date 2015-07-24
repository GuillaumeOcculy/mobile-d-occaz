class CreatePhoneColorsPhones < ActiveRecord::Migration
	def change
		create_table :phone_colors_phones, id: false do |t|
			t.belongs_to :phone, null: false
			t.belongs_to :color, null: false
		end
	end
end
