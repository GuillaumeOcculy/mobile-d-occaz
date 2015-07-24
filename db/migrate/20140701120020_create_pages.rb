class CreatePages < ActiveRecord::Migration
	def change
		create_table :pages do |t|
			t.string :str_key, null: false
			t.string :name, null: false
			t.text :content, null: false
			t.timestamps
		end
		add_index :pages, :str_key, unique: true
	end
end
