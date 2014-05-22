class Feedback
  include Mongoid::Document

  field :email, type: String
  field :name, type: String
  field :content, type: String
  field :date_created, type: DateTime, default: DateTime.now

  validates_presence_of :email, :name, :content, :date_created
end