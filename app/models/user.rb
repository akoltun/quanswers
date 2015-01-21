class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :twitter]

  has_many :identities, dependent: :destroy
  has_many :questions, dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error

  validates :username, presence: true

  def self.find_for_oauth(auth)
    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    return identity.user if identity

    email = auth.info[:email]

    if email
      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.create!(username: auth.info[:nickname] || auth.info[:name] || email, email: email, password: password, password_confirmation: password)
      end
      user.identities.create(provider: auth.provider, uid: auth.uid)

      user

    else
      UserConfirmationRequest.where(provider: auth.provider, uid: auth.uid).first ||
          UserConfirmationRequest.new(provider: auth.provider, uid: auth.uid)
    end
  end
end
