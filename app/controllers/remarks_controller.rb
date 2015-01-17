class RemarksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_remark, except: :create
  before_action :authorize_user, except: :create
  before_action :load_remarkable, only: :create
  before_action :load_question, only: [:create, :update, :destroy]
  after_action :publish, if: "@remark.errors.empty?", unless: "Rails.env.test?"

  def create
    @remark = @remarkable.remarks.build(remark_params.merge(user: current_user))
    if @remark.save
      render json: @remark, status: :created
    else
      render json: @remark.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @remark.update(remark_params)
      render json: @remark
    else
      render json: @remark.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @remark.destroy
    render json: { id: @remark.id }
  end

  private

  def remark_params
    logger.debug params.inspect
    params.require(:remark).permit(:remark)
  end

  def load_remark
    @remark = Remark.find(params[:id])
    @remarkable = @remark.remarkable
  end

  def load_remarkable
    if params[:answer_id]
      @remarkable = Answer.find(params[:answer_id])
    else
      @remarkable = Question.find(params[:question_id])
    end
  end

  def load_question
    if @remarkable.is_a? Answer
      @question = @remarkable.question
    else
      @question = @remarkable
    end
  end

  def authorize_user
    unless @remark.user == current_user
      head :forbidden
    end
  end

  def publish
    PrivatePub.publish_to "/questions/#{@question.id}", action: action_name, remark: @remark
  end
end
