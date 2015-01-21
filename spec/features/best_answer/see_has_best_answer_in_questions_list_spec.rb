require 'features/feature_helper'

feature 'User sees "Has Best Answer" marks', %q{
  In order to be able to find question that has best answers
  As an user
  I want to be able to see "Has Best Answer" mark near the questions that have best answers
} do
  given!(:questions) { create_list(:unique_question, 2) }
  background { questions.first.update({ best_answer_id: create(:answer, question: questions.first).id }) }

  scenario 'User lists all questions', js: true do
    visit questions_path

    questions.each do |question|
      expect(page).to have_link question.title
      expect(page).to have_content question.question
      within("#question-#{question.id}") do
        if question.best_answer.nil?
          expect(page).not_to have_content "Has Best Answer"
        else
          expect(page).to have_content "Has Best Answer"
        end

      end
    end
  end
end