class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, except: :create
  before_action :assign_question, except: :create
  authorize_resource
  after_action :publish, if: "@answer.errors.empty?", unless: "Rails.env.test?"
  after_action :publish_answers_info, only: [:set_as_best, :create, :destroy], if: "@answer.errors.empty?", unless: "Rails.env.test?"

  respond_to :json

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user))) do |format|
      format.json { render json: answer_as_json(true) } if @answer.errors.empty?
    end
  end

  def update
    @answer.update(answer_params)
    respond_with @answer do |format|
      format.json { render json: answer_as_json(true) } if @answer.errors.empty?
    end
  end

  def destroy
    respond_with(@answer.destroy) do |format|
      format.json { render json: { id: @answer.id } }
    end
  end

  def set_as_best
    @answer.best!
    if @question.save
      render json: { id: @answer.id }
    else
      render_errors @question
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:answer, attachments_attributes: [:id, :file, :file_cache, :_destroy])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.includes(:attachments).find(params[:id])
  end

  def assign_question
    @question = @answer.question
  end

  def render_errors(source)
    render json: { errors: source.errors.full_messages }, status: :unprocessable_entity
  end

  def answer_as_json(show_author)
    hash = @answer.as_json(include: :attachments)
    if show_author
      hash[:author] = @answer.user.username
    else
      hash.except!(:user_id)
    end
    hash[:created_at] = @answer.created_at.to_s(:long)
    hash[:updated_at] = @answer.updated_at.to_s(:long)
    hash
  end

  def publish
    PrivatePub.publish_to "/questions/#{@question.id}", action: action_name, answer: answer_as_json(false)
    PrivatePub.publish_to "/signed_in/questions/#{@question.id}", action: action_name, answer: answer_as_json(true)
  rescue
    return
  end

  def publish_answers_info
    answers_count = @answer.question.answers.count > 0 ? @answer.question.answers.count : nil
    PrivatePub.publish_to "/questions", action: 'answers_info', question: { id: @answer.question.id, no_best_answer: !@answer.question.best_answer, answers_count: answers_count }
    PrivatePub.publish_to "/signed_in/questions", action: 'answers_info', question: { id: @answer.question.id, no_best_answer: !@answer.question.best_answer, answers_count: answers_count }
  rescue
    return
  end
end
