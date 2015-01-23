class QuestionsController < ApplicationController
  include TruncateHtmlHelper

  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource
  before_action :load_answers, only: [:show, :update]
  before_action :create_answer, only: [:show, :update]
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
    @question.update(question_params)
    respond_with @question do |format|
      format.js { render :show }
    end
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(:title, :question, attachments_attributes: [:id, :file, :file_cache, :_destroy])
  end

  def load_answers
    @answers = @question.answers.ordered_by_creation_date
  end

  def create_answer
    @answer = Answer.new
  end

  def publish
    question_hash = @question.as_json(only: [:id, :title])
    question_hash[:question] = truncate_html(@question.question)
    question_hash[:no_best_answer] = @question.best_answer.nil?
    PrivatePub.publish_to "/questions", action: action_name, question: question_hash

    question_hash[:author] = @question.user.username
    PrivatePub.publish_to "/signed_in/questions", action: action_name, question: question_hash
  end
end
