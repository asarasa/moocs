class Homework < Test
  include Mongoid::Document
  
  field :description, type: String
  
  embeds_many :attachments, :cascade_callbacks => true
  
  validates_presence_of :description
  
end




  