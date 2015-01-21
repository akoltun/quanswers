class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    sign_in_via "Facebook"
  end

  def google_oauth2
    sign_in_via "Google"
  end
  private

  def sign_in_via provider_name
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    end
  end
end
