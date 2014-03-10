class Quiz < Test
  include Mongoid::Document
  field :question, type: String
  field :numanswers, type: String
  field :answers, type: Array
  field :results, type: Array
  field :multianswer, type: Mongoid::Boolean
  
  
  validates_presence_of :question, :numanswers

end
