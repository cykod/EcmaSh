class Guest
  
  def self.generate!
    last_user = User.last
    name = "guest#{((last_user && last_user.id) || 0)}"

    user = User.create(username: name, password: SecureRandom.urlsafe_base64.downcase[0..32])
    user.setup_user_directory
    user
  end
end
