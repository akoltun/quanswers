require 'rails_helper'

feature 'User edits answer', %q{
  In order to be able to correct mistakes in the answer
  As an user
  I want to be able to edit answer
} do
  given(:question) { create(:question) }
  background { Capybara.match = :first }

  given(:existing_answer_hash) { { answer: "Answer text", question: question } }
  given(:existing_answer) { create(:answer, existing_answer_hash) }
  background { existing_answer }

  given(:edited_answer) { 'Edited answer' }

  scenario 'User edits answer and then saves changes' do
    visit question_path(question)
    click_on 'Edit Answer'
    expect(current_path).to eq edit_question_answer_path(question, existing_answer)

    fill_in 'Answer', with: edited_answer
    click_on 'Save Answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'You have updated the answer'
    expect(page).to have_content :edited_answer
  end

  scenario 'User edits answer and then saves it with invalid attributes' do
    visit question_path(question)
    click_on 'Edit Answer'

    fill_in 'Answer', with: nil
    click_on 'Save Answer'

    expect(current_path).to eq question_answer_path(question, existing_answer)
    expect(page).to have_content 'Error!'
    expect(page).to have_css '.field_with_errors'
  end
end