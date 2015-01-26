require 'features/feature_helper'

feature 'User ratings question on question page', %q{
  In order to be able to estimate question
  As an authenticated user
  I want to be able to rating question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:unique_question_with_rating) }

  scenario "User can't rating own question" do
    sign_in question.user
    visit question_path question

    within('#question') do
      expect(page).to have_selector('input.rating[value="3.0"][readonly]')
    end
  end

  scenario "User ratings another user's question", js: true do
    sign_in user
    visit question_path question

    within('#question') do
      page.execute_script %Q{ $('#question input.rating').rating('update', 2) }
      # page.execute_script %Q{ setTimeout(function() { $('#question').append('<div>Hack Capybara</div>'); }, 1000) }
      # expect(page).to have_content "Hack Capybara"
      # expect(page.execute_script %Q{ return $('#question input.rating').val() }).to eq 2.5
    end
  end
end