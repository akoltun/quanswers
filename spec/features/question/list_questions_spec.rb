require 'rails_helper'

feature 'User lists questions', %q{
  In order to be able to find question
  As an user
  I want to be able to list all questions
} do
  given(:titles) { ['Title 1', 'Title 2'] }
  given(:questions) { ['Body1', 'Body 2'] }

  scenario 'User lists all questions' do
    visit questions_path

    expect(current_path).to eq questions_path
    expect(page).to have_content :titles[0]
    expect(page).to have_content :questions[0]
    expect(page).to have_content :titles[1]
    expect(page).to have_content :questions[1]
  end
end