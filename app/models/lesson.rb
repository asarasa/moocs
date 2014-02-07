class Lesson
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :resources, type: Array
  embedded_in :courses

  validates_presence_of :name, :description, :start_date, :end_date
end
