class DailyDigestMailer < ActionMailer::Base
  default from: "admin@178.62.244.173"

  def digest(user_id)
    @user = User.find(user_id)
    @template = Redis.new.get('daily_digest')

    mail to: @user.email, subject: "QuAnswers: #{Date.yesterday.to_s(:long)} daily digest"
  end
end
