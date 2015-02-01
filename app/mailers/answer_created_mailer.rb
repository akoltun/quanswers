class AnswerCreatedMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_notification(answer_id)
    @answer = Answer.find(answer_id)

    mail to: @answer.question.user.email, subject: "Answer for your question"
  end
end
