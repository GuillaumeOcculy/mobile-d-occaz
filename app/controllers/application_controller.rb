class ApplicationController < ActionController::Base
	include CurrentUser
	include MetaHTML

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	rescue_from ActionController::RoutingError, with: :render_404
	rescue_from ActiveRecord::RecordNotFound, with: :render_404

	def authenticate_admin_user!
		return true if Rails.env.development?

		authenticate_or_request_with_http_basic do |username, password|
			username == "admin" && password == "05ncy378x3m2zf0"
		end
	end

	def render_404(exception)
		if exception.message != exception.class.to_s
			flash[:error] = exception.message
		else
			flash[:error] = I18n.t('flash.error_404')
		end

		redirect_to root_url
	end

end
