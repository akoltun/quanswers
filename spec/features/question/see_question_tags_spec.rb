require 'features/feature_helper'

feature 'User sees question tags', %q{
  In order to be able to easily associate question with subjects
  As an user
  I want to be able to see question tags
} do
  given!(:question) { create(:question, tags: create_list(:tag, 2)) }

  scenario "User sees question tags" do
    visit question_path question

    within('.tags') do
      question.tags.each do |tag|
        expect(page).to have_content tag.name
      end
    end
  end
end

