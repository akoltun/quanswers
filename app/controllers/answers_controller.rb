class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:show, :update, :destroy]
  before_action :assign_question, except: [:new, :create]
  before_action :authorize_user, only: [:update, :destroy]

  def new
    @answer = Answer.new
  end

  def show
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      flash.now[:notice] = 'You have created a new answer'
      load_answers
      @answer = Answer.new
      @editable = false
    else
      load_errors
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:notice] = "You have updated the answer"
      load_answers
    else
      load_errors
    end
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = "You have deleted the answer"
    @editable = @question.answers.empty?
    @id = @answer.id
    @answer = Answer.new
  end

  private

  def authorize_user
    unless @answer.user == current_user
      head :forbidden
    end
  end

  def answer_params
    params.require(:answer).permit(:answer, attachments_attributes: [:id, :file, :file_cache, :_destroy])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def assign_question
    @question = @answer.question
  end

  def load_answers
    @answers = @question.answers.ordered_by_creation_date
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_errors
    @errors = @answer.errors.full_messages
  end
end
