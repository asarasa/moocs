class Course
  include Mongoid::Document
  include Mongoid::Paperclip

  CATEGORIES = %w(art biology business chemistry csia csse csss cst education)
  
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
  field :category, type: String

  has_mongoid_attached_file :banner

  embeds_many :lectures
  has_many :members
  has_many :topics
 
  validates_uniqueness_of :name
  validates_presence_of :name, :abstract, :desc, :start_date, :end_date
  validates :category, inclusion: { in: CATEGORIES,  message: "%{value} is not a valid category" }
  validates_attachment_content_type :banner, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  validate :end_date_cannot_be_smaller_than_start_date

  def all_members
    User.in(id: members.map(&:user_id))
  end

  def members_by(type)
    User.in(id: members.by_course(self.id, type).map(&:user_id))
  end

  def add_member(user, type)
    member = Member.new({ user_id: user.id, course_id: self.id, type: type, date: DateTime.now})
    member.save
  end

  def is_member?(user)
    members.exist?(user, self)
  end

  def is?(user, type)
    members.exist_by_type?(user, self, type)
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
