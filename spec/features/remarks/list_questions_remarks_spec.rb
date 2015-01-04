require 'features/feature_helper'

feature "User lists question's remarks", %q{
  In order to be clarify undestanding of question
  As a user
  I want to be able to read all question's remarks
} do
  given(:question) { create(:question) }
  given!(:remarks) { create_list(:unique_remark, 2, question: question) }

  scenario "User lists all question's remarks" do
    visit question_path(question)

    within('#question') do
      expect(page).to have_content remarks[0].remark
      expect(page).to have_content remarks[1].remark
    end
  end
end