json.array!(@homeworks) do |homework|
  json.extract! homework, :id, :description
  json.url homework_url(homework, format: :json)
end
