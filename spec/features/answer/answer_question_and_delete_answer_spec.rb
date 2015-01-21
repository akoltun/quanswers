require 'features/feature_helper'

feature 'User answers question and then deletes it', %q{
  In order to help others
  As an user
  I want to be able to answer question and delete the answer if I change my mind
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:new_answer) { attributes_for(:unique_answer) }

  context 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
      # fill_in 'Answer', with: new_answer[:answer]
      page.execute_script %Q{ $('#new-answer textarea').data("wysihtml5").editor.setValue('#{new_answer[:answer]}') }
      click_on 'Save Answer'
    end

    scenario 'gives answer with valid attributes', js: true do
      click_on 'Delete Answer'
      within("#confirmation-dialog") { click_on 'Yes' }

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'You have deleted the answer'
      expect(question.answers.count).to eq 0
      expect(page).not_to have_content new_answer[:answer]
    end
  end
end