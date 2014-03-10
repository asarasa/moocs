class Test
  include Mongoid::Document
  field :name, type: String
  
  has_many :users
  belongs_to :resource
  
  validates_presence_of :name
end
