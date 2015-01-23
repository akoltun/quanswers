class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def facebook
    sign_in_via "Facebook"
  end

  def google_oauth2
    sign_in_via "Google"
  end

  def twitter
    sign_in_via "Twitter"
  end

  private

  def sign_in_via provider_name
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.is_a? User
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
      end

    else # @user.is_a? UserConfirmationRequest
      session[:user_confirmation_provider] = @user.provider
      if @user.persisted?
        redirect_to edit_user_confirmation_request_path(@user)
      else
        session[:user_confirmation_uid] = @user.uid
        session[:user_confirmation_name] = @user.username
        redirect_to new_user_confirmation_request_path
      end
    end
  end
end
