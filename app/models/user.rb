class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  has_many :commands

  def access(node)
    Access.new(self,node)
  end

  def can_read?(node)
    access(node).read?
  end

  def can_write?(node)
    access(node).write?
  end
end
