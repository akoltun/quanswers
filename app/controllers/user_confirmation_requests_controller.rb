class UserConfirmationRequestsController < ApplicationController
  skip_authorization_check
  before_action :load_user_confirmation_request, only: [:edit, :update, :confirm]

  respond_to :html

  def new
    @user_confirmation_request = UserConfirmationRequest.new(username: session[:user_confirmation_name])
    respond_with(@user_confirmation_request)
  end

  def edit
    respond_with(@user_confirmation_request)
  end

  def create
    @user_confirmation_request = UserConfirmationRequest.create(user_confirmation_request_params.merge({ provider: session[:user_confirmation_provider], uid: session[:user_confirmation_uid] }))
    respond_with_user_confirmation_request
  end

  def update
    @user_confirmation_request.update(user_confirmation_request_params)
    respond_with_user_confirmation_request
  end

  def confirm
    if @user_confirmation_request.confirmation_token == params[:confirmation_token]
       sign_in_and_redirect @user_confirmation_request.create_or_attach_user, event: :authentication
       flash[:notice] = "Successfully authenticated from #{@user_confirmation_request.provider.humanize} account." if is_navigational_format?
    else
      head :not_found
    end
  end

  private

  def user_confirmation_request_params
    params.require(:user_confirmation_request).permit(:username, :email)
  end

  def load_user_confirmation_request
    @user_confirmation_request = UserConfirmationRequest.find(params[:id])
  end

  def respond_with_user_confirmation_request
    respond_with(@user_confirmation_request) do |format|
      format.html { redirect_to questions_path, notice: 'The message with further instructions has been sent to your email' }
    end
  end
end
