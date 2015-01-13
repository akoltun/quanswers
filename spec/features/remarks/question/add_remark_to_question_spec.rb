require 'features/feature_helper'

feature 'User adds remark to question', %q{
  In order to be able to make question more clear
  As an authenticated user
  I want to be able to add remarks to question
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:question) { create(:question) }
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
        within('#question') { click_on "Add Remark" }
      end

      scenario 'with valid attributes', js: true do
        within('#question') do
          expect(question.remarks.count).to eq 0
          # fill_in 'Remark', with: new_remark[:remark]
          page.execute_script %Q{ $('#remark-textarea').data("wysihtml5").editor.setValue('#{new_remark[:remark]}') }
          click_on 'Save Remark'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'You have added a new remark'
        expect(question.remarks.count).to eq 1
        within("#question-remarks") do
          expect(page).to have_content new_remark[:remark]
          expect(page).not_to have_selector "iframe"
        end
      end

      scenario 'with invalid attributes', js: true do
        within('#question') do
          expect(question.remarks.count).to eq 0
          click_on 'Save Remark'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content "Remark can't be blank"
      end
    end
  end
end