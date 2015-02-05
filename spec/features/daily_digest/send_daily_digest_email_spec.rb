require 'features/feature_helper'

feature 'User receives daily digest email', %q{
  In order to be well informed about QuAnswers activity
  As an user
  I want to be able to receive daily digest email
} do
  given!(:user) { create(:user) }
  given(:old_questions) { create_list(:unique_question, 2) }
  given(:new_questions) { create_list(:unique_question, 2) }
  background do
    Timecop.travel Time.new(2015, 1, 1, 10)
    old_questions

    Timecop.travel Time.new(2015, 1, 2, 10)
    new_questions

    Timecop.travel Time.new(2015, 1, 3, 5)
  end

  context "Sidekiq sends email to user" do
    background { DailyDigestWorker.new.perform }

    scenario "User see all yesterday questions" do
      open_email(user.email)

      expect(current_email).to have_content user.username

      new_questions.each do |question|
        expect(current_email).to have_link question.title #, href: question_url(question)
        expect(current_email).to have_content question.question
      end

      old_questions.each do |question|
        expect(current_email).not_to have_link question.title
        expect(current_email).not_to have_content question.question
      end

      # current_email.save_and_open
    end
  end
end