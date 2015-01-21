require 'features/feature_helper'

feature 'User adds file to new answer', %q{
  In order to illustrate my answer
  As answer's author
  I want to be able to attach files
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:new_answer) { attributes_for(:answer) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User adds file when answer question', js: true do
    within('#new-answer') do
      # fill_in 'Answer', with: new_answer[:answer]
      page.execute_script %Q{ $('#answer_answer').data("wysihtml5").editor.setValue('#{new_answer[:answer]}') }
      click_on "Add a file"
      attach_file 'File', "#{Rails.root}/spec/files/file_to_upload.txt"
      click_on 'Save Answer'
    end

    expect(page).to have_link 'file_to_upload.txt', href: '/uploads/attachment/file/1/file_to_upload.txt'
    question.reload
    within("#answers #answer-#{question.answers.first.id}") do
      expect(page).to have_link 'file_to_upload.txt', href: '/uploads/attachment/file/1/file_to_upload.txt'
    end
    within('#new-answer') do
      expect(page).not_to have_content 'file_to_upload.txt'
    end
  end
end