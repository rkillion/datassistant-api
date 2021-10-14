class ApplicationController < ActionController::API
    include ActionController::Cookies
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response

    private

    def current_user
        @current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
    end
    
    def confirm_authentication
        return render json: { errors: ["You must be logged in to do that."] }, status: :unauthorized unless current_user
    end 

    def record_not_found_response
        return render json: { errors: ["Not found"] }, status: 404
    end
    
end
