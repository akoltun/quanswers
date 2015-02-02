class AnswerCreatedMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_notification(answer_id, user_id)
    @answer = Answer.find(answer_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: "New Answer for the question"
  end
end
