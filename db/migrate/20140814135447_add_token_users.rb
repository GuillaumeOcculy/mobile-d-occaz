class AddTokenUsers < ActiveRecord::Migration
	def change
		add_column :users, :token, :string
		User.all.to_a.each { |p| p.generate_token; p.save! }
		change_column :users, :token, :string, null: false
		add_index :users, :token, unique: true
	end
end
