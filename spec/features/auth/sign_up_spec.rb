require 'features/feature_helper'

feature 'User sign up', %q{
  In order to be able to sign in
  As an user
  I want to be able to sign up
} do

  given(:user) { attributes_for(:user) }

  scenario 'Non-registered user clicks "Sign up" button on home page' do
    visit questions_path
    click_on 'Sign up'

    expect(current_path).to eq new_user_registration_path
  end

  scenario 'Non-registered user signs up' do
    visit new_user_registration_path
    fill_in 'Username', with: user[:username]
    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: user[:password]
    fill_in 'Password confirmation', with: user[:password]
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_content("Hello, #{user[:username]}")
    expect(page).to have_link('Sign out')
  end

end