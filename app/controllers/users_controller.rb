class UsersController < ApplicationController

    # get /me
    def show
        if current_user
            render json: current_user
        else
            render json: {errors: ["You must be logged in to view content."]}, status: 401
        end
    end

    # post /signup
    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: 201
        else
            render json: {errors: user.errors.full_messages}, status: 422
        end
    end

    private

    def user_params
        params.permit(:username, :first_name, :password, :password_confirmation)
    end
    
end
