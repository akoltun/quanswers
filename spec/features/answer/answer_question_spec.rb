require 'rails_helper'

feature 'User answers question', %q{
  In order to help others
  As an user
  I want to be able to answer question
} do
  given(:question) { create(:question) }
  given(:answer) { 'Answer body' }
  background { Capybara.match = :first }

  scenario 'User answers question' do
    visit question_path(question)
    fill_in 'Answer', with: answer
    click_on 'Save Answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'You have created a new answer'
    within('.answers') do
      expect(page).to have_content answer
    end
  end

  scenario 'User saves invalid answer' do
    visit question_path(question)
    click_on 'Save Answer'

    expect(current_path).to eq question_answers_path(question)
    expect(page).to have_content 'Error!'
    expect(page).to have_css '.field_with_errors'
  end
end