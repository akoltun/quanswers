require 'rails_helper'

feature 'User asks question', %q{
  In order to be able to receive answers
  As an user
  I want to be able to ask question
} do
  given(:title) { 'Question title' }
  given(:question) { 'Question body' }

  scenario 'User asks valid question' do
    visit new_question_path
    fill_in 'Title', with: :title
    fill_in 'Question', with: :question
    Capybara.match = :first
    click_on 'Save Question'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'You have created a new question'
    expect(page).to have_content :title
    expect(page).to have_content :question
  end

  scenario 'User asks invalid question' do
    visit new_question_path
    Capybara.match = :first
    click_on 'Save Question'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Error!'
    expect(page).to have_css '.field_with_errors'
  end
end