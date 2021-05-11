class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin
  load_and_authorize_resource
  # GET /questions
  def index
    @questionnaires = Questionnaire.all
    questionnaire = Questionnaire.find(params[:questionnaire]) if params[:questionnaire].present?
    @questionnaire_name = questionnaire&.name
    if params[:questionnaire].present?
      @questions = Question.where(questionnaire_id: questionnaire)
                           .includes(:statements, :options, :dimension)
                           .page(params[:page]).per(25)
    else
      @questions = Question.all.page(params[:page]).per(25)
    end
  end

  # GET /questions/1
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    @dimensions = []
    @question.statements.build(full_text: 'Where is his/her behaviour currently situated?')
    @question.statements.build(full_text: 'Where do you think it should be to be even more effective as a leader ?')
    # statement1
    2.times do
      @question.options.build
    end
    # if request.xhr?

    if params[:questionnaire_id].present?
      @questionnaire = Questionnaire.find(params[:questionnaire_id])
      if @questionnaire.id > 2
        @statement1 = 'How often does this person shows this behaviour?'
        @statement2 = 'How often should this person show this behaviour in order to develop himself as a leader?'
      elsif @questionnaire.id == 2
        @statement1 = 'Observing the behaviour of this person estimate if the underlying belief is more related to the left hand statement or to the right hand one?'
        @statement2 = 'To develop as a leader should this person move more to the right or left hand statement compared with now?'

      else
        @statement1 = 'Where is his/her behaviour currently situated?'
        @statement2 = 'Where do you think it should be to be even more effective as a leader ?'
      end
      @dimensions = @questionnaire.dimensions

      # render json: {dimensions: @dimensions,statement1: statement1,statement2: statement2}
    end


      respond_to do |format|
        format.json {}
        format.html {}
        format.js {}
      end
    # end
  end

  # GET /questions/1/edit
  def edit
    unless @question.statements.present?
      2.times do
        @question.statements.build
      end
    end
  end

  # POST /questions
  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:questionnaire_id,:dimension_id,statements_attributes: [:id,:_destroy,:statement_type,:full_text],options_attributes: [:id,:_destroy,:full_text,:option_type])
    end
end
