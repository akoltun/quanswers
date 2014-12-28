require 'features/feature_helper'

feature 'User lists questions', %q{
  In order to be able to find question
  As an user
  I want to be able to list all questions
} do
  given!(:questions) { create_list(:unique_question, 2) }

  scenario 'User lists all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_link question.title
      expect(page).to have_content question.question
    end
  end
end