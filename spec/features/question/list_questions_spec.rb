require 'features/feature_helper'

feature 'User lists questions', %q{
  In order to be able to find question
  As an user
  I want to be able to list all questions
} do
  given!(:questions) { create_list(:unique_question_with_rating, 2) }

  scenario 'User lists all questions' do
    visit questions_path

    questions.each do |question|
      within("#question-#{question.id}") do
        within('.meta-info') do
          expect(page).to have_content "Created: #{question.created_at.to_s(:long)}"
          expect(page).to have_content "Last update: #{question.updated_at.to_s(:long)}"
        end
        expect(page).to have_selector('input.rating[value="3.0"][readonly]')
        expect(page).not_to have_content "Author"
        expect(page).not_to have_content question.user.username
        expect(page).to have_link question.title
        expect(page).to have_content question.question
      end
    end
  end
end

feature 'Authenticated user sees questions authors', %q{
  In order to be able to personalize question
  As an authenticated user
  I want to be able to see question author name
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:unique_question_with_rating, 2) }

  scenario 'User lists all questions' do
    sign_in user
    visit questions_path

    questions.each do |question|
      within("#question-#{question.id}") do
        within('.meta-info') do
          expect(page).to have_content "Created: #{question.created_at.to_s(:long)}"
          expect(page).to have_content "Last update: #{question.updated_at.to_s(:long)}"
          expect(page).to have_content "Author:"
          expect(page).to have_content question.user.username
        end
        expect(page).to have_selector('input.rating[value="3.0"][readonly]')
        expect(page).to have_link question.title
        expect(page).to have_content question.question
      end
    end
  end
end