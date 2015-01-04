require 'features/feature_helper'

feature 'User adds file to existing answer', %q{
  In order to illustrate my answer
  As answer's author
  I want to be able to attach files
} do
  background { Capybara.match = :first }

  given(:answer) { create(:answer) }

  background do
    sign_in answer.user
    visit question_path(answer.question)
    within("#answer-#{answer.id}") { click_on "Edit Answer" }
  end

  scenario 'User adds file to existing answer', js: true do
    within("#answer-#{answer.id}") do
      click_on "Add a file"
      attach_file 'File', "#{Rails.root}/spec/files/file_to_upload.txt"
      click_on 'Save Answer'
    end

    # visit question_path(question)

    within("#answers #answer-#{answer.id}") do
      expect(page).to have_link 'file_to_upload.txt', href: '/uploads/attachment/file/1/file_to_upload.txt'
    end
  end
end