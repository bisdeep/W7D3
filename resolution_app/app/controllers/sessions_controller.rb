class SessionsController < ApplicationController
    before_action :require_user, only: [:destroy]

    def new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
        if @user
            login_user!(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = ["Invalid credentials"]
            render :new
        end
    end

    def destroy
        logout_user!
        redirect_to new_session_url
    end

end