json.array!(@bets) do |bet|
  json.extract! bet, :id, :team1_goals, :team2_goals, :score, :user_id, :game_id
  json.url bet_url(bet, format: :json)
end
