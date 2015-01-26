class UserConfirmationRequest < ActiveRecord::Base
  validates :provider, :uid, :email, :username, presence: true

  def create_or_attach_user
    user = User.where(email: email).first
    if user
      user.update(username: username) unless user.username == username
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(username: username, email: email, password: password, password_confirmation: password)
    end
    user.identities.create(provider: provider, uid: uid)
    destroy
    user
  end

  def update_and_send_request(update_hash)
    update(update_hash.merge(confirmation_token: Devise.friendly_token))
    UserConfirmationRequestMailer.send_confirmation_email(self).deliver
  end

  def session_alive?
    request_session_created_at + 60*60 > Time.current
  end

  def self.find_for_oauth(auth)
    user_confirmation_request = UserConfirmationRequest.where(provider: auth.provider, uid: auth.uid).first

    if user_confirmation_request
      user_confirmation_request.request_session_created_at = Time.current
      user_confirmation_request.save!(validate: false)
    else
      user_confirmation_request = UserConfirmationRequest.new(provider: auth.provider, uid: auth.uid, request_session_created_at: Time.current)
      user_confirmation_request.save!(validate: false)
    end

    user_confirmation_request
  end
end
