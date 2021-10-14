class TypesController < ApplicationController
    before_action :confirm_authentication

    # get /types/:id
    def show
        type = Type.find(params[:id])
        if current_user.id == type.datassistant.user.id
            
    end

end
