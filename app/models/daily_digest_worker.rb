class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily(1).hour_of_day(5) }

  def perform
    User.find_each do |user|
      DailyDigestMailer.delay.digest(user.id)
    end
  end
end