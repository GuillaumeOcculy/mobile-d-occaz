module Localizable
	extend ActiveSupport::Concern

	FIELDS = %w{ city zip_code region region_code department department_code country country_code lat lng }

	included do
		attr_accessor :place_search
		after_find :set_place_search
	end

	def set_place_search
		self.place_search = "#{self.place_city}" if !self.place_city.blank?
	end

	module ClassMethods

		def where_distance_is_less_than(lat, lng, radius)
			origin = Graticule::Location.new(latitude: lat.to_f, longitude: lng.to_f)

			sql = Graticule::Distance::Spherical.to_sql(
				latitude: origin.latitude,
				longitude: origin.longitude,
				latitude_column: "place_lat",
				longitude_column: "place_lng",
				units: :kilometers
			)

			where(sql.to_s + ' <= ' + radius.to_i.to_s).order(sql.to_s + ' ASC')
		end

		def order_by_distance_from(lat, lng)
			origin = Graticule::Location.new(latitude: lat.to_f, longitude: lng.to_f)

			sql = Graticule::Distance::Spherical.to_sql(
				latitude: origin.latitude,
				longitude: origin.longitude,
				latitude_column: "place_lat",
				longitude_column: "place_lng",
				units: :kilometers
			)

			order(sql.to_s + ' ASC')
		end

	end

end