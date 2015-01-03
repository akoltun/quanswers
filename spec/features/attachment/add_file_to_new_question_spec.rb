require 'features/feature_helper'

feature 'User adds file to new question', %q{
  In order to illustrate my question
  As question's author
  I want to be able to attach files
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:new_question) { attributes_for(:question) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds file when ask question', js: true do
    fill_in 'Title', with: new_question[:title]
    # fill_in 'Question', with: new_question[:question]
    page.execute_script %Q{ $('#question_question').data("wysihtml5").editor.setValue('#{new_question[:question]}') }
    click_on "Add a file"
    attach_file 'File', "#{Rails.root}/spec/files/file_to_upload.txt"
    click_on 'Save Question'

    click_on new_question[:title]

    within('#question') do
      expect(page).to have_link 'file_to_upload.txt', href: '/uploads/attachment/file/1/file_to_upload.txt'
    end
  end
end