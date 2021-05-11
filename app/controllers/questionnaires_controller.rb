# frozen_string_literal: true

# :Questionnaires Controller for managing questionnaires actions:
class QuestionnairesController < ApplicationController
  before_action :set_questionnaire, only: %i[show edit update destroy]
  load_and_authorize_resource
  def index
    @questionnaires = Questionnaire.all
  end

  def new
    @questionnaire = Questionnaire.new
  end

  def show; end

  def create
    @questionnaire = Questionnaire.new(questionnaire_params)
    if @questionnaire.save
      redirect_to @questionnaire, notice: 'Questionnaire was successfully created.'
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @questionnaire.update(questionnaire_params)
      redirect_to @questionnaire, notice: 'Questionnaire was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    return unless @questionnaire.destroy

    redirect_to questionnaires_path, notice: 'Questionnaire was successfully deleted.'
  end

  private

  def set_questionnaire
    @questionnaire = Questionnaire.find(params[:id])
  end

  def questionnaire_params
    params.require(:questionnaire).permit(:name, :intro_text, :priority)
  end
end
