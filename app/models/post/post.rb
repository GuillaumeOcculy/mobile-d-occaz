class Post::Post  < ActiveRecord::Base
	
	include Tokenable
	include UID
	include Localizable

	belongs_to :brand, class_name: 'Phone::Brand'
	belongs_to :phone, class_name: 'Phone::Phone'
	belongs_to :memory, class_name: 'Phone::Memory'
	belongs_to :color, class_name: 'Phone::Color'
	belongs_to :carrier, class_name: 'Phone::Carrier'

	belongs_to :state
	belongs_to :user

	has_many :medias, -> { order("post_media.id ASC") }, dependent: :destroy
	has_many :messages, dependent: :destroy

	validates :remote_ip, presence: true
	
	validates :remote_url, uniqueness: { case_sensitive: false }, if: Proc.new { |p| !p.remote_url.blank? }
	validates :remote_url, uniqueness: { case_sensitive: false }, if: Proc.new { |p| !p.remote_url.blank? }

	with_options if: Proc.new { |post| post.is_valided_by_user? } do |post|
		post.validates :brand_id, :color_id, :carrier_id, :state_id, presence: true

		post.validates :amount, presence: true, numericality: { greater_than: 0 }
		post.validates :have_charger, :is_warranty, :is_sendable, :amount_negotiable, inclusion: {:in => [true, false]}

		post.validates :user_email, presence: true, email_format: true
		post.validates :user_name, presence: true

		post.validates :imei, format: { with: /\A(\d){15}$\z/, allow_blank: true }

		post.validate :validates_place

		post.before_validation :set_phone_name
		post.validates :phone_name, presence: true

		post.before_save { self.user_email.downcase! }
		post.before_save :set_cached_name

		post.before_save :create_user
	end

	scope :is_not_deleted, -> { where(is_deleted: false) }

	scope :is_create_by_user, -> { where(remote_url: nil) }
	scope :is_parsed, -> { where("#{self.table_name}.remote_url IS NOT NULL") }
	scope :is_for_admin, -> { is_parsed.where(is_parsed_complete: true).where(is_admin_complete: false) }
	scope :is_for_parse, -> { is_parsed.where(is_parsed_complete: false) }

	# Filtres de 1er niveau

	scope :is_not_valided_by_user, -> { is_not_deleted.where(is_valided_by_user: false) }
	scope :is_public, -> { is_not_deleted.where(is_valided_by_user: true) }

	# Filtres de 2nd niveau

	scope :with_images, -> { joins(:medias).includes(:medias).order('post_media.id ASC') }
	scope :order_by_date, -> { order("#{self.table_name}.created_at DESC") }

	scope :search_name, ->(q) { q.blank? || q.split(' ').size == 0 ? nil : where("LOWER(#{self.table_name}.cached_name) LIKE LOWER(?)", '%' + q.gsub('%', ' ').gsub('_', ' ').split(' ').join('%') + '%') }

	accepts_nested_attributes_for :medias

	def self.create_post_with_user(user, remote_ip)
		post = Post::Post.new(remote_ip: remote_ip)

		if user
			post.user_id = user.id
			post.user_name = user.last_name
			post.user_phone = user.last_phone
			post.user_email = user.email
			
			for attr in [:place_city, :place_zip_code, :place_department, :place_department_code, :place_region, :place_region_code, :place_country, :place_country_code, :place_lat, :place_lng]
				post[attr] = user['last_' + attr.to_s]
			end
		end

		post.save!
		post
	end

	def to_param
		if cached_name
			"#{uid}-#{cached_name.parameterize}"
		else
			"#{uid}"
		end
	end

	def admin_completed!
		self.is_admin_complete = true
		self.save!
	end

	def validates_place
		if self.place_city.blank? || self.place_lat.blank? || self.place_lng.blank?
			if !self.place_search.blank?
				geocoder = Graticule.service(:google).new(GOOGLE_API_KEY)
				begin
					params = { address: self.place_search, components: 'country:fr' }
					response = geocoder.send('make_url', params).open('User-Agent' => Graticule::Geocoder::Base::USER_AGENT).read
					json = JSON.parse(response)
					result = json['results'][0]

					self.place_lat = result['geometry']['location']['lat']
					self.place_lng = result['geometry']['location']['lng']

		            for data in result['address_components']
		            	if data['types'][0] == 'country'
		            		self.place_country = data['long_name']
		            		self.place_country_code = data['short_name']
		                elsif data['types'][0] == 'administrative_area_level_1'
		                	self.place_region = data['long_name']
		                	self.place_region_code = data['short_name']
		                elsif data['types'][0] == 'administrative_area_level_2'
		                	self.place_department = data['long_name']
		                	self.place_department_code = data['short_name']
		                elsif data['types'][0] == 'locality' || data['types'][0] == 'administrative_area3'
		                	self.place_city = data['long_name']
		                elsif data['types'][0] == 'postal_code'
		                	self.place_zip_code = data['long_name']
		                end
		            end		
				rescue
				end
			end
			if self.place_city.blank? || self.place_lat.blank? || self.place_lng.blank?
				errors.add :place_search, I18n.t('errors.messages.blank')
			end
		end
	end

	def set_phone_name
		self.phone_name = self.phone.name if self.phone
	end

	def set_cached_name
		if self.memory
			self.cached_name = "#{self.brand.name} #{self.phone_name} #{self.memory.name}"
		else
			self.cached_name = "#{self.brand.name} #{self.phone_name}"
		end
	end

	def create_user
		if !self.user_id
			user = User.find_or_create_by!(email: self.user_email.to_s.downcase)
			user.update_last_post_infos!(self)

			self.user_id = user.id
		end
	end

	def place
		if place_department_code
			"#{place_city}, #{place_department} (#{place_department_code})"
		else
			"#{place_city}, #{place_department}"
		end
	end

	def meta_title
		"#{self.cached_name} - #{self.place_city}"
	end

	def meta_keywords
		self.cached_name
	end

end