class Lecture
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :start_date, type: DateTime
  field :end_date, type: DateTime
  
  has_many :lessons
  has_many :testinlectures
  embedded_in :courses

  validates_presence_of :name, :description, :start_date, :end_date

  def start_date_formatted
  	if self.start_date.nil?
  		DateTime.now.strftime('%m/%d/%Y %H:%M')
  	else
  		self.start_date.strftime('%m/%d/%Y %H:%M')
  	end
  end

  def end_date_formatted
  	if self.end_date.nil? 
  		DateTime.now.strftime('%m/%d/%Y %H:%M')
  	else
			self.end_date.strftime('%m/%d/%Y %H:%M')
		end
  end
end
