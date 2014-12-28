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
      expect(page).to have_content questions[1].title
      expect(page).to have_content questions[1].question
      expect(page).not_to have_selector 'textarea'
    end
  end

  scenario "User sees all answers" do
    visit question_path questions[1]

    within('#answers') do
      questions[1].answers.each do |answer|
        expect(page).to have_content answer.answer
        expect(page).not_to have_selector 'textarea'
      end
    end
  end
end