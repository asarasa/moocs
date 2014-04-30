class User
  include Mongoid::Document
  include Mongoid::Paperclip
  include ActiveModel::SecurePassword

  field :email, type: String
  field :name, type: String
  field :lastname, type: String
  field :password_digest, type: String
  field :admin, type: Boolean, default: false
  field :register_date, type: DateTime, default: DateTime.now
  field :last_login, type: DateTime
 
  has_many :members
  has_many :resources
  has_many :tests
  
  has_mongoid_attached_file :photo, :default_url => '/images/:attachment/buddyicon.jpg'
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  validates_presence_of :name, :lastname, :email, :password_digest
  validates :name, :lastname, length: { minimum: 3 }
  validates :email, 
    uniqueness: true, 
    format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/, 
    message: "This isn't a valid email"}
 
  has_secure_password

  def courses
    Course.in(id: members.map(&:course_id))
  end

  def courses_by(type)
    Course.in(id: members.by_user(self.id, type).map(&:course_id))
  end

  before_validation do
    self.email = email.downcase if attribute_present?("email")
  end

end
