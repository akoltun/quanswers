require 'features/feature_helper'

feature 'User sign in via Twitter', %q{
  In order to be able to ask questions
  As an user
  I want to be able to sign in via Twitter
} do
  background do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:twitter, { uid: '123456', info: { name: 'Test' }  })
    clear_emails
  end

  context "(this is not the first time user signs in via Twitter)" do
    given!(:user) { create(:user) }
    background { user.identities.create!(provider: 'twitter', uid: '123456') }

    scenario 'Twitter user signs in' do
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter')
      expect(page).to have_button('Sign out')
      expect(page).not_to have_link('Sign in')
    end
  end

  scenario 'Twitter user signs in for the first time' do
    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).not_to have_content('Successfully authenticated from Twitter')
    expect(page).not_to have_button('Sign out')
    expect(page).to have_link('Sign in')

    fill_in 'Username', with: 'Test2'
    fill_in 'Email', with: 'test2@test.test'
    click_on 'Confirm'

    expect(page).not_to have_content('Successfully authenticated from Twitter')
    expect(page).not_to have_button('Sign out')
    expect(page).to have_link('Sign in')
    expect(page).to have_content('The message with further instructions has been sent to your email')
    expect(current_path).to eq questions_path

    open_email('test2@test.test')

    current_email.click_link 'Confirm the email address'

    expect(current_path).to eq root_path
    expect(page).to have_content('Successfully authenticated from Twitter')
    expect(page).to have_button('Sign out')
    expect(page).not_to have_link('Sign in')
  end

  scenario 'Twitter user signs in for the first time (changing email before confirmation' do
    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).not_to have_content('Successfully authenticated from Twitter')
    expect(page).not_to have_button('Sign out')
    expect(page).to have_link('Sign in')

    fill_in 'Username', with: 'Test2'
    fill_in 'Email', with: 'test2@test.test'
    click_on 'Confirm'

    expect(page).not_to have_content('Successfully authenticated from Twitter')
    expect(page).not_to have_button('Sign out')
    expect(page).to have_link('Sign in')
    expect(page).to have_content('The message with further instructions has been sent to your email')
    expect(current_path).to eq questions_path

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).not_to have_content('Successfully authenticated from Twitter')
    expect(page).not_to have_button('Sign out')
    expect(page).to have_link('Sign in')

    fill_in 'Username', with: 'Test3'
    fill_in 'Email', with: 'test3@test.test'
    click_on 'Confirm'

    open_email('test3@test.test')

    current_email.click_link 'Confirm the email address'

    expect(current_path).to eq root_path
    expect(page).to have_content('Successfully authenticated from Twitter')
    expect(page).to have_button('Sign out')
    expect(page).not_to have_link('Sign in')
  end

end