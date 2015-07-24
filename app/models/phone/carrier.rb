class Phone::Carrier < ActiveRecord::Base

	has_many :posts, dependent: :nullify, class_name: 'Post::Post'
	
	validates :name, presence: true, uniqueness: { case_sensitive: false }

end
