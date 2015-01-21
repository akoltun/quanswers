class UserConfirmationRequestMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_confirmation_email(user_confirmation_request)
    @user_confirmation_request = user_confirmation_request
    mail(to: @user_confirmation_request.email, subject: "Email confirmation message for your QuAnswers account")
  end
end
