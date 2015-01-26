require 'features/feature_helper'

feature "User lists question's remarks", %q{
  In order to clarify undestanding of question
  As a user
  I want to be able to read all question's remarks
} do
  given(:question) { create(:question) }
  given!(:remarks) { create_list(:unique_remark, 2, remarkable: question) }

  scenario "User lists all question's remarks" do
    visit question_path(question)

    within('#question') do
      remarks.each do |remark|
        within("#remark-#{remark.id}") do
          within('.meta-info') do
            expect(page).to have_content "Created: #{remark.created_at.to_s(:long)}"
            expect(page).to have_content "Last update: #{remark.updated_at.to_s(:long)}"
          end
          expect(page).not_to have_content "Author:"
          expect(page).not_to have_content remark.user.username
          expect(page).to have_content remark.remark
        end
      end
    end
  end
end

feature "Authenticated User sees question's remark authors", %q{
  In order to be able to personalize question's remarks
  As an authenticated user
  I want to be able to see remark's author name
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:remarks) { create_list(:unique_remark, 2, remarkable: question) }

  scenario "User lists all question's remarks" do
    sign_in user
    visit question_path(question)

    within('#question') do
      remarks.each do |remark|
        within("#remark-#{remark.id}") do
          within('.meta-info') do
            expect(page).to have_content "Created: #{remark.created_at.to_s(:long)}"
            expect(page).to have_content "Last update: #{remark.updated_at.to_s(:long)}"
            expect(page).to have_content "Author:"
            expect(page).to have_content remark.user.username
          end
          expect(page).to have_content remark.remark
        end
      end
    end
  end
end