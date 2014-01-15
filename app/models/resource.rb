class Resource
  include Mongoid::Document
  field :name, type: String
  field :content, type: String
  field :type, type: String
  field :url, type: String

  belongs_to :user
  embeds_many :quizzes
end
