class Answer
  include Mongoid::Document
  field :answer, type: String
  field :valid, type: Mongoid::Boolean
  
  embedded_in :quiz
end
