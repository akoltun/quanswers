require 'features/feature_helper'

feature 'User adds remark to answer', %q{
  In order to be able to make answer more clear
  As an authenticated user
  I want to be able to add remarks to answer
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:answer) { create :answer }
  given(:question) { answer.question }
  given(:new_remark) { attributes_for(:remark) }

  scenario 'non-authenticated user does not see "Add Remark" button' do
    visit question_path(question)

    expect(page).not_to have_content "Add Remark"
  end

  context 'authenticated user' do
    background { sign_in user }

    context 'add remarks' do
      background do
        visit question_path(question)
        within("#answer-#{answer.id}") { click_on "Add Remark" }
      end

      scenario 'with valid attributes', js: true do
        within("#answer-#{answer.id}") do
          expect(answer.remarks.count).to eq 0
          # fill_in 'Remark', with: new_remark[:remark]
          page.execute_script %Q{ $('#remark-textarea').data("wysihtml5").editor.setValue('#{new_remark[:remark]}') }
          click_on 'Save Remark'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'You have added a new remark'
        expect(answer.remarks.count).to eq 1
        within("#answer-#{answer.id} .answer-remarks") do
          expect(page).to have_content new_remark[:remark]
          expect(page).not_to have_selector "iframe"
        end
      end

      scenario 'with invalid attributes', js: true do
        within("#answer-#{answer.id}") do
          expect(answer.remarks.count).to eq 0
          click_on 'Save Remark'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content "Remark can't be blank"
      end
    end
  end
end