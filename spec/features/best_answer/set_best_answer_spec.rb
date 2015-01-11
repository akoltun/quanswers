require 'features/feature_helper'

feature 'User sets best answer', %q{
  In order to be able to help others easily find best answer
  As an question's author
  I want to be able to set best answer
} do
  background { Capybara.match = :first }

  given(:question) { create(:question) }
  given(:user) { question.user }
  given(:answers) { create_list(:answer, 2, question: question) }
  background { question.update!(best_answer: answers.first) }

  scenario 'Non-authenticated user doesn\'t see "Best" button' do
    visit question_path(question)

    expect(page).not_to have_link "Best"
  end

  context "Authenticated user" do
    background do
      sign_in user
      visit question_path(question)
    end

    context "for another user's question" do
      given(:user) { create(:user) }

      scenario 'doesn\'t see "Best" button' do
        within("#answer-#{answers.first.id}") do
          expect(page).not_to have_link "Best"
        end
      end
    end

    scenario "sets best answer for his question", js: true do
      within("#answer-#{answers.first.id}") do
        expect(page).to have_content "Best"
        expect(page).not_to have_link "Best"
      end
      within("#answer-#{answers.last.id}") do
        click_on "Best"
        expect(page).to have_content "Best"
        expect(page).not_to have_link "Best"
      end
      within("#answer-#{answers.first.id}") do
        expect(page).to have_link "Best"
      end
    end
  end
end