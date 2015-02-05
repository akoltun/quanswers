require 'features/searching/sphinx_helper'

feature 'User searches for any information', %q{
  In order to be able to find information
  As an user
  I want to be able to search question, answer and remark
} do
  given!(:user) { create(:user) }
  given!(:question1) { create(:question, title: '123', question: '456', user: user) }
  given!(:question2) { create(:unique_question) }
  given!(:answer1) { create(:answer, answer: '123 456', user: user) }
  given!(:answer2) { create(:unique_answer) }
  given!(:remark1) { create(:remark, remark: '123 456', user: user, remarkable: create(:question)) }
  given!(:remark2) { create(:unique_remark, remarkable: create(:question)) }
  given!(:remark2) { create(:unique_remark, remarkable: create(:question)) }
  background do
    index
    visit search_path
  end

  context "no search target is specified" do
    scenario "User search for question by question title", js: true do
      fill_in "Search", with: '123'
      within('#searching-form') { click_on "Search" }

      within('.question') do
        expect(page).to have_link question1.title
        expect(page).not_to have_link question2.title
      end
      within('.answer') do
        expect(page).to have_link answer1.answer
        expect(page).not_to have_link answer2.answer
      end
      within('.remark') do
        expect(page).to have_link remark1.remark
        expect(page).not_to have_link remark2.remark
      end
    end

    scenario "User search for question by question body", js: true do
      fill_in "Search", with: '456'
      within('#searching-form') { click_on "Search" }

      within('.question') do
        expect(page).to have_link question1.title
        expect(page).not_to have_link question2.title
      end
      within('.answer') do
        expect(page).to have_link answer1.answer
        expect(page).not_to have_link answer2.answer
      end
      within('.remark') do
        expect(page).to have_link remark1.remark
        expect(page).not_to have_link remark2.remark
      end
    end

    scenario "User search for question by question author", js: true do
      fill_in "Search", with: user.username
      within('#searching-form') { click_on "Search" }

      within('.question') do
        expect(page).to have_link question1.title
        expect(page).not_to have_link question2.title
      end
      within('.answer') do
        expect(page).to have_link answer1.answer
        expect(page).not_to have_link answer2.answer
      end
      within('.remark') do
        expect(page).to have_link remark1.remark
        expect(page).not_to have_link remark2.remark
      end
    end
  end

  context "all search target are specified" do
    background do
      check "questions"
      check "answers"
      check "remarks"
    end
    scenario "User search for question by question title", js: true do
      fill_in "Search", with: '123'
      within('#searching-form') { click_on "Search" }

      within('.question') do
        expect(page).to have_link question1.title
        expect(page).not_to have_link question2.title
      end
      within('.answer') do
        expect(page).to have_link answer1.answer
        expect(page).not_to have_link answer2.answer
      end
      within('.remark') do
        expect(page).to have_link remark1.remark
        expect(page).not_to have_link remark2.remark
      end
    end

    scenario "User search for question by question body", js: true do
      fill_in "Search", with: '456'
      within('#searching-form') { click_on "Search" }

      within('.question') do
        expect(page).to have_link question1.title
        expect(page).not_to have_link question2.title
      end
      within('.answer') do
        expect(page).to have_link answer1.answer
        expect(page).not_to have_link answer2.answer
      end
      within('.remark') do
        expect(page).to have_link remark1.remark
        expect(page).not_to have_link remark2.remark
      end
    end

    scenario "User search for question by question author", js: true do
      fill_in "Search", with: user.username
      within('#searching-form') { click_on "Search" }

      within('.question') do
        expect(page).to have_link question1.title
        expect(page).not_to have_link question2.title
      end
      within('.answer') do
        expect(page).to have_link answer1.answer
        expect(page).not_to have_link answer2.answer
      end
      within('.remark') do
        expect(page).to have_link remark1.remark
        expect(page).not_to have_link remark2.remark
      end
    end
  end
end
