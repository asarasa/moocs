json.array!(@messages) do |message|
  json.extract! message, :id, :from, :date, :order, :title, :text
  json.url message_url(message, format: :json)
end
