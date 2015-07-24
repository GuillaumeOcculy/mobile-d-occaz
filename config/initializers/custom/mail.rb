ActionMailer::Base.default_options = { from: "Mobile d'occaz <contact@mobile-d-occaz.fr>" }

if Rails.env.production?
	ActionMailer::Base.delivery_method = :smtp
	ActionMailer::Base.smtp_settings = {
		address: 'ns0.ovh.net',
		port: 587,
		# enable_starttls_auto: true,
		authentication: :plain,
		user_name: 'contact@mobile-d-occaz.fr',
		password: 'x3467gdh3fh'
	}
end

if Rails.env.production?
	ActionMailer::Base.default_url_options[:host] = 'www.mobile-d-occaz.fr'
else
	ActionMailer::Base.default_url_options[:host] = 'vm.local:3000'
end
