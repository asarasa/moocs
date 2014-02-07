class Quiz
  include Mongoid::Document
  field :question, type: String
  field :numanswers, type: String
  field :answers, type: Array
  field :results, type: Array
  field :users, type: Array
  field :multianswer, type: Mongoid::Boolean
  
  embedded_in :resource
  validates_presence_of :question, :numanswers, :answers, :results

end
