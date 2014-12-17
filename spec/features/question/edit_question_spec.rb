require 'rails_helper'

feature 'User edits question', %q{
  In order to be able to correct mistakes in the question
  As an user
  I want to be able to edit question
} do
  given(:existing_question_hash) { attributes_for(:question) }
  given(:existing_question) { create(:question, existing_question_hash) }
  background { existing_question }
  background { Capybara.match = :first }

  given(:title) { 'Edited question title' }
  given(:question) { 'Edited question body' }

  scenario 'User edits question and then saves changes' do
    visit edit_question_path(existing_question)
    fill_in 'Title', with: :title
    fill_in 'Question', with: :question
    click_on 'Save Question'

    expect(current_path).to eq question_path(existing_question)
    expect(page).to have_content 'You have updated the question'
    expect(page).to have_content :title
    expect(page).to have_content :question
  end

  scenario 'User edits question and then saves it with invalid attributes' do
    visit edit_question_path(existing_question)
    fill_in 'Title', with: nil
    click_on 'Save Question'

    expect(current_path).to eq question_path(existing_question)
    expect(page).to have_content 'Error!'
    expect(page).to have_css '.field_with_errors'
  end
end