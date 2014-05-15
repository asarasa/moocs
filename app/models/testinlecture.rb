class Testinlecture
  include Mongoid::Document
  
  field :active, type: Boolean
  
  belongs_to :test
  belongs_to :lecture
  has_many :scores
  
  def change_visibility
  	if (self.active)
  		self.active = false
  	else
  		self.active = true
  	end
  	if self.save
  		true
  	else
  		false
  	end
  end
  
end