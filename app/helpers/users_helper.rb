module UsersHelper

  def gravatar_for(user, size=0)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, :class => "gravatar", size: size)
  end

  def user_gravatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
