require 'features/feature_helper'


feature 'User follows question', %q{
  In order to be informed about new answers on interesting question
  As authenticated user
  I want to be able to follow question
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:current_user_question) { create(:question, user: user) }
  given(:another_user_question) { create(:question) }

  given(:new_question) { attributes_for(:unique_question) }

  scenario 'Non-authenticated user doesn\'t see "Follow/Unfollow" button' do
    visit question_path(another_user_question)

    expect(page).not_to have_link 'Follow'
    expect(page).not_to have_link 'Unfollow'
  end

  context "Authenticated user" do
    background { sign_in user }

    scenario 'doesn\'t see "Follow/Unfollow" button for his own question' do
      visit question_path(current_user_question)

      expect(page).not_to have_link 'Follow'
      expect(page).not_to have_link 'Unfollow'
    end

    scenario 'follows another user\'s question', js: true do
      visit question_path(another_user_question)

      click_on "Follow"

      expect(current_path).to eq question_path(another_user_question)
      expect(page).not_to have_link 'Follow'
      expect(page).to have_link 'Unfollow'
      another_user_question.reload
      expect(another_user_question).to be_followed_by(user)

      answer = create(:answer, question: another_user_question)

      open_email(user.email)
      expect(current_email).to have_content user.username
      expect(current_email).to have_link another_user_question.title #, href: question_url(another_user_question)
      expect(current_email).to have_content answer.answer
      # current_email.save_and_open

      click_on 'Unfollow'
      expect(current_path).to eq question_path(another_user_question)
      expect(page).to have_link 'Follow'
      expect(page).not_to have_link 'Unfollow'
      another_user_question.reload
      expect(another_user_question).not_to be_followed_by(user)
    end
  end
end