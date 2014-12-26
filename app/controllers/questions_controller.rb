class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :redirect_non_editable_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.ordered_by_creation_date
  end

  def show
    @answers = @question.answers.ordered_by_creation_date
    @editable = editable?
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params.merge({ user: current_user }))
    if @question.save
      redirect_to questions_path, notice: "You have created a new question"
    else
      show_errors
      render :new
    end
  end

  def update
    @question.update(question_params)
    if @question.save
      redirect_to @question, notice: "You have updated the question"
    else
      show_errors
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: "You have deleted the question"
  end

  private

  def show_errors
    flash.now[:alert] = @question.errors.full_messages
  end

  def question_params
    params.require(:question).permit(:title, :question)
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def redirect_non_editable_question
    unless editable?
      redirect_to @question, alert: non_editable_error_message
    end
  end

  def editable?
    user_signed_in? && @question.answers.empty? && (@question.user.id == current_user.id)
  end

  def non_editable_error_message
    "Can't #{request.delete? ? 'delete' : 'edit'} " +
    if user_signed_in? && @question.user.id == current_user.id
      "question which already has answers"
    else
      "other user's question"
    end
  end
end
