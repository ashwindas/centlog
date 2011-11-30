module UsersHelper
  
  def gravatar_for(user, options = { :size => 50 })
  end
  
  def current_user?(user)
    user == current_user
  end
  
end
