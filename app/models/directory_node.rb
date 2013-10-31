class DirectoryNode < Node

  has_many :children, -> {  order("nodes.type != 'DirectoryNode', nodes.name") }, class_name: "Node", foreign_key: "parent_id"

  after_save  :update_children_path


  def directory?; true; end

  protected

  def update_children_path
    if self.name_changed?
      self.children.map(&:save)
    end
  end

end
