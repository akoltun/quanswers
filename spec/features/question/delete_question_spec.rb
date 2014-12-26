require 'rails_helper'

feature 'User deletes question', %q{
  In order to be able to remove mistaken question
  As an user
  I want to be able to delete question
} do
  given(:user) { create(:user) }
  given(:current_user_question) { create(:question, user: user) }
  given(:another_user_question) { create(:question) }
  given(:question_with_answers) { create(:question_with_answers, user: user) }

  scenario 'Non-authenticated user doesn''t see "Delete Question" button' do
    visit question_path(another_user_question)

    expect(page).not_to have_content 'Delete Question'
  end

  context "Authenticated user" do
    background { sign_in user }

    scenario 'deletes his own question' do
      visit question_path(current_user_question)
      click_on 'Delete Question'

      expect(current_path).to eq question_path(current_user_question)
      expect { within("#deleteQuestionDialog") { click_on "Yes" } }.to change(Question, :count).by(-1)

      expect(current_path).to eq questions_path
      expect(page).to have_content 'You have deleted the question'
    end

    scenario 'doesn''t see "Delete Question" button for question with answers' do
      visit question_path(question_with_answers)

      expect(page).not_to have_content 'Delete Question'
    end
  end

  # scenario 'User try to delete question but then changes his mind' do
  #   visit question_path(existing_question)
  #   click_on 'Delete Question'
  #   expect(current_path).to eq question_path(existing_question)
  #
  #   expect { within("#deleteQuestionDialog") { click_on "No" } }.not_to change(Question, :count)
  #
  #   expect(current_path).to eq question_path(existing_question)
  #   expect(page).not_to have_content 'You have deleted the question'
  # end
end