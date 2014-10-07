json.array!(@games) do |game|
  json.extract! game, :id, :team1_name, :team2_name, :team1_goals, :team2_goals, :time, :championship_id
  json.url game_url(game, format: :json)
end
