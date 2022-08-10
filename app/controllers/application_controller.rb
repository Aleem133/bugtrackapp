class ApplicationController < ActionController::Base
    def require_user
        if current_user
            @user = current_user
        else
            redirect_to new_user_session_path, notice: 'You are not logged in.'
        end
    end
end
