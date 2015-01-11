require 'features/feature_helper'

feature 'User sees best answer', %q{
  In order to be able to easily find best answer
  As an user
  I want to be able to see a "Best" answer mark
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answers) { create_list(:unique_answer, 2, user: user, question: question) }
  background { answers.each { |answer| create(:answer, answer: answer, question: question) } }
  background { question.update!(best_answer: question.answers.first) }

  scenario 'User lists all answers on the question page' do
    visit question_path(question)

    within('#answers') do
      answers.each do |answer|
        within("#answer-#{answer.id}") do
          expect(page).to have_content answer.answer

          if answer == question.best_answer
            expect(page).to have_content "Best"
          else
            expect(page).not_to have_content "Best"
          end
        end
      end
    end
  end
end