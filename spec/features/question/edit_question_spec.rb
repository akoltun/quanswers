require 'features/feature_helper'

feature 'User edits question', %q{
  In order to be able to correct mistakes in the question
  As an user
  I want to be able to edit question
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:current_user_question) { create(:question, user: user) }
  given(:another_user_question) { create(:question) }
  given(:question_with_answers) { create(:question_with_answers, user: user) }

  given(:new_question) { attributes_for(:unique_question) }

  scenario 'Non-authenticated user doesn\'t see "Edit Question" button' do
    visit question_path(another_user_question)

    expect(page).not_to have_content 'Edit Question'
  end

  context "Authenticated user" do
    background { sign_in user }

    scenario 'doesn\'t see "Edit Question" button for another user\'s question' do
      visit question_path(another_user_question)

      expect(page).not_to have_content 'Edit Question'
    end

    scenario 'doesn\'t see "Edit Question" button for question which already has answers' do
      visit question_path(question_with_answers)

      expect(page).not_to have_content 'Edit Question'
    end

    context 'edits question' do
      background do
        visit question_path(current_user_question)
        click_on 'Edit Question'
      end

      scenario 'with valid attributes', js: true do
        expect(current_path).to eq question_path(current_user_question)

        fill_in 'Title', with: new_question[:title]
        # fill_in 'Question', with: new_question[:question]
        page.execute_script %Q{ $('#question_question').data("wysihtml5").editor.setValue('#{new_question[:question]}') }
        click_on 'Save Question'

        expect(current_path).to eq question_path(current_user_question)
        expect(page).to have_content 'You have updated the question'
        expect(page).to have_content new_question[:title]
        expect(page).to have_content new_question[:question]
      end

      scenario 'with invalid attributes', js: true do
        expect(current_path).to eq question_path(current_user_question)

        fill_in 'Title', with: nil
        click_on 'Save Question'

        expect(current_path).to eq question_path(current_user_question)
        expect(page).to have_content "There is one error"
        expect(page).to have_css '.has-error'
      end

      scenario "and then changes his mind", js: true do
        expect(current_path).to eq question_path(current_user_question)

        fill_in 'Title', with: new_question[:title]
        # fill_in 'Question', with: new_question[:question]
        page.execute_script %Q{ $('#question_question').data("wysihtml5").editor.setValue('#{new_question[:question]}') }
        find('a', text: 'Cancel').click

        within('#confirmation-dialog') { click_on "Yes" }
        expect(page).not_to have_content 'You have updated the question'
        expect(page).not_to have_content new_question[:title]
        expect(page).not_to have_content new_question[:question]
        expect(page).to have_content current_user_question.title
        expect(page).to have_content current_user_question.question
      end
    end
  end
end