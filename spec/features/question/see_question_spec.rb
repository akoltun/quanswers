require 'features/feature_helper'

feature 'User sees question page', %q{
  In order to be able to read question's answers
  As an user
  I want to be able to open question page
} do
  given(:questions) { create_list(:unique_question_with_rating, 2) }
  given!(:question) { questions.first }

  scenario 'User opens question page' do
    visit questions_path
    click_on question.title

    expect(current_path).to eq question_path question.id
  end

  scenario "User sees question" do
    visit question_path question

    within('#question') do
      within('.meta-info') do
        expect(page).to have_content "Created: #{question.created_at.to_s(:long)}"
        expect(page).to have_content "Last update: #{question.updated_at.to_s(:long)}"
      end
      expect(page).to have_selector('input.rating[value="3.0"]')
      expect(page).not_to have_content "Author"
      expect(page).not_to have_content question.user.username
      expect(page).to have_content question.title
      expect(page).to have_content question.question
      expect(page).not_to have_selector 'textarea'
    end
  end
end

feature 'User sees question author', %q{
  In order to be able to personalize question
  As an authenticated user
  I want to be able to see question author name
} do
  given(:user) { create(:user) }
  given!(:question) { create(:unique_question_with_rating, user: user) }

  scenario "User sees question" do
    sign_in user
    visit question_path question

    within('#question') do
      within('.meta-info') do
        expect(page).to have_content "Created: #{question.created_at.to_s(:long)}"
        expect(page).to have_content "Last update: #{question.updated_at.to_s(:long)}"
        expect(page).to have_content "Author:"
        expect(page).to have_content question.user.username
      end
      expect(page).to have_selector('input.rating[value="3.0"][readonly]')
      expect(page).to have_content question.title
      expect(page).to have_content question.question
      expect(page).not_to have_selector 'textarea'
    end
  end
end
