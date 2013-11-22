class Registration
  include ActiveModel::Model

  validates :username, format: { with:  /\A[a-zA-Z\-._0-9]+\z/, message: "is invalid, no spaces or special characters" }
  validate :check_username_uniqueness
  validate :verify_username_format

  attr_accessor :username, :password, :email

  def id=(val); self.username = val; end


  def register!
    return false unless self.valid?
    user = User.create({ username: username, password: password, email: email })
    DirectoryNode.create(name: user.username, parent: DirectoryNode.home_node, user: user)
    user
  end


  protected

  def  check_username_uniqueness
    if User.where(username: self.username).first
      errors[:username] << "is taken"
    end
  end

  def verify_username_format
    if self.username.downcase =~ /\Aguest/
      errors[:username] << "cannot start with guest"
    end
  end


end
