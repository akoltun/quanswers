require 'features/feature_helper'

feature 'User sees question tags in questions list', %q{
  In order to be able to easily associate question with subjects
  As an user
  I want to be able to see question tags in questions list
} do
  given!(:questions) { create_list(:unique_question, 2) }
  background { questions.each { |question| create_list(:tag, 2, questions: [question]) } }

  scenario 'User sees each question tags' do
    visit questions_path

    questions.each do |question|
      within("#question-#{question.id} .tags") do
        question.tags.each do |tag|
          expect(page).to have_content tag.name
        end
      end
    end
  end
end