require 'features/feature_helper'

feature "User lists answer's remarks", %q{
  In order to clarify undestanding of answer
  As a user
  I want to be able to read all answer's remarks
} do
  given(:answer) { create(:answer) }
  given(:question) { answer.question }
  given!(:remarks) { create_list(:unique_remark, 2, remarkable: answer) }

  scenario "User lists all answer's remarks" do
    visit question_path(question)

    within("#answer-#{answer.id}") do
      expect(page).to have_content remarks[0].remark
      expect(page).to have_content remarks[1].remark
    end
  end
end