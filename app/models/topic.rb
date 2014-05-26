class Topic
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
  field :state, type: String
  field :date, type: DateTime, default: DateTime.now
  
  embeds_many :messages
  belongs_to :user
  belongs_to :course

  validates_presence_of :title, :content, :state, :date
end
