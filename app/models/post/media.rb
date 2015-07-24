class Post::Media < ActiveRecord::Base

	belongs_to :post

	validates :post_id, presence: true

	has_attached_file :image, styles: { medium: 'x670', thumb: 'x240' }
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
