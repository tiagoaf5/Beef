json.array!(@championships) do |championship|
  json.extract! championship, :id, :year, :name, :country
  json.url championship_url(championship, format: :json)
end
