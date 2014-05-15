class Quiz < Test
  include Mongoid::Document
  field :question, type: String
  
  embeds_many :answers
  
  
  validates_presence_of :question

  def multianswer
    if self.answers.where(valid: true).count == 1 
      false
    else
      true
    end
  end
end
