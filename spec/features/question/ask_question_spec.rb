require 'rails_helper'

feature 'User asks question', %q{
  In order to be able to receive answers
  As an user
  I want to be able to ask question
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }

  given(:question_title) { 'Question title' }
  given(:question_body) { 'Question body' }

  scenario 'Non-authenticated user tries to ask valid question' do
    visit new_question_path

    expect(current_path).to eq new_user_session_path
  end

  context "Authenticated user" do
    background { sign_in user }

    context "asks" do
      background { visit new_question_path }

      scenario 'valid question' do
        fill_in 'Title', with: :question_title
        fill_in 'Question', with: :question_body
        click_on 'Save Question'

        expect(current_path).to eq questions_path
        expect(page).to have_content 'You have created a new question'
        expect(page).to have_content :question_title
        expect(page).to have_content :question_body
      end

      scenario 'invalid question' do
        visit new_question_path
        click_on 'Save Question'

        expect(current_path).to eq questions_path
        expect(page).to have_content 'Error!'
        expect(page).to have_css '.field_with_errors'
      end
    end

    scenario 'click "Ask New Question" button' do
      visit questions_path
      click_on "Ask New Question"

      expect(current_path).to eq new_question_path
    end
  end
end