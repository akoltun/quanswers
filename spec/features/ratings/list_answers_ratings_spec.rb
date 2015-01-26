require 'features/feature_helper'

feature 'User see answers ratings in answers list', %q{
  In order to be able to estimate answers
  As an user
  I want to be able to see answers ratings
} do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:unique_answer_with_rating, 2, question: question) }

  scenario 'User lists all answers on the question page' do
    visit question_path(question)

    within('#answers') do
      answers.each do |answer|
        within("#answer-#{answer.id}") do
          expect(page).to have_selector('input.rating[value="3.0"][data-initial-value="3.0"][readonly]')
        end
      end
    end
  end
end
