require 'exception_notification'
require 'exception_notification/rails'

ExceptionNotification.configure do |config|
	config.ignored_exceptions += ['ActionController::InvalidCrossOriginRequest', 'ActionController::InvalidAuthenticityToken']

	config.ignore_if do |exception, options|
		not Rails.env.production?
	end

	config.add_notifier :email, {
		:email_prefix         => "[MOBILE-D-OCCAZ][ERROR] ",
		:sender_address       => %{"Mobile d'occaz" <error@mobile-d-occaz.fr>},
		:exception_recipients => %w{error@mobile-d-occaz.fr}
	}
end
