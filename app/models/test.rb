class Test
  include Mongoid::Document
  field :name, type: String
  
 
  belongs_to :user
  belongs_to :lesson
  
  validates_presence_of :name
end
