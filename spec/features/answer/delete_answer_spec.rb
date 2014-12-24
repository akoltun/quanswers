require 'rails_helper'

feature 'User deletes answer', %q{
  In order to be able to remove mistaken answer
  As an user
  I want to be able to delete answer
} do
  given(:question_with_answers) { create(:question_with_answers) }
  given(:answer) { question_with_answers.answers[0] }
  background { Capybara.match = :first }

  background { question_with_answers }

  scenario 'User deletes answer' do
    visit question_path(question_with_answers)
    click_on 'Delete Answer'
    expect(current_path).to eq question_path(question_with_answers)
    expect { within("#deleteAnswerDialog#{answer.id}") { click_on "Yes" } }.to change(Answer, :count).by(-1)

    expect(current_path).to eq question_path(question_with_answers)
    expect(page).to have_content 'You have deleted the answer'
  end

end