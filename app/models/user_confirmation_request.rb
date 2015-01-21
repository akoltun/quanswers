class UserConfirmationRequest < ActiveRecord::Base
  validates :provider, :uid, :email, :username, presence: true

  before_save :generate_confirmation_token
  after_save :send_email

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

  private

  def generate_confirmation_token
    self.confirmation_token = Devise.friendly_token
  end

  def send_email
    UserConfirmationRequestMailer.send_confirmation_email(self).deliver
  end
end
