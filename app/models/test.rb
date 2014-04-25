class Test
  include Mongoid::Document
  field :name, type: String
  
 
  belongs_to :user
  belongs_to :resource
  
  validates_presence_of :name
end
