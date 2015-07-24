%w{faq cgu privacy cgv about}.each do |name|
	Page.create! str_key: name, name: name, content: name
end

["4Go et moins", "8Go", "16Go", "32Go", "64Go et plus"].each do |name|
	Phone::Memory.create! name: name
end

%w{ Blanc Bleu Gris Jaune Noir Or Orange Rose Rouge Violet }.each do |name|
	Phone::Color.create! name: name
end

%w{ Débloqué Orange SFR Bouygues Autre }.each do |name|
	Phone::Carrier.create! name: name
end

%W{ #{"Mauvais / cassé"} Moyen Bon Neuf }.each do |name|
	Post::State.create! name: name
end

### PROD ###

Rake::Task['local:parse_phones'].invoke

Phone::Brand.create! name: 'Autre'

### TEST ###

# require 'factory_girl_rails'
# require 'faker'

# puts 'Create Phones'
# ActiveRecord::Base.transaction do
# 	200.times { FactoryGirl.create(:phone) }
# end

# puts 'Create Users'
# ActiveRecord::Base.transaction do
# 	10.times { FactoryGirl.create(:user) }
# end

# puts 'Create Posts'
# ActiveRecord::Base.transaction do
# 	200.times { post = FactoryGirl.create(:post); post_media = FactoryGirl.build(:post_media); post_media.post = post; post_media.save }
# end
