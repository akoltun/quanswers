require 'features/feature_helper'

feature 'User deletes file from answer', %q{
  In order to remove mistaken information
  As answer's author
  I want to be able to delete attached files
} do
  background { Capybara.match = :first }

  given(:answer) { create(:answer) }
  given(:attachment) { create(:attachment, attachmentable: answer) }

  background do
    attachment
    sign_in answer.user
    visit question_path(answer.question)
    within("#answer-#{answer.id}") { click_on "Edit Answer" }
  end

  scenario 'User deletes file from existing answer', js: true do
    within("#answer-#{answer.id}") do
      within("#attachment-form-#{answer.id}") { click_on "Remove" }
      click_on 'Save Answer'
    end

    # visit question_path(question)

    within("#answers #answer-#{answer.id}") do
      expect(page).not_to have_content 'file_to_upload.txt'
    end
  end
end