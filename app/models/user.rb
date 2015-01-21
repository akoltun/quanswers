class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many :identities, dependent: :destroy
  has_many :questions, dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error

  validates :username, presence: true

  def self.find_for_oauth(auth)
    identity = Identity.where(provider: auth.provider, uid: auth.uid).first
    return identity.user if identity

    user = User.where(email: auth.info[:email]).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(username: auth.info[:nickname] || auth.info[:name], email: auth.info[:email], password: password, password_confirmation: password)
    end
    user.identities.create(provider: auth.provider, uid: auth.uid)

    user
  end
end
