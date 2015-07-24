class AddTokenPostPosts < ActiveRecord::Migration
	def change
		add_column :post_posts, :token, :string
		Post::Post.all.to_a.each { |p| p.generate_token; p.save! }
		change_column :post_posts, :token, :string, null: false
		add_index :post_posts, :token, unique: true
	end
end
