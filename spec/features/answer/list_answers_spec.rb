require 'features/feature_helper'

feature 'User lists answers', %q{
  In order to be able to read all answers
  As an user
  I want to be able to list all answers on the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:unique_answer_with_rating, 2, user: user, question: question) }

  scenario 'User lists all answers on the question page' do
    visit question_path(question)

    within('#answers') do
      answers.each do |answer|
        within("#answer-#{answer.id}") do
          within('.meta-info') do
            expect(page).to have_content "Created: #{answer.created_at.to_s(:long)}"
            expect(page).to have_content "Last update: #{answer.updated_at.to_s(:long)}"
          end
          expect(page).to have_selector('input.rating[value="3.0"]')
          expect(page).not_to have_content "Author:"
          expect(page).not_to have_content answer.user.username
          expect(page).to have_content answer.answer
          expect(page).not_to have_selector 'textarea'
        end
      end
    end
  end
end

feature 'Authenticated User sees answers authors', %q{
  In order to be able to personalize answer
  As an authenticated user
  I want to be able to see answer author name
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:unique_answer_with_rating, 2, user: user, question: question) }

  scenario 'User lists all answers on the question page' do
    sign_in user
    visit question_path(question)

    within('#answers') do
      answers.each do |answer|
        within("#answer-#{answer.id}") do
          within('.meta-info') do
            expect(page).to have_content "Created: #{answer.created_at.to_s(:long)}"
            expect(page).to have_content "Last update: #{answer.updated_at.to_s(:long)}"
            expect(page).to have_content "Author:"
            expect(page).to have_content answer.user.username
          end
          expect(page).to have_selector('input.rating[value="3.0"]')
          expect(page).to have_content answer.answer
          expect(page).not_to have_selector 'textarea'
        end
      end
    end
  end
end