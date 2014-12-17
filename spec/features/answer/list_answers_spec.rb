require 'rails_helper'

feature 'User lists answers', %q{
  In order to be able to read all answers
  As an user
  I want to be able to list all answers on the question
} do
  given(:question) { create(:question) }
  given(:answers) { ['Answer 1', 'Answer 2' ] }
  background { answers.each { |answer| create(:answer, answer: answer, question: question) } }

  scenario 'User lists all answers on the question' do
    visit question_path(question)

    expect(page).to have_content answers[0]
    expect(page).to have_content answers[1]
  end
end