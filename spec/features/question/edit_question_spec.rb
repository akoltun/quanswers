require 'rails_helper'

feature 'User edits question', %q{
  In order to be able to correct mistakes in the question
  As an user
  I want to be able to edit question
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:question_hash) { attributes_for(:question) }
  given(:current_user_question) { create(:question, question_hash.merge(user: user)) }
  given(:another_user_question) { create(:question, question_hash) }
  given(:question_with_answers) { create(:question_with_answers, user: user) }

  given(:new_title) { 'Edited question title' }
  given(:new_question) { 'Edited question body' }

  scenario "Non-authenticated user tries to open edit page" do
    visit edit_question_path(another_user_question)

    expect(current_path).to eq new_user_session_path
  end

  context "Authenticated user" do
    before { sign_in user }

    scenario 'edits his own question and then saves changes' do
      visit edit_question_path(current_user_question)
      fill_in 'Title', with: :new_title
      fill_in 'Question', with: :new_question
      click_on 'Save Question'

      expect(current_path).to eq question_path(current_user_question)
      expect(page).to have_content 'You have updated the question'
      expect(page).to have_content :new_title
      expect(page).to have_content :new_question
    end

    scenario 'edits his own question and then saves it with invalid attributes' do
      visit edit_question_path(current_user_question)
      fill_in 'Title', with: nil
      click_on 'Save Question'

      expect(current_path).to eq question_path(current_user_question)
      expect(page).to have_content 'Error!'
      expect(page).to have_css '.field_with_errors'
    end

    scenario "tries open edit question page for another user's question" do
      visit edit_question_path(another_user_question)

      expect(current_path).to eq question_path(another_user_question)
      expect(page).to have_content "Can't edit other user's question"
      expect(page).not_to have_content 'Edit Question'
    end

    scenario "doesn't see 'Edit Question' button for other users' questions" do
      visit question_path(another_user_question)

      expect(page).not_to have_content 'Edit Question'
    end

    scenario 'tries open edit question page for his own question which already has answers' do
      visit edit_question_path(question_with_answers)

      expect(current_path).to eq question_path(question_with_answers)
      expect(page).to have_content "Can't edit question which already has answers"
      expect(page).not_to have_content 'Edit Question'
    end

    scenario "doesn't see 'Edit Question' button for his own questions which already has answers" do
      visit question_path(question_with_answers)

      expect(page).not_to have_content 'Edit Question'
    end
  end
end