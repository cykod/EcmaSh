class UserKey < ActiveRecord::Base

  belongs_to :user

  before_validation :generate_token, on: :create

  scope :valid_keys, -> { where("valid_until > ?",Time.now) }

  def self.authenticate(token)
    self.valid_keys.where(token: token).first
  end


  protected

  def generate_token 
    self.token = SecureRandom.urlsafe_base64.downcase[0..32]
  end
end
