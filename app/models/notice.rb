class Notice
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
  field :date, type: String, default: DateTime.now

  validates_presence_of :title, :content, :date

  embedded_in :courses
end