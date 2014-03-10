class Topic
  include Mongoid::Document
  field :title, type: String
  field :state, type: String
  field :createBy, type: String
  field :nextmessage , type: Integer
  field :creation_Date, type: DateTime
  
  embeds_many :messages
  
  
  belongs_to :course
end
