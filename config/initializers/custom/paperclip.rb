Paperclip::Attachment.default_options[:url] = "/upload/:class/:attachment/:id/:style/:fingerprint.:content_type_extension"
Paperclip::Attachment.default_options[:path] = ":rails_root/public#{Paperclip::Attachment.default_options[:url]}"
Paperclip::Attachment.default_options[:use_timestamp] = false
Paperclip::Attachment.default_options[:convert_options] = { all: '-strip' }

if Rails.env.production?
	Rails.application.config.action_controller.asset_host = "//static.mobile-d-occaz.fr"
	ActionController::Base.config.asset_host = Rails.application.config.action_controller.asset_host # https://github.com/rails/rails/issues/16209
	Paperclip::Attachment.default_options[:url] = "//cdn.mobile-d-occaz.fr#{Paperclip::Attachment.default_options[:url]}"
end
