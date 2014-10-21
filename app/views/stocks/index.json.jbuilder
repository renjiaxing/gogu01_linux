json.array!(@stocks) do |stock|
  json.extract! stock, :id, :code, :name
  json.url stock_url(stock, format: :json)
end
