class RemarksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :load_remarkable, only: :create
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
    params.require(:remark).permit(:remark)
  end

  def load_remarkable
    if params[:answer_id]
      @remarkable = Answer.find(params[:answer_id])
    else
      @remarkable = Question.find(params[:question_id])
    end
  end

  def publish
    remark = @remark.as_json(except: :user_id)
    question = @remark.remarkable.is_a?(Answer) ? @remark.remarkable.question : @remark.remarkable
    PrivatePub.publish_to "/questions/#{question.id}", action: action_name, remark: remark

    remark[:user_id] = @remark.user.id
    remark[:author] = @remark.user.username
    PrivatePub.publish_to "/signed_in/questions/#{question.id}", action: action_name, remark: remark
  end
end
