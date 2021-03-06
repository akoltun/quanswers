require 'features/feature_helper'

feature 'User sign in via Google', %q{
  In order to be able to ask questions
  As an user
  I want to be able to sign in via Facebook
} do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, { uid: '123456', info: { email: 'test@test.test', name: 'Test' }  })
  end

  scenario 'Facebook user signs in' do
    visit new_user_session_path
    click_on 'Sign in with Google Oauth2'

    expect(page).to have_content('Successfully authenticated from Google account')
    expect(page).to have_content("Hello, Test")
    expect(page).to have_link('Sign out')
    expect(page).not_to have_link('Sign in')
  end

end