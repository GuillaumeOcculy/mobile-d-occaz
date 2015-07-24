class AddIsAdminProcessedToPostPosts < ActiveRecord::Migration
	def change
		add_column :post_posts, :is_admin_processed, :boolean, null: false, default: false
	end
end
