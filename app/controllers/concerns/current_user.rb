module CurrentUser
	extend ActiveSupport::Concern

	included do
		helper_method :current_user
	end

	def set_current_user(user)
		session[:user_id] = user.id
		user.increment_login_stats!(request.remote_ip)
	end

	def current_user
		@current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
		@current_user
	end

	def require_user
		redirect_to login_url if !current_user
	end
	
	def require_no_user
		redirect_to root_url if current_user
	end	

end