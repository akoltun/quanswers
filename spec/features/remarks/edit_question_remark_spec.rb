require 'features/feature_helper'

feature "User edits question's remark", %q{
  In order to be able to correct mistakes in the remark
  As remark's author
  I want to be able to edit remark
} do
  background { Capybara.match = :first }

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:remark) { create(:remark, user: user, remarkable: question) }
  given(:new_remark) { attributes_for(:unique_remark) }

  scenario 'Non-authenticated user doesn\'t see "Edit" remark button' do
    visit question_path(question)

    within("#question-remarks") { expect(page).not_to have_content "Edit" }
  end

  context "Authenticated user" do
    background do
      sign_in user
      visit question_path(question)
    end

    context "for another user's remark" do
      given!(:remark) { create(:remark, remarkable: question) }

      scenario 'doesn\'t see "Edit" remark button' do
        within("#question-remarks") { expect(page).not_to have_content "Edit" }
      end
    end

    context 'edits remark' do
      given(:new_value)  { new_remark[:remark] }
      background { within("#question-remarks") { click_on 'Edit' } }

      scenario 'with valid attributes', js: true do
        within("#question-remarks") do
          # fill_in 'Remark', with: new_value
          page.execute_script %Q{ $('#remark-textarea').data("wysihtml5").editor.setValue('#{new_value}') }
          click_on 'Save Remark'

          expect(current_path).to eq question_path(question)
          expect(page).to have_content new_value
          expect(page).not_to have_selector 'iframe'
          expect(page).to have_content "Edit"
          expect(page).not_to have_selector 'input[value="Save Remark"]'
        end
        expect(page).to have_content 'You have updated the remark'
      end

      scenario 'with invalid attributes', js: true do
        within("#question-remarks") do
          # fill_in 'Remark', with: ''
          page.execute_script %Q{ $('#remark-textarea').data("wysihtml5").editor.setValue('') }
          click_on 'Save Remark'

          expect(current_path).to eq question_path(question)
          expect(page).to have_content "There is one error"
          expect(page).to have_content "Remark can't be blank"
          expect(page).to have_css '.has-error'
          expect(page).to have_selector 'iframe'
          expect(page).to have_selector 'input[value="Save Remark"]'
          expect(page).not_to have_content "Edit"
        end
        expect(page).not_to have_content 'You have updated the remark'
      end

      scenario 'and then changes his mind', js: true do
        within("#question-remarks") do
          # fill_in 'Remark', with: new_value
          page.execute_script %Q{ $('#remark-textarea').data("wysihtml5").editor.setValue('#{new_value}') }
          find('a', text: 'Cancel').click
        end

        within("#confirmation-dialog") { click_on "Yes" }

        expect(current_path).to eq question_path(question)
        within("#question-remarks") do
          expect(page).to have_content remark.remark
          expect(page).not_to have_selector "iframe"
          expect(page).not_to have_selector 'input[value="Save Remark"]'
          expect(page).to have_content "Edit"
        end
        expect(page).not_to have_content 'You have updated the remark'
      end
    end
  end
end