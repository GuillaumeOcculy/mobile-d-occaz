class Phone::Memory < ActiveRecord::Base

	has_and_belongs_to_many :phones
	has_many :posts, dependent: :destroy, class_name: 'Post::Post'

	validates :name, presence: true, uniqueness: { case_sensitive: false }

end
