class AnswersController < ApplicationController

  def edit
    @question = Question.find(params[:question_id])
    @answers = @question.answers.ordered_by_creation_date
    @answer = @question.answers.find(params[:id])

    render 'questions/show'
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(params.require(:answer).permit(:answer))
    if @answer.save
      flash[:notice] = 'You have created a new answer'
      redirect_to @question
    else
      flash[:alert] = @answer.errors.full_messages
      render 'questions/show'
    end
  end

  def update
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    if @answer.save
      redirect_to @question, notice: "You have updated the answer"
    else
      show_errors
      @answers = @question.answers.ordered_by_creation_date
      render 'questions/show'
    end
  end

  def delete
  end

  private

  def show_errors
    flash.now[:alert] = @answer.errors.full_messages
  end

  def answer_params
    params.require(:answer).permit(:answer)
  end

end
