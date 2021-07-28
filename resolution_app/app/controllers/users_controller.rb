class UsersController < ApplicationController
    before_action :require_user, only: [:show]
    def new
        @user = User.new
        render :new
    end

    def show
        @user = User.find(params[:id])
        render :show
    end

    def create
        @user = User.new(users_params)
        if @user.save
            login_user!(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    private
    def users_params
        params.require(:user).permit(:username, :password)
    end

end