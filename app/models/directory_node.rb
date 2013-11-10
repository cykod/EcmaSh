class DirectoryNode < Node

  has_many :children, -> {  order("nodes.type != 'DirectoryNode', nodes.name") }, class_name: "Node", foreign_key: "parent_id"

  after_save  :update_children_path

  def self.home_node
    self.fetch("/home") || self.create(name: "home")
  end
    

  def directory?; true; end

  def download(url)
    file = URI.parse(url)

    begin 
      FileNode.create(
        user: self.user,
        parent: self,
        file: file
      )
    rescue OpenURI::HTTPError
      return nil
    end
  end

  protected

  def update_children_path
    if self.name_changed?
      self.children.map(&:save)
    end
  end

end
