module UsersHelper
  def avatar(user)
    if user.photo?
      raw image_tag(user.photo.url, alt: user.full_name)
    else
      raw image_tag('buddyicon.jpg', alt: "Default avatar")
    end
  end
end
