class Member
  include Mongoid::Document
  field :type, type: String
  field :date, type: DateTime

  belongs_to :user
  belongs_to :course

	validates_uniqueness_of :user_id, :scope => :course_id
	
  validates :type, inclusion: { in: %w(student teacher),
    message: "%{value} is not a valid member (student, teacher)" }

  def self.by_user(type, user_id)
  	where(type: type, user_id: user_id)
  end

  def self.by_course(type, course_id)
  	where(type: type, course_id: course_id)
  end

  def self.exist?(type, user, course)
    where(type: type, user_id: user, course_id: course).any?
  end
end