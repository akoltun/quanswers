class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  # before_action :load_question, only: [:create]
  # before_action :load_answer, only: [:edit, :update, :destroy]
  # before_action :authorize_user, only: [:update]
  # before_action :load_answers, only: [:edit]

  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
  end

  def show
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      flash.now[:notice] = 'You have created a new answer'
      @answers = @question.answers.ordered_by_creation_date
      @answer = Answer.new
    else
      @errors = @answer.errors.full_messages
    end
  end

  def update
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    if @answer.user == current_user
      if @answer.update(answer_params)
        flash.now[:notice] = "You have updated the answer"
        @answers = @question.answers.ordered_by_creation_date
      else
        @errors = @answer.errors.full_messages
      end
    else
      head :forbidden
    end
  end

  def destroy
    authenticate_user!
    @question = Question.find(params[:question_id])
    @answer = @question.answers.find(params[:id])
    if @answer.user == current_user
      @id = @answer.id
      @answer.destroy
      flash.now[:notice] = "You have deleted the answer"
    else
      head :forbidden
    end
  end

  private

  # def authorize_user
  #   unless @answer.user == current_user
  #     head :forbidden
  #   end
  # end

  # def show_errors
  #   flash.now[:alert] = @answer.errors.full_messages
  # end

  def answer_params
    params.require(:answer).permit(:answer)
  end

  # def load_question
  #   @question = Question.find(params[:question_id])
  # end

  # def load_answers
  #   @answers = @question.answers.ordered_by_creation_date
  # end

  # def load_answer
  #   @answer = Answer.find(params[:id])
  # end

  # def save_answer(success_message)
  #   if @answer.save
  #     flash.now[:notice] = success_message
  #   else
  #     flash.now[:alert] = @answer.errors.full_messages
  #   end
  # end
end
