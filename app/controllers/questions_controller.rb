class QuestionsController < ApplicationController
  include TruncateHtmlHelper

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :load_answers, only: [:show, :update]
  before_action :create_answer, only: :show
  before_action :assigns_author_signed_in, only: [:show, :update, :destroy]
  after_action :publish, only: [:create, :update, :destroy], if: "@question.errors.empty?", unless: "Rails.env.test?"

  respond_to :html, except: :update
  respond_to :js, only: [:show, :update]

  def index
    respond_with(@questions = Question.ordered_by_creation_date)
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params.merge({ user: current_user })))
  end

  def update
    if @author_signed_in
      if @question.editable?
        if @question.update(question_params)
          flash.now[:notice] = "You have updated the question"
        end
      else
        flash.now[:alert] = "Can't update question which already has answers"
      end
    else
      flash.now[:alert] = "Can't update another user's question"
    end
    create_answer
    respond_with @question do |format|
      format.js { render :show }
    end
  end

  def destroy
    redirect_to @question, alert: "Can't delete another user's question" and return unless @author_signed_in
    redirect_to @question, alert: "Can't delete question which already has answers" and return unless @question.editable?

    respond_with(@question.destroy)
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

  def assigns_author_signed_in
    @author_signed_in = @question.user == current_user
  end

  def publish
    question_hash = @question.as_json(only: [:id, :title])
    question_hash[:question] = truncate_html(@question.question)
    questions_path[:no_best_answer] = @question.best_answer.nil?
    PrivatePub.publish_to "/questions", action: action_name, question: question_hash

    question_hash[:author] = @question.user.username
    PrivatePub.publish_to "/signed_in/questions", action: action_name, question: question_hash
  end
end
