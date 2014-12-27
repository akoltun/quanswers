require 'rails_helper'

feature 'User shows question', %q{
  In order to be able to read question's answers
  As an user
  I want to be able to open question page
} do
  given(:questions) { [create(:question, title: 'Title 1'), create(:question, title: 'Title 2')] }
  background { questions }

  scenario 'User opens question page' do
    visit questions_path
    click_on questions[1].title

    expect(current_path).to eq question_path(questions[1].id)
  end
end