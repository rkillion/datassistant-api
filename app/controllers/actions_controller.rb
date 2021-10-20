class ActionsController < ApplicationController
    before_action :confirm_authentication
    before_action :set_datassistant

    def new
        if params[:make]
            if params[:make]=="type"
                new_type = Type.new(
                    datassistant_id: @datassistant.id,
                    title_singular: params[:title_singular],
                    title_plural: params[:title_plural]
                )
                if new_type.valid?
                    if params[:parent_type_id]
                        parent = @datassistant.types.find(params[:parent_type_id])
                        sub_type = parent.make_subtype(params[:title_singular],params[:title_plural])
                        render json: sub_type
                    else
                        new_type.save
                        Log.create(
                            datassistant_id: @datassistant.id,
                            type_a_id: new_type.id,
                            relationship: "base"
                        )
                        render json: new_type
                    end
                else
                    render json: {errors: new_type.errors}, status: :unprocessable_entity
                end
            elsif params[:make]=="instance"
                render json: {message: "You are making an instance."}
            else
                render json: {errors: ["invalid item to make"]}, status: :unprocessable_entity
            end
        else
            render json: {errors: ["include 'make' field to define what you are creating"]}, status: :unprocessable_entity
        end
    end

    private

    def set_datassistant
        @datassistant = current_user.datassistants.find(params[:datassistant_id])
    end

end
