class Test
  include Mongoid::Document
  
  field :name, type: String

  

  belongs_to :user
  has_and_belongs_to_many :lessons
  has_many :testinlectures
  
  validates_presence_of :name
end
