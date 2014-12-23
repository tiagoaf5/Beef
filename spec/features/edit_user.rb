require 'spec_helper'

feature 'User' do
  scenario 'name change' do

    user = User.create! :email => 'owner@a.com', :password => 'beef1234', :password_confirmation => 'beef1234'
    expect(User.count).to eq(1)

    visit new_user_session_path
    fill_in "user[email]", with: "owner@a.com"
    fill_in "user[password]", with: "beef1234"
    click_button "Sign in"

    visit user_profile_path(user.id)
    click_button "Edit profile"
    fill_in "name", with: "Mudei o nome"
    click_button "Save changes"

    visit user_profile_path(user.id)
    page.should have_content("Mudei o nome")

  end

  scenario 'password change' do

    user = User.create! :email => 'owner@a.com', :password => 'beef1234', :password_confirmation => 'beef1234'
    expect(User.count).to eq(1)

    visit new_user_session_path
    fill_in "user[email]", with: "owner@a.com"
    fill_in "user[password]", with: "beef1234"
    click_button "Sign in"

    visit user_profile_path(user.id)
    click_button "Edit password"
    fill_in "user[password]", with: "beef12345"
    fill_in "user[password_confirmation]", with: "beef12345"
    fill_in "user[current_password]", with: "beef1234"
    click_button "Update"

    page.should have_content("Welcome, owner@a.com")

    visit sign_out_path

    visit new_user_session_path
    fill_in "user[email]", with: "owner@a.com"
    fill_in "user[password]", with: "beef12345"
    click_button "Sign in"
    page.should have_content("Welcome, owner@a.com")

  end
end
