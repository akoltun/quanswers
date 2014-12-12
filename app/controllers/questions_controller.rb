class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.order(created_at: :desc)
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
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
    flash[:alert] = @question.errors.full_messages
  end

  def question_params
    params.require(:question).permit(:title, :question)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
