require 'features/feature_helper'

feature 'User see questions ratings in questions list', %q{
  In order to be able to estimate questions
  As an user
  I want to be able to see questions ratings
} do
  given!(:questions) { create_list(:unique_question_with_rating, 2) }

  scenario 'User see questions ratings' do
    visit questions_path

    questions.each do |question|
      within("#question-#{question.id}") do
        expect(page).to have_selector('input.rating[value="3.0"][data-initial-value="3.0"][readonly]')
      end
    end
  end
end