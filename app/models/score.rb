class Score
  include Mongoid::Document
  
  field :score, type: Float
  field :attempt, type: Integer
  field :status, type: String
  
  belongs_to :testinlecture
  belongs_to :member
end
