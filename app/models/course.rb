class Course
  include Mongoid::Document
  field :name, type: String
  field :abstract, type: String
  field :desc, type: String
  field :estimated_effort, type: String
  field :prerequisites, type: String
  field :date_created, type: DateTime
  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :teachers, type: Array
  has_and_belongs_to_many :users
  embeds_many :lessons
end
