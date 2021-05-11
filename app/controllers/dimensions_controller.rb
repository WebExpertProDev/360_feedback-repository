class DimensionsController < ApplicationController
  before_action :set_dimension, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /dimensions
  def index
    @dimensions = Dimension.all
  end

  # GET /dimensions/1
  def show
  end

  # GET /dimensions/new
  def new
    @dimension = Dimension.new
  end

  # GET /dimensions/1/edit
  def edit
  end

  # POST /dimensions
  def create
    @dimension = Dimension.new(dimension_params)

    if @dimension.save
      redirect_to admin_questionnaires_path, notice: 'Dimension was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /dimensions/1
  def update
    if @dimension.update(dimension_params)
      redirect_to admin_questionnaires_path, notice: 'Dimension was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dimensions/1
  def destroy
    @dimension.destroy
    redirect_to admin_questionnaires_path, notice: 'Dimension was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dimension
      @dimension = Dimension.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dimension_params
      params.require(:dimension).permit(:name, :questionnaire_id)
    end
end
