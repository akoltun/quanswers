class AnswersController < ApplicationController
  before_action :load_question, only: [:edit, :create, :update]
  before_action :load_answer, only: [:edit, :update]
  before_action :load_answers, only: [:edit]

  def edit
    render 'questions/show'
  end

  def create
    @answer = @question.answers.build(answer_params)
    save_answer 'You have created a new answer'
  end

  def update
    @answer.update(answer_params)
    save_answer "You have updated the answer"
  end

  private

  def show_errors
    flash.now[:alert] = @answer.errors.full_messages
  end

  def answer_params
    params.require(:answer).permit(:answer)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answers
    @answers = @question.answers.ordered_by_creation_date
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def save_answer(success_message)
    if @answer.save
      redirect_to @question, notice: success_message
    else
      show_errors
      load_answers
      render 'questions/show'
    end
  end
end
