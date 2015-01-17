class RemarksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_remark, except: :create
  before_action :authorize_user, except: :create
  before_action :load_remarkable, only: :create
  before_action :load_question, only: [:create, :update, :destroy]
  after_action :publish, if: "@remark.errors.empty?", unless: "Rails.env.test?"

  respond_to :json

  def create
    respond_with(@remark = @remarkable.remarks.create(remark_params.merge(user: current_user)))
  end

  def update
    @remark.update(remark_params)
    respond_with(@remark) do |format|
      format.json { render :show } if @remark.errors.empty?
    end
  end

  def destroy
    respond_with(@remark.destroy) do |format|
      format.json { render json: { id: @remark.id } }
    end
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
