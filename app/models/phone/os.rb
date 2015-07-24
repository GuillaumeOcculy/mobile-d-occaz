class Phone::Os < ActiveRecord::Base

	has_many :phones, dependent: :destroy

	validates :name, presence: true, uniqueness: { case_sensitive: false }

end
