class Phone::Media < ActiveRecord::Base

	belongs_to :phone

	validates :phone_id, presence: true

	has_attached_file :image
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	default_scope -> { order("#{self.table_name}.id ASC") }

end
