require 'features/feature_helper'

feature "User deletes answer's remark", %q{
  In order to be able to eliminate incorrect remark
  As remark's author
  I want to be able to delete remark
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:question) { answer.question }
  given!(:remark) { create(:remark, user: user, remarkable: answer) }

  scenario 'Non-authenticated user doesn\'t see "Delete" button' do
    visit question_path(question)

    within("#answers .answer-remarks") { expect(page).not_to have_content "Delete" }
  end

  context "Authenticated user" do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'deletes remark', js: true do
      within("#answer-#{answer.id} .answer-remarks") { click_on 'Delete' }
      within("#confirmation-dialog") { click_on 'Yes' }

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'You have deleted the remark'
      expect(page).not_to have_content remark.remark
    end

    context "for another user's remark" do
      given(:remark) { create(:remark, remarkable: answer) }

      scenario 'doesn\'t see "Delete" button' do
        within("#answer-#{answer.id} .answer-remarks") { expect(page).not_to have_content "Delete" }
      end
    end
  end
end