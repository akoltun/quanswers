require 'features/feature_helper'

feature 'User sees question page', %q{
  In order to be able to read question's answers
  As an user
  I want to be able to open question page
} do
  given(:questions) { create_list(:unique_question, 2) }
  background { create_list(:unique_answer, 2, question: questions[1]) }

  scenario 'User opens question page' do
    visit questions_path
    click_on questions[1].title

    expect(current_path).to eq question_path questions[1].id
  end

  scenario "User sees question" do
    visit question_path questions[1]

    within('#question') do
      expect(page).not_to have_content "Author"
      expect(page).not_to have_content questions[1].user.username
      expect(page).to have_content questions[1].title
      expect(page).to have_content questions[1].question
      expect(page).not_to have_selector 'textarea'
    end
  end
end

feature 'User sees question author', %q{
  In order to be able to personalize question
  As an authenticated user
  I want to be able to see question author name
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario "User sees question" do
    sign_in user
    visit question_path question

    within('#question') do
      expect(page).to have_content "Author"
      expect(page).to have_content question.user.username
      expect(page).to have_content question.title
      expect(page).to have_content question.question
      expect(page).not_to have_selector 'textarea'
    end
  end
end