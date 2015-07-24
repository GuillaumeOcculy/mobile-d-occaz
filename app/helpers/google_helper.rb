module GoogleHelper

	def javascript_include_goole_maps
		javascript_include_tag('google') +
		javascript_include_tag('//maps.googleapis.com/maps/api/js?libraries=places&language=fr_FR&sensor=true&callback=googleMapInitialize', async: true)
	end

	class ActionView::Helpers::FormBuilder

		def place_field(method, options = {})
			output = text_field(method.to_s + '_search', options)

			for attr in Localizable::FIELDS
				output += hidden_field(method.to_s + "_#{attr}")
			end
			
			output
		end

	end

	def place_field_tag(object_name, object, options = {})
		object ||= {}
		options[:value] = object[:search]
		output = text_field(object_name, :search, options)

		for attr in Localizable::FIELDS
			output += hidden_field(object_name, attr, value: object[attr])
		end

		output
	end

end