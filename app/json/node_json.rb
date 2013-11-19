class NodeJSON < JSONBase 

  def list
    build do |json,node|
      json.fullpath node.fullpath
      json.name node.name
      json.directory node.directory?
    end
  end

  def details
    build do |json,node|
      json.id node.fullpath
      json.fullpath node.fullpath
      json.name node.name
      json.directory node.directory?
      json.src node.file(:original)
      json.file_type node.file_type
      json.image node.image?
      json.text node.text?
      json.audio node.audio?
      json.content node.content
    end
  end

end
