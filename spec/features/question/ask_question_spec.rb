require 'rails_helper'

feature 'User asks question', %q{
  In order to be able to receive answers
  As an user
  I want to be able to ask question
} do
  given(:title) { 'Question title' }
  given(:question) { 'Question body' }
  given(:user) { create(:user) }
  before { user }

  scenario 'Non-authenticated user tries to ask valid question' do
    visit new_question_path

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  scenario 'Authenticated user asks valid question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_on 'Sign in'

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

  scenario 'Authenticated user asks invalid question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_on 'Sign in'

    visit new_question_path
    Capybara.match = :first
    click_on 'Save Question'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Error!'
    expect(page).to have_css '.field_with_errors'
  end

  scenario 'Authenticated user click "Ask New Question" button' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_on 'Sign in'

    visit questions_path
    click_on "Ask New Question"

    expect(current_path).to eq new_question_path
  end

end