class UserConfirmationRequestsController < ApplicationController
  skip_authorization_check
  before_action :load_user_confirmation_request
  before_action :authorize, except: :confirm

  respond_to :html

  def edit
    respond_with(@user_confirmation_request)
  end

  def update
    @user_confirmation_request.update_and_send_request(user_confirmation_request_params)
    respond_with(@user_confirmation_request) do |format|
      format.html do
        redirect_to questions_path, notice: 'The message with further instructions has been sent to your email'
        session[:request_user_confirmation] = nil
      end
    end
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

  def authorize
    unless session[:request_user_confirmation] && @user_confirmation_request.session_alive?
      head :not_found
    end
  end
end
