json.array!(@lectures) do |lecture|
  json.extract! lecture, :name, :description
  json.url lecture_url(lecture, format: :json)
end
