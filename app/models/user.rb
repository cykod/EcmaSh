class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :password, presence: true, :on => :create
  validates :username, presence: true, uniqueness: true

  has_many :commands, dependent: :delete_all
  has_many :user_keys, dependent: :delete_all

  def self.login(username,password)
    return false if username.blank?
    user = User.where(username: username).first || User.where(email: username).first
    user.try(:authenticate,password)
  end

  def access
    @access ||= Access.new(self)
  end

  def generate_token
    self.generate_key.token
  end

  def generate_key(valid_until=nil)
    self.user_keys.create(valid_until: valid_until || (Time.now+2.weeks))
  end

  def destroy_key(token)
    self.user_keys.where(token: token).destroy_all
  end

  def setup_user_directory
    DirectoryNode.create(name: self.username, parent: DirectoryNode.home_node, user: self)
  end

end
