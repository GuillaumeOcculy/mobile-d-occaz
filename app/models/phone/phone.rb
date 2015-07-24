class Phone::Phone < ActiveRecord::Base

	FEATURES = [
		:have_3g,
		:have_4g,
		:have_gps,
		:have_wifi,
		:have_double_sim,
		:have_external_memory,
		:have_radio,
		:have_tactile,
		:have_keyboard
	]

	belongs_to :brand
	belongs_to :os

	has_many :medias, dependent: :destroy

	has_and_belongs_to_many :memories
	has_and_belongs_to_many :colors

	has_many :posts, dependent: :destroy, class_name: 'Post::Post'

	validates :brand_id, presence: true

	validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :brand_id }

	accepts_nested_attributes_for :medias

	default_scope -> { order("#{self.table_name}.name ASC") }

end
