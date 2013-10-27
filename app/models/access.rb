class Access

  def initialize(user,node)
    @user = user
    @target = node
    @node = node.directory? ? node : node.parent
  end


  def read?
    if @node.user == @user
      true
    elsif @node.lock_level < Node::SECRET
      true
    else 
      false
    end

  end

  def list?
    @node.user == @user || @node.lock_level == Node::PUBLIC
  end


  def write?
    @node.user == @user
  end

end
