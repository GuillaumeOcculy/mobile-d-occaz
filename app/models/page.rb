class Page < ActiveRecord::Base

	validates :name, :content, presence: true

	validates :str_key, presence: true, uniqueness: { case_sensitive: false }
	before_save { self.str_key.downcase! }

end
