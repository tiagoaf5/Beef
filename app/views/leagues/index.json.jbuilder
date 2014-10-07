json.array!(@leagues) do |league|
  json.extract! league, :id, :name, :score_correct, :score_difference, :score_prediction, :user_id
  json.url league_url(league, format: :json)
end
