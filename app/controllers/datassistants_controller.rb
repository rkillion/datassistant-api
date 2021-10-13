class DatassistantsController < ApplicationController
  before_action :confirm_authentication
  before_action :set_datassistant, only: [:show, :update, :destroy]

  # GET /datassistants
  def index
    @datassistants = current_user.datassistants

    render json: @datassistants
  end

  # GET /datassistants/1
  def show
    render json: @datassistant
  end

  # POST /datassistants
  def create
    datassistant = Datassistant.new(datassistant_params)
    current_user.datassistants << datassistant
    if datassistant.save
      render json: datassistant, status: :created
    else
      render json: {errors: datassistant.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /datassistants/1
  def update
    if @datassistant.update(datassistant_params)
      render json: @datassistant
    else
      render json: @datassistant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /datassistants/1
  def destroy
    @datassistant.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_datassistant
      @datassistant = current_user.datassistants.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def datassistant_params
      params.require(:datassistant).permit(:title)
    end
end
