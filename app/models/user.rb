class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :username, type: String
  field :email, type: String
  field :name, type: String
  field :lastname, type: String
  field :password_digest, type: String
  field :admin, type: Boolean, default: false
  field :register_date, type: DateTime
  field :last_login, type: DateTime
  has_and_belongs_to_many :courses
  has_many :resources


  validates_uniqueness_of :email, :username
  validates_presence_of :username, :email, :password_digest

  has_secure_password

end
