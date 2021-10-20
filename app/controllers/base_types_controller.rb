class BaseTypesController < ApplicationController
    before_action :set_base_type, only: [:show]
    before_action :confirm_authentication

    # GET /base_types
  def index
    common_base_types = BaseType.all.where(datassistant_id: nil)
    render json: common_base_types
  end

  # GET /base_types/1
  def show
    if (!params[:datassistant_id])
      if (@base_type.datassistant_id)
        render json: {errors: ["Not found"]}, status: 404
      else
        render json: @base_type
      end
    else
      datassistant = current_user.datassistants.find(params[:datassistant_id])
      render json: object_with_relatives(@base_type,datassistant)
    end
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_base_type
      @base_type = BaseType.all.find(params[:id])
    end

    def object_with_relatives(base_type,datassistant)
      sub_types = base_type.get_relatives("child",datassistant.id)
      parent_path = base_type.parent_path
      {
        id: base_type.id,
        title_singular: base_type.title_singular,
        title_plural: base_type.title_plural,
        value_type: base_type.value_type,
        datassistant_id: base_type.datassistant_id,
        sub_types: sub_types,
        parent_path: parent_path
      }
    end

end
