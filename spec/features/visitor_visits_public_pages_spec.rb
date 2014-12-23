#spec/features/visitor_visits_public_pages_spec.rb
require 'spec_helper'

feature 'Visitor visits' do
  scenario 'the home page' do
    visit "/"
    page.should have_content("Home")
    page.should have_content("Login")
  end
end

