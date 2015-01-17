class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, except: :create
  before_action :assign_question, except: :create
  before_action :authorize_user, except: [:create, :set_as_best]
  after_action :publish, if: "@answer.errors.empty?", unless: "Rails.env.test?"

  respond_to :json

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer do |format|
      format.json { render json: @answer, include: :attachments } if @answer.errors.empty?
    end
  end

  def destroy
    respond_with(@answer.destroy) do |format|
      format.json { render json: { id: @answer.id } }
    end
  end

  def set_as_best
    if @question.user == current_user
      @answer.best!
      if @question.save
        render json: { id: @answer.id }
      else
        render_errors @question
      end
    else
      head :forbidden
    end
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

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def assign_question
    @question = @answer.question
  end

  def render_errors(source)
    render json: { errors: source.errors.full_messages }, status: :unprocessable_entity
  end

  def publish
    PrivatePub.publish_to "/questions/#{@question.id}", action: action_name, answer: @answer.as_json(include: :attachments)
  end
end
