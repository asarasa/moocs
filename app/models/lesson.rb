class Lesson
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :active, type: Boolean
  field :order, type: Integer

  belongs_to :lecture
  has_and_belongs_to_many :resources

  def change_state
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

  def change_order(id)
    diff_lesson= Lesson.find(id)
    temp = self.order
   	self.order = diff_lesson.order
   	diff_lesson.order = temp
    if self.save && diff_lesson.save
    	true
    else
    	false
    end 
	end

end
