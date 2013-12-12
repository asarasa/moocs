json.array!(@courses) do |course|
  json.extract! course, :name, :desc
  json.url course_url(course, format: :json)
end
