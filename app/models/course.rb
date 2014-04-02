class Course
  include Mongoid::Document
  field :name, type: String
  field :abstract, type: String
  field :desc, type: String
  field :estimated_effort, type: String
  field :prerequisites, type: String
  field :date_created, type: DateTime, default: DateTime.now
  field :start_date, type: DateTime, default: DateTime.now
  field :end_date, type: DateTime , default: DateTime.now + 1
  field :forumpermision , type: Boolean
  field :tags, type: Array
  
  embeds_many :lessons
  has_many :members
  has_many :topics
 
  validates_uniqueness_of :name
  validates_presence_of :name, :abstract, :desc, :start_date, :end_date
  validate :end_date_cannot_be_smaller_than_start_date

  def all_members
    User.in(id: members.map(&:user_id))
  end

  def members_by(type)
    User.in(id: members.by_course(type, self.id).map(&:user_id))
  end

  def add_member(user, type)
    member = Member.new({ user_id: user.id, course_id: self.id, type: type, date: DateTime.now})
    member.save
  end

  def is_member?(user, type)
    members.exist?(type, user, self)
  end

  private

  def end_date_cannot_be_smaller_than_start_date
    if self.end_date != nil && self.start_date != nil
      if self.end_date < self.start_date
        errors.add(:end_date, "can't be smaller than start date")
      end
    end
  end
end
