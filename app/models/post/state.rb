class Post::State < ActiveRecord::Base

	has_many :posts, dependent: :destroy

	validates :name, presence: true

	default_scope -> { order("#{self.table_name}.id ASC") }

end
