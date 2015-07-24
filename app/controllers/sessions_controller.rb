class SessionsController < ApplicationController

	before_filter :require_no_user, except: :destroy
	
	def create
		if auth_hash
			user = User.create_or_update_from_auth_hash(auth_hash)
		else
			user = User.where(email: params[:email]).first.try(:authenticate, params[:password])
		end

		if user
			set_current_user(user)
			redirect_to root_url
		else
			# render :new
			redirect_to login_url
		end
	end
	
	def destroy
		reset_session
		redirect_to root_url
	end	

	def failure
		redirect_to root_url
	end

protected

	def auth_hash
		request.env['omniauth.auth']
	end

end
