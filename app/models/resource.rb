class Resource
  include Mongoid::Document
  include Mongoid::Paperclip

  field :name, type: String
  field :content, type: String

  has_mongoid_attached_file :file
  
  belongs_to :user
  has_and_belongs_to_many :lessons
  has_many :tests

  validates_presence_of :name, :content
  validates_attachment_content_type :file, :content_type => ["video/mp4", "application/pdf", 'audio/mp3', 'application/x-mp3']

  def type
    if (!self.file_content_type.nil?)
      self.file.content_type
    else
      "text"
    end
  end  
end
