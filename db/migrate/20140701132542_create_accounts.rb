class CreateAccounts < ActiveRecord::Migration
	def change
		create_table :accounts do |t|
			t.belongs_to :user, null: false

			t.string :provider_name, null: false
			t.string :provider_uid, null: false

			t.string :token
			t.string :refresh_token
			t.datetime :expires_at
			
			t.timestamps
		end
		add_index :accounts, [:provider_name, :provider_uid], unique: true
	end
end
