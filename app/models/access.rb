class Access

  def initialize(user_id)
    @user_id = user_id
    @user_id = @user_id.id if @user_id.is_a?(User)
  end


  def read?(node)
    return false unless node
    node = access_unit(node)
    if node.user_id == @user_id
      true
    elsif node.lock_level < Node::SECRET
      true
    else 
      false
    end

  end

  def list?(node)
    return false unless node
    node = access_unit(node)
    node.user_id == @user_id || node.lock_level == Node::PUBLIC
  end


  def write?(node)
    return false unless node
    access_unit(node).user_id == @user_id
  end

  def write_directory?(node)
    return false unless node && node.directory?
    write?(node)
  end


  private

  def access_unit(node)
    node.directory? ? node : node.parent
  end

end
