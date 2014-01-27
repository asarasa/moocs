json.array!(@quizzes) do |quiz|
  json.extract! quiz, :question, :answers, :results, :multianswer
  json.url quiz_url(quiz, format: :json)
end
