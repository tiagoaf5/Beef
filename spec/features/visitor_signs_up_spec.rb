require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'via email' do
    visit new_user_registration_path
    expect(page).to have_content("Sign up")

    fill_in "user[name]", with: "John"
    fill_in "user[email]", with: "john@bot.com"
    fill_in "user[password]", with: "beef1234"
    fill_in "user[password_confirmation]", with: "beef1234"


    click_button "Sign up"
    expect(User.count).to eq(1)
    expect(User.first.email).to eq("john@bot.com")
    expect(User.first.name).to eq("John")

  end
end