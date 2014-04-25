class Attachment
  include Mongoid::Document
  include Mongoid::Paperclip
  
  embedded_in :homeworks
  
  has_mongoid_attached_file :file
  validates_attachment_content_type :file, :content_type => ["application/zip", "application/x-zip", "application/x-zip-compressed", "application/pdf", "application/x-pdf,image/jpg", "image/jpeg", "image/png"]

  
end

