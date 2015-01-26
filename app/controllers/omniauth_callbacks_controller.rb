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
    auth = request.env['omniauth.auth']

    user = User.find_for_oauth(auth)

    if user
      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
      end
      return
    end

    redirect_to edit_user_confirmation_request_path(UserConfirmationRequest.find_for_oauth(auth))
    session[:request_user_confirmation] = true
  end
end
