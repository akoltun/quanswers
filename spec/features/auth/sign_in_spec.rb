require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask questions
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user signs in' do
    user

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Sign in'

    expect(page).to have_content('Signed in successfully')
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@example.com'
    fill_in 'Password', with: '123456'
    click_on 'Sign in'

    expect(page).to have_content('Invalid email or password')
    expect(current_path).to eq new_user_session_path
  end

end