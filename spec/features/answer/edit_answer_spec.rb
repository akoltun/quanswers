require 'features/feature_helper'

feature 'User edits answer', %q{
  In order to be able to correct mistakes in the answer
  As an authenticated user
  I want to be able to edit answer
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:answer) { create(:answer, user: user) }
  given(:new_answer) { attributes_for(:unique_answer) }

  scenario 'Non-authenticated user doesn\'t see "Edit Answer" button' do
    visit question_path(answer.question)

    expect(page).not_to have_content "Edit Answer"
  end

  context "Authenticated user" do
    background do
      sign_in user
      visit question_path(answer.question)
    end

    context "for another user's answer" do
      given(:answer) { create(:answer) }

      scenario 'doesn\'t see "Edit Answer" button' do
        within("#answer-#{answer.id}") do
          expect(page).not_to have_content "Edit Answer"
        end
      end
    end

    context 'edits answer' do
      given(:new_value)  { new_answer[:answer] }

      background do
        within("#answer-#{answer.id}") do
          click_on 'Edit Answer'
        end
      end

      scenario 'with valid attributes', js: true do
        within("#answer-#{answer.id}") do
          # fill_in 'Answer', with: new_answer[:answer]
          page.execute_script %Q{ $('#answer_answer').data("wysihtml5").editor.setValue('#{new_value}') }
          click_on 'Save Answer'

          expect(current_path).to eq question_path(answer.question)
          expect(page).to have_content new_answer[:answer]
          expect(page).not_to have_selector 'iframe'
          expect(page).to have_content "Edit Answer"
          expect(page).not_to have_selector 'input[value="Save Answer"]'
        end
        expect(page).to have_content 'You have updated the answer'
      end

      scenario 'with invalid attributes', js: true do
        within("#answer-#{answer.id}") do
          # fill_in 'Answer', with: new_answer[:answer]
          page.execute_script %Q{ $('#answer_answer').data("wysihtml5").editor.setValue('') }
          click_on 'Save Answer'

          expect(current_path).to eq question_path(answer.question)
          expect(page).to have_content "There is one error"
          expect(page).to have_content "Answer can't be blank"
          expect(page).to have_css '.has-error'
          expect(page).to have_selector 'iframe'
          expect(page).to have_selector 'input[value="Save Answer"]'
          expect(page).not_to have_content "Edit Answer"
        end
        expect(page).not_to have_content 'You have updated the answer'
      end

      scenario 'and then changes his mind', js: true do
        within("#answer-#{answer.id}") do
          # fill_in 'Answer', with: new_answer[:answer]
          page.execute_script %Q{ $('#answer_answer').data("wysihtml5").editor.setValue('#{new_value}') }
          find('a', text: 'Cancel').click
        end

        within("#confirmation-dialog") { click_on "Yes" }

        within("#answer-#{answer.id}") do
          expect(current_path).to eq question_path(answer.question)
          expect(page).to have_content answer.answer
          expect(page).not_to have_selector 'iframe'
          expect(page).not_to have_content have_selector 'input[value="Save Answer"]'
          expect(page).to have_content "Edit Answer"
        end
        expect(page).not_to have_content 'You have updated the answer'
      end
    end
  end
end