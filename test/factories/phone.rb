FactoryGirl.define do
	factory :phone, class: 'Phone::Phone' do
		brand { Phone::Brand.offset(rand(Phone::Brand.count)).first }
		os { Phone::Os.offset(rand(Phone::Os.count)).first }
		
		colors { Phone::Color.limit(2).order('RANDOM()').to_a }
		memories { Phone::Memory.limit(2).order('RANDOM()').to_a }

		name { Faker::Commerce.product_name }

		camera { rand(20) }

		have_3g { rand(2) }
		have_4g { rand(2) }
		have_gps { rand(2) }
		have_wifi { rand(2) }
		have_double_sim { rand(2) }
		have_external_memory { rand(2) }
		have_radio { rand(2) }
		have_tactile { rand(2) }
		have_keyboard { rand(2) }
	end
end
