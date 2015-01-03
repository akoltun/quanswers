require 'features/feature_helper'

feature 'User deletes answer', %q{
  In order to be able to remove mistaken answer
  As an user
  I want to be able to delete answer
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:answer) { create(:answer, user: user) }

  scenario 'Non-authenticated user doesn\'t see "Delete Answer" button' do
    visit question_path(answer.question)

    expect(page).not_to have_content "Delete Answer"
  end

  context "Authenticated user" do
    background do
      sign_in user
      visit question_path(answer.question)
    end

    scenario 'deletes answer', js: true do
      within("#answer-#{answer.id}") { click_on 'Delete Answer' }
      within("#confirmation-dialog") { click_on 'Yes' }

      expect(current_path).to eq question_path(answer.question)
      expect(page).to have_content 'You have deleted the answer'
      expect(page).not_to have_css "#answer-#{answer.id}"
      expect(page).not_to have_content answer.answer
    end

    context "for another user's answer" do
      given(:answer) { create(:answer) }

      scenario 'doesn\'t see "Delete Answer" button' do
        within("#answer-#{answer.id}") { expect(page).not_to have_content "Delete Answer" }
      end
    end
  end
end