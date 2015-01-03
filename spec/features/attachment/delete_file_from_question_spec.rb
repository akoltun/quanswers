require 'features/feature_helper'

feature 'User deletes file from question', %q{
  In order to remove mistaken information
  As question's author
  I want to be able to delete attached files
} do
  background { Capybara.match = :first }

  given(:attachment) { create(:attachment) }
  given(:question) { attachment.question }
  given(:user) { question.user }

  background do
    sign_in user
    visit question_path(question)
    click_on "Edit Question"
  end

  scenario 'User deletes file from existing question', js: true do
    within("#question") do
      within('#attachment-form') { click_on "Remove" }
      click_on 'Save Question'
    end

    # click_on question.title
    visit question_path(question)

    within('#question') do
      expect(page).not_to have_link 'file_to_upload.txt', href: '/uploads/attachment/file/1/file_to_upload.txt'
    end
  end
end