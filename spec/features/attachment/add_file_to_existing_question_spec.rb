require 'features/feature_helper'

feature 'User adds file to existing question', %q{
  In order to illustrate my question
  As question's author
  I want to be able to attach files
} do
  background { Capybara.match = :first }

  given(:question) { create(:question) }

  background do
    sign_in question.user
    visit question_path(question)
    click_on "Edit Question"
  end

  scenario 'User adds file to existing question', js: true do
    within("#question") do
      click_on "Add a file"
      attach_file 'File', "#{Rails.root}/spec/files/file_to_upload.txt"
      click_on 'Save Question'
    end

    # click_on question.title
    visit question_path(question)

    within('#question') do
      expect(page).to have_link 'file_to_upload.txt', href: '/uploads/attachment/file/1/file_to_upload.txt'
    end
  end
end