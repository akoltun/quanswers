class RemarksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_remark, except: :create
  before_action :authorize_user, except: :create

  def create
    @question = Question.find(params[:question_id])
    @remark = @question.remarks.build(remark_params.merge(user: current_user))
    if @remark.save
      render :show, status: :created
    else
      @errors = @remark.errors.full_messages
      render :error, status: :unprocessable_entity
    end
  end

  def update
    if @remark.update(remark_params)
      render :show
    else
      @errors = @remark.errors.full_messages
      render :error, status: :unprocessable_entity
    end
  end

  def destroy
    @remark.destroy
    head :ok
  end

  private

  def remark_params
    params.require(:remark).permit(:remark)
  end

  def load_remark
    @remark = Remark.find(params[:id])
  end

  def authorize_user
    unless @remark.user == current_user
      head :forbidden
    end
  end

end
