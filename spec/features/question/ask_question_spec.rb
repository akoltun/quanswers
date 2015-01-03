require 'features/feature_helper'

feature 'User asks question', %q{
  In order to be able to receive answers
  As an user
  I want to be able to ask question
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:new_question) { attributes_for(:unique_question) }

  context "Non-authenticated user" do
    scenario 'clicks "Ask New Question" button on Question List Page' do
      visit questions_path
      click_on "Ask New Question"

      expect(current_path).to eq new_user_session_path
    end

    scenario 'tries to ask a question' do
      visit new_question_path

      expect(current_path).to eq new_user_session_path
    end
  end

  context "Authenticated user" do
    background { sign_in user }

    scenario 'clicks "Ask New Question" button on Question List Page' do
      visit questions_path
      click_on "Ask New Question"

      expect(current_path).to eq new_question_path
    end

    context "asks question" do
      background { visit new_question_path }

      scenario 'with valid attributes' do
        fill_in 'Title', with: new_question[:title]
        fill_in 'Question', with: new_question[:question]
        click_on 'Save Question'

        expect(current_path).to eq questions_path
        expect(page).to have_content 'You have created a new question'
        expect(page).to have_content new_question[:title]
        expect(page).to have_content new_question[:question]
      end

      scenario 'with invalid attributes' do
        visit new_question_path
        click_on 'Save Question'

        expect(current_path).to eq questions_path
        expect(page).to have_content "There is one error"
        expect(page).to have_css '.has-error'
      end
    end
  end
end