json.array!(@resources) do |resource|
  json.extract! resource, :name, :content, :type, :url, :data
  json.url resource_url(resource, format: :json)
end
