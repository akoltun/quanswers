require 'features/searching/sphinx_helper'

feature 'User opens searching page', %q{
  In order to be able to search
  As an user
  I want to be able to open searching page
} do
  background { Capybara.match = :first }

  scenario 'User opens searching page' do
    visit root_path
    click_on "Search"

    expect(current_path).to eq search_path
  end
end
