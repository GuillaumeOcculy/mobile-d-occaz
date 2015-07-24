class Phone::Brand < ActiveRecord::Base

	has_many :phones, dependent: :destroy
	has_many :posts, dependent: :destroy, class_name: 'Post::Post'

	validates :name, presence: true, uniqueness: { case_sensitive: false }

	default_scope -> { order("#{self.table_name}.name ASC") }

end
