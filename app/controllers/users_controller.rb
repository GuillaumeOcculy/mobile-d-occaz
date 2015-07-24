class UsersController < ApplicationController

	before_action :require_no_user

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			set_current_user(@user)
			redirect_to root_url
		else
			render :new
		end
	end

private

	def user_params
		params.require(:user).permit(:email, :password)
	end

end