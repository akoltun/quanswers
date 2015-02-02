class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  ActionView::Base.send(:include, Rails.application.routes.url_helpers)

  recurrence { daily(1).hour_of_day(5) }

  def perform
    template = File.read("app/views/daily_digest_mailer/questions.html.erb")
    @questions = Question.last_day
    Redis.new.set('daily_digest', ERB.new(template).result(binding))

    User.find_each do |user|
      DailyDigestMailer.delay.digest(user.id)
    end
  end
end