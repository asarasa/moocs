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

  validates_uniqueness_of :email

  has_secure_password

end
