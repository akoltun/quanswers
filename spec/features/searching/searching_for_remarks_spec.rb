require 'features/searching/sphinx_helper'

feature 'User searches for remark', %q{
  In order to be able to find remark
  As an user
  I want to be able to search remark
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
    check "remarks"
  end

  scenario "User search for remark by remark body", js: true do
    fill_in "Search", with: '123'
    within('#searching-form') { click_on "Search" }

    expect(page).not_to have_selector('.question')
    expect(page).not_to have_selector('.answer')
    within('.remark') do
      expect(page).to have_link remark1.remark
      expect(page).not_to have_link remark2.remark
    end
  end

  scenario "User search for answer by remark author", js: true do
    fill_in "Search", with: user.username
    within('#searching-form') { click_on "Search" }

    expect(page).not_to have_selector('.question')
    expect(page).not_to have_selector('.answer')
    within('.remark') do
      expect(page).to have_link remark1.remark
      expect(page).not_to have_link remark2.remark
    end
  end
end
