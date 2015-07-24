def fixture(filename)
	File.open(Rails.root.join('test', 'fixtures', filename))
end

FactoryGirl.define do
	factory :post, class: 'Post::Post' do

		place_city 'Paris'
		place_zip_code '75000'
		place_department 'Paris'
		place_department_code '75'
		place_region 'Île-de-France'
		place_region_code 'IDF'
		place_country 'France'
		place_country_code 'FR'
		place_lat 48.856614
		place_lng 2.3522219000000177

		brand { Phone::Brand.offset(rand(Phone::Brand.count)).first }
		phone {  brand.phones.offset(rand(brand.phones.count)).first }
		memory { Phone::Memory.offset(rand(Phone::Memory.count)).first }
		color { Phone::Color.offset(rand(Phone::Color.count)).first }
		carrier { Phone::Carrier.offset(rand(Phone::Carrier.count)).first }

		state { Post::State.offset(rand(Post::State.count)).first }
		have_charger { rand(2) }
		is_warranty { rand(2) }

		amount { rand(400) + 50 }
		content { Faker::Lorem.sentences.join('') }

		user { User.offset(rand(User.count)).first }
		user_email { user.email }
		user_name { Faker::Name.name }
		user_phone { rand(2) % 2 == 0 ? Faker::PhoneNumber.cell_phone : nil }
		
		is_valided_by_user true
		remote_ip '127.0.0.1'
	end


	factory :post_media, class: 'Post::Media' do
		image { fixture((rand(3) + 1).to_s + '.jpg') }
	end
end
