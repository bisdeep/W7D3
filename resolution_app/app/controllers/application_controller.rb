class ApplicationController < ActionController::Base
    #skip_before_action :verify_authenticity_token

    helper_method :current_user, :logged_in?

    #C:
    def current_user
        return nil unless session[:session_token]
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    #Ensure logged in/require user
    def require_user
        redirect_to new_user_url if current_user.nil?
    end

    #Login!(user)
    def login_user!(user)
        session[:session_token] = user.reset_session_token!
    end

    #log out
    def logout_user!
        current_user.reset_session_token! if logged_in?
        session[:session_token] = nil
        @current_user = nil
    end

    #Logged in?
    def logged_in?
        !!current_user
    end
end
