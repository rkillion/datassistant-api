class InstancesController < ApplicationController
    before_action :confirm_authentication

    # get /instances/:id
    def show
        instance = Instance.find(params[:id])
        if current_user.id == instance.datassistant.user.id
            render json: instance
        else
            render json: {errors: ["Not found"]}, status: 404 
        end
    end

end
