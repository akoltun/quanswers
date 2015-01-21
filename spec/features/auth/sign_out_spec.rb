require 'features/feature_helper'

feature 'User sign out', %q{
  In order for security reason
  As an authenticated user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user signs out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content('Signed out successfully')
    expect(current_path).to eq root_path
    expect(page).not_to have_content("Hello, #{user.username}")
    expect(page).not_to have_link('Sign out')
    expect(page).to have_link('Sign in')
  end
end