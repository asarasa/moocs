class Message
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
  field :date, type: DateTime, default: DateTime.now
  field :user_id, type: String

  embedded_in :topics
   
  validates_presence_of :title, :content, :date

  def user
    User.find(self.user_id)
  end
end
