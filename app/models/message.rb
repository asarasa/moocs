class Message
  include Mongoid::Document
  field :date, type: DateTime
  field :order, type: Integer
  field :title, type: String
  field :text, type: String
  field :from, type: String

  embedded_in :topics
  
  
  validates_presence_of :from, :date, :title, :text
end
