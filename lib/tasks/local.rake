require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'

namespace :local do
	
	task remove_empty_post: :environment do
		Post::Post.is_create_by_user.is_not_valided_by_user.where('created_at < ?', 24.hours.ago).destroy_all
	end
	
	task remove_expired_post: :environment do
		Post::Post.is_not_deleted.where('created_at < ?', 2.month.ago).update_all(is_deleted: true)
	end

	task parse_phones: :environment do
		def url(brand_name)
			"http://fr.gsmchoice.com#{brand_name.downcase.split(' ').join('')}"
		end

		def find_field(doc, text)
			div = doc.search("[text()*='" + text + "']")
			return nil if div.size == 0
			div.first.parent.css('span').text
		end

		def find_or_create(model, name)
			record = model.where('LOWER(name) = LOWER(?)', name).first
			record = model.create! name: name if !record
			record
		end

		for brand_name in %W{ Apple BlackBerry HTC LG Motorola Nokia Samsung Sony ZTE Huawei Wiko Microsoft Lenovo #{"Sony Ericsson"} }

			puts brand_name

			if Phone::Brand.find_by name: brand_name
				next
			end

			brand = Phone::Brand.find_or_create_by! name: brand_name

			page_url = url("/fr/catalogue/#{brand_name.downcase}")

			while page_url
				puts page_url

				doc_brand = Nokogiri::HTML(open(page_url))

				for phone_anchor in doc_brand.css('.phone-small-box a')
					# begin
						phone_url = url(phone_anchor.attributes['href'].value)
						doc_phone = Nokogiri::HTML(open(phone_url))

						phone = Phone::Phone.new

						phone.brand_id = brand.id
						phone.remote_url = phone_url

						phone_name = doc_phone.css('h1')[0].text
						phone_name.sub!("#{brand.name} ", '')

						# Pour Apple
						if phone_name.end_with?('GB')
							phone_name.sub!(/ \d+ GB/, '')
							phone_name.sub!(/ \d+GB/, '')
						end
						next if brand.phones.where('LOWER(name) = LOWER(?)', phone_name).count > 0

						phone.name = phone_name

						phone_os = find_field(doc_phone, "exploitation")
						phone.os = find_or_create(Phone::Os, phone_os) if phone_os

						phone_camera = find_field(doc_phone, 'Capteur photo')
						phone.camera = phone_camera.sub(' Mpx', '').sub(',', '.').to_f if phone_camera

						puts phone_camera if phone.camera == 0.0

						memory_storage = find_field(doc_phone, 'Mémoire interne')
						if memory_storage
							if memory_storage.end_with?('GB')
								memory_storage.sub!(' GB', '')
								memory_storage = 1024 * memory_storage.to_i
							else
								memory_storage.sub!(' MB', '')
							end
							phone.memory_storage = memory_storage.to_i
						end

						if !phone.save
							puts phone_url
							puts phone.name
							puts phone.errors.inspect
							puts phone.errors.messages
							raise "Erreur"
						end

						puts "#{phone.id} - #{phone.camera} - #{phone.name}"

						# phone_memory = find_field(doc_phone, 'Mémoire interne')
						# if !phone_memory.blank?
						# 	memory = find_or_create(Phone::Memory, phone_memory)
						# 	phone.memories << memory
						# end

					# rescue Exception => e
						# puts phone_url
						# throw e
					# end
				end

				if doc_brand.css('.LinkNext').size > 0
					page_url = url(doc_brand.css('.LinkNext')[0].attributes['href'].value)
				else
					page_url = nil
				end
			end

		end

		puts Phone::Phone.count
	end

	task parse_leboncoin: :environment do
		search_url = "http://www.leboncoin.fr/telephonie/offres/ile_de_france/occasions/?o="
		page_index = 1

		while page_index < 15
			puts "Parse #{(search_url + page_index.to_s)}"

			doc_search = Nokogiri::HTML(open(search_url + page_index.to_s + "&ps=6"))

			for phone_anchor in doc_search.css('.list-lbc a')
				phone_url = phone_anchor.attributes['href'].value

				post = Post::Post.new

				post.phone_name = phone_anchor.css('.title')[0].text.strip
				post.amount = phone_anchor.css('.price')[0].text.strip.to_i if phone_anchor.css('.price').size > 0
				post.place_city = phone_anchor.css('.placement')[0].text.strip.split("\n\t").map {|x| x.split('/')[0].strip }.join(', ')
				post.remote_url = phone_url
				post.remote_ip = '127.0.0.1'

				post.save!
			end

			page_index += 1
		end
	end

	task parse_leboncoin_medias: :environment do
		for post in Post::Post.is_for_parse.to_a

			doc_post = Nokogiri::HTML(open(post.remote_url))
			puts "Parse #{post.remote_url}"

			if doc_post.css('.lbcImages').size > 0
				image_urls = doc_post.css('.lbcImages')[0].search('script').text.scan(/aImages\[\d\] = "(.*)";/).flatten

				if image_urls.size == 0
					image_urls = doc_post.css('.lbcImages #image')[0].attributes['style'].value.scan(/url\('(.*)'/).flatten
				end

				for image_url in image_urls
					media = post.medias.new
					media.image = open(image_url)
					media.save!
				end
			end

			post.user_name = doc_post.css('.upload_by a')[0].text.strip
			content = ""
			for children in doc_post.css('.AdviewContent .content')[0].children
				if children.class == Nokogiri::XML::Text
					content += children.text.strip
				else
					content += "\n"
				end
			end
			post.content = content
			post.is_parsed_complete = true
			post.save!			
		end
	end

	task send_message_leboncoin: :environment do
		posts = [[70341018, "http://www.leboncoin.fr/telephonie/693485202.htm?ca=12_s"], [53478037, "http://www.leboncoin.fr/telephonie/693484908.htm?ca=12_s"], [80447531, "http://www.leboncoin.fr/telephonie/686719276.htm?ca=12_s"], [9482059, "http://www.leboncoin.fr/telephonie/493010610.htm?ca=12_s"], [11370050, "http://www.leboncoin.fr/telephonie/693486142.htm?ca=12_s"], [35325651, "http://www.leboncoin.fr/telephonie/693479190.htm?ca=12_s"], [41528430, "http://www.leboncoin.fr/telephonie/693481004.htm?ca=12_s"], [81407928, "http://www.leboncoin.fr/telephonie/693479416.htm?ca=12_s"], [61850529, "http://www.leboncoin.fr/telephonie/693480554.htm?ca=12_s"], [77923253, "http://www.leboncoin.fr/telephonie/693480661.htm?ca=12_s"], [69132318, "http://www.leboncoin.fr/telephonie/693480768.htm?ca=12_s"], [25662853, "http://www.leboncoin.fr/telephonie/693485452.htm?ca=12_s"], [18983075, "http://www.leboncoin.fr/telephonie/693485020.htm?ca=12_s"], [20518852, "http://www.leboncoin.fr/telephonie/693485054.htm?ca=12_s"], [2530286, "http://www.leboncoin.fr/telephonie/693485322.htm?ca=12_s"], [75946313, "http://www.leboncoin.fr/telephonie/693485917.htm?ca=12_s"], [57920479, "http://www.leboncoin.fr/telephonie/693486182.htm?ca=12_s"], [81665972, "http://www.leboncoin.fr/telephonie/693486096.htm?ca=12_s"], [41308470, "http://www.leboncoin.fr/telephonie/693481752.htm?ca=12_s"], [80043979, "http://www.leboncoin.fr/telephonie/693481939.htm?ca=12_s"], [2687537, "http://www.leboncoin.fr/telephonie/693482269.htm?ca=12_s"], [12121162, "http://www.leboncoin.fr/telephonie/693482222.htm?ca=12_s"], [77900856, "http://www.leboncoin.fr/telephonie/686148281.htm?ca=12_s"], [5685996, "http://www.leboncoin.fr/telephonie/693483290.htm?ca=12_s"], [901158, "http://www.leboncoin.fr/telephonie/693484160.htm?ca=12_s"], [95804278, "http://www.leboncoin.fr/telephonie/693484211.htm?ca=12_s"], [37727867, "http://www.leboncoin.fr/telephonie/693484750.htm?ca=12_s"], [899119, "http://www.leboncoin.fr/telephonie/693484500.htm?ca=12_s"], [50669934, "http://www.leboncoin.fr/telephonie/693480719.htm?ca=12_s"], [17755919, "http://www.leboncoin.fr/telephonie/693479081.htm?ca=12_s"], [47436888, "http://www.leboncoin.fr/telephonie/693479064.htm?ca=12_s"], [36129620, "http://www.leboncoin.fr/telephonie/684553445.htm?ca=12_s"], [66989428, "http://www.leboncoin.fr/telephonie/693481167.htm?ca=12_s"], [98321829, "http://www.leboncoin.fr/telephonie/693481300.htm?ca=12_s"], [67539413, "http://www.leboncoin.fr/telephonie/693480263.htm?ca=12_s"], [14521474, "http://www.leboncoin.fr/telephonie/693480644.htm?ca=12_s"], [74512132, "http://www.leboncoin.fr/telephonie/693478396.htm?ca=12_s"], [16386066, "http://www.leboncoin.fr/telephonie/685435320.htm?ca=12_s"], [71293188, "http://www.leboncoin.fr/telephonie/693477152.htm?ca=12_s"], [18779969, "http://www.leboncoin.fr/telephonie/693478232.htm?ca=12_s"], [12520778, "http://www.leboncoin.fr/telephonie/693477478.htm?ca=12_s"], [30676447, "http://www.leboncoin.fr/telephonie/693478056.htm?ca=12_s"], [12273650, "http://www.leboncoin.fr/telephonie/693483032.htm?ca=12_s"], [20137534, "http://www.leboncoin.fr/telephonie/693482021.htm?ca=12_s"], [33887777, "http://www.leboncoin.fr/telephonie/693483296.htm?ca=12_s"], [50257895, "http://www.leboncoin.fr/telephonie/693483228.htm?ca=12_s"], [18328711, "http://www.leboncoin.fr/telephonie/693483999.htm?ca=12_s"], [73736899, "http://www.leboncoin.fr/telephonie/672298883.htm?ca=12_s"], [49403669, "http://www.leboncoin.fr/telephonie/693483823.htm?ca=12_s"], [43402828, "http://www.leboncoin.fr/telephonie/693483911.htm?ca=12_s"], [86939804, "http://www.leboncoin.fr/telephonie/693481568.htm?ca=12_s"], [85632010, "http://www.leboncoin.fr/telephonie/693479136.htm?ca=12_s"], [30068137, "http://www.leboncoin.fr/telephonie/671299962.htm?ca=12_s"], [25375401, "http://www.leboncoin.fr/telephonie/584223186.htm?ca=12_s"], [69673132, "http://www.leboncoin.fr/telephonie/693477047.htm?ca=12_s"], [76421947, "http://www.leboncoin.fr/telephonie/693478043.htm?ca=12_s"], [11695949, "http://www.leboncoin.fr/telephonie/693477803.htm?ca=12_s"], [63820380, "http://www.leboncoin.fr/telephonie/693478042.htm?ca=12_s"], [23307906, "http://www.leboncoin.fr/telephonie/693478967.htm?ca=12_s"], [45956656, "http://www.leboncoin.fr/telephonie/693479026.htm?ca=12_s"], [89560949, "http://www.leboncoin.fr/telephonie/693479207.htm?ca=12_s"], [41766464, "http://www.leboncoin.fr/telephonie/693483097.htm?ca=12_s"], [56804277, "http://www.leboncoin.fr/telephonie/693480728.htm?ca=12_s"], [98378626, "http://www.leboncoin.fr/telephonie/693480762.htm?ca=12_s"], [33495733, "http://www.leboncoin.fr/telephonie/693481681.htm?ca=12_s"], [54922827, "http://www.leboncoin.fr/telephonie/693483117.htm?ca=12_s"], [87851133, "http://www.leboncoin.fr/telephonie/693484361.htm?ca=12_s"], [50175041, "http://www.leboncoin.fr/telephonie/693484632.htm?ca=12_s"], [58206517, "http://www.leboncoin.fr/telephonie/693484655.htm?ca=12_s"], [89909029, "http://www.leboncoin.fr/telephonie/693484826.htm?ca=12_s"], [6865215, "http://www.leboncoin.fr/telephonie/693484861.htm?ca=12_s"], [30908812, "http://www.leboncoin.fr/telephonie/693484844.htm?ca=12_s"], [20017901, "http://www.leboncoin.fr/telephonie/693485688.htm?ca=12_s"], [42601452, "http://www.leboncoin.fr/telephonie/693486191.htm?ca=12_s"]]

		for post in posts
			begin
			puts post[1]

			edit_url = "http://www.mobile-d-occaz.fr/annonces/#{post[0]}/edition"
			remote_url = post[1]
			remote_id = remote_url.sub('http://www.leboncoin.fr/telephonie/', '').sub('.htm?ca=12_s', '').to_i
			remote_message_url = "http://www2.leboncoin.fr/ar/form/0?ca=12_s&id=#{remote_id}"
			remote_send_message_url = "http://www2.leboncoin.fr/ar/send/0?ca=12_s&id=#{remote_id}"

			data = {
				name: "Mobile d'occaz",
				email: 'contact@mobile-d-occaz.fr',
				phone: '',
				body: "Bonjour,
je vous contact pour augmenter la visibilité de votre annonce gratuitement en la déposant sur notre site à l'adresse #{edit_url}.
Votre annonce est déjà préremplie, vous n'avez qu'à valider les informations.

Cordialement,
Mobile d'occaz",
				send: 'Envoyer'
			}

			result = Net::HTTP.post_form URI(remote_send_message_url), data
			puts result.inspect
			rescue Exception => e
				puts "Error: #{e}"
				puts "Error: #{e.inspect}"
				puts "Error: #{e.message}"
			end
		end

	end

end
