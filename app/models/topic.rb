class Topic
  include Mongoid::Document
  field :title, type: String
  field :state, type: String
  field :nextmessage , type: Integer
  field :creation_Date, type: DateTime
  field :createBy, type: String
  embeds_many :messages
end
