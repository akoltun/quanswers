require 'features/searching/sphinx_helper'

feature 'User searches for question', %q{
  In order to be able to find question
  As an user
  I want to be able to search question
} do
  given!(:user) { create(:user) }
  given!(:question1) { create(:question, title: '123', question: '456', user: user) }
  given!(:question2) { create(:unique_question) }
  given!(:answer1) { create(:answer, answer: '123 456', user: user) }
  given!(:answer2) { create(:unique_answer) }
  given!(:remark1) { create(:remark, remark: '123 456', user: user, remarkable: create(:question)) }
  given!(:remark2) { create(:unique_remark, remarkable: create(:question)) }
  background do
    index
    visit search_path
    check "questions"
  end

  scenario "User search for question by question title", js: true do
    fill_in "Search", with: '123'
    within('#searching-form') { click_on "Search" }

    within('.question') do
      expect(page).to have_link question1.title
      expect(page).not_to have_link question2.title
    end
    expect(page).not_to have_selector('.answer')
    expect(page).not_to have_selector('.remark')
  end

  scenario "User search for question by question body", js: true do
    fill_in "Search", with: '456'
    within('#searching-form') { click_on "Search" }

    within('.question') do
      expect(page).to have_link question1.title
      expect(page).not_to have_link question2.title
    end
    expect(page).not_to have_selector('.answer')
    expect(page).not_to have_selector('.remark')
  end

  scenario "User search for question by question author", js: true do
    fill_in "Search", with: user.username
    within('#searching-form') { click_on "Search" }

    within('.question') do
      expect(page).to have_link question1.title
      expect(page).not_to have_link question2.title
    end
    expect(page).not_to have_selector('.answer')
    expect(page).not_to have_selector('.remark')
  end
end
