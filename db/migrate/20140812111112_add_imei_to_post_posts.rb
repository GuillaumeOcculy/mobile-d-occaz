class AddImeiToPostPosts < ActiveRecord::Migration
	def change
		add_column :post_posts, :imei, :string
	end
end
