require 'features/feature_helper'

feature 'User lists answers', %q{
  In order to be able to read all answers
  As an user
  I want to be able to list all answers on the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answers) { create_list(:unique_answer, 2, user: user, question: question) }
  background { answers.each { |answer| create(:answer, answer: answer, question: question) } }

  scenario 'User lists all answers on the question page' do
    visit question_path(question)

    within('#answers') do
      answers.each do |answer|
        within("#answer-#{answer.id}") do
          expect(page).to have_content answer.answer
        end
      end
    end
  end
end