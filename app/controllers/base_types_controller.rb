class BaseTypesController < ApplicationController
    before_action :set_base_type, only: [:show]

    # GET /base_types
  def index
    @base_types = BaseType.all

    render json: @base_types
  end

  # GET /base_types/1
  def show
    render json: @base_type
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_base_type
      @base_type = BaseType.all.find(params[:id])
    end

end
