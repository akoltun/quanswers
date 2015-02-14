class AnswerCreatedMailer < ActionMailer::Base
  default from: "admin@178.62.244.173"

  def send_notification(answer_id, user_id)
    @answer = Answer.find(answer_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: "New Answer for the question"
  end
end
