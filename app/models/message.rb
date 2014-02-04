class Message
  include Mongoid::Document
  field :from, type: String
  field :date, type: DateTime
  field :order, type: Integer
  field :title, type: String
  field :text, type: String
  embedded_in :topics
end
