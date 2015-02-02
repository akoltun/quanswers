class NewAnswerNotificationWorker
  include Sidekiq::Worker

  def perform(answer_id)
    Answer.find(answer_id).question.followers.find_each do |user|
      AnswerCreatedMailer.delay.send_notification(answer_id, user.id)
    end
  end
end