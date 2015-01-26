require 'features/feature_helper'

feature 'User answers question', %q{
  In order to help others
  As an user
  I want to be able to answer question
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:new_answer) { attributes_for(:unique_answer) }

  scenario 'Non-authenticated user does not see neither "Save Answer" button nor textarea' do
    visit question_path(question)

    expect(page).not_to have_content "Save Answer"
    expect(page).not_to have_selector "iframe"
  end

  context 'Authenticated user' do
    background { sign_in user }

    scenario 'gives answer with valid attributes', js: true do
      visit question_path(question)
      # fill_in 'Answer', with: new_answer[:answer]
      page.execute_script %Q{ $('#new-answer textarea').data("wysihtml5").editor.setValue('#{new_answer[:answer]}') }
      click_on 'Save Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'You have created a new answer'
      expect(question.answers.count).to eq 1
      within("#answers #answer-#{question.answers.first.id}") do
        expect(page).to have_content new_answer[:answer]
        within(".meta-info") do
          expect(page).to have_content "Created: #{question.answers.first.created_at.to_s(:long)}"
          expect(page).to have_content "Last update: #{question.answers.first.updated_at.to_s(:long)}"
        end
      end
      within('#new-answer') do
        expect(page).not_to have_content new_answer[:answer]
      end
    end

    scenario 'gives answer with invalid attributes', js: true do
      visit question_path(question)
      click_on 'Save Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Answer can't be blank"
    end
  end
end