require 'rails_helper'

feature 'User lists questions', %q{
  In order to be able to find question
  As an user
  I want to be able to list all questions
} do
  given(:questions) { [{ title: 'Title 1', question: 'Body 1' }, { title: 'Title 2', question: 'Body 2' }] }
  background { questions.each { |question| create(:question, question) } }

  scenario 'User lists all questions' do
    visit questions_path

    expect(page).to have_content questions[0][:title]
    expect(page).to have_content questions[0][:question]
    expect(page).to have_content questions[1][:title]
    expect(page).to have_content questions[1][:question]
  end
end