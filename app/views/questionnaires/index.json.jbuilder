json.array!(@questionnaires) do |questionnaire|
  json.extract! questionnaire, :id, :question, :answer
  json.url questionnaire_url(questionnaire, format: :json)
end
