class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :load_answers, only: [:show, :update]
  before_action :assign_editable, only: [:show, :update, :destroy]

  def index
    @questions = Question.ordered_by_creation_date
  end

  def show
    create_answer
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params.merge({ user: current_user }))
    if @question.save
      redirect_to questions_path, notice: "You have created a new question"
    else
      render :new
    end
  end

  def update
    if @editable
      if @question.update(question_params)
        flash.now[:notice] = "You have updated the question"
      end
    else
      flash.now[:alert] = "Can't edit #{non_editable_reason}"
    end
    create_answer
    render :show
  end

  def destroy
    if @editable
      @question.destroy
      redirect_to questions_path, notice: "You have deleted the question"
    else
      redirect_to @question, alert: "Can't delete #{non_editable_reason}"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :question, attachments_attributes: [:id, :file, :file_cache, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def load_answers
    @answers = @question.answers.ordered_by_creation_date
  end

  def create_answer
    @answer = @question.answers.build
  end

  def assign_editable
    @editable = user_signed_in? && @question.answers.empty? && (@question.user.id == current_user.id)
  end

  def non_editable_reason
    if user_signed_in? && @question.user.id == current_user.id
      "question which already has answers"
    else
      "another user's question"
    end
  end
end
