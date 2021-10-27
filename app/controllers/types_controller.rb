class TypesController < ApplicationController
    before_action :confirm_authentication

    # get /types
    def index
        if (!params[:datassistant_id])
            render json: {errors: "You must specify a datassistant."}, status: :unprocessable_entity
        else
            assistant = current_user.datassistants.find(params[:datassistant_id])
            types = assistant.types
            render json: types, each_serializer: TypeIndexSerializer
        end
    end


    # get /types/:id
    def show
        type = Type.find(params[:id])
        if current_user.id == type.datassistant.user.id
            render json: type
        else
            render json: {errors: ["Not found"]}, status: 404 
        end
    end

end
