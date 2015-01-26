require 'features/feature_helper'

feature 'User see question rating on question page', %q{
  In order to be able to estimate question
  As an user
  I want to be able to see question rating
} do
  given!(:question) { create(:unique_question_with_rating) }

  scenario "User sees question" do
    visit question_path question

    within('#question') do
      expect(page).to have_selector('input.rating[value="3.0"][data-initial-value="3.0"][readonly]')
    end
  end
end
