require 'spec_helper'

feature 'Bet score' do
  scenario 'game result' do

    saved_league = Championship.create! :name => "arroz", :year => "2014", :country => "Portugal"

    match = Game.create! :team1_name => "SLB", :team2_name => "SLB B", :team1_goals => "-1", :team2_goals => "-1", :time => "2050-12-28T14:00:00Z", :matchday => "1"
    saved_league.games << match

    league_owner = User.create! :email => 'owner@a.com', :password => 'beef1234', :password_confirmation => 'beef1234'
    league = League.create! name: "Bife com Atum", score_correct: 150, score_difference: 100, score_prediction: 75,
                            owner: league_owner, championships: [Championship.find_by(name: "arroz")]
    league.users << (User.create! :email => 'a@a.com', :password => 'beef1234', :password_confirmation => 'beef1234')

    #do the bet
    bet = Bet.create! team1_goals: 2, team2_goals: 0, user: league_owner, game: match, league: league
    match.bets << bet
    league_owner.bets << bet
    league.bets << bet


    expect(User.count).to eq(2)

    #LOGIN
    visit new_user_session_path

    fill_in "user[email]", with: "owner@a.com"
    fill_in "user[password]", with: "beef1234"

    click_button "Sign in"

    page.should have_content("Welcome, owner@a.com")



    #Checking page before match update

    visit league_mybets_path(league.id)
    element = page.find(".score")

    expect(element.text).to eq("0")


    #updating match result

    match.team1_goals = 2
    match.team2_goals = 0
    match.save


    #Checking page after match update
    visit league_mybets_path(league.id)

    element = page.find(".score")

    expect(element.text).to eq("150")

    page.should have_content("SLB")

  end
end