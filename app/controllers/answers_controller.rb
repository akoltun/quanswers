class AnswersController < ApplicationController
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

  def udate
  end

  def delete
  end
end
